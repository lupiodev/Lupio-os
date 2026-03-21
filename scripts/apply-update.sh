#!/usr/bin/env bash
set -euo pipefail
# ============================================================
# Lupio OS — Apply Update
# Downloads latest agents, commands, templates, core modules.
# Preserves all project memory and context.
# ============================================================

LUPIO_DIR=".lupio"
VERSION_FILE="$LUPIO_DIR/context/version.json"
REPO_RAW="https://raw.githubusercontent.com/lupiodev/Lupio-os/main"
REPO_URL="https://github.com/lupiodev/Lupio-os.git"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log()    { echo -e "${BLUE}[lupio]${NC} $1"; }
success(){ echo -e "${GREEN}[lupio]${NC} $1"; }

[ -d "$LUPIO_DIR" ] || { echo "Error: .lupio/ not found."; exit 1; }

log "Descargando última versión de Lupio OS..."
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

git clone --depth=1 "$REPO_URL" "$TMP_DIR" 2>/dev/null

log "Actualizando agentes..."
cp -r "$TMP_DIR/claude/agents/."   "$LUPIO_DIR/agents/"

log "Actualizando comandos..."
cp -r "$TMP_DIR/claude/commands/." "$LUPIO_DIR/commands/"

log "Actualizando workflows..."
[ -d "$TMP_DIR/claude/workflows" ] && cp -r "$TMP_DIR/claude/workflows/." "$LUPIO_DIR/workflows/"

log "Actualizando system map..."
[ -f "$TMP_DIR/claude/SYSTEM_MAP.md" ] && cp "$TMP_DIR/claude/SYSTEM_MAP.md" "$LUPIO_DIR/SYSTEM_MAP.md"

log "Actualizando módulos core..."
cp -r "$TMP_DIR/core/."            "$LUPIO_DIR/core/"

log "Actualizando templates..."
cp -r "$TMP_DIR/templates/."       "$LUPIO_DIR/templates/"

# Record updated SHA
LATEST_SHA=$(cd "$TMP_DIR" && git rev-parse --short HEAD)
python3 - << EOF
import json, os
path = "$VERSION_FILE"
data = {}
try:
    with open(path) as f: data = json.load(f)
except: pass
data['sha'] = '$LATEST_SHA'
data['last_updated'] = '$(date -u +"%Y-%m-%dT%H:%M:%SZ")'
import time; data['last_checked'] = int(time.time())
with open(path, 'w') as f: json.dump(data, f, indent=2)
EOF

echo ""
success "¡Lupio OS actualizado a la versión $LATEST_SHA!"
echo ""
echo "  Agentes, comandos y templates actualizados."
echo "  Tu memoria y contexto del proyecto no fueron modificados."
echo ""
