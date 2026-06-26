# Tasks: Repository scaffold (spec 001)

## Phase 1: Setup

- [ ] T001 Copy `tu.keys.example` → `tu.keys`; add IAM access key; `chmod 600 tu.keys`
- [ ] T002 Run `eval "$(scripts/load-aws-env.sh)"` and `aws sts get-caller-identity`
- [ ] T003 Run `scripts/check-session-prereqs.sh`

## Phase 2: Remote state

- [ ] T004 Set `ORG_SLUG`; run `scripts/bootstrap-remote-state.sh`
- [ ] T005 Copy `config/backend.hcl.example` → `config/backend.hcl` (gitignored)
- [ ] T006 Copy `aws/terraform.tfvars.example` → `aws/terraform.tfvars` (gitignored)

## Phase 3: Terraform gate

- [ ] T007 `terraform -chdir=aws init -backend-config=../config/backend.hcl`
- [ ] T008 `terraform -chdir=aws validate`
- [ ] T009 `terraform -chdir=aws plan` — review output
- [ ] T010 `terraform apply` — **explicit human approval only**
- [ ] T011 Update `progress.ai` with account ID, bucket name, plan/apply results
