output "web-sg" {
  value = "${aws_security_group.web-access.id}"
}

output "ssh-sg" {
  value = "${aws_security_group.ssh-access.id}"
}