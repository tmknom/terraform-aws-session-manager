module "session_manager" {
  source        = "../../"
  name          = "example"
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnet_ids[0]
  vpc_id        = module.vpc.vpc_id

  ssm_document_name             = "SSM-SessionManagerRunShell-for-example"
  s3_bucket_name                = aws_s3_bucket.default.id
  s3_key_prefix                 = "prefix"
  s3_encryption_enabled         = false
  cloudwatch_log_group_name     = aws_cloudwatch_log_group.default.name
  cloudwatch_encryption_enabled = false
  ami                           = data.aws_ami.default.id
  vpc_security_group_ids        = [aws_security_group.default.id]
  user_data                     = file("${path.module}/user_data.sh")
  iam_policy                    = data.aws_iam_policy_document.default.json
  iam_path                      = "/service-role/"
  description                   = "This is example"

  tags = {
    Environment = "prod"
  }
}

resource "aws_s3_bucket" "default" {
  bucket        = "session-manager-${data.aws_caller_identity.current.account_id}"
  acl           = "private"
  force_destroy = true
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/session-manager/example"
  retention_in_days = "1"
}

data "aws_ami" "default" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_security_group" "default" {
  name   = "session-manager"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

data "aws_iam_policy_document" "default" {
  source_json = data.aws_iam_policy.default.policy

  # A custom policy for S3 bucket access
  # https://docs.aws.amazon.com/en_us/systems-manager/latest/userguide/setup-instance-profile.html#instance-profile-custom-s3-policy
  statement {
    sid = "S3BucketAccessForSessionManager"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.default.arn}/*",
    ]
  }

  # A custom policy for CloudWatch Logs access
  # https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/permissions-reference-cwl.html
  statement {
    sid = "CloudWatchLogsAccessForSessionManager"

    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy" "default" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
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

data "aws_caller_identity" "current" {}
