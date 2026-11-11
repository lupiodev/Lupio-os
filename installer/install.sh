#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Lupio OS Installer v2.1.0
# Prepara UN proyecto. Agentes, comandos y skills llegan por el
# plugin `lupio-os` (se actualiza solo). Este script solo deja:
#   .lupio/  ·  CLAUDE.md  ·  .claude/settings.json  ·  editores
#
# Uso:
#   bash <(curl -fsSL https://raw.githubusercontent.com/lupiodev/Lupio-os/main/installer/install.sh)
# Opciones (variables de entorno):
#   LUPIO_YES=true      sin preguntas (CI)
#   LUPIO_MARKETING=true|false   activa (o no) el plugin de marketing sin preguntar
#   LUPIO_BYPASS=true   activa bypassPermissions SOLO en tu máquina (settings.local.json)
# ============================================================

LUPIO_REPO="${LUPIO_REPO_URL:-https://github.com/lupiodev/Lupio-os}"
LUPIO_GH="lupiodev/Lupio-os"
LUPIO_BRANCH="main"
LUPIO_DIR=".lupio"
LUPIO_VERSION="2.1.0"   # se reemplaza por la `version` de plugin.json tras descargar
PLUGIN_ID="lupio-os@lupio"
# Plugin compañero opcional (MIT, Corey Haines) — ver .claude/skills/ATTRIBUTION.md
MARKETING_GH="coreyhaines31/marketingskills"
MARKETING_MARKETPLACE="marketingskills"
MARKETING_PLUGIN_ID="marketing-skills@marketingskills"

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

success() { echo -e "${GREEN}  ✔${NC}  $1" >&2; }
warn()    { echo -e "${YELLOW}  ⚠${NC}  $1" >&2; }
error()   { echo -e "${RED}  ✖  $1${NC}" >&2; exit 1; }
info()    { echo -e "  ${CYAN}$1${NC}" >&2; }
step()    { echo -e "${BLUE}  →${NC}  $1" >&2; }
hr()      { echo -e "  ${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

LUPIO_SRC=""
EDITOR_CURSOR=false
EDITOR_VSCODE=false
HAS_CLAUDE_CODE=false
PLUGIN_OK=false
WANT_MARKETING=false
STALE_CLAUDE_MD=false

print_banner() {
  echo ""
  echo -e "${BOLD}  LUPIO OS${NC}  ${YELLOW}AI Development Operating System — v${LUPIO_VERSION}${NC}"
  echo ""; hr; echo ""
}

check_requirements() {
  command -v git     >/dev/null 2>&1 || error "Necesitas git."
  command -v python3 >/dev/null 2>&1 || error "Necesitas python3 (para editar settings.json sin romperlo)."
}

detect_editors() {
  if command -v cursor >/dev/null 2>&1 || [ -d "$HOME/.cursor" ] || [ -d "/Applications/Cursor.app" ]; then EDITOR_CURSOR=true; fi
  if command -v code   >/dev/null 2>&1 || [ -d "$HOME/.vscode" ] || [ -d "/Applications/Visual Studio Code.app" ]; then EDITOR_VSCODE=true; fi
  if command -v claude >/dev/null 2>&1; then HAS_CLAUDE_CODE=true; fi
}

confirm_installation() {
  echo -e "  ${BOLD}Proyecto:${NC} ${GREEN}$(pwd)${NC}"
  echo ""
  echo -e "  ${BOLD}Se instalará:${NC}"
  echo -e "  ${CYAN}plugin lupio-os${NC}          13 agentes · 15 comandos · skills (auto-actualizable)"
  echo -e "  ${CYAN}.lupio/${NC}                  contexto, memoria, workflows, templates, core"
  echo -e "  ${CYAN}CLAUDE.md${NC}                reglas del proyecto (si no existe)"
  echo -e "  ${CYAN}.claude/settings.json${NC}    activa el plugin + permisos seguros (se fusiona)"
  [ "$EDITOR_CURSOR" = true ] && echo -e "  ${CYAN}.cursor/rules.md${NC}         reglas para Cursor"
  [ "$EDITOR_VSCODE" = true ] && echo -e "  ${CYAN}.vscode/settings.json${NC}    exclusiones de búsqueda (se fusiona)"
  [ "${LUPIO_MARKETING:-}" = "true" ] && echo -e "  ${CYAN}plugin marketing-skills${NC}  skills de marketing (opcional, de terceros)"
  echo ""
  [ -d "$LUPIO_DIR/agents" ] && warn "Instalación v1 detectada: se migrará (respaldo en .lupio/checkpoints/)."
  hr; echo ""

  if [ "${LUPIO_YES:-}" = "true" ]; then return; fi
  printf "  ¿Continuar? (y/n): "
  local answer
  read -r answer < /dev/tty 2>/dev/null || { echo ""; warn "Sin terminal. Usa: LUPIO_YES=true bash install.sh"; exit 1; }
  [[ "$answer" =~ ^[YySs]$ ]] || { echo ""; info "Cancelado. No se modificó nada."; exit 0; }
  echo ""
}

# ── Opcional: skills de marketing (plugin de terceros, se actualiza solo) ──
ask_marketing() {
  case "${LUPIO_MARKETING:-}" in
    true)  WANT_MARKETING=true;  return ;;
    false) WANT_MARKETING=false; return ;;
  esac
  [ "${LUPIO_YES:-}" = "true" ] && return
  echo -e "  ${BOLD}Opcional:${NC} skills de marketing (CRO, copy, SEO, ads, emails, pricing…)."
  echo -e "  Plugin ${CYAN}marketing-skills${NC} de Corey Haines (MIT). Suma ~50 skills al contexto."
  printf "  ¿Activarlo en este proyecto? (y/N): "
  local answer=""
  read -r answer < /dev/tty 2>/dev/null || answer=""
  [[ "$answer" =~ ^[YySs]$ ]] && WANT_MARKETING=true
  echo ""
  return 0
}

check_claude_code() {
  if [ "$HAS_CLAUDE_CODE" = true ]; then success "Claude Code detectado."; return; fi
  warn "Claude Code no está instalado."
  if command -v npm >/dev/null 2>&1; then
    step "Instalando Claude Code..."
    npm install -g @anthropic-ai/claude-code >/dev/null 2>&1 && { success "Claude Code instalado."; HAS_CLAUDE_CODE=true; } \
      || warn "No se pudo instalar. Ejecuta: npm install -g @anthropic-ai/claude-code"
  else
    warn "Instala Node.js 18+ y luego: npm install -g @anthropic-ai/claude-code"
  fi
}

download_lupio() {
  step "Descargando Lupio OS..."
  local tmp; tmp=$(mktemp -d)
  git clone --depth=1 --branch "$LUPIO_BRANCH" "$LUPIO_REPO" "$tmp/lupio-os" >/dev/null 2>&1 \
    || error "No se pudo descargar $LUPIO_REPO"
  LUPIO_SRC="$tmp/lupio-os"
  local v
  v=$(python3 -c "import json,sys; print(json.load(open(sys.argv[1]))['version'])" "$LUPIO_SRC/.claude-plugin/plugin.json" 2>/dev/null || true)
  [ -n "$v" ] && LUPIO_VERSION="$v"
  success "Descargado (v$LUPIO_VERSION)."
}

# ── Migración desde v1 (copias locales de agentes/comandos/skills) ──
migrate_v1() {
  local stamp backup moved=0 d s name f base
  stamp=$(date -u +"%Y%m%d-%H%M%S")
  backup="$LUPIO_DIR/checkpoints/legacy-v1-$stamp"
  for d in agents commands; do
    if [ -d "$LUPIO_DIR/$d" ]; then mkdir -p "$backup"; mv "$LUPIO_DIR/$d" "$backup/"; moved=1; fi
  done

  # Skills copiadas por v1: carpetas con el mismo nombre que las del plugin…
  if [ -d ".claude/skills" ] && [ -d "$LUPIO_SRC/.claude/skills" ]; then
    for s in "$LUPIO_SRC/.claude/skills/"*/; do
      name=$(basename "$s")
      if [ -d ".claude/skills/$name" ]; then
        mkdir -p "$backup/claude-skills"; mv ".claude/skills/$name" "$backup/claude-skills/"; moved=1
      fi
    done
    # …y archivos sueltos que un instalador viejo aplanó en la raíz
    # (SKILL.md, LICENSE, AUDIT.md…). Solo los que existen dentro de una skill de Lupio.
    for f in ".claude/skills/"*; do
      [ -f "$f" ] || continue
      base=$(basename "$f")
      if [ "$base" = "ATTRIBUTION.md" ] || compgen -G "$LUPIO_SRC/.claude/skills/*/$base" >/dev/null; then
        mkdir -p "$backup/claude-skills"; mv "$f" "$backup/claude-skills/"; moved=1
      fi
    done
    rmdir ".claude/skills" 2>/dev/null || true
  fi

  # Comandos copiados por v1 a .claude/commands/: ahora llegan por el plugin
  # (dejarlos duplica cada /comando). Los comandos propios del proyecto no se tocan.
  if [ -d ".claude/commands" ] && [ -d "$LUPIO_SRC/claude/commands" ]; then
    for s in "$LUPIO_SRC/claude/commands/"*.md; do
      name=$(basename "$s")
      if [ -f ".claude/commands/$name" ]; then
        mkdir -p "$backup/claude-commands"; mv ".claude/commands/$name" "$backup/claude-commands/"; moved=1
      fi
    done
    rmdir ".claude/commands" 2>/dev/null || true
  fi

  [ "$moved" = 1 ] && success "Copias v1 retiradas (ahora vienen del plugin). Respaldo: $backup"
  return 0
}

# ── .lupio/ : solo lo propio del proyecto + material de referencia ──
install_lupio_dir() {
  step "Preparando .lupio/..."
  for d in memory context checkpoints workflows templates core prompts scripts; do mkdir -p "$LUPIO_DIR/$d"; done
  [ -f "$LUPIO_DIR/.gitignore" ] || printf 'memory/\ncontext/\ncheckpoints/\n*.local.md\n' > "$LUPIO_DIR/.gitignore"

  local s="$LUPIO_SRC"
  [ -d "$s/claude/workflows" ] && cp -r "$s/claude/workflows/." "$LUPIO_DIR/workflows/"
  [ -d "$s/claude/prompts" ]   && cp -r "$s/claude/prompts/."   "$LUPIO_DIR/prompts/"
  [ -f "$s/claude/SYSTEM_MAP.md" ] && cp "$s/claude/SYSTEM_MAP.md" "$LUPIO_DIR/SYSTEM_MAP.md"
  [ -d "$s/templates" ] && cp -r "$s/templates/." "$LUPIO_DIR/templates/"
  [ -d "$s/core" ]      && cp -r "$s/core/."      "$LUPIO_DIR/core/"
  [ -d "$s/scripts" ]   && cp -r "$s/scripts/."   "$LUPIO_DIR/scripts/" && chmod +x "$LUPIO_DIR/scripts/"*.sh 2>/dev/null || true

  # WordPress: solo si el proyecto es WP
  if { [ -f "wp-config.php" ] || [ -d "wp-content" ]; } && [ -d "$s/claude/skills/wordpress" ]; then
    mkdir -p "$LUPIO_DIR/skills/wordpress"
    cp -r "$s/claude/skills/wordpress/." "$LUPIO_DIR/skills/wordpress/"
    success "WordPress detectado — guías WP instaladas."
  fi
  success ".lupio/ listo."
}

# ── .claude/settings.json: activa plugin + permisos (fusiona, no pisa) ──
configure_project_settings() {
  step "Configurando .claude/settings.json..."
  mkdir -p .claude
  LUPIO_GH="$LUPIO_GH" WANT_MARKETING="$WANT_MARKETING" MARKETING_GH="$MARKETING_GH" \
  MARKETING_MARKETPLACE="$MARKETING_MARKETPLACE" MARKETING_PLUGIN_ID="$MARKETING_PLUGIN_ID" python3 - << 'PYEOF'
import json, os, sys
p = ".claude/settings.json"
try:
    data = json.load(open(p)) if os.path.exists(p) else {}
except Exception as e:
    print(f"  ⚠  settings.json inválido, no se tocó: {e}", file=sys.stderr); sys.exit(0)

data.setdefault("extraKnownMarketplaces", {})["lupio"] = {
    "source": {"source": "github", "repo": os.environ["LUPIO_GH"]}
}
data.setdefault("enabledPlugins", {})["lupio-os@lupio"] = True
if os.environ.get("WANT_MARKETING") == "true":
    data["extraKnownMarketplaces"][os.environ["MARKETING_MARKETPLACE"]] = {
        "source": {"source": "github", "repo": os.environ["MARKETING_GH"]}
    }
    data["enabledPlugins"][os.environ["MARKETING_PLUGIN_ID"]] = True

perm = data.setdefault("permissions", {})
perm.setdefault("defaultMode", "acceptEdits")
deny = ["Bash(git commit:*)","Bash(git push:*)","Bash(git tag:*)","Bash(vercel:*)",
        "Bash(netlify deploy:*)","Bash(fly deploy:*)","Bash(flyctl deploy:*)","Bash(railway up:*)",
        "Bash(firebase deploy:*)","Bash(gcloud app deploy:*)","Bash(gcloud run deploy:*)",
        "Bash(eb deploy:*)","Bash(pm2 deploy:*)","Bash(serverless deploy:*)","Bash(npm publish:*)",
        "Bash(yarn publish:*)","Bash(gh release create:*)","Bash(gh workflow run:*)",
        "Bash(kubectl apply:*)","Read(./.env)","Read(./.env.*)",
        "mcp__git__git_commit","mcp__git__git_checkout","mcp__git__git_create_branch","mcp__git__git_reset"]
ask  = ["Bash(rm -rf:*)","Bash(rm -fr:*)","Bash(git reset --hard:*)","Bash(git clean -fd:*)",
        "Bash(git branch -D:*)","Bash(git rebase:*)","Bash(kubectl delete:*)",
        "Bash(docker rm -f:*)","Bash(docker system prune:*)"]
for key, rules in (("deny", deny), ("ask", ask)):
    cur = perm.setdefault(key, [])
    cur.extend(r for r in rules if r not in cur)

json.dump(data, open(p, "w"), indent=2)
print("  ✔  .claude/settings.json: plugin activado + permisos seguros", file=sys.stderr)
PYEOF

  if [ "${LUPIO_BYPASS:-}" = "true" ]; then
    python3 - << 'PYEOF'
import json, os, sys
p = ".claude/settings.local.json"
try:
    d = json.load(open(p)) if os.path.exists(p) else {}
except Exception as e:
    print(f"  ⚠  settings.local.json inválido, no se tocó: {e}", file=sys.stderr); sys.exit(0)
d.setdefault("permissions", {})["defaultMode"] = "bypassPermissions"
json.dump(d, open(p, "w"), indent=2)
print("  ⚠  bypassPermissions activado SOLO en esta máquina (.claude/settings.local.json)", file=sys.stderr)
PYEOF
  fi
}

# ── Instala el plugin (si Claude Code está disponible) ──
install_plugin() {
  if [ "$HAS_CLAUDE_CODE" != true ]; then return; fi
  step "Instalando plugin lupio-os..."
  claude plugin marketplace add "$LUPIO_GH" --scope project >/dev/null 2>&1 || true
  if claude plugin install "$PLUGIN_ID" --scope project >/dev/null 2>&1; then
    PLUGIN_OK=true; success "Plugin lupio-os instalado."
  else
    warn "No se pudo instalar automáticamente. Al abrir Claude Code acepta el aviso del plugin, o ejecuta: /plugin install $PLUGIN_ID"
  fi
  if [ "$WANT_MARKETING" = true ]; then
    claude plugin marketplace add "$MARKETING_GH" --scope project >/dev/null 2>&1 || true
    if claude plugin install "$MARKETING_PLUGIN_ID" --scope project >/dev/null 2>&1; then
      success "Plugin marketing-skills instalado."
    else
      warn "marketing-skills quedó declarado en settings.json; acepta el aviso al abrir Claude Code, o: /plugin install $MARKETING_PLUGIN_ID"
    fi
  fi
}

# ── MCP: solo si el proyecto no tiene uno ──
configure_mcp() {
  [ -f ".mcp.json" ] && { success ".mcp.json existente — no se toca."; return; }
  [ -f "$LUPIO_SRC/mcp/config.json" ] || return
  python3 - "$LUPIO_SRC/mcp/config.json" << 'PYEOF'
import json, shutil, sys
src = json.load(open(sys.argv[1]))
servers, skipped = {}, []
for name, cfg in src.get("mcpServers", {}).items():
    # Un servidor cuyo ejecutable no existe falla en cada arranque de Claude Code: se omite.
    if not shutil.which(cfg.get("command", "")):
        skipped.append(f"{name} (falta `{cfg.get('command')}`)")
        continue
    servers[name] = {k: v for k, v in cfg.items() if k != "description"}
json.dump({"mcpServers": servers}, open(".mcp.json", "w"), indent=2)
print("  ✔  .mcp.json creado: " + ", ".join(servers), file=sys.stderr)
if skipped:
    print("  ⚠  MCP omitidos: " + ", ".join(skipped) + ". Para git/fetch/time instala uv (https://docs.astral.sh/uv/) y reinstala.", file=sys.stderr)
PYEOF
}

configure_cursor() {
  [ "$EDITOR_CURSOR" = false ] && return
  mkdir -p .cursor
  [ -f ".cursor/rules.md" ] && { success ".cursor/rules.md existente — no se toca."; return; }
  cat > ".cursor/rules.md" << 'EOF'
# Lupio OS — Cursor AI Rules

1. Lee `.lupio/context/project.md` al iniciar cada sesión.
2. Lee `.lupio/context/decisions.md` antes de sugerir arquitectura.
3. Revisa `.lupio/core/` antes de crear un módulo backend nuevo.
4. Sigue los patrones de `.lupio/templates/`.
5. Guarda salidas en `.lupio/memory/`.
6. Lecturas dirigidas: máximo 10 archivos por tarea.
EOF
  success "Creado .cursor/rules.md"
}

configure_vscode() {
  [ "$EDITOR_VSCODE" = false ] && return
  mkdir -p .vscode
  python3 - << 'PYEOF'
import json, os, sys
p = ".vscode/settings.json"
try:
    d = json.load(open(p)) if os.path.exists(p) else {}
except Exception:
    print("  ⚠  .vscode/settings.json con comentarios — no se tocó", file=sys.stderr); sys.exit(0)
ex = d.setdefault("search.exclude", {})
ex.update({"**/.lupio/core": True, "**/.lupio/templates": True, "**/.lupio/checkpoints": True})
json.dump(d, open(p, "w"), indent=2)
print("  ✔  .vscode/settings.json actualizado", file=sys.stderr)
PYEOF
}

generate_claude_md() {
  [ -f "$LUPIO_SRC/claude/CLAUDE.template.md" ] || return
  if [ -f "CLAUDE.md" ]; then
    cp "$LUPIO_SRC/claude/CLAUDE.template.md" "$LUPIO_DIR/CLAUDE.lupio.md"
    if grep -qE '\.lupio/(agents|commands)/' CLAUDE.md 2>/dev/null; then
      STALE_CLAUDE_MD=true
      warn "Tu CLAUDE.md es de v1 y apunta a .lupio/agents|commands, que ya no existen."
      warn "Refréscalo (muestra el diff y pide confirmación):  bash .lupio/scripts/apply-update.sh --refresh-claude-md"
    else
      warn "CLAUDE.md ya existe — la versión Lupio quedó en .lupio/CLAUDE.lupio.md (fusiónala a mano)."
    fi
  else
    cp "$LUPIO_SRC/claude/CLAUDE.template.md" "CLAUDE.md"
    success "Creado CLAUDE.md"
  fi
}

# Sin esto check-updates.sh no sabe qué versión hay y pide actualizar en la primera sesión.
write_version_file() {
  local sha; sha=$(git -C "$LUPIO_SRC" rev-parse --short HEAD 2>/dev/null || true)
  VERSION_FILE="$LUPIO_DIR/context/version.json" V="$LUPIO_VERSION" SHA="$sha" python3 - << 'PYEOF'
import json, os, time
path = os.environ["VERSION_FILE"]
try:
    data = json.load(open(path))
except Exception:
    data = {}
data.pop("latest_sha", None)
data.update({"version": os.environ["V"], "latest_version": os.environ["V"], "sha": os.environ["SHA"],
             "last_updated": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
             "last_checked": int(time.time())})
json.dump(data, open(path, "w"), indent=2)
PYEOF
}

init_project_context() {
  local name; name=$(basename "$(pwd)")
  if [ ! -f "$LUPIO_DIR/context/project.md" ]; then
    cat > "$LUPIO_DIR/context/project.md" << EOF
# Project Context

**Name:** $name
**Initialized:** $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Lupio OS Version:** $LUPIO_VERSION

## Tech Stack
<!-- Completar tras /generate-architecture -->

## Current Phase
discovery

## Last Completed Task
none
EOF
  fi
  [ -f "$LUPIO_DIR/context/decisions.md" ] || \
    printf '# Decision Log\n\nFormat: `## DECISION-001: <title>`\n\n- **Date:**\n- **Decision:**\n- **Rationale:**\n- **Impact:**\n' > "$LUPIO_DIR/context/decisions.md"
  if [ ! -f "$LUPIO_DIR/context/servers.md" ] && [ -f "$LUPIO_SRC/claude/prompts/servers-template.md" ]; then
    sed "s/\[Project Name\]/$name/" "$LUPIO_SRC/claude/prompts/servers-template.md" > "$LUPIO_DIR/context/servers.md"
  fi
  write_version_file
  success "Contexto del proyecto listo."
}

print_summary() {
  echo ""; hr
  echo -e "${GREEN}  ✔  Lupio OS v${LUPIO_VERSION} listo en $(pwd)${NC}"; hr; echo ""
  echo "  Siguiente:"
  echo "    1. Abre Claude Code en esta carpeta:  claude"
  if [ "$PLUGIN_OK" = true ]; then
    echo "    2. Verifica:  /plugin  y  /agents   (debe aparecer lupio-os)"
  else
    echo "    2. Acepta el aviso para instalar 'lupio-os' (o: /plugin install $PLUGIN_ID)"
  fi
  [ "$STALE_CLAUDE_MD" = true ] && echo "    !  Refresca tu CLAUDE.md v1:  bash .lupio/scripts/apply-update.sh --refresh-claude-md"
  echo "    3. Haz commit de: CLAUDE.md, .claude/settings.json, .lupio/ (lo que no esté en .gitignore)"
  echo ""
  echo -e "  ${CYAN}Actualizar framework:${NC} automático (activa auto-update una vez en /plugin › Marketplaces)"
  echo -e "  ${CYAN}Actualizar .lupio/:${NC}   bash .lupio/scripts/apply-update.sh"
  echo ""
}

main() {
  print_banner
  check_requirements
  detect_editors
  confirm_installation
  ask_marketing
  check_claude_code
  download_lupio
  mkdir -p "$LUPIO_DIR/checkpoints"
  migrate_v1
  install_lupio_dir
  configure_project_settings
  install_plugin
  configure_mcp
  configure_cursor
  configure_vscode
  generate_claude_md
  init_project_context
  print_summary
}

main "$@"
