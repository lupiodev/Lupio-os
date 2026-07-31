#!/usr/bin/env bash
set -euo pipefail
# ============================================================
# Lupio OS — Apply Update
# Downloads latest agents, commands, skills, templates, core.
# Preserves all project memory, context — and CLAUDE.md by default.
# Cada update hace un backup reversible en .lupio/checkpoints/.
#
# Uso:
#   bash .lupio/scripts/apply-update.sh                  # update normal (no toca CLAUDE.md)
#   bash .lupio/scripts/apply-update.sh --refresh-claude-md  # además ofrece refrescar CLAUDE.md
# ============================================================

LUPIO_DIR=".lupio"
VERSION_FILE="$LUPIO_DIR/context/version.json"
REPO_RAW="https://raw.githubusercontent.com/lupiodev/Lupio-os/main"
REPO_URL="https://github.com/lupiodev/Lupio-os.git"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

log()    { echo -e "${BLUE}[lupio]${NC} $1"; }
success(){ echo -e "${GREEN}[lupio]${NC} $1"; }
warn()   { echo -e "${YELLOW}[lupio]${NC} $1"; }

REFRESH_CLAUDE_MD=false
for arg in "$@"; do
  case "$arg" in
    --refresh-claude-md) REFRESH_CLAUDE_MD=true ;;
    *) warn "Opción desconocida: $arg (ignorada)" ;;
  esac
done

[ -d "$LUPIO_DIR" ] || { echo "Error: .lupio/ not found."; exit 1; }

log "Descargando última versión de Lupio OS..."
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

git clone --depth=1 "$REPO_URL" "$TMP_DIR" 2>/dev/null

# ── Backup reversible ANTES de sobrescribir nada ──────────────
STAMP=$(date -u +"%Y%m%d-%H%M%S")
BACKUP_DIR="$LUPIO_DIR/checkpoints/backup-$STAMP"
mkdir -p "$BACKUP_DIR"
log "Backup reversible en $BACKUP_DIR ..."
for d in agents commands workflows prompts core templates scripts skills; do
  [ -d "$LUPIO_DIR/$d" ] && cp -r "$LUPIO_DIR/$d" "$BACKUP_DIR/" 2>/dev/null || true
done
if [ -d ".claude/skills" ]; then
  mkdir -p "$BACKUP_DIR/claude-skills"
  cp -r ".claude/skills/." "$BACKUP_DIR/claude-skills/" 2>/dev/null || true
fi
[ -f "CLAUDE.md" ] && cp "CLAUDE.md" "$BACKUP_DIR/CLAUDE.md" 2>/dev/null || true
# Conservar solo los últimos 5 backups (evita crecimiento indefinido)
ls -dt "$LUPIO_DIR/checkpoints/backup-"* 2>/dev/null | tail -n +6 | xargs rm -rf 2>/dev/null || true

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

# ── Refresh opt-in del CLAUDE.md (solo con --refresh-claude-md) ─
# Por defecto NO se toca el CLAUDE.md del proyecto. Con el flag, se muestra el
# diff y se pide confirmación; el actual queda respaldado en el backup.
if [ "$REFRESH_CLAUDE_MD" = true ]; then
  if [ -f "$TMP_DIR/claude/CLAUDE.template.md" ]; then
    if [ -f "CLAUDE.md" ]; then
      echo ""
      log "Diff de tu CLAUDE.md actual vs. el nuevo (lean):"
      diff -u "CLAUDE.md" "$TMP_DIR/claude/CLAUDE.template.md" || true
      echo ""
      printf "¿Reemplazo tu CLAUDE.md? El actual ya está en %s/CLAUDE.md (s/n): " "$BACKUP_DIR"
      ans="n"; [ -e /dev/tty ] && read -r ans < /dev/tty || read -r ans || true
      case "$ans" in
        s|S|si|Si|y|Y) cp "$TMP_DIR/claude/CLAUDE.template.md" "CLAUDE.md"
           success "CLAUDE.md actualizado (backup en $BACKUP_DIR/CLAUDE.md)." ;;
        *) log "CLAUDE.md sin cambios." ;;
      esac
    else
      cp "$TMP_DIR/claude/CLAUDE.template.md" "CLAUDE.md"
      success "CLAUDE.md creado desde el template."
    fi
  else
    warn "No se encontró el template de CLAUDE.md — refresh omitido."
  fi
fi

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
echo "  Agentes, comandos, skills y templates actualizados."
echo "  Tu memoria, contexto y CLAUDE.md NO fueron modificados."
echo "  Backup reversible: $BACKUP_DIR"
echo "  Para traer el CLAUDE.md nuevo a este proyecto: apply-update.sh --refresh-claude-md"
echo ""
