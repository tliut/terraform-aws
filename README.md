<a name="top"></a>
***
# Terraform IaC-1 - AWS Custom VPC
***

## Summary
Terraform IaC-1 allows you to creates a highly scalable and Highly Available (HA) AWS Cloud Infrastructure with a simple command. The following cloud resources can be provisioned:

1. Layer 1 - A Base VPC with the following components:
    * Custom VPC
    * Subnets (Public/Internet-facing and Private/backend)
    * Route Tables
    * Elastic IP for NAT Gateway
    * NAT and Internet Gateways
2. Layer 2 - Virtual Machine Layer with the following components:
    * Data Source using Remote State from Base Layer
    * Security Groups (Front-end and Back-end)
    * IAM Roles, Role Policy and EC2 Instance Profile
    * Load Balancers
    * ASG - Launch Configuration, Auto Scaling Group & Scaling Policy
    * SNS (Topic, Subscription, and Notification)


**Version**: 0.1.0
***

## Contents
* [**Dependencies**](#dependencies)
* [**Installation**](#installation)
* [**Screenshots**](#screenshots)
* [**Author & Copyright**](#author-copyright)
* [**License**](#license)
* [**Disclaimer**](#disclaimer)

--

[back to the top](#top)

***
## Dependencies
[Terraform IaC-1 - AWS Custom VPC](https://github.com/tliut/terraform-aws) requires the following:
* [Terraform](https://www.terraform.io/downloads.html)
* [AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

[back to the top](#top)

***
## Installation


[back to the top](#top)


***
## Screenshots

#### IaC Level 1: Provision the Base Layer Custom VPC Components:
```bash
    $ cd BaseLayerVPC
    $ terraform apply -var-file=YourProductionConfigFile.tfvars
```

<p align="center">
    <a href="#"><img src="./assets/terraform-iac-base-vpc.JPG" width="800">
</p>

[back to the top](#top)

***

#### IaC Level 2: Provision the Vm Instance and ASG Components:
```bash
    $ cd VmLayer
    $ terraform apply -var-file=YourProductionConfigFile.tfvars
```

<p align="center">
    <a href="#"><img src="./assets/terraform-vm-layer.JPG" width="800">
</p>

[back to the top](#top)

***
## Author & Copyright
All works contained herein copyrighted via below author unless work is explicitly noted by an alternate author.
* Copyright Tony Liu, All Rights Reserved

[back to the top](#top)

***

## License
* Software contained in this repo is licensed under the [license agreement](./LICENSE.md).

[back to the top](#top)

***

## Disclaimer
*Code is provided "as-is". No liability is assumed by either the code's author nor this repo's owner for their use at AWS or any other facility. Additionally, running code to create and provision cloud infrastructure resources at AWS may incur monetary charges; in some cases, charges may be substantial. Charges are the sole responsibility of the account holder executing code obtained from this repository.*

Additional terms may be found in the complete [license agreement](./LICENSE.md)

[back to the top](#top)

***