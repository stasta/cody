resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "primary_private_subnet" {
  cidr_block = "${var.subnet_cidr_block["primary_private"]}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "primary_private"
  }
}

resource "aws_subnet" "secondary_private_subnet" {
  cidr_block = "${var.subnet_cidr_block["secondary_private"]}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "secondary_private"
  }}

resource "aws_subnet" "primary_public_subnet" {
  cidr_block = "${var.subnet_cidr_block["primary_public"]}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "primary_public"
  }}

resource "aws_subnet" "secondary_public_subnet" {
  cidr_block = "${var.subnet_cidr_block["secondary_public"]}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "secondary_public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}