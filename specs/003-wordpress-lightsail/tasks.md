# Tasks: WordPress on Lightsail (spec 003 — reference)

Complete on branch `003-wordpress-lightsail` during `start.ai` §4 training. Check off as you go.

## Phase 1: Spec and plan

- [ ] T001 `git checkout main && git pull`; `git checkout -b 003-wordpress-lightsail`
- [ ] T002 Review/finish `specs/003-wordpress-lightsail/spec.md`; run `.specify/scripts/bash/setup-plan.sh` if needed
- [ ] T003 Complete `plan.md` and this `tasks.md` with operator

## Phase 2: Configure Lightsail

- [ ] T004 `eval "$(scripts/load-aws-env.sh)"`
- [ ] T005 Run blueprint lookup; set `lightsail_wordpress_blueprint_id` in `aws/terraform.tfvars`
- [ ] T006 Confirm `lightsail_wordpress_bundle_id` (default `small_3_0` or larger)
- [ ] T007 Read `aws/lightsail_wordpress.tf` with operator — explain each resource

## Phase 3: Terraform gate

- [ ] T008 `terraform -chdir=aws fmt`
- [ ] T009 `terraform -chdir=aws validate`
- [ ] T010 `terraform -chdir=aws plan` — review every add/change with operator
- [ ] T011 `terraform apply` — **explicit human approval only**
- [ ] T012 Note `wordpress_static_ip` and instance name from outputs; test `http://<ip>`
- [ ] T013 Save WordPress admin password from Lightsail console/CLI (not in git/chat)

## Phase 4: Merge and traceability

- [ ] T014 Commit, push, open PR, merge to `main`
- [ ] T015 Debrief per `setup/speckitSecondTrainingWordPress.md`
- [ ] T016 Update `progress.ai`

## What's next?

See [docs/where-to-go-from-here.md](../../docs/where-to-go-from-here.md) — Route53, SES, migrating an existing WordPress site, and future specs.
