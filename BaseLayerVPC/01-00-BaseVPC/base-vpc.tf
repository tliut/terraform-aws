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