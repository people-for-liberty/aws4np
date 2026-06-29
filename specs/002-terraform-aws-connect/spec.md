# Spec 002: Connect Terraform to AWS

**Status**: Template reference — complete on branch `002-terraform-aws-connect` during `start.ai` §3 training  
**Branch**: `002-terraform-aws-connect`  
**Audience**: Nonprofit with session gates 0–2 complete (fork, speckit CLI, `.secrets/tu.keys`)

## Goal

Connect this repository to the nonprofit’s AWS account with **Terraform remote state** (S3 + DynamoDB), run `init` / `validate` / `plan`, and merge infrastructure config via PR — the first speckit training exercise.

## How this spec maps to onboarding

| Phase | What | Where |
|-------|------|--------|
| **Prereq** | Fork, VS Code + AI, speckit CLI, AWS credentials | `start.ai` §0–2, `setup/install*.md` |
| **1–4** | Terraform install, remote state, init/plan, PR merge | `start.ai` §3 — `setup/speckitFirstTraining.md` |

**Do not apply from this reference on `main` without a feature branch and reviewed plan.**

## User stories

### P1 — Terraform connected (MVP)

**As** nonprofit tech volunteer, **I want** Terraform to use our AWS account with remote state **so** infrastructure changes are tracked and shared safely.

**Acceptance:**

- Terraform `>= 1.13` installed
- S3 state bucket + DynamoDB lock table exist (via `scripts/bootstrap-remote-state.sh`)
- `config/backend.hcl` and `aws/terraform.tfvars` configured (gitignored)
- `terraform init`, `validate`, and `plan` succeed
- `terraform plan` reviewed; apply only with explicit approval
- Spec merged to `main`; `progress.ai` updated

## Scope

- Install Terraform (`setup/installTerraform.md`)
- `ORG_SLUG`, `scripts/bootstrap-remote-state.sh`
- Backend config and tfvars from examples
- First plan for `aws/backend_state.tf` (remote state resources in Terraform)
- Optional: `terraform apply` for `backend_state.tf` after approval

## Out of scope

- Application workloads (WordPress, etc.) — spec **003**
- Importing existing manual AWS resources
- CI/CD

## Acceptance

- `scripts/check-session-prereqs.sh` passes (including terraform validate after init)
- Spec `002` merged via PR
- Account ID and state bucket documented in `progress.ai`

## What's next

[docs/where-to-go-from-here.md](../../docs/where-to-go-from-here.md) — after merge, continue to spec **003** (WordPress) via `start.ai` §4.
