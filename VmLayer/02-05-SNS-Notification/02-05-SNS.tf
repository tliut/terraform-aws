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
