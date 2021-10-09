provider "aws" {
  region = "${var.region}"
}

terraform {
    backend "s3" {}
}

resource "aws_vpc" "tf-prod-vpc" {
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
      Name = "tf-prod-vpc"
  }
}

resource "aws_subnet" "tf-public-subnet-1" {
  cidr_block = "${var.public_subnet_1_cidr}"
  vpc_id = "${aws_vpc.tf-prod-vpc.id}"
  availability_zone = "us-east-2a"
  tags = {
      Name  = "tf-public-subnet-1"
  }
}

resource "aws_subnet" "tf-public-subnet-2" {
  cidr_block = "${var.public_subnet_2_cidr}"
  vpc_id = "${aws_vpc.tf-prod-vpc.id}"
  availability_zone = "us-east-2b"
  tags = {
      Name  = "tf-public-subnet-2"
  }
}

resource "aws_subnet" "tf-public-subnet-3" {
  cidr_block        = "${var.public_subnet_3_cidr}"
  vpc_id            = "${aws_vpc.tf-prod-vpc.id}"
  availability_zone = "us-east-2c"
  tags = {
      Name  = "tf-public-subnet-3"
  }
}

resource "aws_subnet" "tf-private-subnet-1" {
  cidr_block        = "${var.private_subnet_1_cidr}"
  vpc_id            = "${aws_vpc.tf-prod-vpc.id}"
  availability_zone = "us-east-2a"
  tags = {
      Name  = "tf-private-subnet-1"
  }
}
resource "aws_subnet" "tf-private-subnet-2" {
  cidr_block        = "${var.private_subnet_2_cidr}"
  vpc_id            = "${aws_vpc.tf-prod-vpc.id}"
  availability_zone = "us-east-2b"
  tags = {
      Name  = "tf-private-subnet-2"
  }
}

resource "aws_subnet" "tf-private-subnet-3" {
  cidr_block        = "${var.private_subnet_3_cidr}"
  vpc_id            = "${aws_vpc.tf-prod-vpc.id}"
  availability_zone = "us-east-2c"
  tags = {
      Name  = "tf-private-subnet-3"
  }
}

resource "aws_route_table" "tf-public-route-table" {
  vpc_id = "${aws_vpc.tf-prod-vpc.id}"
  tags = {
      Name = "tf-public-route-table"
  }
}
resource "aws_route_table" "tf-private-route-table" {
  vpc_id = "${aws_vpc.tf-prod-vpc.id}"
  tags = {
      Name = "tf-private-route-table"
  }
}

resource "aws_route_table_association" "tf-public-subnet-1-association" {
  route_table_id = "${aws_route_table.tf-public-route-table.id}"
  subnet_id = "${aws_subnet.tf-public-subnet-1.id}"
}

resource "aws_route_table_association" "tf-public-subnet-2-association" {
  route_table_id = "${aws_route_table.tf-public-route-table.id}"
  subnet_id = "${aws_subnet.tf-public-subnet-2.id}"
}
resource "aws_route_table_association" "tf-public-subnet-3-association" {
  route_table_id = "${aws_route_table.tf-public-route-table.id}"
  subnet_id = "${aws_subnet.tf-public-subnet-3.id}"
}

resource "aws_route_table_association" "tf-private-subnet-1-association" {
  route_table_id = "${aws_route_table.tf-private-route-table.id}"
  subnet_id = "${aws_subnet.tf-private-subnet-1.id}"
}
resource "aws_route_table_association" "tf-private-subnet-2-association" {
  route_table_id = "${aws_route_table.tf-private-route-table.id}"
  subnet_id = "${aws_subnet.tf-private-subnet-2.id}"
}
resource "aws_route_table_association" "tf-private-subnet-3-association" {
  route_table_id = "${aws_route_table.tf-private-route-table.id}"
  subnet_id = "${aws_subnet.tf-private-subnet-3.id}"
}

resource "aws_eip" "tf-eip-for-nat-gw" {
  vpc =   true
  associate_with_private_ip = "10.0.0.5"

  tags = {
      Name    = "tf-prod-eip"
    }
}

resource "aws_nat_gateway" "tf-prod-NAT-GW" {
  depends_on = ["aws_eip.tf-eip-for-nat-gw"]
  allocation_id = "${aws_eip.tf-eip-for-nat-gw.id}"
  subnet_id = "${aws_subnet.tf-public-subnet-1.id}"

  tags = {
    Name = "tf-prod-NAT-GW"
  }
}

resource "aws_route" "tf-NAT-GW-route" {
  route_table_id = "${aws_route_table.tf-private-route-table.id}"
  nat_gateway_id = "${aws_nat_gateway.tf-prod-NAT-GW.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "tf-prod-IGW" {
  vpc_id = "${aws_vpc.tf-prod-vpc.id}"

  tags = {
    Name = "tf-prod-IGW"
  }
}

resource "aws_route" "tf-public-internet-route-4-IGW" {
  route_table_id = "${aws_route_table.tf-public-route-table.id}"
  gateway_id = "${aws_internet_gateway.tf-prod-IGW.id}"
  destination_cidr_block = "0.0.0.0/0"
}