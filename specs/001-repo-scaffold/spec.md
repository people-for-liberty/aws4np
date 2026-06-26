# Spec 001: Repository scaffold

**Status**: Template  
**Branch**: `001-repo-scaffold`  
**Audience**: New 501(c)(3) fork of aws4np

## Goal

Bootstrap a nonprofit Terraform repository: credentials hygiene, remote state, speckit workflow, and first successful `terraform plan`.

## Scope

- Fork aws4np; configure `tu.keys` and `ORG_SLUG`
- S3 + DynamoDB remote state bootstrap
- `terraform init` / `validate` / `plan` for `backend_state.tf`
- Document expected AWS account in `progress.ai`

## Out of scope

- Application workloads (Lightsail, RDS, etc.) — future specs `002+`
- CI/CD and IAM role assumption — future spec

## Acceptance

- `scripts/check-session-prereqs.sh` passes
- `terraform plan` shows only expected backend resources (or no drift after first apply)
- `tu.keys` confirmed gitignored
