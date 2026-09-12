#!/usr/bin/env bash
set -euo pipefail

if [ "$NIX_UNIT_FAILURE_COUNT" -eq 0 ]; then
    echo "nix-unit: $NIX_UNIT_ASSERTION_COUNT assertions passed"
    touch "$out"
else
    echo "nix-unit: $NIX_UNIT_FAILURE_COUNT assertion(s) failed:" >&2
    while IFS= read -r name; do
        printf '  - %s\n' "$name" >&2
    done <<< "$NIX_UNIT_FAILURE_NAMES"
    exit 1
fi
