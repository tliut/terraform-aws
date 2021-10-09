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