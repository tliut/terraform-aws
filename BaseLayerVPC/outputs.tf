output "tf-vpc-id" {
  value = "${aws_vpc.tf-prod-vpc.id}"
}

output "tf-vpc-cidr-block" {
  value = "${aws_vpc.tf-prod-vpc.cidr_block}"
}

output "tf-public-subnet-1-id" {
  value = "${aws_subnet.tf-public-subnet-1.id}"
}
output "tf-public-subnet-2-id" {
  value = "${aws_subnet.tf-public-subnet-2.id}"
}
output "tf-public-subnet-3-id" {
  value = "${aws_subnet.tf-public-subnet-3.id}"
}

output "tf-private-subnet-1-id" {
  value = "${aws_subnet.tf-private-subnet-1.id}"
}
output "tf-private-subnet-2-id" {
  value = "${aws_subnet.tf-private-subnet-2.id}"
}
output "tf-private-subnet-3-id" {
  value = "${aws_subnet.tf-private-subnet-3.id}"
}

