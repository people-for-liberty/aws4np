# Install Terraform

**Audience:** AI agent during first speckit training (`setup/speckitFirstTraining.md`, `start.ai` §3).  
**Goal:** Terraform `>= 1.13` on PATH, matching `aws/versions.tf`.

## Verify first

```bash
command -v terraform && terraform version
```

Need `1.13.0` or newer. If satisfied, stop.

## Linux (Debian/Ubuntu) — recommended for WSL

HashiCorp APT repo:

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
terraform version
```

## macOS

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform version
```

## Windows (WSL)

Install **inside WSL**, not Windows PowerShell — same Linux steps as above. Run all `terraform` commands from the WSL clone.

## Manual install (any OS)

Download from [terraform.io/downloads](https://developer.hashicorp.com/terraform/install), unpack, add binary to PATH.

## Smoke test (after remote state exists)

Credentials loaded and `config/backend.hcl` in place:

```bash
eval "$(scripts/load-aws-env.sh)"
terraform -chdir=aws init -backend-config=../config/backend.hcl
terraform -chdir=aws validate
```

During early training, `init` may not run until after `bootstrap-remote-state.sh` — `terraform version` alone is enough for the install step.

## References

- [HashiCorp: Install Terraform](https://developer.hashicorp.com/terraform/install)
- `aws/versions.tf` — `required_version = ">= 1.13.0"`
