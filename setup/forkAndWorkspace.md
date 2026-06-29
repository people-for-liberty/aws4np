# Fork the repo and open your workspace

**Audience:** AI agent helping a nonprofit operator begin with aws4np.  
**Goal:** The organization owns **its own** GitHub copy of this template, cloned locally, opened in VS Code (WSL on Windows) with an **AI coding assistant** installed in VS Code.

## Why this comes first

aws4np is a **starting template**, not the place to store your nonprofit’s infrastructure history. Your Terraform, specs, and `progress.ai` decisions belong in **your organization’s repository** so that:

- Changes are **version-controlled** and recoverable if someone leaves or a laptop fails
- Your board and staff can see **who changed what and when**
- Secrets stay local (`.secrets/`) while **infrastructure code** is safely backed up on GitHub
- You are not blocked if the upstream template changes or disappears

You will probably never contribute back to the public template — that is fine. Forking is about **preserving your work**, not open-source etiquette.

## What “ready” means

| Check | Pass criteria |
|-------|---------------|
| GitHub fork | A repo under **your org’s** GitHub account (not only a read-only clone of the upstream template) |
| Local clone | Working copy on disk with `origin` pointing at **your** fork |
| Editor | VS Code installed; on Windows, project opened **inside WSL** |
| AI assistant | A coding-AI extension installed and signed in (or Cursor opened on the same folder) |

## Step 1 — GitHub account and fork

If the user has no GitHub account:

1. Sign up at [https://github.com/](https://github.com/) with the org’s tech email if possible.
2. Prefer a **GitHub Organization** for the nonprofit (Settings → Organizations → New) so access survives staff turnover.

**Fork the template:**

1. Open the upstream template (e.g. [people-for-liberty/aws4np](https://github.com/people-for-liberty/aws4np)).
2. Click **Fork** (top right) → choose **your organization** or personal account.
3. Optionally rename the repo (e.g. `our-nonprofit-infra`) — any name is fine.

Alternative: **Use this template** on GitHub creates a one-off copy without fork lineage — also acceptable for nonprofits that want a clean repo.

Confirm the new repo URL looks like `https://github.com/YOUR-ORG/YOUR-REPO`.

## Step 2 — Clone **your** fork locally

Replace placeholders with their fork URL:

```bash
git clone git@github.com:YOUR-ORG/YOUR-REPO.git
cd YOUR-REPO
git remote -v
```

`origin` must point at **their** GitHub repo, not `people-for-liberty/aws4np`.

If they already cloned the upstream template by mistake:

```bash
git remote set-url origin git@github.com:YOUR-ORG/YOUR-REPO.git
git push -u origin main   # after creating the empty fork / first push
```

Or re-clone from the fork — simpler for beginners.

## Step 3 — Install VS Code

### Linux / macOS

1. Download from [https://code.visualstudio.com/](https://code.visualstudio.com/)
2. Install and launch VS Code
3. **File → Open Folder** → select the cloned repo root

### Windows (use WSL)

Infrastructure work in this repo assumes a **Linux-like shell** (bash, Terraform, AWS CLI). On Windows:

1. Install [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install) (Ubuntu recommended).
2. Install [VS Code](https://code.visualstudio.com/) on Windows.
3. In VS Code, install the **WSL** extension (`ms-vscode-remote.remote-wsl`).
4. Open a WSL terminal (`wsl` from PowerShell or “Ubuntu” from Start).
5. Clone the repo **inside WSL** (e.g. under `~/projects/`), not on `C:\`:
   ```bash
   git clone git@github.com:YOUR-ORG/YOUR-REPO.git
   cd YOUR-REPO
   code .
   ```
   `code .` opens the folder in VS Code attached to WSL.

Explain: editing from Windows paths (`/mnt/c/...`) causes permission and tooling pain — keep the repo in the Linux home directory.

## Step 4 — Install an AI coding assistant in VS Code

This repo is designed to work **with** an AI partner. The human opens the project in VS Code; the AI helps run gates in `start.ai`, edit Terraform, and explain AWS steps. Any capable assistant is fine — the repo is intentionally vendor-neutral.

### Pick one (recommended options)

| Option | Install | Good for |
|--------|---------|----------|
| **GitHub Copilot** | VS Code Extensions → search “GitHub Copilot” → Install → sign in with GitHub | Orgs already on GitHub; simple chat + inline edits |
| **Continue** | Extensions → “Continue” → configure a model ([continue.dev](https://continue.dev)) | Teams that want choice of model/provider |
| **Cursor** (alternative editor) | Install [Cursor](https://cursor.com/) instead of VS Code; open the same WSL folder | VS Code–like UI with built-in agent; skip Copilot/Continue |

Nonprofits may qualify for discounted or donated Copilot seats — check [GitHub for Nonprofits](https://github.com/solutions/industry/nonprofits) when relevant. Free tiers exist for several tools; paid plans are optional to start.

### After install — smoke test

1. With the repo folder open in VS Code, open the AI chat panel (Copilot: chat icon; Continue: sidebar).
2. Ask: *“Read `start.ai` and tell me the first three setup gates.”*
3. The assistant should reference fork → Speckit → AWS credentials. If it cannot see project files, confirm the **folder** (not a single file) is open.

Tell the user: **every working session** they (or their AI) should load `start.ai` first. That file is the shared checklist regardless of Copilot, Continue, or Cursor.

## Step 5 — Verify

```bash
git rev-parse --is-inside-work-tree   # true
git remote get-url origin             # your-org/your-repo
test -f start.ai && echo "ready for session bootstrap"
```

Confirm the AI can read repo files (quick chat test above).

Proceed to **start.ai §1** (Speckit) only after fork + clone + VS Code + AI assistant are in place.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `origin` still shows upstream template | Fork if needed, then `git remote set-url origin …` |
| `git push` permission denied | Add SSH key to GitHub — [githubFirstPr.md](./githubFirstPr.md) |
| `code: command not found` in WSL | In VS Code: Command Palette → “WSL: Install VS Code Server” or reinstall VS Code with “Add to PATH” |
| Cursor instead of VS Code | Cursor is VS Code–compatible; same WSL workflow applies — open the cloned folder from WSL; built-in agent replaces Copilot/Continue |
| AI cannot see project files | **File → Open Folder** on repo root; avoid opening only `start.ai` in isolation |
| Copilot “not authorized” | Sign in with the same GitHub account that owns the fork; check org billing/seat assignment |

## References

- [GitHub: Fork a repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
- [VS Code: Developing in WSL](https://code.visualstudio.com/docs/remote/wsl)
