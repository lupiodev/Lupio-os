#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Lupio OS Updater
# Pulls latest agent definitions, commands, and templates
# ============================================================

LUPIO_REPO="https://github.com/your-org/lupio-os"
LUPIO_BRANCH="main"
LUPIO_DIR=".lupio"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log()    { echo -e "${BLUE}[lupio-update]${NC} $1"; }
success(){ echo -e "${GREEN}[lupio-update]${NC} $1"; }

[ -d "$LUPIO_DIR" ] || { echo "Error: .lupio/ not found. Run install.sh first."; exit 1; }

log "Pulling latest Lupio OS..."
TMP_DIR=$(mktemp -d)
git clone --depth=1 --branch "$LUPIO_BRANCH" "$LUPIO_REPO" "$TMP_DIR" 2>/dev/null

log "Updating agents..."
cp -r "$TMP_DIR/claude/agents/." "$LUPIO_DIR/agents/"

log "Updating commands..."
cp -r "$TMP_DIR/claude/commands/." "$LUPIO_DIR/commands/"

log "Updating core modules..."
cp -r "$TMP_DIR/core/." "$LUPIO_DIR/core/"

log "Updating templates..."
cp -r "$TMP_DIR/templates/." "$LUPIO_DIR/templates/"

rm -rf "$TMP_DIR"
success "Lupio OS updated to latest version."
