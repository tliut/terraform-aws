resource "aws_security_group" "tf-ec2-public-security-group" {
  name = "tf-ec2-public-security-group"
  description = "Internet access for EC2 Instances"
  vpc_id = "${data.terraform_remote_state.network_configuration.outputs.tf-vpc-id}"

  ingress {
    protocol = "TCP"
    from_port = 80
    to_port = 80
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  
  ingress {
    protocol = "TCP"
    from_port = 22
    to_port = 22
    cidr_blocks = [ "MY.IP.ADD.RESS/32" ]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  } 
}