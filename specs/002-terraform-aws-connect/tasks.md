# Tasks: Connect Terraform to AWS (spec 002)

Complete on branch `002-terraform-aws-connect` during `start.ai` §3 training. Gates 0–2 should already be done.

## Phase 1: Branch and spec

- [ ] T001 `git checkout main && git pull`; `git checkout -b 002-terraform-aws-connect`
- [ ] T002 Review/finish `specs/002-terraform-aws-connect/spec.md`; run `.specify/scripts/bash/setup-plan.sh` if needed
- [ ] T003 Complete `plan.md` and this `tasks.md` with operator

## Phase 2: Terraform and remote state

- [ ] T004 `eval "$(scripts/load-aws-env.sh)"`; `aws sts get-caller-identity`
- [ ] T005 Install Terraform `>= 1.13` — `setup/installTerraform.md`; `terraform version`
- [ ] T006 Choose `ORG_SLUG`; run `scripts/bootstrap-remote-state.sh` (use `--yes` only after explicit chat approval)
- [ ] T007 Copy `config/backend.hcl.example` → `config/backend.hcl`; fill bucket and lock table names
- [ ] T008 Copy `aws/terraform.tfvars.example` → `aws/terraform.tfvars`; set `org_slug` and `aws_account_id`

## Phase 3: Init, plan, merge

- [ ] T009 `terraform -chdir=aws init -backend-config=../config/backend.hcl`
- [ ] T010 `terraform -chdir=aws fmt` and `validate`
- [ ] T011 `terraform -chdir=aws plan` — review every line with operator
- [ ] T012 `terraform apply` — **explicit human approval only**
- [ ] T013 Commit, push, open PR, merge to `main` — `setup/githubFirstPr.md`
- [ ] T014 Debrief per `setup/speckitFirstTraining.md`
- [ ] T015 Update `progress.ai` with account ID, bucket name, plan/apply summary

## What's next?

[docs/where-to-go-from-here.md](../../docs/where-to-go-from-here.md) — then `start.ai` §4 (WordPress / spec 003).
