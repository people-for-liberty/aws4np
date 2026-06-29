# Spec 001: Repository scaffold

**Status**: Template reference  
**Branch**: `001-repo-scaffold` (historical; not used for org bootstrap work)  
**Audience**: New 501(c)(3) fork of aws4np

## Goal

Describe the full bootstrap path for a nonprofit Terraform repository: session gates, speckit training, remote state, and first successful `terraform plan`.

## How this spec maps to onboarding

| Phase | What | Where |
|-------|------|--------|
| **1** | Fork, VS Code + AI, speckit CLI, AWS credentials | `start.ai` gates **0–2**, `setup/install*.md` |
| **2–3** | Terraform install, remote state, init, validate, plan, merge | `start.ai` §3 — `specs/002-terraform-aws-connect/` + `setup/speckitFirstTraining.md` |

**Do not implement phases 2–3 directly on `main` from this template spec.** They are the payload of the §3 training exercise so the operator learns branch → spec → plan → tasks → PR → merge.

## Scope (reference)

- Fork aws4np to the org’s GitHub; `.secrets/tu.keys`; `ORG_SLUG`
- S3 + DynamoDB remote state bootstrap (`scripts/bootstrap-remote-state.sh`)
- `terraform init` / `validate` / `plan` for `backend_state.tf`
- Document AWS account and resources in `progress.ai`

## Out of scope

- Application workloads — **spec 003** (WordPress/Lightsail, `start.ai` §4); other apps `004+`
- Importing existing console-built AWS resources — later spec
- CI/CD and IAM role assumption — future spec

## Acceptance (org is bootstrap-complete when)

- `scripts/check-session-prereqs.sh` passes (gates 0–2)
- Speckit training spec (typically `002`) merged to `main` with plan/tasks completed
- `terraform -chdir=aws validate` passes after init
- `terraform plan` reviewed (apply only with explicit approval)
- `.secrets/tu.keys` confirmed gitignored
