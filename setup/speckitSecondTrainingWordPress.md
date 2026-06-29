# Second speckit training: WordPress on Lightsail

**Audience:** AI agent after **§3 Terraform training** is merged to `main` (spec `002`, remote state, `terraform init` working).  
**Goal:** Second learn-by-doing exercise — branch → spec → plan → tasks → `terraform plan` → optional apply → PR → merge — while standing up **WordPress on AWS Lightsail** in Terraform.

## Prerequisites

- `start.ai` gates 0–3 complete (fork, speckit CLI, `.secrets/tu.keys`, Terraform connected)
- `config/backend.hcl` and `aws/terraform.tfvars` configured
- `terraform -chdir=aws validate` passes on `main`
- `eval "$(scripts/load-aws-env.sh)"` and `aws sts get-caller-identity` succeed

## Why this lesson next

The operator already knows branch/spec/plan/merge from §3. This lesson applies the **same speckit + constitution pattern** to a **real workload** nonprofits care about — a public website — without abandoning Terraform-first discipline.

## The user prompt (give them this verbatim)

```
Using speckit, GitHub, and our constitution (.specify/memory/constitution.md), help me:

1. Create or use feature branch 003-wordpress-lightsail and a spec for hosting our nonprofit WordPress site on AWS Lightsail with Terraform.
2. Walk me through spec, plan, and tasks — use the starter Terraform in aws/lightsail_wordpress.tf — so I understand what will be created (instance, static IP, web ports) before anything is applied.
3. I will run commands myself. Do not terraform apply without my explicit approval after we review the plan together.
4. When done, help me commit, push, open a pull request, merge to main, and update progress.ai.
5. Explain in plain language what we did and how this WordPress site relates to our Terraform state and Git history.
```

Shorter variant:

```
Using speckit, GitHub, and our constitution, branch and spec 003 to run WordPress on Lightsail via Terraform, guide me through plan and tasks, help me merge to main, and explain what I did.
```

## What the AI should do (playbook)

### Before creating artifacts

- Confirm spec `002` / Terraform bootstrap is merged; `terraform -chdir=aws plan` runs on `main` (may show only backend or no changes).
- Read constitution — Terraform-first (no Lightsail console one-click unless emergency + codify in TF).
- Load credentials: `eval "$(scripts/load-aws-env.sh)"`.

### Branch + spec

**If `specs/003-wordpress-lightsail/` already exists** (template reference):

```bash
git checkout main && git pull
git checkout -b 003-wordpress-lightsail
```

Flesh out `spec.md`, run `.specify/scripts/bash/setup-plan.sh`, complete `plan.md` and `tasks.md` from the reference stubs.

**If `003` does not exist** on this fork:

```bash
.specify/scripts/bash/create-new-feature.sh "WordPress on Lightsail" --short-name wordpress-lightsail
```

### spec.md should cover

- **Goal:** Public WordPress site on Lightsail, managed in Terraform
- **Users:** Staff/volunteers who need a simple nonprofit website
- **In scope:** Lightsail instance (WordPress blueprint), static IP, HTTP/HTTPS ports, outputs for URL/admin access
- **Out of scope (v1):** Domain/DNS (Route53 spec later), migration from GoDaddy, WooCommerce, multisite, autoscaling
- **Acceptance:** `terraform plan` reviewed; site reachable at static IP (or documented next step for DNS); merged PR

### plan.md should cover

1. **Blueprint lookup** — WordPress blueprint IDs vary by region:
   ```bash
   aws lightsail get-blueprints --query "blueprints[?contains(blueprintName, 'WordPress')].{id:blueprintId,name:blueprintName}" --output table
   ```
   Set `lightsail_wordpress_blueprint_id` in `aws/terraform.tfvars`.

2. **Bundle size** — WordPress needs at least a **small** bundle (not nano). Default in `terraform.tfvars.example`: `small_3_0`.

3. **Review** `aws/lightsail_wordpress.tf` — static IP, instance, attachment, ports 80/443.

4. **`terraform fmt`**, **`validate`**, **`plan`** — walk through output line by line with the operator.

5. **Apply** only after explicit approval; capture outputs (public IP, instance name).

6. **Post-apply:** Lightsail generates WordPress admin password — retrieve via AWS console or CLI (`aws lightsail get-instance-access-details`); **never paste passwords into chat**; tell operator to save in password manager.

7. Update `progress.ai`.

### tasks.md

Use `specs/003-wordpress-lightsail/tasks.md` as checklist template; assign task IDs; operator executes step by step.

### GitHub finish

Same as §3 training: commit with `003:` prefix, push, PR, merge, debrief.

## Scope clarifications

| Operator may say | Clarify |
|------------------|---------|
| “Use Lightsail one-click WordPress” | Constitution prefers Terraform; starter file uses `aws_lightsail_instance` with WordPress blueprint |
| “I already have WordPress elsewhere” | Migration is a **later spec**; this lesson is greenfield Lightsail |
| “Hook up our domain” | **Spec 004+** (Route53); note static IP for now |

## Constitution checkpoints

| Principle | Practice |
|-----------|----------|
| III Spec-driven | No Lightsail resources before spec/plan/tasks |
| VI Branch discipline | Work on `003-wordpress-lightsail`; merge via PR |
| IV Validation | fmt, validate, plan before apply |
| Ia Terraform-first | All Lightsail via `.tf` files |
| I Safety | Plan review; apply only on approval |

## Debrief checklist

Explain in plain language:

1. **Why Lightsail** for a small nonprofit site (cost, simplicity vs EC2)
2. **What Terraform will own** — instance, IP, firewall ports
3. **Static IP** — stable address for later DNS
4. **WordPress blueprint** — AWS-managed image; still tracked in Terraform state
5. **Plan vs apply** — what changed in AWS only after apply
6. **State file** — WordPress resources recorded in S3 backend from §3
7. **PR + merge** — website infra is versioned like backend infra
8. **Admin credentials** — where to find them safely (not in git)

Ask: *“Before we apply, what would you tell your board we’re about to create?”*

## When training is complete

- Spec `003` merged to `main`
- `terraform -chdir=aws plan` on `main` shows no unexpected drift (or only known changes)
- Operator can articulate speckit workflow without prompting
- `progress.ai` lists instance name, static IP, spec path

**What's next:** [docs/where-to-go-from-here.md](../docs/where-to-go-from-here.md)

## References

- `specs/003-wordpress-lightsail/` (reference checklist)
- `aws/lightsail_wordpress.tf`
- `setup/speckitFirstTraining.md` (first lesson pattern)
- [Terraform: aws_lightsail_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lightsail_instance)
