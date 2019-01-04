variable "name" {
  type        = "string"
  description = "The name of the Session Manager."
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
