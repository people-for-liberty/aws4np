output "remote_state" {
  description = "Terraform remote state bucket and lock table."

  value = {
    bucket     = aws_s3_bucket.terraform_state.id
    lock_table = aws_dynamodb_table.terraform_locks.name
    region     = var.region
    account_id = var.aws_account_id
  }
}

output "wordpress" {
  description = "WordPress on Lightsail (populated after spec 003 apply)."

  value = var.enable_wordpress_lightsail ? {
    static_ip     = aws_lightsail_static_ip.wordpress[0].ip_address
    instance_name = aws_lightsail_instance.wordpress[0].name
    http_url      = "http://${aws_lightsail_static_ip.wordpress[0].ip_address}"
    blueprint_id  = var.lightsail_wordpress_blueprint_id
    bundle_id     = var.lightsail_wordpress_bundle_id
  } : null
}
