resource "aws_efs_file_system" "efs_shared_filesystem" {}

resource "aws_efs_mount_target" "efs_mount_target" {
  count          = "${length( var.subnets )}"
  file_system_id = "${aws_efs_file_system.efs_shared_filesystem.id}"
  subnet_id      = "${element(var.subnets, count.index)}"

  security_groups = ["${aws_security_group.efs_sg.id}"]
}

resource "aws_security_group" "efs_sg" {
  vpc_id      = "${var.vpc_id}"
  name_prefix = "efs-sg-"
  description = "Allows EFS access"

  ingress {
    security_groups = ["${var.allowed-sgs}"]
    from_port       = 2049
    protocol        = "TCP"
    to_port         = 2049
  }
}

// TODO add EFS backup solution