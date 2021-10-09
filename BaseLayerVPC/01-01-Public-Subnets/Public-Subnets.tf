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