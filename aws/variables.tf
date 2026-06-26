variable "org_slug" {
  type        = string
  description = "Short lowercase org identifier used in resource names (e.g. my-nonprofit)."
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID for this 501(c)(3). Used in naming and validation."
}

variable "region" {
  type    = string
  default = "us-east-1"
}

locals {
  state_bucket_name = "${var.org_slug}-terraform-state-${var.aws_account_id}"
  lock_table_name   = "${var.org_slug}-terraform-locks"
}
