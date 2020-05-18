resource "aws_security_group" "web-access" {
  vpc_id = "${var.vpc_id}"
  name_prefix = "public-web-access-"
  description = "Allows all traffic on port 80"

  ingress {
    from_port = 80
    protocol = "TCP"
    to_port = 80
    cidr_blocks = [ "0.0.0.0/0" ]

    description = "Allows all traffic on port 80"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh-access" {
  vpc_id = "${var.vpc_id}"
  name_prefix = "ssh-access-"
  description = "Allows traffic on port 22 to whitelisted IPs"

  ingress {
    from_port = 22
    protocol = "TCP"
    to_port = 22
    cidr_blocks = "${var.whitelisted_ssh_ips}"

    description = "Allows traffic on port 22 to whitelisted IPs"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}