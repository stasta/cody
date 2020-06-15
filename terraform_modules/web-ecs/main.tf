resource "aws_ecs_cluster" "foo" {
  name = "${var.ecs_cluster_name}" //TODO refactor its name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_service" "wordpress-ecs-service" {
  name            = "${var.wordpress-ecs-service}"
  cluster         = "${aws_ecs_cluster.foo.id}"               //TODO refactor its name
  task_definition = "${aws_ecs_task_definition.wordpress-task-definition.arn}"
  desired_count   = "${var.des_web_containers}"
  launch_type     = "EC2"

  load_balancer {
    container_name   = "wordpress"                                   //TODO externalize to a variable. must be the same as the container definition container name
    container_port   = 80
    target_group_arn = "${aws_lb_target_group.web-target-group.arn}"
  }

  depends_on = ["aws_lb_listener.web-listener-target-group"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_task_definition" "wordpress-task-definition" {
  family = "wordpress-task"

  //TODO externalize to a template document. Have the container name, image, version and memory as variables
  container_definitions = <<DEFINITION
[
  {
      "memory": 128,
      "portMappings": [
          {
              "hostPort": 0,
              "containerPort": 80,
              "protocol": "tcp"
          }
      ],
      "essential": true,
      "name": "wordpress",
      "image": "wordpress:php7.2",
  "mountPoints":
  [
      {
          "sourceVolume": "html",
          "containerPath": "/var/www/html"
      }
  ]
  }
]
DEFINITION

  volume {
    name = "html"

    //    host_path = "/opt/html" //TODO remove

    efs_volume_configuration {
      file_system_id = "${var.file_system_id}"

      //      root_directory = "/efs" //TODO remove
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "ecs-service-role" {
  name               = "ecs-service-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-service-policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role       = "${aws_iam_role.ecs-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs-instance-role" {
  name               = "ecs-instance-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-instance-policy.json}"
}

data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = "${aws_iam_role.ecs-instance-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "ecs-instance-profile"
  path = "/"
  role = "${aws_iam_role.ecs-instance-role.id}"

  // TODO what is this?
  /*provisioner "local-exec" {
    command = "sleep 10"
  }*/
}

resource "aws_launch_configuration" "ecs-launch-configuration" {
  name                 = "ecs-launch-configuration"
  image_id             = "ami-fad25980"                                        //TODO check AMI
  instance_type        = "t2.micro"                                            //TODO externalize to a variable
  iam_instance_profile = "${aws_iam_instance_profile.ecs-instance-profile.id}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 10    //TODO externalize to a variable
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = ["${var.web_sg}", "${var.ssh_sg}"]
  associate_public_ip_address = "true"
  key_name                    = "${var.ecs_key_pair_name}"

  //TODO dont need to mount the /efs dir anymore. Maybe not even installing the efs-utils package
  user_data = <<EOF
                                  #!/bin/bash
                                  sudo yum install -y amazon-efs-utils
                                  sudo mkdir /efs
                                  echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
                                  EOF
}

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name                 = "ecs-autoscaling-group"
  max_size             = "${var.max_instance_size}"
  min_size             = "${var.min_instance_size}"
  desired_capacity     = "${var.des_instance_size}"
  vpc_zone_identifier  = ["${var.subnets}"]
  launch_configuration = "${aws_launch_configuration.ecs-launch-configuration.name}"
  health_check_type    = "ELB"
}

resource "aws_lb" "web_alb" {
  name_prefix        = "web-"
  internal           = false
  load_balancer_type = "application"

  security_groups = ["${var.alb_sg}"]
  subnets         = ["${var.subnets}"]

  enable_deletion_protection = false

  // TODO create s3 logs bucket
  //  access_logs {
  //    bucket  = "${aws_s3_bucket.web_alb-logs-bucket.bucket}"
  //    prefix  = "access_logs" // TODO use an application tag?
  //    enabled = true
  //  }

  tags = {
    Name = "${var.alb_name}"
  }
}

resource "aws_lb_target_group" "web-target-group" {
  name_prefix = "webtg-"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"

  target_type = "instance"

  health_check {
    path                = "/wp-login.php" //TODO move out to a variable
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "10"
  }

  deregistration_delay = 30
}

resource "aws_lb_listener" "web-listener-target-group" {
  load_balancer_arn = "${aws_lb.web_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.web-target-group.arn}"
  }
}

// TODO
// Also check https://www.terraform.io/docs/providers/datadog/r/integration_aws.html
module "ecs-datadog" {
  source = "github.com/riboseinc/terraform-aws-ecs-datadog"

  datadog-api-key      = "${var.datadog-api-key}"
  datadog-extra-config = "${var.datadog-extra-config}"
  env                  = "${var.env}"
  identifier           = "datadog"
  ecs-cluster-id       = "${aws_ecs_cluster.foo.id}"
}

// TODO add cloudwatch alerts and triggers


// TODO add logs to cloudwatch logs from containers

