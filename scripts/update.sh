#!/usr/bin/env bash
# Delegates to apply-update.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$SCRIPT_DIR/apply-update.sh" "$@"
