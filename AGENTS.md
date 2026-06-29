# Agent instructions (aws4np)

This repository uses **spec-driven, constitution-governed** infrastructure work for U.S. 501(c)(3) nonprofits. All AI assistants (Copilot, Continue, Cursor, Claude, etc.) should follow the same non-proprietary files.

## Every session — read first

1. **`start.ai`** — run the gates in order (§0 → §4 for new orgs; §5+ for ongoing work).
2. **`.specify/memory/constitution.md`** — safety, branch discipline, no unapproved `terraform apply`.
3. **`progress.ai`** — recent decisions and account context.

If the operator has not loaded `start.ai`, read **`AGENTS.md`** and **`start.ai`** yourself before discretionary work.

## Bootstrap order (new nonprofit fork)

| Step | Gate | Guide |
|------|------|--------|
| 0 | Fork, VS Code + AI (WSL on Windows) | `setup/forkAndWorkspace.md` |
| 1 | Speckit CLI | `setup/installSpeckit.md` |
| 2 | AWS credentials (`.secrets/tu.keys`) | `setup/installAwsCredentials.md` |
| 3 | First speckit training (Terraform connect) | `setup/speckitFirstTraining.md` |
| 4 | Second speckit training (WordPress on Lightsail) | `setup/speckitSecondTrainingWordPress.md` |

**After bootstrap:** [docs/where-to-go-from-here.md](../docs/where-to-go-from-here.md) — Route53, SES, WordPress migration.

Full index: `setup/README.md`.

Verify with: `scripts/check-session-prereqs.sh`

## Hard rules

- Never commit `.secrets/tu.keys`, `config/backend.hcl`, or `aws/terraform.tfvars`.
- Never run `terraform apply` without explicit human approval after a reviewed plan.
- Work on feature branches; merge via PR — never commit infrastructure work directly to `main`.
- Every change maps to a spec/task ID (Constitution III).
- Store decisions in `progress.ai`, not only in chat history.
- Use `eval "$(scripts/load-aws-env.sh)"` before AWS/Terraform commands.

## Speckit commands

Use `.specify/scripts/bash/create-new-feature.sh`, `setup-plan.sh`, and templates under `.specify/templates/`. Do **not** run `specify init` — `.specify/` is pre-seeded.

## Template maintainers

Working on the upstream template repo (not a nonprofit fork)? Set `AWS4NP_ALLOW_UPSTREAM=1` when running `scripts/check-session-prereqs.sh`.
