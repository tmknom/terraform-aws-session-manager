# terraform-aws-session-manager

[![CircleCI](https://circleci.com/gh/tmknom/terraform-aws-session-manager.svg?style=svg)](https://circleci.com/gh/tmknom/terraform-aws-session-manager)
[![GitHub tag](https://img.shields.io/github/tag/tmknom/terraform-aws-session-manager.svg)](https://registry.terraform.io/modules/tmknom/session-manager/aws)
[![License](https://img.shields.io/github/license/tmknom/terraform-aws-session-manager.svg)](https://opensource.org/licenses/Apache-2.0)

Terraform module which creates Session Manager resources on AWS.

## Description

Provision [SSM Documents](https://docs.aws.amazon.com/systems-manager/latest/userguide/getting-started-configure-preferences-cli.html),
[EC2 Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html) and
[Instance Profiles for Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-instance-profile.html).

This module provides recommended settings:

- No open inbound ports
- Loggable session activity

## Usage

### Minimal

```hcl
module "session_manager" {
  source        = "git::https://github.com/tmknom/terraform-aws-session-manager.git?ref=tags/1.2.0"
  name          = "example"
  instance_type = "t2.micro"
  subnet_id     = "${var.subnet_id}"
  vpc_id        = "${var.vpc_id}"
}
```

### Complete

```hcl
module "session_manager" {
  source        = "git::https://github.com/tmknom/terraform-aws-session-manager.git?ref=tags/1.2.0"
  name          = "example"
  instance_type = "t2.micro"
  subnet_id     = "${var.subnet_id}"
  vpc_id        = "${var.vpc_id}"

  ssm_document_name             = "SSM-SessionManagerRunShell-for-example"
  s3_bucket_name                = "${var.s3_bucket_name}"
  s3_key_prefix                 = "prefix"
  s3_encryption_enabled         = false
  cloudwatch_log_group_name     = "${var.cloudwatch_log_group_name}"
  cloudwatch_encryption_enabled = false
  ami                           = "${var.ami}"
  vpc_security_group_ids        = ["${var.vpc_security_group_ids}"]
  iam_policy                    = "${var.iam_policy}"
  iam_path                      = "/service-role/"
  description                   = "This is example"

  tags = {
    Environment = "prod"
  }
}
```

## Examples

- [Minimal](https://github.com/tmknom/terraform-aws-session-manager/tree/master/examples/minimal)
- [Complete](https://github.com/tmknom/terraform-aws-session-manager/tree/master/examples/complete)

## Inputs

| Name                          | Description                                                           |  Type  |           Default            | Required |
| ----------------------------- | --------------------------------------------------------------------- | :----: | :--------------------------: | :------: |
| instance_type                 | The type of instance to start.                                        | string |              -               |   yes    |
| name                          | The name of the Session Manager.                                      | string |              -               |   yes    |
| subnet_id                     | The VPC Subnet ID to launch in.                                       | string |              -               |   yes    |
| vpc_id                        | The VPC ID.                                                           | string |              -               |   yes    |
| ami                           | The AMI to use for the instance.                                      | string |           `` | no            |
| cloudwatch_encryption_enabled | Specify true to indicate that encryption for CloudWatch Logs enabled. | string |            `true`            |    no    |
| cloudwatch_log_group_name     | The name of the log group.                                            | string |           `` | no            |
| description                   | The description of the all resources.                                 | string |    `Managed by Terraform`    |    no    |
| iam_path                      | Path in which to create the IAM Role and the IAM Policy.              | string |             `/`              |    no    |
| iam_policy                    | The policy document. This is a JSON formatted string.                 | string |           `` | no            |
| s3_bucket_name                | The name of the bucket.                                               | string |           `` | no            |
| s3_encryption_enabled         | Specify true to indicate that encryption for S3 Bucket enabled.       | string |            `true`            |    no    |
| s3_key_prefix                 | The prefix for the specified S3 bucket.                               | string |           `` | no            |
| ssm_document_name             | The name of the document.                                             | string | `SSM-SessionManagerRunShell` |    no    |
| tags                          | A mapping of tags to assign to all resources.                         |  map   |             `{}`             |    no    |
| user_data                     | The user data to provide when launching the instance.                 | string |           `` | no            |
| vpc_security_group_ids        | A list of security group IDs to associate with.                       |  list  |             `[]`             |    no    |

## Outputs

| Name                                  | Description                                                  |
| ------------------------------------- | ------------------------------------------------------------ |
| iam_instance_profile_arn              | The ARN assigned by AWS to the instance profile.             |
| iam_instance_profile_create_date      | The creation timestamp of the instance profile.              |
| iam_instance_profile_id               | The instance profile's ID.                                   |
| iam_instance_profile_name             | The instance profile's name.                                 |
| iam_instance_profile_path             | The path of the instance profile in IAM.                     |
| iam_instance_profile_role             | The role assigned to the instance profile.                   |
| iam_instance_profile_unique_id        | The unique ID assigned by AWS.                               |
| iam_policy_arn                        | The ARN assigned by AWS to this IAM Policy.                  |
| iam_policy_description                | The description of the IAM Policy.                           |
| iam_policy_document                   | The policy document of the IAM Policy.                       |
| iam_policy_id                         | The IAM Policy's ID.                                         |
| iam_policy_name                       | The name of the IAM Policy.                                  |
| iam_policy_path                       | The path of the IAM Policy.                                  |
| iam_role_arn                          | The Amazon Resource Name (ARN) specifying the IAM Role.      |
| iam_role_create_date                  | The creation date of the IAM Role.                           |
| iam_role_description                  | The description of the IAM Role.                             |
| iam_role_name                         | The name of the IAM Role.                                    |
| iam_role_unique_id                    | The stable and unique string identifying the IAM Role.       |
| instance_arn                          | The ARN of the instance.                                     |
| instance_availability_zone            | The availability zone of the instance.                       |
| instance_id                           | The instance ID.                                             |
| instance_key_name                     | The key name of the instance.                                |
| instance_placement_group              | The placement group of the instance.                         |
| instance_primary_network_interface_id | The ID of the instance's primary network interface.          |
| instance_private_dns                  | The private DNS name assigned to the instance.               |
| instance_private_ip                   | The private IP address assigned to the instance.             |
| instance_security_groups              | The associated security groups.                              |
| instance_subnet_id                    | The VPC subnet ID.                                           |
| security_group_arn                    | The ARN of the security group.                               |
| security_group_description            | The description of the security group.                       |
| security_group_egress                 | The egress rules of the security group.                      |
| security_group_id                     | The ID of the security group.                                |
| security_group_ingress                | The ingress rules of the security group.                     |
| security_group_name                   | The name of the security group.                              |
| security_group_owner_id               | The owner ID of the security group.                          |
| security_group_vpc_id                 | The VPC ID of the security group.                            |
| ssm_document_default_version          | The default version of the document.                         |
| ssm_document_description              | The description of the document.                             |
| ssm_document_hash                     | The sha1 or sha256 of the document content.                  |
| ssm_document_hash_type                | The hashing algorithm used when hashing the content.         |
| ssm_document_latest_version           | The latest version of the document.                          |
| ssm_document_owner                    | The AWS user account of the person who created the document. |
| ssm_document_parameter                | The parameters that are available to this document.          |
| ssm_document_platform_types           | A list of OS platforms compatible with this SSM document.    |
| ssm_document_schema_version           | The schema version of the document.                          |
| ssm_document_status                   | The current status of the document.                          |

## Development

### Requirements

- [Docker](https://www.docker.com/)

### Configure environment variables

```shell
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=ap-northeast-1
```

### Installation

```shell
git clone git@github.com:tmknom/terraform-aws-session-manager.git
cd terraform-aws-session-manager
make install
```

### Makefile targets

```text
check-format                   Check format code
cibuild                        Execute CI build
clean                          Clean .terraform
docs                           Generate docs
format                         Format code
help                           Show help
install                        Install requirements
lint                           Lint code
release                        Release GitHub and Terraform Module Registry
start-session                  Start session to example
terraform-apply-complete       Run terraform apply examples/complete
terraform-apply-minimal        Run terraform apply examples/minimal
terraform-destroy-complete     Run terraform destroy examples/complete
terraform-destroy-minimal      Run terraform destroy examples/minimal
terraform-plan-complete        Run terraform plan examples/complete
terraform-plan-minimal         Run terraform plan examples/minimal
upgrade                        Upgrade makefile
```

### Releasing new versions

Bump VERSION file, and run `make release`.

### Terraform Module Registry

- <https://registry.terraform.io/modules/tmknom/session-manager/aws>

## License

Apache 2 Licensed. See LICENSE for full details.
