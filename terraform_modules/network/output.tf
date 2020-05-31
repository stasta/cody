output "vpc" {
  value = "${aws_vpc.vpc.id}"
}

//TODO remove
output "primary_public_subnet" {
  value = "${aws_subnet.primary_public_subnet.id}"
}

//TODO remove
output "secondary_public_subnet" {
  value = "${aws_subnet.secondary_public_subnet.id}"
}

output "public_subnets" {
  value = ["${aws_subnet.public_subnets.*.id}"]
}
