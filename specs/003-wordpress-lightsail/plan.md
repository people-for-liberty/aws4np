# Implementation Plan: WordPress on Lightsail

**Branch**: `003-wordpress-lightsail` | **Spec**: [spec.md](./spec.md)

## Summary

Reference plan for second speckit training. Flesh out during `setup/speckitSecondTrainingWordPress.md` — implement on branch `003-wordpress-lightsail`, not directly on `main`.

## Technical Context

**Stack**: AWS Lightsail via Terraform (`hashicorp/aws` ~> 5.0), WordPress blueprint  
**Starter code**: `aws/lightsail_wordpress.tf`  
**Prereqs**: Remote state backend, `terraform.tfvars` with `org_slug` and `aws_account_id`

## Constitution Check

| Principle | Status |
|-----------|--------|
| Terraform-first | PASS — Lightsail via `.tf`; no console-only instance |
| Safety-first | PASS — plan before apply |
| Spec-driven | PASS — this spec |
| Branch discipline | PASS — feature branch + PR |

## Phases (reference)

1. Lookup WordPress blueprint ID for region (`aws lightsail get-blueprints`)
2. Set `lightsail_*` variables in `aws/terraform.tfvars`
3. `terraform fmt` / `validate` / `plan` — review with operator
4. `terraform apply` — explicit approval only
5. Retrieve WordPress admin password (console/CLI); store in password manager
6. Smoke test `http://<static-ip>`
7. PR, merge, `progress.ai`

## Notes

- **Bundle:** use at least `small_3_0` (WordPress is heavy for nano).
- **Blueprint ID** is region-specific — do not assume `wordpress` without lookup.
- **HTTPS:** Lightsail certificates often pair with custom domain; HTTP on IP is OK for v1.
