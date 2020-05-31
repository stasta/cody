data "aws_availability_zones" "azs" {
  all_availability_zones = true
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.vpc_name}"
  }
}

//// TODO remove
//resource "aws_subnet" "primary_public_subnet" {
//  cidr_block              = "${var.subnet_cidr_block["primary_public"]}"
//  vpc_id                  = "${aws_vpc.vpc.id}"
//  availability_zone       = "${data.aws_availability_zones.azs.names[0]}"
//  map_public_ip_on_launch = true
//
//  tags = {
//    Name = "public-${data.aws_availability_zones.azs.names[0]}"
//  }
//}
//
//// TODO remove
//resource "aws_subnet" "secondary_public_subnet" {
//  cidr_block              = "${var.subnet_cidr_block["secondary_public"]}"
//  vpc_id                  = "${aws_vpc.vpc.id}"
//  availability_zone       = "${data.aws_availability_zones.azs.names[1]}"
//  map_public_ip_on_launch = true
//
//  tags = {
//    Name = "public-${data.aws_availability_zones.azs.names[1]}"
//  }
//}

resource "aws_subnet" "public_subnets" {
  vpc_id = "${aws_vpc.vpc.id}"
  count  = "${length(var.subnets_cidr_block)}"

  cidr_block        = "${element( var.subnets_cidr_block, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.azs.names, count.index)}"

  tags = {
    Name = "public-${element(data.aws_availability_zones.azs.names, count.index)}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  count          = "${length(var.subnets_cidr_block)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
  subnet_id      = "${element(aws_subnet.public_subnets.*.id, count.index)}"
}

// TODO remove
//resource "aws_route_table_association" "primary_public_subnet_route_table_association" {
//  route_table_id = "${aws_route_table.public_route_table.id}"
//  subnet_id      = "${aws_subnet.primary_public_subnet.id}"
//}


// TODO remove
//resource "aws_route_table_association" "secondary_public_subnet_route_table_association" {
//  route_table_id = "${aws_route_table.public_route_table.id}"
//  subnet_id      = "${aws_subnet.secondary_public_subnet.id}"
//}

