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