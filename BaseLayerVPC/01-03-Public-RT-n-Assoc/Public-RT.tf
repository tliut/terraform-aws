resource "aws_route_table" "tf-public-route-table" {
  vpc_id = "${aws_vpc.tf-prod-vpc.id}"
  tags = {
      Name = "tf-public-route-table"
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