#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Lupio OS Installer v1.1.0
# Interactive, safe, editor-aware
# ============================================================

LUPIO_REPO="https://github.com/lupiodev/Lupio-os"
LUPIO_BRANCH="main"
LUPIO_DIR=".lupio"
LUPIO_VERSION="1.1.0"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

success() { echo -e "${GREEN}  ✔${NC}  $1" >&2; }
warn()    { echo -e "${YELLOW}  ⚠${NC}  $1" >&2; }
error()   { echo -e "${RED}  ✖  $1${NC}" >&2; exit 1; }
info()    { echo -e "  ${CYAN}$1${NC}" >&2; }
step()    { echo -e "${BLUE}  →${NC}  $1" >&2; }
hr()      { echo -e "  ${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

# Global vars — set by functions, consumed in main
LUPIO_SRC=""
EDITOR_CURSOR=false
EDITOR_VSCODE=false
HAS_CLAUDE_CODE=false

# ── Banner ────────────────────────────────────────────────────
print_banner() {
  echo ""
  echo -e "${BLUE}  ██╗     ██╗   ██╗██████╗ ██╗ ██████╗      ██████╗ ███████╗${NC}"
  echo -e "${BLUE}  ██║     ██║   ██║██╔══██╗██║██╔═══██╗    ██╔═══██╗██╔════╝${NC}"
  echo -e "${BLUE}  ██║     ██║   ██║██████╔╝██║██║   ██║    ██║   ██║███████╗${NC}"
  echo -e "${BLUE}  ██║     ██║   ██║██╔═══╝ ██║██║   ██║    ██║   ██║╚════██║${NC}"
  echo -e "${BLUE}  ███████╗╚██████╔╝██║     ██║╚██████╔╝    ╚██████╔╝███████║${NC}"
  echo -e "${BLUE}  ╚══════╝ ╚═════╝ ╚═╝     ╚═╝ ╚═════╝      ╚═════╝ ╚══════╝${NC}"
  echo ""
  echo -e "  ${YELLOW}AI Development Operating System — v${LUPIO_VERSION}${NC}"
  echo ""
  hr
  echo ""
}

# ── Requirements ──────────────────────────────────────────────
check_requirements() {
  command -v git  >/dev/null 2>&1 || error "git is required but not installed."
  command -v curl >/dev/null 2>&1 || error "curl is required but not installed."
}

# ── Detect editors and tools ──────────────────────────────────
detect_editors() {
  # Cursor
  if command -v cursor >/dev/null 2>&1 \
    || [ -d "$HOME/.cursor" ] \
    || [ -d "/Applications/Cursor.app" ] \
    || [ -f "$HOME/Library/Application Support/Cursor/storage.json" ]; then
    EDITOR_CURSOR=true
  fi

  # VS Code
  if command -v code >/dev/null 2>&1 \
    || [ -d "$HOME/.vscode" ] \
    || [ -d "/Applications/Visual Studio Code.app" ] \
    || [ -f "$HOME/Library/Application Support/Code/storage.json" ]; then
    EDITOR_VSCODE=true
  fi

  # Claude Code CLI
  if command -v claude >/dev/null 2>&1; then
    HAS_CLAUDE_CODE=true
  fi
}

# ── Interactive confirmation ──────────────────────────────────
confirm_installation() {
  local project_dir
  project_dir="$(pwd)"

  echo -e "  ${BOLD}Detected project directory:${NC}"
  echo -e "  ${GREEN}${project_dir}${NC}"
  echo ""

  echo -e "  ${BOLD}Detected editors:${NC}"
  if [ "$EDITOR_CURSOR" = true ]; then
    echo -e "  ${GREEN}✔${NC}  Cursor"
  else
    echo -e "  ${YELLOW}–${NC}  Cursor (not detected)"
  fi
  if [ "$EDITOR_VSCODE" = true ]; then
    echo -e "  ${GREEN}✔${NC}  VS Code"
  else
    echo -e "  ${YELLOW}–${NC}  VS Code (not detected)"
  fi
  echo ""

  echo -e "  ${BOLD}The following folders will be installed:${NC}"
  echo ""
  echo -e "  ${CYAN}.lupio/${NC}"
  echo -e "  ${CYAN}.lupio/agents/${NC}          13 AI agent definitions"
  echo -e "  ${CYAN}.lupio/commands/${NC}         13 executable commands"
  echo -e "  ${CYAN}.lupio/workflows/${NC}        9 development workflows"
  echo -e "  ${CYAN}.lupio/context/${NC}          project context (preserved if exists)"
  echo -e "  ${CYAN}.lupio/memory/${NC}           agent memory (preserved if exists)"
  if [ "$EDITOR_CURSOR" = true ]; then
    echo -e "  ${CYAN}.cursor/${NC}               Cursor AI operating rules"
  fi
  if [ "$EDITOR_VSCODE" = true ]; then
    echo -e "  ${CYAN}.vscode/${NC}               VS Code settings (merged, not overwritten)"
  fi
  echo ""

  if [ -d "$LUPIO_DIR" ]; then
    warn ".lupio/ already exists — only missing files will be added."
    echo ""
  fi

  hr
  echo ""

  # Skip prompt if --yes flag passed (for CI or scripted use)
  if [ "${LUPIO_YES:-}" = "true" ]; then
    echo -e "  ${CYAN}--yes flag detected, proceeding automatically.${NC}"
    echo ""
    return
  fi

  # Use /dev/tty so this works when script is piped via bash <(curl ...)
  printf "  Continue installation? (y/n): "
  local answer
  if read -r answer < /dev/tty 2>/dev/null; then
    :
  else
    # /dev/tty not available (non-interactive environment) — require explicit --yes
    echo ""
    warn "Non-interactive environment detected."
    info "To install without prompts, run:  LUPIO_YES=true bash install.sh"
    echo ""
    exit 1
  fi

  if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "  ${YELLOW}Installation cancelled. No files were modified.${NC}"
    echo ""
    exit 0
  fi

  echo ""
}

# ── Claude Code install prompt ────────────────────────────────
check_claude_code() {
  if [ "$HAS_CLAUDE_CODE" = true ]; then
    success "Claude Code CLI detected."
    return
  fi

  echo ""
  warn "Claude Code not detected."
  echo ""
  printf "  Install Claude Code now? (y/n): "
  local answer
  read -r answer < /dev/tty 2>/dev/null || answer="n"

  if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo ""
    if command -v npm >/dev/null 2>&1; then
      step "Installing Claude Code via npm..."
      npm install -g @anthropic-ai/claude-code 2>&1 \
        && success "Claude Code installed." \
        || warn "Could not auto-install. Run: npm install -g @anthropic-ai/claude-code"
    else
      warn "npm not found. Install Node.js 18+ then run: npm install -g @anthropic-ai/claude-code"
    fi
  else
    info "Skipping. Install later: npm install -g @anthropic-ai/claude-code"
  fi
  echo ""
}

# ── Download lupio-os from GitHub ─────────────────────────────
download_lupio() {
  step "Downloading Lupio OS v${LUPIO_VERSION}..."
  local tmp_base
  tmp_base=$(mktemp -d)
  local tmp_dir="$tmp_base/lupio-os"

  if git clone --depth=1 --branch "$LUPIO_BRANCH" "$LUPIO_REPO" "$tmp_dir" >/dev/null 2>&1; then
    success "Downloaded from GitHub."
    LUPIO_SRC="$tmp_dir"
  else
    error "Could not clone from GitHub: $LUPIO_REPO\nCheck your internet connection and try again."
  fi
}

# ── Create .lupio structure (safe) ────────────────────────────
create_lupio_dir() {
  step "Setting up .lupio/ directory..."

  for dir in agents commands memory context workflows scripts templates core; do
    mkdir -p "$LUPIO_DIR/$dir"
  done

  if [ ! -f "$LUPIO_DIR/.gitignore" ]; then
    printf 'memory/\ncontext/\n*.local.md\n' > "$LUPIO_DIR/.gitignore"
  fi

  success "Directory structure ready."
}

# ── Install system files (agents, commands, workflows) ────────
install_agents() {
  local src="$1"
  if [ -d "$src/claude/agents" ]; then
    cp -r "$src/claude/agents/." "$LUPIO_DIR/agents/"
    local count
    count=$(ls "$LUPIO_DIR/agents/"*.md 2>/dev/null | wc -l | tr -d ' ')
    success "Installed $count agents."
  else
    warn "Agents source not found."
  fi
}

install_commands() {
  local src="$1"
  if [ -d "$src/claude/commands" ]; then
    cp -r "$src/claude/commands/." "$LUPIO_DIR/commands/"
    local count
    count=$(ls "$LUPIO_DIR/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
    success "Installed $count commands."
  else
    warn "Commands source not found."
  fi
}

install_workflows() {
  local src="$1"
  if [ -d "$src/claude/workflows" ]; then
    cp -r "$src/claude/workflows/." "$LUPIO_DIR/workflows/"
    local count
    count=$(ls "$LUPIO_DIR/workflows/"*.md 2>/dev/null | wc -l | tr -d ' ')
    success "Installed $count workflows."
  fi
}

install_scripts() {
  local src="$1"
  if [ -d "$src/scripts" ]; then
    cp -r "$src/scripts/." "$LUPIO_DIR/scripts/"
    chmod +x "$LUPIO_DIR/scripts/"*.sh 2>/dev/null || true
    success "Scripts installed."
  fi
}

# ── Configure MCP ─────────────────────────────────────────────
configure_mcp() {
  local src="$1"
  if [ -f "$src/mcp/config.json" ]; then
    if [ -f ".mcp.json" ]; then
      warn ".mcp.json already exists — backed up to .mcp.json.bak"
      cp ".mcp.json" ".mcp.json.bak"
    fi
    cp "$src/mcp/config.json" ".mcp.json"
    success "MCP configuration installed."
  fi
}

# ── Copy templates and core modules ───────────────────────────
copy_templates_and_core() {
  local src="$1"
  [ -d "$src/templates" ] && cp -r "$src/templates/." "$LUPIO_DIR/templates/"
  [ -d "$src/core" ]      && cp -r "$src/core/." "$LUPIO_DIR/core/"
  success "Templates and core modules installed."
}

# ── Configure Cursor (.cursor/rules.md) ───────────────────────
configure_cursor() {
  [ "$EDITOR_CURSOR" = false ] && return

  step "Configuring Cursor..."
  mkdir -p ".cursor"

  if [ ! -f ".cursor/rules.md" ]; then
    cat > ".cursor/rules.md" << 'EOF'
# Lupio OS — Cursor AI Rules

This project runs on **Lupio OS**, an AI development operating system.

## Rules for AI assistants in Cursor

1. Read `.lupio/context/project.md` at the start of every session.
2. Read `.lupio/context/decisions.md` before making any architectural suggestion.
3. Check `.lupio/core/` before creating a new backend module.
4. Follow patterns in `.lupio/templates/` for consistency.
5. Write outputs to `.lupio/memory/` for persistence across sessions.
6. Never load the full repository — use targeted file reads only.
7. Max 10 files loaded per task.

## Key files

| File | Purpose |
|------|---------|
| `.lupio/context/project.md` | Tech stack and current phase |
| `.lupio/context/decisions.md` | All architectural decisions |
| `.lupio/agents/orchestrator.md` | Task routing guide |
| `.lupio/workflows/` | Step-by-step phase workflows |
| `.lupio/memory/scope.md` | Product scope |
| `.lupio/memory/architecture.md` | System architecture |
EOF
    success "Created .cursor/rules.md"
  else
    success ".cursor/rules.md already exists — skipped."
  fi
}

# ── Configure VS Code (.vscode/settings.json) ─────────────────
configure_vscode() {
  [ "$EDITOR_VSCODE" = false ] && return

  step "Configuring VS Code..."
  mkdir -p ".vscode"

  if [ ! -f ".vscode/settings.json" ]; then
    cat > ".vscode/settings.json" << 'EOF'
{
  "// lupio-os": "Settings managed by Lupio OS — do not remove this line",
  "search.exclude": {
    "**/node_modules": true,
    "**/.git": true,
    "**/.lupio/core": true,
    "**/.lupio/templates": true
  },
  "editor.formatOnSave": true
}
EOF
    success "Created .vscode/settings.json"
  else
    if ! grep -q "lupio-os" ".vscode/settings.json" 2>/dev/null; then
      if command -v python3 >/dev/null 2>&1; then
        python3 - << 'PYEOF'
import json, sys
try:
    with open('.vscode/settings.json', 'r') as f:
        settings = json.loads(f.read())
    settings['// lupio-os'] = 'Settings merged by Lupio OS'
    excl = settings.get('search.exclude', {})
    excl.update({'**/.lupio/core': True, '**/.lupio/templates': True})
    settings['search.exclude'] = excl
    with open('.vscode/settings.json', 'w') as f:
        json.dump(settings, f, indent=2)
    print('  ✔  Merged Lupio OS entries into .vscode/settings.json', file=sys.stderr)
except Exception as e:
    print(f'  ⚠  Could not merge .vscode/settings.json: {e}', file=sys.stderr)
PYEOF
      else
        warn ".vscode/settings.json exists — skipped merge (python3 not available)"
      fi
    else
      success ".vscode/settings.json already configured — skipped."
    fi
  fi
}

# ── Generate CLAUDE.md (safe — skip if exists) ────────────────
generate_claude_md() {
  step "Generating CLAUDE.md..."

  local claude_target
  if [ -f "CLAUDE.md" ]; then
    warn "CLAUDE.md already exists — writing to .lupio/CLAUDE.lupio.md instead."
    claude_target=".lupio/CLAUDE.lupio.md"
  else
    claude_target="CLAUDE.md"
  fi

  cat > "$claude_target" << 'CLAUDEEOF'
# Lupio OS

All system files live in `.lupio/`. Read `.lupio/context/project.md` before any task.

## Session Start

Run once, silently: `bash .lupio/scripts/check-updates.sh 2>/dev/null`

If output = `UPDATE_AVAILABLE`, ask:
> 🔄 **Nueva versión de Lupio OS disponible.** ¿Actualizar ahora? (sí/no)
- sí → `bash .lupio/scripts/apply-update.sh`
- no → continue

## Rules

1. Read `context/project.md` first
2. Load only files needed for the current task (max 10)
3. Delegate to agents — never implement everything yourself
4. Write all outputs to `memory/` or project folders, not to conversation
5. Load `memory/architecture.md` SUMMARY section only (first 30 lines)
6. Load `context/decisions.md` first 30 lines only

## Auto-Learning

Trigger after: 3+ modules built, bug fixed and working, full feature done, or user says "perfecto/listo/done/works".

Check if `memory/prompt-changelog.md` has new entries. If yes, ask:
> 💡 **Lupio OS aprendió algo nuevo.** ¿Actualizo automáticamente? (sí/no)
- sí → `bash .lupio/scripts/auto-contribute.sh`
- no → skip, don't ask again this session

## Locations

- Agents: `.lupio/agents/<name>.md`
- Commands: `.lupio/commands/<name>.md`
- Workflows: `.lupio/workflows/<name>.md`
- Core modules: `.lupio/core/<module>/module.md`
- Context: `.lupio/context/project.md`, `decisions.md`
- Memory: `.lupio/memory/`
CLAUDEEOF

  success "Generated $claude_target"
}

# ── Initialize project context (safe) ─────────────────────────
init_project_context() {
  step "Initializing project context..."
  local project_name
  project_name=$(basename "$(pwd)")

  if [ ! -f "$LUPIO_DIR/context/project.md" ]; then
    cat > "$LUPIO_DIR/context/project.md" << EOF
# Project Context

**Name:** $project_name
**Initialized:** $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Lupio OS Version:** $LUPIO_VERSION

## Tech Stack
<!-- Fill in after running /generate-architecture -->

## Current Phase
discovery

## Last Completed Task
none

## Active Sprint / Focus
initial setup
EOF
    success "Created project.md"
  else
    success "project.md already exists — skipped."
  fi

  if [ ! -f "$LUPIO_DIR/context/decisions.md" ]; then
    printf '# Decision Log\n\nFormat: `## DECISION-001: <title>`\n\n- **Date:**\n- **Decision:**\n- **Rationale:**\n- **Impact:**\n' \
      > "$LUPIO_DIR/context/decisions.md"
    success "Created decisions.md"
  else
    success "decisions.md already exists — skipped."
  fi
}

# ── Print summary ─────────────────────────────────────────────
print_summary() {
  local project_dir
  project_dir="$(pwd)"

  echo ""
  echo -e "${GREEN}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}  ✔  Lupio OS v${LUPIO_VERSION} installed successfully!${NC}"
  echo -e "${GREEN}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "  Installed to: ${GREEN}${project_dir}/.lupio/${NC}"
  echo ""
  echo "  Next steps:"
  if [ "$EDITOR_VSCODE" = true ]; then
    echo "    1. Open this folder in VS Code"
    echo "    2. Start Claude Code  (Cmd+Shift+P → Claude Code)"
  elif [ "$EDITOR_CURSOR" = true ]; then
    echo "    1. Open this folder in Cursor"
    echo "    2. Start a new AI chat and describe your project"
  else
    echo "    1. Open this folder in your editor"
    echo "    2. Start Claude Code"
  fi
  echo "    3. Claude will read CLAUDE.md and greet you"
  echo ""
  echo -e "  Update Lupio OS: ${CYAN}bash .lupio/scripts/apply-update.sh${NC}"
  echo ""
  echo -e "  ${BLUE}  Docs: https://github.com/lupiodev/Lupio-os${NC}"
  echo ""
}

# ── Main ──────────────────────────────────────────────────────
main() {
  print_banner
  check_requirements
  detect_editors
  confirm_installation
  check_claude_code
  download_lupio
  create_lupio_dir
  install_scripts "$LUPIO_SRC"
  install_agents "$LUPIO_SRC"
  install_commands "$LUPIO_SRC"
  install_workflows "$LUPIO_SRC"
  configure_mcp "$LUPIO_SRC"
  copy_templates_and_core "$LUPIO_SRC"
  configure_cursor
  configure_vscode
  generate_claude_md
  init_project_context
  print_summary
}

main "$@"
