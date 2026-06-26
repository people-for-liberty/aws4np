output "remote_state" {
  description = "Terraform remote state bucket and lock table."

  value = {
    bucket     = aws_s3_bucket.terraform_state.id
    lock_table = aws_dynamodb_table.terraform_locks.name
    region     = var.region
    account_id = var.aws_account_id
  }
}
