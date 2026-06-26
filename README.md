# aws4np

**Public template** for U.S. **501(c)(3)** organizations adopting AWS infrastructure with Terraform, speckit specs, and agent-friendly workflows.

Fork this repo (or use **Use this template** on GitHub), rename for your organization, and follow spec `001` to bootstrap.

## What you get

| Piece | Purpose |
|-------|---------|
| `.specify/` | Speckit templates + scripts (`spec.md` → `plan.md` → `tasks.md`) |
| `start.ai` | Agent/human session checklist |
| `progress.ai` | Decision and apply traceability |
| `tu.keys.example` | Credential file format (copy to gitignored `tu.keys`) |
| `scripts/load-aws-env.sh` | Load IAM keys into your shell |
| `scripts/bootstrap-remote-state.sh` | One-time S3 + DynamoDB for Terraform remote state |
| `aws/` | Starter Terraform (remote state resources + provider) |

Inspired by production use at [People for Liberty / np-terraforms](https://github.com/people-for-liberty/np-terraforms); stripped of org-specific resources.

## Quick start

```bash
# 1. Fork / clone
git clone git@github.com:YOUR-ORG/aws4np.git
cd aws4np

# 2. Credentials (never commit tu.keys)
cp tu.keys.example tu.keys
chmod 600 tu.keys
# Edit tu.keys with IAM access key + secret

# 3. Verify session
eval "$(scripts/load-aws-env.sh)"
aws sts get-caller-identity
scripts/check-session-prereqs.sh

# 4. Bootstrap remote state (one time)
export ORG_SLUG=your-short-org-name
scripts/bootstrap-remote-state.sh
cp config/backend.hcl.example config/backend.hcl
# Edit config/backend.hcl and aws/terraform.tfvars

# 5. Terraform
terraform -chdir=aws init -backend-config=../config/backend.hcl
terraform -chdir=aws validate
terraform -chdir=aws plan
```

Never run `terraform apply` without a reviewed plan and explicit approval.

## Speckit workflow

```bash
.specify/scripts/bash/create-new-feature.sh "Add Route53 hosted zone" --short-name route53-zone
.specify/scripts/bash/setup-plan.sh
# Fill spec.md, plan.md, tasks.md — then implement per task ID
```

See `.specify/memory/constitution.md` for governance rules.

## Security

- Use a **dedicated IAM user** with least privilege; enable MFA on root.
- `tu.keys` and `config/backend.hcl` are gitignored.
- This is a template — review IAM policies and resources before production use.

## License

MIT — see [LICENSE](LICENSE).
