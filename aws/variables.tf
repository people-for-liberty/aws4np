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
  state_bucket_name           = "${var.org_slug}-terraform-state-${var.aws_account_id}"
  lock_table_name             = "${var.org_slug}-terraform-locks"
  wordpress_availability_zone = "${var.region}a"
}

variable "lightsail_wordpress_blueprint_id" {
  type        = string
  description = "Lightsail WordPress blueprint ID for var.region (aws lightsail get-blueprints). Required when enable_wordpress_lightsail is true."
  default     = ""
}

variable "lightsail_wordpress_bundle_id" {
  type        = string
  description = "Lightsail bundle (WordPress needs at least small; e.g. small_3_0)."
  default     = "small_3_0"
}

variable "enable_wordpress_lightsail" {
  type        = bool
  description = "Create Lightsail WordPress stack (spec 003). Leave false until §4 training."
  default     = false
}
