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