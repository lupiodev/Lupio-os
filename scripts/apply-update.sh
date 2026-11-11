#!/usr/bin/env bash
set -euo pipefail
# ============================================================
# Lupio OS — Apply Update
# v2: agentes, comandos y skills llegan por el plugin `lupio-os`.
# Este script actualiza el plugin y refresca .lupio/ (workflows, templates, core).
# Preserves all project memory, context — and CLAUDE.md by default.
# Cada update hace un backup reversible en .lupio/checkpoints/.
#
# Uso:
#   bash .lupio/scripts/apply-update.sh                  # update normal (no toca CLAUDE.md)
#   bash .lupio/scripts/apply-update.sh --refresh-claude-md  # además ofrece refrescar CLAUDE.md
# ============================================================

LUPIO_DIR=".lupio"
VERSION_FILE="$LUPIO_DIR/context/version.json"
REPO_URL="${LUPIO_REPO_URL:-https://github.com/lupiodev/Lupio-os.git}"

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

git clone --depth=1 "$REPO_URL" "$TMP_DIR" >/dev/null 2>&1 \
  || { echo "Error: no se pudo descargar $REPO_URL (¿sin red?). No se modificó nada."; exit 1; }

# ── Backup reversible ANTES de sobrescribir nada ──────────────
STAMP=$(date -u +"%Y%m%d-%H%M%S")
BACKUP_DIR="$LUPIO_DIR/checkpoints/backup-$STAMP"
mkdir -p "$BACKUP_DIR"
log "Backup reversible en $BACKUP_DIR ..."
for d in workflows prompts core templates scripts skills; do
  [ -d "$LUPIO_DIR/$d" ] && cp -r "$LUPIO_DIR/$d" "$BACKUP_DIR/" 2>/dev/null || true
done
[ -f "CLAUDE.md" ] && cp "CLAUDE.md" "$BACKUP_DIR/CLAUDE.md" 2>/dev/null || true
# Conservar solo los últimos 5 backups (evita crecimiento indefinido)
ls -dt "$LUPIO_DIR/checkpoints/backup-"* 2>/dev/null | tail -n +6 | xargs rm -rf 2>/dev/null || true

log "Actualizando plugin lupio-os..."
if command -v claude >/dev/null 2>&1; then
  claude plugin marketplace update lupio >/dev/null 2>&1 || true
  claude plugin update lupio-os@lupio >/dev/null 2>&1 \
    && success "Plugin actualizado (reinicia Claude Code para aplicarlo)." \
    || warn "No se pudo actualizar el plugin. En Claude Code: /plugin › lupio-os › Update"
else
  warn "Claude Code no encontrado: actualiza el plugin desde /plugin al abrirlo."
fi
if [ -d "$LUPIO_DIR/agents" ] || [ -d "$LUPIO_DIR/commands" ]; then
  warn "Proyecto en v1. Ejecuta el instalador nuevo para migrar:"
  warn "  bash <(curl -fsSL https://raw.githubusercontent.com/lupiodev/Lupio-os/main/installer/install.sh)"
fi

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

# Registrar versión instalada (check-updates.sh compara `version`, no el SHA)
LATEST_SHA=$(cd "$TMP_DIR" && git rev-parse --short HEAD)
LATEST_VERSION=$(VERSION_FILE="$VERSION_FILE" PLUGIN_JSON="$TMP_DIR/.claude-plugin/plugin.json" LATEST_SHA="$LATEST_SHA" python3 - << 'PYEOF'
import json, os, time
path = os.environ["VERSION_FILE"]
try:
    data = json.load(open(path))
except Exception:
    data = {}
try:
    version = json.load(open(os.environ["PLUGIN_JSON"]))["version"]
except Exception:
    version = data.get("version", "0.0.0")
data.pop("latest_sha", None)
data.update({
    "version": version,
    "latest_version": version,
    "sha": os.environ["LATEST_SHA"],
    "last_updated": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "last_checked": int(time.time()),
})
os.makedirs(os.path.dirname(path), exist_ok=True)
json.dump(data, open(path, "w"), indent=2)
print(version)
PYEOF
)

echo ""
success "¡Lupio OS actualizado a la versión $LATEST_VERSION ($LATEST_SHA)!"
echo ""
echo "  Plugin (agentes, comandos, skills) + workflows, templates y core actualizados."
echo "  Tu memoria, contexto y CLAUDE.md NO fueron modificados."
echo "  Backup reversible: $BACKUP_DIR"
echo "  Para traer el CLAUDE.md nuevo a este proyecto: apply-update.sh --refresh-claude-md"
echo ""
