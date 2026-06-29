# Implementation Plan: Connect Terraform to AWS

**Branch**: `002-terraform-aws-connect` | **Spec**: [spec.md](./spec.md)

## Summary

Reference plan for first speckit training. Flesh out during `setup/speckitFirstTraining.md` — implement on branch `002-terraform-aws-connect`, not directly on `main`.

## Technical Context

**Stack**: Terraform >= 1.13, AWS provider ~> 5.0, us-east-1 default  
**Secrets**: `.secrets/tu.keys`, `config/backend.hcl`, `aws/terraform.tfvars` (gitignored)  
**Bootstrap**: `scripts/bootstrap-remote-state.sh` (`--yes` only after operator approves in chat)

## Constitution Check

| Principle | Status |
|-----------|--------|
| Safety-first | PASS — plan before apply |
| Terraform-first | PASS |
| Spec-driven | PASS — this spec |
| Branch discipline | PASS — feature branch + PR |
| Secrets hygiene | PASS — no keys in git |

## Phases (reference)

1. Install Terraform; verify version
2. Set `ORG_SLUG`; bootstrap S3 + DynamoDB (`bootstrap-remote-state.sh`)
3. Copy and edit `config/backend.hcl`, `aws/terraform.tfvars`
4. `terraform init` with backend config
5. `fmt`, `validate`, `plan` — review with operator
6. Optional `apply` for `backend_state.tf` — explicit approval only
7. PR, merge, debrief, `progress.ai`

## Notes

- Bootstrap script may create resources before Terraform manages them — `backend_state.tf` aligns Terraform state with reality after apply.
- “Pull down state” for new accounts means **establishing** remote state, not importing a legacy stack.
