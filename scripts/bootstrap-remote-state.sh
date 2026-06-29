#!/usr/bin/env bash
# One-time bootstrap: S3 state bucket + DynamoDB lock table for a new nonprofit AWS account.
#
# Usage:
#   export ORG_SLUG=your-org-short-name   # lowercase, no spaces
#   eval "$(scripts/load-aws-env.sh)"
#   scripts/bootstrap-remote-state.sh           # interactive confirm
#   scripts/bootstrap-remote-state.sh --yes     # skip prompt (human approved in chat)
#
# Then copy config/backend.hcl.example → config/backend.hcl, fill values, and:
#   terraform -chdir=aws init -backend-config=../config/backend.hcl
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
org_slug="${ORG_SLUG:-}"
region="${AWS_DEFAULT_REGION:-us-east-1}"
auto_confirm=false

usage() {
  cat <<'EOF'
Usage: scripts/bootstrap-remote-state.sh [OPTIONS]

Creates S3 bucket + DynamoDB table for Terraform remote state.

Environment:
  ORG_SLUG              Required. Lowercase org short name (e.g. my-nonprofit)
  AWS_DEFAULT_REGION    Optional. Default: us-east-1

Options:
  --yes                 Create resources without interactive [y/N] prompt.
                        Use only after the operator explicitly approves in chat.
  -h, --help            Show this help

EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --yes)
      auto_confirm=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$org_slug" ]]; then
  echo "ERROR: Set ORG_SLUG (e.g. export ORG_SLUG=my-nonprofit)" >&2
  exit 1
fi

if ! [[ "$org_slug" =~ ^[a-z][a-z0-9-]{1,30}$ ]]; then
  echo "ERROR: ORG_SLUG must be lowercase alphanumeric/hyphen, 2–31 chars" >&2
  exit 1
fi

account_id=$(aws sts get-caller-identity --query Account --output text)
bucket="${org_slug}-terraform-state-${account_id}"
lock_table="${org_slug}-terraform-locks"

echo "Account:  $account_id"
echo "Bucket:   $bucket"
echo "Lock:     $lock_table"
echo "Region:   $region"
echo

if $auto_confirm; then
  echo "Proceeding (--yes): creating resources if missing."
else
  read -r -p "Create these resources? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || exit 0
fi

if aws s3api head-bucket --bucket "$bucket" 2>/dev/null; then
  echo "Bucket already exists: $bucket"
else
  if [[ "$region" == "us-east-1" ]]; then
    aws s3api create-bucket --bucket "$bucket" --region "$region"
  else
    aws s3api create-bucket --bucket "$bucket" --region "$region" \
      --create-bucket-configuration "LocationConstraint=$region"
  fi
  aws s3api put-public-access-block --bucket "$bucket" \
    --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
  aws s3api put-bucket-versioning --bucket "$bucket" \
    --versioning-configuration Status=Enabled
  aws s3api put-bucket-encryption --bucket "$bucket" \
    --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
  echo "Created bucket: $bucket"
fi

if aws dynamodb describe-table --table-name "$lock_table" --region "$region" >/dev/null 2>&1; then
  echo "Lock table already exists: $lock_table"
else
  aws dynamodb create-table --table-name "$lock_table" --region "$region" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
  echo "Created lock table: $lock_table"
fi

cat <<EOF

Next steps:
  1. cp config/backend.hcl.example config/backend.hcl
  2. Edit config/backend.hcl — set bucket=$bucket, dynamodb_table=$lock_table
  3. Set org_slug and aws_account_id in aws/terraform.tfvars (see terraform.tfvars.example)
  4. terraform -chdir=aws init -backend-config=../config/backend.hcl
  5. terraform -chdir=aws plan   # review backend_state.tf alignment

EOF
