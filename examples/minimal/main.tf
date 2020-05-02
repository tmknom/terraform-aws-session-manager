module "session_manager" {
  source        = "../../"
  name          = "example"
  instance_type = "t2.micro"
  subnet_id     = element(module.vpc.public_subnet_ids, 0)
  vpc_id        = module.vpc.vpc_id

  ssm_document_name = "SSM-SessionManagerRunShell-for-example"
}

module "vpc" {
  source                    = "git::https://github.com/tmknom/terraform-aws-vpc.git?ref=tags/2.0.1"
  cidr_block                = local.cidr_block
  name                      = "session-manager"
  public_subnet_cidr_blocks = [cidrsubnet(local.cidr_block, 8, 0), cidrsubnet(local.cidr_block, 8, 1)]
  public_availability_zones = data.aws_availability_zones.available.names
}

locals {
  cidr_block = "10.255.0.0/16"
}

data "aws_availability_zones" "available" {}
