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