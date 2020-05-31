resource "aws_efs_file_system" "efs_shared_filesystem" {}

resource "aws_efs_mount_target" "efs_mount_target_primary" {
  file_system_id = "${aws_efs_file_system.efs_shared_filesystem.id}"
  subnet_id      = "${var.primary_subnet}"

  security_groups = ["${aws_security_group.efs_sg.id}"]
}

resource "aws_efs_mount_target" "efs_mount_target_secondary" {
  file_system_id = "${aws_efs_file_system.efs_shared_filesystem.id}"
  subnet_id      = "${var.secondary_subnet}"

  security_groups = ["${aws_security_group.efs_sg.id}"]
}

resource "aws_security_group" "efs_sg" {
  vpc_id      = "${var.vpc_id}"
  name_prefix = "efs-sg-"
  description = "Allows EFS access to the Web servers"

  ingress {
    security_groups = ["${var.web_sg}"]
    from_port       = 2049
    protocol        = "TCP"
    to_port         = 2049
  }
}
