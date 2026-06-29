#!/usr/bin/env bash
# Load AWS credentials from tu.keys (gitignored). Usage:
#   eval "$(scripts/load-aws-env.sh)"
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
keys_file="${AWS_KEYS_FILE:-$repo_root/.secrets/tu.keys}"

if [[ ! -f "$keys_file" ]]; then
  echo "ERROR: Keys file not found: $keys_file" >&2
  echo "Follow setup/installAwsCredentials.md — create .secrets/tu.keys from .secrets/tu.keys.example." >&2
  exit 1
fi

python3 - "$keys_file" <<'PY'
import re, sys
text = open(sys.argv[1]).read()
ak = re.search(r'Access key:\s*(\S+)', text, re.I)
sk = re.search(r'Secret access key:\s*(\S+)', text, re.I)
if not ak or not sk:
    raise SystemExit('Could not parse Access key / Secret access key from tu.keys')
print(f"export AWS_ACCESS_KEY_ID={ak.group(1)!r}")
print(f"export AWS_SECRET_ACCESS_KEY={sk.group(1)!r}")
print("export AWS_DEFAULT_REGION=us-east-1")
print("unset AWS_PROFILE")
PY
