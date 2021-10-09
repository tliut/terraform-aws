variable "region" {
    default = "us-east-2"
    description = "AWS Default Region"
}
variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
    description = "VPC CIDR Block"
}
variable "public_subnet_1_cidr" {
    description = "Public Subnet 1 CIDR Block"
}
variable "public_subnet_2_cidr" {
    description = "Public Subnet 2 CIDR Block"
}
variable "public_subnet_3_cidr" {
    description = "Public Subnet 3 CIDR Block"
}
variable "private_subnet_1_cidr" {
    description = "Private Subnet 1 CIDR Block"
}

variable "private_subnet_2_cidr" {
    description = "Private Subnet 2 CIDR Block"
}
variable "private_subnet_3_cidr" {
    description = "Private Subnet 3 CIDR Block"
}