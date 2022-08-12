# Terraform module which creates Session Manager resources on AWS.
#
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html

# SSM Document
#
# https://docs.aws.amazon.com/systems-manager/latest/userguide/getting-started-configure-preferences-cli.html

# https://www.terraform.io/docs/providers/aws/r/ssm_document.html
resource "aws_ssm_document" "default" {
  name            = var.ssm_document_name
  document_type   = "Session"
  document_format = "JSON"
  tags            = merge({ "Name" = var.ssm_document_name }, var.tags)

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to hold regional settings for Session Manager"
    sessionType   = "Standard_Stream"
    inputs = {
      s3BucketName                = var.s3_bucket_name
      s3KeyPrefix                 = var.s3_key_prefix
      s3EncryptionEnabled         = var.s3_encryption_enabled
      cloudWatchLogGroupName      = var.cloudwatch_log_group_name
      cloudWatchEncryptionEnabled = var.cloudwatch_encryption_enabled
    }
  })
}

# EC2 Instance
#
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html

# https://www.terraform.io/docs/providers/aws/r/instance.html
resource "aws_instance" "default" {
  ami                    = local.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.default.name
  vpc_security_group_ids = flatten([aws_security_group.default.id, var.vpc_security_group_ids])

  user_data = var.user_data
  tags      = merge({ "Name" = var.name }, var.tags)
}

# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "default" {
  name        = local.security_group_name
  vpc_id      = var.vpc_id
  description = var.description
  tags        = merge({ "Name" = local.security_group_name }, var.tags)
}

# https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

locals {
  ami                 = var.ami == "" ? data.aws_ami.default.id : var.ami
  security_group_name = "${var.name}-session-manager-ec2"
}

# https://www.terraform.io/docs/providers/aws/d/ami.html#attributes-reference
data "aws_ami" "default" {
  most_recent = true
  owners      = ["amazon"]

  # Describe filters
  # https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeImages.html
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Session Manager IAM Instance Profile
#
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-getting-started-instance-profile.html

# https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html
resource "aws_iam_instance_profile" "default" {
  name = local.iam_name
  role = aws_iam_role.default.name
  path = var.iam_path
}

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "default" {
  name               = local.iam_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  path               = var.iam_path
  description        = var.description
  tags               = merge({ "Name" = local.iam_name }, var.tags)
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# https://www.terraform.io/docs/providers/aws/r/iam_policy.html
resource "aws_iam_policy" "default" {
  name        = local.iam_name
  policy      = local.iam_policy
  path        = var.iam_path
  description = var.description
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

locals {
  iam_name   = "${var.name}-session-manager"
  iam_policy = var.iam_policy == "" ? data.aws_iam_policy.default.policy : var.iam_policy
}

data "aws_iam_policy" "default" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
