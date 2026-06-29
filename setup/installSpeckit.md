# Install GitHub Spec Kit (`specify` CLI)

**Audience:** AI agent helping a nonprofit operator set up this repo.  
**Goal:** Install the [GitHub Spec Kit](https://github.com/github/spec-kit) CLI so speckit workflows work.  
**Do not** run `specify init` in this repo — `.specify/` is already committed.

## What “installed” means here

| Check | Pass criteria |
|-------|---------------|
| CLI on PATH | `command -v specify` prints a path |
| CLI runs | `specify version` or `specify check` exits 0 |
| Repo ready | Directory `.specify/` exists at repo root (already true in aws4np) |

Slash commands like `/speckit.specify` are optional during bootstrap. This template drives early work through `start.ai` and `.specify/scripts/bash/`. **Workflow training** (spec → plan → tasks under the constitution) is a separate guided session after install — do not rush the operator through feature work during this gate.

## Step 0 — Explain briefly to the user

Tell them Spec Kit is GitHub’s spec-driven development toolkit. We only need its **`specify` command-line tool**; the project templates are already in `.specify/`.

## Step 1 — Check what is already installed

Run these in the repo root:

```bash
command -v git && git --version
command -v specify && specify version || specify check
command -v uv && uv --version
python3 --version 2>/dev/null || python --version
test -d .specify && echo ".specify present"
```

If `specify` is found and `.specify/` exists, **stop** — installation is complete.

## Step 2 — Install Git (if missing)

Required for this repo regardless of Spec Kit.

- **Linux (Debian/Ubuntu):** `sudo apt update && sudo apt install -y git`
- **macOS:** install Xcode Command Line Tools or `brew install git`
- **Windows:** [Git for Windows](https://git-scm.com/download/win)

## Step 3 — Install Python 3.11+ (if missing)

Spec Kit requires **Python 3.11 or newer**.

Check:

```bash
python3 --version
```

If missing or below 3.11:

- **Linux (Debian/Ubuntu):** `sudo apt update && sudo apt install -y python3 python3-venv`
- **macOS:** `brew install python@3.12`
- **Windows:** [python.org downloads](https://www.python.org/downloads/) — enable “Add Python to PATH”

## Step 4 — Install `uv` (Python package manager)

Spec Kit recommends [uv](https://docs.astral.sh/uv/) to install the CLI without polluting the system Python.

**Linux / macOS (official installer):**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

After install, ensure `~/.local/bin` is on PATH. In the current shell:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Open a **new terminal** if the installer says to, then verify:

```bash
uv --version
```

Other install options: [Installing uv (Spec Kit docs)](https://github.com/github/spec-kit/blob/main/docs/install/uv.md).

## Step 5 — Install the `specify` CLI

Pin to the latest stable release tag from [Spec Kit releases](https://github.com/github/spec-kit/releases). As of template authoring, that tag is **`v0.11.8`** — replace if a newer release is clearly current.

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.11.8
```

Ensure PATH includes uv’s tool bin directory (usually `~/.local/bin`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Verify:

```bash
specify version
specify check
```

### Upgrade an old CLI

If `specify version` shows a much older CLI than the template version line, reinstall:

```bash
uv tool install specify-cli --force --from git+https://github.com/github/spec-kit.git@v0.11.8
```

## Step 6 — Confirm repo state (no `specify init`)

This template **already includes**:

- `.specify/memory/constitution.md`
- `.specify/scripts/bash/` (create feature, plan, tasks helpers)
- `.specify/templates/`
- Example spec `specs/001-repo-scaffold/`

**Do not run** `specify init` — it would prompt to merge agent files and is unnecessary for aws4np’s workflow.

Optional later: if the user wants IDE slash commands (`/speckit.*`), they can run (with user approval only):

```bash
specify init . --force --integration cursor
```

That is **not** required to use `start.ai` or the bash scripts in `.specify/scripts/bash/`.

## Step 7 — Re-run session gate

From repo root:

```bash
scripts/check-session-prereqs.sh
```

Or at minimum:

```bash
command -v specify && specify version
test -d .specify
```

Proceed with the rest of `start.ai` only when these pass.

## Troubleshooting

### `specify: command not found` after install

- Run `export PATH="$HOME/.local/bin:$PATH"` and retry.
- Confirm symlink: `ls -la ~/.local/bin/specify`
- Confirm tool list: `uv tool list` should show `specify-cli`.

### `uv: command not found`

Repeat Step 4 and restart the terminal.

### Python version too old

Install Python 3.11+ (Step 3), then reinstall specify (Step 5).

### Permission errors on Linux

Do **not** use `sudo` with `uv tool install`. Install as the normal user; tools land in `~/.local/`.

## References

- [github/spec-kit](https://github.com/github/spec-kit)
- [Installing uv](https://github.com/github/spec-kit/blob/main/docs/install/uv.md)
- [uv installation docs](https://docs.astral.sh/uv/getting-started/installation/)
