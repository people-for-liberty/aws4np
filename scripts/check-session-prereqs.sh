#!/usr/bin/env bash
# Lightweight session gate for agents and humans (aws4np template).
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
failures=0

info() { echo "[INFO] $*"; }
pass() { echo "[PASS] $*"; }
fail() { echo "[FAIL] $*"; failures=$((failures + 1)); }

info "Checking aws4np session prerequisites"

if [[ -f "$repo_root/tu.keys" ]]; then
  pass "tu.keys present (gitignored)"
else
  fail "tu.keys missing — copy from tu.keys.example"
fi

if git -C "$repo_root" check-ignore -q tu.keys 2>/dev/null; then
  pass "tu.keys is gitignored"
else
  fail "tu.keys is not gitignored — fix .gitignore before committing"
fi

if [[ -f "$repo_root/.specify/memory/constitution.md" ]]; then
  pass "constitution present"
else
  fail "missing .specify/memory/constitution.md"
fi

if command -v aws >/dev/null 2>&1 && [[ -f "$repo_root/tu.keys" ]]; then
  # shellcheck disable=SC1090
  eval "$("$repo_root/scripts/load-aws-env.sh")"
  if account=$(aws sts get-caller-identity --query Account --output text 2>/dev/null); then
    pass "AWS STS OK — account $account"
  else
    fail "AWS STS failed — check tu.keys credentials"
  fi
else
  info "Skipping AWS STS (aws CLI or tu.keys unavailable)"
fi

if [[ -d "$repo_root/aws" ]] && command -v terraform >/dev/null 2>&1; then
  if terraform -chdir="$repo_root/aws" validate >/dev/null 2>&1; then
    pass "terraform validate (aws/)"
  else
    info "terraform validate skipped or not yet initialized"
  fi
fi

if [[ "$failures" -gt 0 ]]; then
  echo "HALT: $failures prerequisite failure(s). Fix before discretionary infrastructure work."
  exit 1
fi

pass "session prerequisites satisfied"
exit 0
