# Terraform AWS stack (nonprofit template)

Starter stack for **remote state only**. Add your infrastructure in new `.tf` files under this directory, driven by speckit specs.

## Credentials

IAM keys live in **`tu.keys`** at the repo root (gitignored). See `tu.keys.example`.

```bash
eval "$(scripts/load-aws-env.sh)"
aws sts get-caller-identity   # must match aws_account_id in terraform.tfvars
```

## Remote state

1. `export ORG_SLUG=your-short-org-name`
2. `scripts/bootstrap-remote-state.sh` (creates S3 + DynamoDB)
3. `cp config/backend.hcl.example config/backend.hcl` — fill bucket and lock table names
4. `cp aws/terraform.tfvars.example aws/terraform.tfvars` — set `org_slug` and `aws_account_id`
5. `terraform -chdir=aws init -backend-config=../config/backend.hcl`

| Resource | Typical name |
|----------|----------------|
| S3 bucket | `{org_slug}-terraform-state-{account_id}` |
| State key | `aws/terraform.tfstate` |
| DynamoDB lock | `{org_slug}-terraform-locks` |

`backend_state.tf` manages the same resources in Terraform for drift detection after first apply.

## Commands

```bash
eval "$(scripts/load-aws-env.sh)"
terraform -chdir=aws fmt
terraform -chdir=aws validate
terraform -chdir=aws plan -input=false
```

Never run `terraform apply` without a reviewed plan and explicit human approval.
