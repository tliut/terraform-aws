variable "region" {
  default = "us-east-2"
  description = "AWS Region"
}
variable "remote_state_bucket" {
  description = "Bucket name for layer 1 remote state"
}

variable "remote_state_key" {
  description = "Key name for layer 1 remote state"
}
variable "instance-type" {
  description = "Instance type to launch in autoscaling group"
}
variable "keyname" {
  default = "myKP"
  description = "SSH Key name for EC2 instance"
}

variable "max-instance-size" {
  description = "Maximum number of instances for autoscaling group"
}
variable "min-instance-size" {
  description = "Minimum number of instances for autoscaling group"
}

