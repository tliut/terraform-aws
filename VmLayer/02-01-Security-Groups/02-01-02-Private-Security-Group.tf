resource "aws_security_group" "tf-ec2-private-security-group" {
  name = "tf-ec2-private-security-group"
  description = "Only allow public SG to access EC2 Instances"
  vpc_id = "${data.terraform_remote_state.network_configuration.outputs.tf-vpc-id}"

  ingress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    security_groups = [ "${aws_security_group.tf-ec2-public-security-group.id}" ]
  }

  ingress {
    protocol = "TCP"
    from_port = 80
    to_port = 80
    cidr_blocks = [ "0.0.0.0/0"]
    description = "Allow health check on the instances using this SG"
  } 
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  } 
}