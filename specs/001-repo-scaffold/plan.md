# Implementation Plan: Repository scaffold

**Branch**: `001-repo-scaffold` | **Spec**: [spec.md](./spec.md)

## Summary

Guide a new nonprofit from empty fork to Terraform-ready remote state with speckit governance.

## Technical Context

**Stack**: Terraform >= 1.13, AWS provider ~> 5.0, us-east-1 default  
**Secrets**: `tu.keys` (gitignored), `config/backend.hcl` (gitignored)  
**Bootstrap**: `scripts/bootstrap-remote-state.sh` then `backend_state.tf` apply (with approval)

## Constitution Check

| Principle | Status |
|-----------|--------|
| Safety-first | PASS — plan before apply |
| Terraform-first | PASS |
| Secrets hygiene | PASS — tu.keys.example only in git |
| Spec-driven | PASS — this spec |
| Branch discipline | PASS — feature branch for org-specific commits |

## Phases

1. Credentials + session prereqs
2. Remote state bootstrap (CLI or script)
3. Terraform init with backend config
4. Plan/apply `backend_state.tf` (apply needs approval)
5. Record account ID and resource names in `progress.ai`
