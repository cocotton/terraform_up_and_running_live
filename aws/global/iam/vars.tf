variable "iam_users" {
  description = "IAM users"
  type        = "list"
  default     = ["neo", "trinity", "morpheus"]
}

variable "give_neo_cloudwatch_read_write" {
  description = "If true. net gets full access to CloudWatch"
}
