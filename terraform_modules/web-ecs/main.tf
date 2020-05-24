resource "aws_ecs_cluster" "foo" {
  name = "${var.ecs_cluster_name}"
}

resource "aws_ecs_service" "bar" {
  name            = "efs-example-service" //TODO
  cluster         = "${aws_ecs_cluster.foo.id}"
  task_definition = "${aws_ecs_task_definition.web-task.arn}" //TODO
  desired_count   = 1
  launch_type     = "EC2"
  load_balancer {
    container_name = "nginx"
    container_port = 80
    target_group_arn = "${var.web_tg_arn}"
  }

/*  network_configuration {
    subnets = [ "${var.primary_subnet}", "${var.secondary_subnet}" ]
  }*/
}

//TODO
//resource "aws_ecs_task_definition" "efs-task" {
//  family        = "efs-example-task" //TODO
//  network_mode = "awsvpc"
//
//  container_definitions = <<DEFINITION
//[
//  {
//      "memory": 128,
//      "portMappings": [
//          {
//              "hostPort": 80,
//              "containerPort": 80,
//              "protocol": "tcp"
//          }
//      ],
//      "essential": true,
//      "mountPoints": [
//          {
//              "containerPath": "/usr/share/nginx/html",
//              "sourceVolume": "efs-html"
//          }
//      ],
//      "name": "nginx",
//      "image": "nginx"
//  }
//]
//DEFINITION
//
//  volume {
//    name      = "efs-html"
//    efs_volume_configuration {
//      file_system_id = "${var.file_system_id}"
//      root_directory = "/efs"
//    }
//  }
//}

resource "aws_ecs_task_definition" "web-task" {
  family        = "web-task" //TODO
  //network_mode = "awsvpc"

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
      "name": "nginx",
      "image": "nginx"
  }
]
DEFINITION

//  volume {
//    name      = "efs-html"
//    efs_volume_configuration {
//      file_system_id = "${var.file_system_id}"
//      root_directory = "/efs"
//    }
//  }
}


resource "aws_iam_role" "ecs-service-role" {
  name                = "ecs-service-role"
  path                = "/"
  assume_role_policy  = "${data.aws_iam_policy_document.ecs-service-policy.json}"
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
  name                = "ecs-instance-role"
  path                = "/"
  assume_role_policy  = "${data.aws_iam_policy_document.ecs-instance-policy.json}"
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
  name                        = "ecs-launch-configuration"
  image_id                    = "ami-fad25980"
  instance_type               = "t2.micro"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-instance-profile.id}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 10
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = ["${var.web_sg}", "${var.ssh_sg}"]
  associate_public_ip_address = "true"
  key_name                    = "${var.ecs_key_pair_name}"
  user_data                   = <<EOF
                                  #!/bin/bash
                                  sudo yum install -y amazon-efs-utils
                                  sudo mkdir /efs
                                  echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
                                  EOF
}

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name                        = "ecs-autoscaling-group"
  max_size                    = "${var.max_instance_size}"
  min_size                    = "${var.min_instance_size}"
  desired_capacity            = "${var.desired_capacity}"
  vpc_zone_identifier         = ["${var.primary_subnet}", "${var.secondary_subnet}"]
  launch_configuration        = "${aws_launch_configuration.ecs-launch-configuration.name}"
  health_check_type           = "ELB"
}