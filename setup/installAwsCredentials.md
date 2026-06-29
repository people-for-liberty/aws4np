# AWS credentials (`.secrets/tu.keys`)

**Audience:** AI agent helping a nonprofit operator connect this repo to AWS.  
**Goal:** Ensure `.secrets/tu.keys` exists with working IAM access keys the agent can load for Terraform and AWS CLI work.

## What “ready” means

| Check | Pass criteria |
|-------|---------------|
| Secrets folder | `.secrets/` exists at repo root |
| Keys file | `.secrets/tu.keys` exists (gitignored) |
| Parseable | `scripts/load-aws-env.sh` exits 0 |
| Valid | `aws sts get-caller-identity` returns account + IAM user ARN after loading keys |
| Git safety | `.secrets/tu.keys` is gitignored |

Default IAM layout for this template:

- **Group:** `terraformers`
- **Policy:** AWS managed `PowerUserAccess` (attached to the group)
- **User:** `aws_assistant` (or a name the operator prefers)
- **User membership:** `aws_assistant` → group `terraformers`

PowerUser allows broad infrastructure work but not IAM user/group administration — a reasonable default for Terraform operators. Adjust only with explicit user approval.

## Step 0 — Explain briefly to the user

Nonprofits need their **own** AWS account (not personal AWS). We create a **dedicated IAM user** for this repo — never use the root account’s access keys. Keys live only in `.secrets/tu.keys` on their machine; they are never committed to git.

## Step 1 — Check current state

From repo root:

```bash
test -d .secrets && echo ".secrets exists" || echo ".secrets missing"
test -f .secrets/tu.keys && echo "tu.keys present" || echo "tu.keys missing"
command -v aws && aws --version
```

If `.secrets/tu.keys` exists, skip to **Step 7 (Validate)**.

## Step 2 — AWS account (if they do not have one)

Walk the user through account creation at [https://aws.amazon.com/](https://aws.amazon.com/):

1. Choose **Create an AWS Account** (use the organization’s email, e.g. `tech@yournonprofit.org`).
2. Complete contact and billing setup (nonprofits may later apply for [AWS Nonprofit Credit Program](https://aws.amazon.com/government-education/nonprofits/) — optional, not required to start).
3. Choose a **root account password**; store it in their org password manager.
4. **Enable MFA on the root account** (IAM → Dashboard → “Add MFA for root user” or Security credentials on root). Strongly recommend before creating IAM users.

Sign in to the **AWS Management Console** as root (or an admin) for the steps below.

## Step 3 — Create group `terraformers` with PowerUser

In the console: **IAM** → **User groups** → **Create group**.

1. **Group name:** `terraformers`
2. **Attach permissions policies:** search for and select **`PowerUserAccess`** (AWS managed, full name `PowerUserAccess`).
3. Create the group.

Console path: IAM → User groups → Create group → attach `PowerUserAccess`.

## Step 4 — Create IAM user and add to group

Ask whether they want the default username **`aws_assistant`** or another name. Use their choice consistently below.

**IAM** → **Users** → **Create user**:

1. **User name:** `aws_assistant` (or their preference)
2. **Do not** enable console access unless they explicitly want it; programmatic access via access keys is enough for this repo.
3. **Add user to group:** select **`terraformers`**
4. Create user

## Step 5 — Create access keys and write `.secrets/tu.keys`

Still on the user’s page → **Security credentials** tab → **Access keys** → **Create access key**.

1. Use case: **Command Line Interface (CLI)** (acknowledge the recommendation).
2. Copy the **Access key ID** and **Secret access key** immediately (secret is shown once).

On their machine, in the repo root:

```bash
mkdir -p .secrets
cp .secrets/tu.keys.example .secrets/tu.keys
chmod 600 .secrets/tu.keys
```

Edit `.secrets/tu.keys` and replace the placeholder lines:

```
Access key: AKIA................
Secret access key: ................................
```

Optionally uncomment and fill the account ID and organization name for later verification.

**Security reminders for the user:**

- Never paste keys into chat, tickets, or git.
- Never commit `.secrets/tu.keys`.
- Rotate keys if they are ever exposed.

## Step 6 — Install AWS CLI (if missing)

Check: `command -v aws`

**Linux (Debian/Ubuntu):**

```bash
sudo apt update && sudo apt install -y awscli
```

Or follow [Installing the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) for their OS.

## Step 7 — Validate credentials

From repo root:

```bash
eval "$(scripts/load-aws-env.sh)"
aws sts get-caller-identity
```

Success looks like JSON with:

- `Account` — 12-digit AWS account ID
- `Arn` — should include their IAM user name (e.g. `.../user/aws_assistant`)

Run the full session gate:

```bash
scripts/check-session-prereqs.sh
```

If STS fails:

| Error | Likely fix |
|-------|------------|
| `InvalidClientTokenId` / `SignatureDoesNotMatch` | Re-copy keys into `.secrets/tu.keys`; no extra spaces |
| `AccessDenied` on STS | Unlikely for normal users; confirm user exists and keys are active |
| Keys file not found | Confirm path is `.secrets/tu.keys` not repo-root `tu.keys` |
| `aws: command not found` | Install AWS CLI (Step 6) |

## Step 8 — Confirm gitignore

```bash
git check-ignore -v .secrets/tu.keys
```

Should report that `.secrets/tu.keys` is ignored. If not, stop and fix `.gitignore` before any commit.

## Optional — Expected account ID

If the user noted their account ID in `.secrets/tu.keys`, compare:

```bash
eval "$(scripts/load-aws-env.sh)"
aws sts get-caller-identity --query Account --output text
```

Must match their nonprofit account before running Terraform against live infrastructure.

## References

- [AWS IAM — Creating IAM users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
- [AWS managed policy: PowerUserAccess](https://docs.aws.amazon.com/aws-managed-policy/latest/reference/PowerUserAccess.html)
- [AWS CLI — get-caller-identity](https://docs.aws.amazon.com/cli/latest/reference/sts/get-caller-identity.html)
