# GitHub: branches, push, and your first pull request

**Audience:** AI agent helping a nonprofit operator who has never opened a PR.  
**Goal:** Get infrastructure work from a **feature branch** onto **`main`** safely — required at the end of §3 and §4 training.

## Why this matters

The constitution (principle VI) says: **never commit infrastructure work directly to `main`**. A pull request (PR) is how your org reviews changes before they become the official record — like a board packet for code.

## What “done” looks like

- Work happened on `002-terraform-aws-connect` or `003-wordpress-lightsail`
- Commits pushed to **your fork** on GitHub
- PR opened → reviewed (even a self-review with AI counts for small teams) → **merged**
- Local `main` updated with `git pull`

## Before you can push

### SSH key (recommended)

If `git push` asks for a password or fails with “Permission denied”:

1. Generate a key (WSL/Linux/macOS):
   ```bash
   ssh-keygen -t ed25519 -C "you@yournonprofit.org"
   ```
   Press Enter for defaults; optional passphrase.

2. Start agent and copy public key:
   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   cat ~/.ssh/id_ed25519.pub
   ```

3. GitHub → **Settings** → **SSH and GPG keys** → **New SSH key** → paste.

4. Test:
   ```bash
   ssh -T git@github.com
   ```

Use clone URL form: `git@github.com:YOUR-ORG/YOUR-REPO.git`.

**HTTPS alternative:** use a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) instead of a password when Git prompts.

## Standard workflow (CLI + browser)

Run from repo root on your **feature branch**:

```bash
git status
git add path/to/changed/files    # or: git add specs/002-... config/... aws/...
git commit -m "002: describe what changed briefly"
git push -u origin HEAD
```

Then open a PR:

### Option A — GitHub website (easiest for beginners)

1. Go to your repo on GitHub — banner **“Compare & pull request”** often appears after push.
2. Or: **Pull requests** → **New pull request** → base: `main` ← compare: your branch.
3. Title: e.g. `002: Connect Terraform to AWS` or `003: WordPress on Lightsail`
4. Description: link spec path (`specs/002-terraform-aws-connect/`), note plan was reviewed.
5. **Create pull request** → **Merge pull request** → **Confirm merge**.

### Option B — GitHub CLI (`gh`)

If `gh` is installed and authenticated (`gh auth login`):

```bash
gh pr create --title "002: Connect Terraform to AWS" --body "Spec: specs/002-terraform-aws-connect/"
gh pr merge --merge
```

## After merge — update local `main`

```bash
git checkout main
git pull origin main
```

Optional: delete the feature branch on GitHub and locally:

```bash
git branch -d 002-terraform-aws-connect
git push origin --delete 002-terraform-aws-connect
```

## What to commit vs never commit

| Commit | Do not commit |
|--------|----------------|
| `specs/`, `aws/*.tf`, `progress.ai` | `.secrets/tu.keys` |
| `setup/` doc tweaks on your fork | `config/backend.hcl` |
| | `aws/terraform.tfvars` |

If `git status` shows gitignored files, **do not** `git add` them.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `push` rejected — non-fast-forward | Someone else pushed; `git pull --rebase origin main` on your branch first |
| No “Compare & pull request” | Confirm you pushed to **your** fork, not upstream template |
| Merge conflicts | Ask AI to walk through conflict markers; finish on the branch, push again |
| Accidental commit to `main` | Ask AI for `git revert` or move commits to a branch — do not force-push without understanding |

## When the AI should use this doc

- End of **§3** (spec 002) and **§4** (spec 003) training
- Any time the operator says “how do I merge?” or “git push failed”
- Before first `terraform apply` results are committed — branch should already exist

## References

- [GitHub: Creating a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)
- [GitHub: SSH keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
