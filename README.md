<a name="top></a>
***
# Terraform IaC-1 - AWS Custom VPC
***

## Summary
Terraform InfrastructureAsCode(IaC) Creates a custom VPC with public/private subnets, IGW, NAT GW, ASG and SNS Notification


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
    <a href="#"><img src="./assets/terraform-iac-base-vpc.jpg" width="800">
</p>

[back to the top](#top)

***

#### IaC Level 2: Provision the Vm Instance and ASG Components:
```bash
    $ cd VmLayer
    $ terraform apply -var-file=YourProductionConfigFile.tfvars
```

<p align="center">
    <a href="#"><img src="./assets/terraform-vm-layer.jpg" width="800">
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
* Code is provided "as-is". No liability is assumed by either the code's author nor this repo's owner for their use at AWS or any other facility. Additionally, running code to create and provision cloud infrastructure resources at AWS may incur monetary charges; in some cases, charges may be substantial. Charges are the sole responsibility of the account holder executing code obtained from this repository.*

Additional terms may be found in the complete [license agreement](./LICENSE.md)

[back to the top](#top)

***