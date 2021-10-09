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