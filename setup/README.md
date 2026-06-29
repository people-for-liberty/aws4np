# Setup guides (aws4np)

Ordered walkthroughs for AI agents and operators. Match **`start.ai`** gate numbers.

## New nonprofit — do in order

| Order | `start.ai` | Guide | Outcome |
|-------|------------|-------|---------|
| 1 | §0 | [forkAndWorkspace.md](./forkAndWorkspace.md) | Org-owned GitHub fork, clone, VS Code + AI (WSL on Windows) |
| 2 | §1 | [installSpeckit.md](./installSpeckit.md) | `specify` CLI on PATH; `.specify/` present |
| 3 | §2 | [installAwsCredentials.md](./installAwsCredentials.md) | `.secrets/tu.keys`, AWS CLI, STS OK |
| 4 | §3 | [speckitFirstTraining.md](./speckitFirstTraining.md) | Branch + spec 002, Terraform, remote state, init/plan, PR merge |
| 5 | §4 | [speckitSecondTrainingWordPress.md](./speckitSecondTrainingWordPress.md) | Branch + spec 003, WordPress on Lightsail, plan/apply, PR merge |
| — | (during §3–§4) | [installTerraform.md](./installTerraform.md) | Terraform `>= 1.13` installed |
| — | (during §3–§4) | [githubFirstPr.md](./githubFirstPr.md) | Branch, push, open PR, merge to `main` |

## Verify anytime

```bash
scripts/check-session-prereqs.sh
```

## Reference specs

- `specs/001-repo-scaffold/` — bootstrap overview
- `specs/002-terraform-aws-connect/` — Terraform connect (§3 training)
- `specs/003-wordpress-lightsail/` — WordPress (§4 training)

## After bootstrap

- **Next projects:** [docs/where-to-go-from-here.md](docs/where-to-go-from-here.md) — Route53, SES, migrate existing WordPress
- Ongoing gates: `start.ai` §5–7
- Governance: `.specify/memory/constitution.md`
- Traceability: `progress.ai`
