data "aws_region" "region" {
  name = "${var.vpc_region}"
}

data "aws_availability_zones" "azs" {
  all_availability_zones = true
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "primary_public_subnet" {
  cidr_block = "${var.subnet_cidr_block["primary_public"]}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${data.aws_availability_zones.azs.names[0]}"

  tags = {
    Name = "public-${data.aws_availability_zones.azs.names[0]}"
  }}

resource "aws_subnet" "secondary_public_subnet" {
  cidr_block = "${var.subnet_cidr_block["secondary_public"]}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${data.aws_availability_zones.azs.names[1]}"

  tags = {
    Name = "public-${data.aws_availability_zones.azs.names[1]}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}