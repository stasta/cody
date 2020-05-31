output "file_system" {
  value = "${aws_efs_file_system.efs_shared_filesystem.id}"
}
