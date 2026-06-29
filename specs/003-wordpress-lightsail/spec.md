# Spec 003: WordPress on Lightsail

**Status**: Template reference — complete on branch `003-wordpress-lightsail` during `start.ai` §4 training  
**Branch**: `003-wordpress-lightsail`  
**Audience**: Nonprofit with Terraform bootstrap (spec `002`) merged to `main`

## Goal

Host a nonprofit WordPress website on **AWS Lightsail**, fully declared in Terraform, with a stable static IP and web ports — learned through the second speckit training exercise.

## How this spec maps to onboarding

| Phase | What | Where |
|-------|------|--------|
| **Prereq** | Terraform remote state, init, validate on `main` | `start.ai` §3, spec `002` |
| **1–4** | Branch, plan, tasks, plan/apply, PR merge | `start.ai` §4 — `setup/speckitSecondTrainingWordPress.md` |

**Do not apply from this reference on `main` without a feature branch and reviewed plan.**

## User stories

### P1 — Public website (MVP)

**As** nonprofit staff, **I want** a WordPress site on a stable IP **so** we can share our mission online.

**Acceptance:**

- Lightsail instance running WordPress blueprint
- Static IP attached
- Ports 80 and 443 open on the instance
- `terraform plan` reviewed before apply
- Admin access documented (password in operator’s vault, not in git)

### P2 — DNS (deferred)

Custom domain (e.g. `www.ournonprofit.org`) — **spec 004+** per [docs/where-to-go-from-here.md](../../docs/where-to-go-from-here.md).

## Scope

- Terraform in `aws/lightsail_wordpress.tf`
- Variables: `lightsail_wordpress_blueprint_id`, `lightsail_wordpress_bundle_id` in `terraform.tfvars`
- Outputs: static IP, instance name, default WordPress URL

## Out of scope (v1)

- Site migration from another host
- WooCommerce, multisite, email on Lightsail
- CI/CD, WAF, CloudFront
- Automated backups (note for future spec)

## Acceptance

- Spec `003` merged via PR
- `terraform validate` passes
- `terraform plan` was reviewed; apply only with explicit approval
- Site loads at `http://<static-ip>` (HTTPS may need cert/DNS later)
- `progress.ai` updated
