output "web-lb-sg" {
  value = "${aws_security_group.web-lb.id}"
}

output "web-sg" {
  value = "${aws_security_group.web-access.id}"
}

output "ssh-sg" {
  value = "${aws_security_group.ssh-access.id}"
}

output "keypair_name" {
  value = "${aws_key_pair.ec2_key_pair.key_name}"
}
