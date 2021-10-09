resource "aws_elb" "tf-prod-webapp-load-balancer" {
  name = "tf-prod-webapp-load-balancer"
  internal = false
  security_groups = ["${aws_security_group.tf-elb-security-group.id}"]
  subnets = [
    "${data.terraform_remote_state.network_configuration.outputs.tf-public-subnet-1-id}",
    "${data.terraform_remote_state.network_configuration.outputs.tf-public-subnet-2-id}",
    "${data.terraform_remote_state.network_configuration.outputs.tf-public-subnet-3-id}"
  ]
  listener {
    instance_port = 80
    instance_protocol = "HTTP"
    lb_port = 80
    lb_protocol = "HTTP"
  } 

  health_check {
    healthy_threshold = 5
    interval = 30
    target = "http:80/index.html"
    timeout = 10
    unhealthy_threshold = 5
  }
}

resource "aws_elb" "tf-prod-backend-load-balancer" {
  name = "tf-prod-backend-load-balancer"
  internal = true
  security_groups = ["${aws_security_group.tf-elb-security-group.id}"]
  subnets = [
    "${data.terraform_remote_state.network_configuration.outputs.tf-private-subnet-1-id}",
    "${data.terraform_remote_state.network_configuration.outputs.tf-private-subnet-2-id}",
    "${data.terraform_remote_state.network_configuration.outputs.tf-private-subnet-3-id}"
  ]
  listener {
    instance_port = 80
    instance_protocol = "HTTP"
    lb_port = 80
    lb_protocol = "HTTP"
  } 

  health_check {
    healthy_threshold = 5
    interval = 30
    target = "http:80/index.html"
    timeout = 10
    unhealthy_threshold = 5
  }
}