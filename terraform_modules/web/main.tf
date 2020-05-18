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

  vpc_zone_identifier   = ["${var.asg_web_azs}"]

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