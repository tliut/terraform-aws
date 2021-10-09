provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "network_configuration" {
  backend = "s3"

  config = {
      bucket = "${var.remote_state_bucket}"
      key = "${var.remote_state_key}"
      region = "${var.region}"
  }
}

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
    cidr_blocks = [ "99.112.186.52/32" ]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  } 
}
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

resource "aws_iam_role" "tf-ec2-iam-role" {
  name               = "tf-ec2-iam-role"
  assume_role_policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement":
  [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com", "application-autoscaling.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "tf-ec2-iam-role-policy" {
  name = "tf-ec2-iam-role-policy"
  role = "${aws_iam_role.tf-ec2-iam-role.id}"
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "ec2:*",
        "elasticloadbalancing:*",
        "cloudwatch:*",
        "logs:*"
      ],
      "Resource" : "*"
    }
  ]
}
  EOF
}

resource "aws_iam_instance_profile" "tf-ec2-instance-profile" {
  name = "tf-ec2-instance-profile"
  role = "${aws_iam_role.tf-ec2-iam-role.name}"
}

# data "aws_ami" "tf-launch-configuration-ami" {
#   most_recent = true

#   filter {
#     name = "owner-alias"
#     values = ["amazon"]
#   }
# }

resource "aws_launch_configuration" "tf-ec2-private-launch-configuration" {
  image_id = "ami-074cce78125f09d61"
  instance_type = "${var.instance-type}"
  key_name = "${var.keyname}"
  associate_public_ip_address =false
  iam_instance_profile = "${aws_iam_instance_profile.tf-ec2-instance-profile.name}"
  security_groups = ["${aws_security_group.tf-ec2-private-security-group.id}"]

  user_data = <<EOF
  #!/bin/bash
  yum update -y
  yum install httd -y
  service httpd start
  chkconfig httpd on
  export INSTANCE_ID=$(curl http://169.254.169.254/meta-data/instance-id)
  echo "<html><body><h1>Hello from the Production Backend at Instance <b>"$INSTANCE_ID"</b></h1></body></html>" > /var/www/html/index.html

  EOF

}

resource "aws_launch_configuration" "tf-ec2-public-launch-configuration" {
  image_id = "ami-074cce78125f09d61"
  instance_type = "${var.instance-type}"
  key_name = "${var.keyname}"
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.tf-ec2-instance-profile.name}"
  security_groups = ["${aws_security_group.tf-ec2-public-security-group.id}"]

  user_data = <<EOF
  #!/bin/bash
  yum update -y
  yum install httpd -y
  service httpd start
  chkconfig httpd on
  export INSTANCE_ID=$(curl http://169.254.169.254/meta-data/instance-id)
  echo "<html><body><h1>Hello from the Production Backend at Instance <b>"$INSTANCE_ID"</b></h1></body></html>" > /var/www/html/index.html

  EOF

}

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

resource "aws_autoscaling_policy" "tf-webapp-prod-autoscaling-policy" {
  autoscaling_group_name = "${aws_autoscaling_group.tf-ec2-webapp-public-autoscaling-group.name}"
  name = "tf-webapp-prod-autoscaling-policy"
  policy_type = "TargetTrackingScaling"
  min_adjustment_magnitude = 1

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization" 
    }
    target_value = 80.0
  }
}

resource "aws_autoscaling_policy" "tf-backend-prod-autoscaling-policy" {
  autoscaling_group_name = "${aws_autoscaling_group.tf-ec2-backend-private-autoscaling-group.name}"
  name = "tf-backend-prod-autoscaling-policy"
  policy_type = "TargetTrackingScaling"
  min_adjustment_magnitude = 1

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization" 
    }
    target_value = 80.0
  }
}

resource "aws_sns_topic" "tf-webapp-prod-autoscaling-alert-topic" {
  display_name = "tf-webapp-prod-autoscaling-alert-topic"
  name = "tf-webapp-prod-autoscaling-alert-topic" 
}

resource "aws_sns_topic_subscription" "tf-webapp-prod-autoscaling-sns-subscription" {
  endpoint = "+1xxxyyyabcd"
  protocol = "sms"
  topic_arn = "${aws_sns_topic.tf-webapp-prod-autoscaling-alert-topic.arn}"
}

resource "aws_autoscaling_notification" "tf-webapp-autoscaling-notification" {
  group_names = ["${aws_autoscaling_group.tf-ec2-webapp-public-autoscaling-group.name}"]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"
  ]

  topic_arn = "${aws_sns_topic.tf-webapp-prod-autoscaling-alert-topic.arn}"
}
