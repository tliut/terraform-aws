resource "aws_autoscaling_group" "tf-ec2-backend-private-autoscaling-group" {
  name = "tf-ec2-backend-private-autoscaling-group"
  vpc_zone_identifier = [
    "${data.terraform_remote_state.network_configuration.outputs.tf-private-subnet-1-id}",
    "${data.terraform_remote_state.network_configuration.outputs.tf-private-subnet-2-id}",
    "${data.terraform_remote_state.network_configuration.outputs.tf-private-subnet-3-id}"    
  ]
  max_size = "${var.max-instance-size}"
  min_size = "${var.min-instance-size}"
  launch_configuration = "${aws_launch_configuration.tf-ec2-private-launch-configuration.name}"
  health_check_type = "ELB"
  load_balancers = ["${aws_elb.tf-prod-backend-load-balancer.name}"]

  tag {
    key = "Name"
    propagate_at_launch = false
    value = "tf-backend-ec2-instance"
  }

  tag {
    key = "Type"
    propagate_at_launch = false
    value = "Backend"
  }
  tag {
    key = "Environment"
    propagate_at_launch = false
    value = "Production"
  }
}

resource "aws_autoscaling_group" "tf-ec2-webapp-public-autoscaling-group" {
  name = "tf-ec2-webapp-public-autoscaling-group"
  vpc_zone_identifier = [
    "${data.terraform_remote_state.network_configuration.outputs.tf-public-subnet-1-id}",
    "${data.terraform_remote_state.network_configuration.outputs.tf-public-subnet-2-id}",
    "${data.terraform_remote_state.network_configuration.outputs.tf-public-subnet-3-id}"    
  ]
  max_size = "${var.max-instance-size}"
  min_size = "${var.min-instance-size}"
  launch_configuration = "${aws_launch_configuration.tf-ec2-public-launch-configuration.name}"
  health_check_type = "ELB"
  load_balancers = ["${aws_elb.tf-prod-webapp-load-balancer.name}"]

  tag {
    key = "Name"
    propagate_at_launch = false
    value = "tf-webapp-ec2-instance"
  }
  tag {
    key = "Type"
    propagate_at_launch = false
    value = "WebApp"
  }
  tag {
    key = "Environment"
    propagate_at_launch = false
    value = "Production"
  }
}