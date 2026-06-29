#!/usr/bin/env bash
# Lightweight session gate for agents and humans (aws4np template).
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
failures=0
allow_upstream="${AWS4NP_ALLOW_UPSTREAM:-0}"

info() { echo "[INFO] $*"; }
pass() { echo "[PASS] $*"; }
fail() { echo "[FAIL] $*"; failures=$((failures + 1)); }

terraform_version_ok() {
  local ver
  ver=$(terraform version -json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('terraform_version',''))" 2>/dev/null) || \
    ver=$(terraform version 2>/dev/null | head -1 | sed -n 's/.* v\([0-9.]*\).*/\1/p')
  [[ -n "$ver" ]] || return 1
  python3 - "$ver" <<'PY'
import sys
from itertools import zip_longest
need = (1, 13, 0)
got = tuple(int(x) for x in sys.argv[1].split(".")[:3])
got = got + (0,) * (3 - len(got))
sys.exit(0 if got >= need else 1)
PY
}

info "Checking aws4np session prerequisites"

if git -C "$repo_root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  pass "git repository present"
  if origin_url=$(git -C "$repo_root" remote get-url origin 2>/dev/null); then
    if [[ "$origin_url" =~ people-for-liberty/aws4np ]]; then
      if [[ "$allow_upstream" == "1" ]]; then
        pass "upstream template remote (AWS4NP_ALLOW_UPSTREAM=1)"
      else
        fail "origin still points at upstream template — fork to your org first (setup/forkAndWorkspace.md)"
      fi
    else
      pass "origin remote set ($origin_url)"
    fi
  else
    fail "no git origin remote — clone your fork (setup/forkAndWorkspace.md)"
  fi
else
  fail "not a git repository — fork and clone first (setup/forkAndWorkspace.md)"
fi

if command -v specify >/dev/null 2>&1; then
  if specify version >/dev/null 2>&1 || specify check >/dev/null 2>&1; then
    pass "specify CLI available"
  else
    fail "specify on PATH but not working — see setup/installSpeckit.md"
  fi
else
  fail "specify CLI missing — follow setup/installSpeckit.md"
fi

if [[ -d "$repo_root/.specify" ]]; then
  pass ".specify/ present (repo pre-initialized; do not run specify init)"
else
  fail "missing .specify/ — this template should include it; see setup/installSpeckit.md"
fi

if [[ -d "$repo_root/.secrets" ]]; then
  pass ".secrets/ directory present"
else
  fail ".secrets/ missing — follow setup/installAwsCredentials.md"
fi

if [[ -f "$repo_root/.secrets/tu.keys" ]]; then
  pass ".secrets/tu.keys present (gitignored)"
else
  fail ".secrets/tu.keys missing — follow setup/installAwsCredentials.md"
fi

if git -C "$repo_root" check-ignore -q .secrets/tu.keys 2>/dev/null; then
  pass ".secrets/tu.keys is gitignored"
else
  fail ".secrets/tu.keys is not gitignored — fix .gitignore before committing"
fi

if [[ -f "$repo_root/.specify/memory/constitution.md" ]]; then
  pass "constitution present"
else
  fail "missing .specify/memory/constitution.md"
fi

if [[ -f "$repo_root/.secrets/tu.keys" ]]; then
  if command -v aws >/dev/null 2>&1; then
    pass "AWS CLI available"
    # shellcheck disable=SC1090
    eval "$("$repo_root/scripts/load-aws-env.sh")"
    if account=$(aws sts get-caller-identity --query Account --output text 2>/dev/null); then
      pass "AWS STS OK — account $account"
    else
      fail "AWS STS failed — check .secrets/tu.keys credentials (setup/installAwsCredentials.md)"
    fi
  else
    fail "AWS CLI missing — install awscli (setup/installAwsCredentials.md)"
  fi
fi

bootstrap_started=false
if [[ -f "$repo_root/config/backend.hcl" ]]; then
  bootstrap_started=true
elif compgen -G "$repo_root/specs/002-*" >/dev/null 2>&1; then
  bootstrap_started=true
fi

if $bootstrap_started; then
  if command -v terraform >/dev/null 2>&1; then
    if terraform_version_ok; then
      pass "terraform >= 1.13"
    else
      fail "terraform too old — need >= 1.13 (setup/installTerraform.md)"
    fi
    if terraform -chdir="$repo_root/aws" validate >/dev/null 2>&1; then
      pass "terraform validate (aws/)"
    else
      info "terraform validate pending — run init if backend.hcl is configured"
    fi
  else
    fail "terraform missing — required after bootstrap started (setup/installTerraform.md)"
  fi
  pass "bootstrap in progress or complete (backend.hcl or spec 002)"
  if [[ -d "$repo_root/specs/003-wordpress-lightsail" ]]; then
    info "WordPress training — start.ai §4 (setup/speckitSecondTrainingWordPress.md)"
  fi
else
  info "Bootstrap training pending — complete start.ai §3 (setup/speckitFirstTraining.md)"
  if [[ -d "$repo_root/aws" ]] && command -v terraform >/dev/null 2>&1; then
    if terraform_version_ok; then
      pass "terraform >= 1.13 (optional until §3)"
    else
      info "terraform present but below 1.13 — upgrade before §3"
    fi
  fi
fi

if [[ "$failures" -gt 0 ]]; then
  echo "HALT: $failures prerequisite failure(s). Fix before discretionary infrastructure work."
  exit 1
fi

pass "session prerequisites satisfied"
exit 0
