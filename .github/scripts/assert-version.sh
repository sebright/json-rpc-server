#!/usr/bin/env bash
# Usage: ./assert-version.sh <package-name> <expected-version>

set -euo pipefail

PKG="$1"
EXPECTED="$2"
FREEZE_FILE="cabal.project.freeze"

cabal freeze -v0
[[ -f "$FREEZE_FILE" ]] || { echo "Error: Missing freeze file"; exit 1; }

if grep -q "any.$PKG ==$EXPECTED" "$FREEZE_FILE"; then
  echo "Assertion passed: $PKG's version is $EXPECTED"
  rm "$FREEZE_FILE"
else
  echo "Assertion failed: $PKG's version is NOT $EXPECTED"
  cat "$FREEZE_FILE" | grep "any.$PKG"
  rm "$FREEZE_FILE"
  exit 1
fi
