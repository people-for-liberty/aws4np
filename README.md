# aws4np

**Public template** for U.S. **501(c)(3)** organizations adopting AWS infrastructure with Terraform, speckit specs, and agent-friendly workflows.

Fork this repo to your organization’s GitHub, open it in VS Code with an AI assistant (WSL on Windows), and follow spec `001` to bootstrap.

## What you get

| Piece | Purpose |
|-------|---------|
| `.specify/` | Speckit templates + scripts (`spec.md` → `plan.md` → `tasks.md`) |
| `AGENTS.md` | AI entrypoint — read `start.ai` every session |
| `start.ai` | Agent/human session checklist |
| `setup/README.md` | Ordered setup guides (fork → training) |
| `docs/where-to-go-from-here.md` | After bootstrap: Route53, SES, WordPress migration |
| `progress.ai` | Decision and apply traceability |
| `.secrets/tu.keys.example` | Credential file format (copy to gitignored `.secrets/tu.keys`) |
| `scripts/load-aws-env.sh` | Load IAM keys into your shell |
| `scripts/bootstrap-remote-state.sh` | One-time S3 + DynamoDB for Terraform remote state |
| `aws/` | Starter Terraform (remote state + optional Lightsail WordPress) |
| `specs/001-repo-scaffold/` | Bootstrap overview (reference) |
| `specs/002-terraform-aws-connect/` | Terraform connect (§3 training) |
| `specs/003-wordpress-lightsail/` | WordPress on Lightsail (§4 training) |

Inspired by production use at [People for Liberty / np-terraforms](https://github.com/people-for-liberty/np-terraforms); stripped of org-specific resources.

## Getting started

Do these steps **in order** the first time. Each session, run `start.ai` (or let your AI agent load it) — it repeats the same gates.

### Step 0 — Fork this repo to **your** organization (do this first)

aws4np is a **template**. Your nonprofit’s Terraform, specs, and decision log must live in **your own GitHub repository**, not as uncommitted edits on someone else’s copy.

**Why this matters for your organization:**

- **Preservation** — Staff change; laptops break. Git history on *your* repo is the durable record of how your AWS environment was built.
- **Accountability** — Commits show who changed DNS, billing alarms, or security groups and when — important for boards and audits.
- **Safety** — Secrets (`.secrets/tu.keys`) stay on your machines; everything else should be backed up in *your* repo.
- **Independence** — You are not tied to the public template’s lifecycle. You may never contribute upstream; the fork is for **you**.

**How:**

1. Create a [GitHub account](https://github.com/) or use your nonprofit’s GitHub Organization.
2. Open the upstream template ([people-for-liberty/aws4np](https://github.com/people-for-liberty/aws4np)).
3. Click **Fork** → select your org (or use **Use this template** to create a standalone copy).
4. Clone **your** fork — not a read-only checkout you cannot push to:

```bash
git clone git@github.com:YOUR-ORG/YOUR-REPO.git
cd YOUR-REPO
git remote -v   # origin must be YOUR-ORG/YOUR-REPO
```

Detailed walkthrough: `setup/forkAndWorkspace.md`.

### Step 1 — Install VS Code, an AI assistant, and open the project

**VS Code + workspace**

- **Linux / macOS:** Install [VS Code](https://code.visualstudio.com/), then **File → Open Folder** on your clone.
- **Windows:** Use [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install), install VS Code on Windows, add the **WSL** extension, clone the repo **inside WSL** (e.g. `~/projects/`), then run `code .` from that directory. Do not keep the repo on `C:\` — tooling and permissions work best in the Linux filesystem.

**AI coding assistant (inside VS Code)**

This template assumes you work **with** an AI that can read and edit files in the repo. Install one extension in VS Code:

- **[GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)** — easiest if you already use GitHub; sign in with your fork’s account.
- **[Continue](https://marketplace.visualstudio.com/items?itemName=Continue.continue)** — open-source; connect your preferred model.

Alternatively, **[Cursor](https://cursor.com/)** is a VS Code–based editor with a built-in agent — open the same cloned folder from WSL.

**First session:** open the AI chat and ask it to read `start.ai` and walk you through the gates. Repeat at the start of every session.

Details: `setup/forkAndWorkspace.md`.

### Step 2 — Session gates (Speckit install, AWS, then training)

After fork + editor, follow `start.ai` and the setup guides:

| Order | Gate | Guide |
|-------|------|-------|
| 1 | Speckit CLI | `setup/installSpeckit.md` |
| 2 | AWS credentials (`.secrets/tu.keys`) | `setup/installAwsCredentials.md` |
| 3 | **First speckit training** (Terraform + GitHub + constitution) | `setup/speckitFirstTraining.md` |
| 4 | **Second speckit training** (WordPress on Lightsail) | `setup/speckitSecondTrainingWordPress.md` |

First training connects Terraform to AWS; second applies the same speckit workflow to a real website workload.

## Quick start (after fork and VS Code)

```bash
# Already cloned YOUR fork and opened in VS Code

# Credentials (never commit .secrets/tu.keys)
mkdir -p .secrets
cp .secrets/tu.keys.example .secrets/tu.keys
chmod 600 .secrets/tu.keys
# Edit .secrets/tu.keys — see setup/installAwsCredentials.md

# Verify session
eval "$(scripts/load-aws-env.sh)"
aws sts get-caller-identity
scripts/check-session-prereqs.sh

# Bootstrap remote state (one time; during speckit training §3)
export ORG_SLUG=your-short-org-name
eval "$(scripts/load-aws-env.sh)"
scripts/bootstrap-remote-state.sh          # interactive
# scripts/bootstrap-remote-state.sh --yes  # after explicit approval in chat
cp config/backend.hcl.example config/backend.hcl
# Edit config/backend.hcl and aws/terraform.tfvars

# Terraform
terraform -chdir=aws init -backend-config=../config/backend.hcl
terraform -chdir=aws validate
terraform -chdir=aws plan
```

Never run `terraform apply` without a reviewed plan and explicit approval.

## Where to go from here

After WordPress training (spec 003), common next projects — each as its own speckit spec:

- **Route53** — point your domain at the Lightsail static IP  
- **Amazon SES** — reliable outbound email for WordPress  
- **WordPress migration** — move an existing site from another host  

See **[docs/where-to-go-from-here.md](docs/where-to-go-from-here.md)** for recommended order, AI prompts, and scope notes.

## Speckit workflow

```bash
.specify/scripts/bash/create-new-feature.sh "Add Route53 hosted zone" --short-name route53-zone
.specify/scripts/bash/setup-plan.sh
# Fill spec.md, plan.md, tasks.md — then implement per task ID
```

See `.specify/memory/constitution.md` for governance rules.

## Security

- Use a **dedicated IAM user** with least privilege; enable MFA on root.
- `.secrets/tu.keys` and `config/backend.hcl` are gitignored.
- This is a template — review IAM policies and resources before production use.

## License

MIT — see [LICENSE](LICENSE).
