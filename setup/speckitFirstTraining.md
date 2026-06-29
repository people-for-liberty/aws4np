# First speckit training: connect Terraform to AWS

**Audience:** AI agent guiding a nonprofit operator after gates 0–2 (fork, speckit CLI, AWS credentials).  
**Goal:** Teach speckit + GitHub + constitution **by doing** — while delivering a real outcome: Terraform installed, remote state configured, first `plan` against their AWS account.

## Why this instead of a dry “install Terraform” gate

Field tests show newcomers learn fastest when they:

1. **Say one intent** in plain language  
2. Watch the AI produce **branch → spec → plan → tasks** under the constitution  
3. **Execute tasks** with coaching (not magic one-shots)  
4. **Push and merge** so git history reflects their work  
5. **Debrief** — “tell me what I did” locks in mental models  

Terraform install and remote state bootstrap are the *payload* of the lesson, not a separate checklist.

## The user prompt (give them this verbatim)

After gates 0–2 pass, ask the operator to paste this into their AI chat:

```
Using speckit, GitHub, and our constitution (.specify/memory/constitution.md), help me:

1. Create a feature branch and a new spec for connecting this repo to my nonprofit AWS account with Terraform.
2. Walk me through the spec, plan, and tasks so I install Terraform, set up remote state, run init/validate/plan, and understand what will change in AWS.
3. I will run commands myself where you tell me — do not terraform apply without my explicit approval.
4. When we are done, help me commit, push, open a pull request, and merge to main.
5. Finally, explain in plain language what we did: branch, spec, state, plan, merge — and why each step mattered for our organization.
```

Shorter variant if they prefer one line:

```
Using speckit, GitHub, and our constitution, make a branch and spec to connect Terraform to my AWS account, guide me through plan and tasks, then help me push and merge to main and explain what I did.
```

## What the AI should do (playbook)

### Before creating artifacts

- Confirm gates 0–2: fork with correct `origin`, `.secrets/tu.keys` works, `aws sts get-caller-identity` succeeds.
- Read `.specify/memory/constitution.md` — cite branch discipline, spec-driven delivery, no apply without approval.
- Load credentials: `eval "$(scripts/load-aws-env.sh)"`.

### Speckit flow

1. **Branch + spec** — reference spec is pre-shipped at `specs/002-terraform-aws-connect/`:
   ```bash
   git checkout main && git pull
   git checkout -b 002-terraform-aws-connect
   ```
   Flesh out `spec.md`, run `.specify/scripts/bash/setup-plan.sh`, complete `plan.md` and `tasks.md`.

   **If `specs/002-terraform-aws-connect/` does not exist** on this fork (older template):
   ```bash
   .specify/scripts/bash/create-new-feature.sh "Connect Terraform to AWS" --short-name terraform-aws-connect
   ```

2. **spec.md** — confirm or refine goal, prerequisites (gates 0–2), acceptance criteria (see reference `specs/002-terraform-aws-connect/spec.md`).

3. **plan.md** — technical steps:
   - Install Terraform `>= 1.13` — `setup/installTerraform.md`
   - Choose `ORG_SLUG` (org short name, lowercase)
   - Run `scripts/bootstrap-remote-state.sh` — operator reviews the resource summary first; use `--yes` only after they **explicitly approve in chat** (non-interactive for AI-guided terminals)
   - Copy `config/backend.hcl.example` → `config/backend.hcl`, `aws/terraform.tfvars.example` → `aws/terraform.tfvars`
   - `terraform init`, `validate`, `plan`
   - Optional apply only with explicit human approval after plan review
   - Update `progress.ai`

4. **tasks.md** — use `specs/002-terraform-aws-connect/tasks.md` as checklist; complete with operator.

5. **Implement task-by-task** — operator runs commands; AI explains each step before the next. For `bootstrap-remote-state.sh`, show bucket/table names and wait for explicit approval before passing `--yes`.

### GitHub finish

Follow **`setup/githubFirstPr.md`** with the operator:

- Commit on the feature branch with messages referencing spec ID (e.g. `002: add backend config for terraform init`).
- `git push -u origin HEAD`
- Open a PR to `main`; short description linking spec path.
- After merge: checkout `main`, `git pull`.
- **Debrief** (required) — see checklist below.

### Bootstrap script vs `backend_state.tf`

`scripts/bootstrap-remote-state.sh` creates the S3 bucket and DynamoDB table **first** so `terraform init` has a backend. Later, `terraform plan` for `backend_state.tf` may show those resources as **already existing**. With the operator:

1. Prefer **`terraform import`** for each resource into state, **or**
2. Skip apply for `backend_state.tf` until a follow-up task documents import — **do not** create duplicate buckets.

Explain: the script is bootstrap; Terraform is the long-term source of truth once imported.

## Scope clarification: “pull down current state”

Operators often say *“pull down the current state of things.”* For a **new** nonprofit AWS account:

- There is usually **no existing Terraform state** — you are **establishing** state, not importing a legacy stack.
- “State” means Terraform’s **remote state file** in S3 (the record of what Terraform manages), not “everything already in AWS.”
- If they already have manual AWS resources, **import** is a later, advanced spec — not this lesson.

Explain that clearly during the debrief.

## Relationship to spec 001

`specs/001-repo-scaffold/` is the **overview** reference. **`specs/002-terraform-aws-connect/`** is the working spec for §3 training — checkout branch `002-terraform-aws-connect` and complete plan/tasks there. Phase 1 of spec 001 maps to gates 0–2.

## Constitution checkpoints (call these out during training)

| Principle | What they practice |
|-----------|-------------------|
| III Spec-driven | No terraform work before spec/plan/tasks exist |
| VI Branch discipline | All work on feature branch; merge via PR |
| IV Validation | `fmt`, `validate`, `plan` before any apply |
| I Safety | Plan reviewed; apply only on explicit approval |
| V Traceability | `progress.ai` updated with account ID, bucket name, plan summary |

## Debrief checklist (“tell me what I did”)

The AI should explain in plain language:

1. **Fork** — why the repo lives under *their* org on GitHub  
2. **Branch** — what `002-terraform-aws-connect` is and why we never commit infra work straight to `main`  
3. **Spec / plan / tasks** — the contract before touching AWS  
4. **Terraform install** — local tool that reads `.tf` files  
5. **Remote state** — S3 bucket + DynamoDB lock; why state must not live only on one laptop  
6. **`terraform init`** — connects the repo to the backend  
7. **`terraform plan`** — preview of changes; no changes until apply  
8. **PR + merge** — how the org keeps a durable audit trail  
9. **Secrets** — what stayed in `.secrets/` and never went to GitHub  

Ask: *“What would you do differently next time before running plan?”* — reinforces safety habit.

## When training is complete

- Operator can describe branch → spec → plan → tasks → merge in their own words.
- `terraform version` works; `terraform -chdir=aws validate` passes (after init).
- Feature branch merged to `main` (or PR open with user understanding next step).
- `progress.ai` has an entry for the session.

Then normal session bootstrap (§5+) applies for ongoing work. Next: **§4 WordPress training** (`setup/speckitSecondTrainingWordPress.md`), then [docs/where-to-go-from-here.md](../docs/where-to-go-from-here.md).

## References

- `.specify/scripts/bash/create-new-feature.sh`
- `.specify/scripts/bash/setup-plan.sh`
- `scripts/bootstrap-remote-state.sh`
- `specs/001-repo-scaffold/` (reference scaffold)
