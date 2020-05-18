output "vpc" {
  value = "${aws_vpc.vpc.id}"
}

output "primary_public_subnet" {
  value = "${aws_subnet.primary_public_subnet.id}"
}

output "secondary_public_subnet" {
  value = "${aws_subnet.secondary_public_subnet.id}"
}
