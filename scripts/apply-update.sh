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

log "Actualizando prompts..."
[ -d "$TMP_DIR/claude/prompts" ] && mkdir -p "$LUPIO_DIR/prompts" && cp -r "$TMP_DIR/claude/prompts/." "$LUPIO_DIR/prompts/"

mkdir -p "$LUPIO_DIR/checkpoints"

# WordPress skills — solo si el proyecto es WordPress
if [ -f "wp-config.php" ] || [ -d "wp-content" ]; then
  if [ -d "$TMP_DIR/claude/skills/wordpress" ]; then
    log "WordPress detectado — actualizando WP skills..."
    mkdir -p "$LUPIO_DIR/skills/wordpress"
    cp -r "$TMP_DIR/claude/skills/wordpress/." "$LUPIO_DIR/skills/wordpress/"
  fi
fi

# Lupio skills (arranque + diseño) — van a .claude/skills/ para que auto-carguen
if [ -d "$TMP_DIR/.claude/skills" ]; then
  log "Actualizando Lupio skills (.claude/skills/)..."
  mkdir -p ".claude/skills"
  for skill_dir in "$TMP_DIR/.claude/skills/"*/; do
    [ -d "$skill_dir" ] && cp -r "$skill_dir" ".claude/skills/"
  done
  [ -f "$TMP_DIR/.claude/skills/ATTRIBUTION.md" ] && cp "$TMP_DIR/.claude/skills/ATTRIBUTION.md" ".claude/skills/"
fi

log "Actualizando templates..."
cp -r "$TMP_DIR/templates/."       "$LUPIO_DIR/templates/"

# Self-update de scripts — debe ir al FINAL para no modificar el script en ejecución
if [ -d "$TMP_DIR/scripts" ]; then
  log "Auto-actualizando scripts (efectivo en próximo run)..."
  cp -r "$TMP_DIR/scripts/." "$LUPIO_DIR/scripts/"
  find "$LUPIO_DIR/scripts/" -name "*.sh" -exec chmod +x {} \;
fi

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
