# Nonprofit AWS Constitution

## Core Principles

### I. Safety-First Infrastructure
Infrastructure changes MUST avoid destructive actions. Always plan before apply, prefer least-privilege IAM, and keep changes reversible. Avoid manual cloud edits that cause drift outside Terraform.

### Ia. Terraform-First Changes
Do not manipulate AWS infrastructure directly (console/CLI) unless strictly necessary for recovery or emergency triage. Emergency out-of-band changes must be codified back into Terraform immediately.

### II. Secrets & Access Hygiene
Keep cloud credentials (`tu.keys`, PEM files) out of git and logs. Use `scripts/load-aws-env.sh` for local sessions; never commit secrets.

### III. Spec-Driven Delivery
Every change maps to a speckit spec/task ID before implementation. Number specs sequentially from **001** in this repository.

### IV. Validation & Review Discipline
Run `terraform fmt`, `terraform validate`, and targeted `terraform plan` before review. Block applies when validation fails or plans are unreviewed.

### V. Traceability
Document decisions and plan/apply outcomes in `progress.ai`.

### VI. Branch Discipline
Work from feature branches; never commit directly to `main`.

## Infrastructure Execution Standards

- Never run `terraform apply` against shared state without a reviewed plan and explicit approval.
- Treat remote state as the source of truth.
- Do not leave Terraform state locks behind without documenting the event.
- Record out-of-band fixes in Terraform immediately.

## Governance

**Version**: 1.0.0 | **Ratified**: 2026-06-26 | **Template**: [aws4np](https://github.com/people-for-liberty/aws4np)
