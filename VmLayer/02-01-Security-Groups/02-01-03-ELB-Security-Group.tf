resource "aws_security_group" "tf-elb-security-group" {
  name = "tf-elb-security-group"
  description = "ELB Security Group"
  vpc_id = "${data.terraform_remote_state.network_configuration.outputs.tf-vpc-id}"

  ingress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic to ELB"
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]  
  }
}