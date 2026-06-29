# Implementation Plan: Repository scaffold

**Branch**: `001-repo-scaffold` | **Spec**: [spec.md](./spec.md)

## Summary

Reference plan for nonprofit bootstrap. **Phases 1–3 below are not executed from this directory** — phase 1 is `start.ai` gates 0–2; phases 2–3 are the operator’s first speckit training spec (`002-terraform-aws-connect` per `setup/speckitFirstTraining.md`).

## Technical Context

**Stack**: Terraform >= 1.13, AWS provider ~> 5.0, us-east-1 default  
**Secrets**: `.secrets/tu.keys` (gitignored), `config/backend.hcl` (gitignored)  
**Bootstrap**: `scripts/bootstrap-remote-state.sh` (`--yes` only after operator approves in chat), then `backend_state.tf` apply (with approval)

## Constitution Check

| Principle | Status |
|-----------|--------|
| Safety-first | PASS — plan before apply |
| Terraform-first | PASS |
| Secrets hygiene | PASS — `.secrets/tu.keys.example` only in git |
| Spec-driven | PASS — training creates spec 002+ |
| Branch discipline | PASS — feature branch; merge via PR |

## Phases (reference)

1. **Session gates** — fork, editor, speckit CLI, AWS credentials (`start.ai` §0–2)
2. **Speckit training** — branch + spec 002; install Terraform; remote state; init/validate/plan; PR merge (`start.ai` §3)
3. **Optional apply** — `backend_state.tf` apply with explicit human approval
4. **Traceability** — `progress.ai` with account ID, bucket name, plan summary
