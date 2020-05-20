data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "lc_web" {
  name_prefix                 = "${var.lc_web_name_prefix}"
  image_id                    = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.lc_web_instance_type}"
  security_groups             = ["${var.lc_web_security_groups}"]
  associate_public_ip_address = true

  user_data = "${file("${path.module}/bootstrap/setup-webserver.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_web" {
  name_prefix           =  "${var.asg_web_name_prefix}"
  launch_configuration  = "${aws_launch_configuration.lc_web.name}"

  min_size              = "${var.asg_web_min_size}"
  max_size              = "${var.asg_web_max_size}"
  desired_capacity      = "${var.asg_web_des_size}"

  vpc_zone_identifier   = ["${var.subnets_ids}"]

  target_group_arns = [ "${aws_lb_target_group.web-target-group.arn}"]

  tags = [
    {
      key                 = "Name"
      value               = "${var.asg_web_ec2_tag_name}"
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}
// TODO figure out bucket policy
/*resource "aws_s3_bucket" "web_alb-logs-bucket" {
  bucket_prefix = "web-alb-access-logs"
  acl = "private"

  policy = <<EOF
{
"Version": "2012-10-17,
“Statement”: [
{
“Effect”: “Allow”,
“Principal”: {
“AWS”: “arn:aws:iam::783225319266:root”
},
“Action”: “s3:PutObject”,
“Resource”: “arn:aws:s3:::elb-log.davidwzhang.com*//*”
}
]
}
EOF
}*/

resource "aws_lb" "web_alb" {
  name_prefix = "web-"
  internal = false
  load_balancer_type = "application"

  security_groups = ["${var.alb_sg}"]
  subnets = ["${var.subnets_ids}"]

  enable_deletion_protection = true

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
