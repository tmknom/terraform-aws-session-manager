variable "name" {
  type        = "string"
  description = "The name of the Session Manager."
}

variable "instance_type" {
  type        = "string"
  description = "The type of instance to start."
}

variable "subnet_id" {
  type        = "string"
  description = "The VPC Subnet ID to launch in."
}

variable "vpc_id" {
  type        = "string"
  description = "The VPC ID."
}

variable "ssm_document_name" {
  default     = "SSM-SessionManagerRunShell"
  type        = "string"
  description = "The name of the document."
}

variable "s3_bucket_name" {
  default     = ""
  type        = "string"
  description = "The name of the bucket."
}

variable "s3_key_prefix" {
  default     = ""
  type        = "string"
  description = "The prefix for the specified S3 bucket."
}

variable "s3_encryption_enabled" {
  default     = "true"
  type        = "string"
  description = "Specify true to indicate that encryption for S3 Bucket enabled."
}

variable "cloudwatch_log_group_name" {
  default     = ""
  type        = "string"
  description = "The name of the log group."
}

variable "cloudwatch_encryption_enabled" {
  default     = "true"
  type        = "string"
  description = "Specify true to indicate that encryption for CloudWatch Logs enabled."
}

variable "ami" {
  default     = ""
  type        = "string"
  description = "The AMI to use for the instance."
}

variable "vpc_security_group_ids" {
  default     = []
  type        = "list"
  description = "A list of security group IDs to associate with."
}

variable "iam_policy" {
  default     = ""
  type        = "string"
  description = "The policy document. This is a JSON formatted string."
}

variable "iam_path" {
  default     = "/"
  type        = "string"
  description = "Path in which to create the IAM Role and the IAM Policy."
}

variable "description" {
  default     = "Managed by Terraform"
  type        = "string"
  description = "The description of the all resources."
}

variable "tags" {
  default     = {}
  type        = "map"
  description = "A mapping of tags to assign to all resources."
}
