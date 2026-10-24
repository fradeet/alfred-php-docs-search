#!/usr/bin/env bash
set -euo pipefail

workflow_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)
source "$workflow_dir/entries/lib/alfred_default_error.sh"

if ! result=$("$workflow_dir/template-cli" docs-index --output-format alfred); then
  alfred_default_error
  exit 1
fi

printf '%s\n' "$result"
