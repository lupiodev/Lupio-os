#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Lupio OS Installer
# ============================================================

LUPIO_REPO="https://github.com/lupiodev/Lupio-os"
LUPIO_BRANCH="main"
LUPIO_DIR=".lupio"
LUPIO_VERSION="1.0.0"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()    { echo -e "${BLUE}[lupio]${NC} $1" >&2; }
success(){ echo -e "${GREEN}[lupio]${NC} $1" >&2; }
warn()   { echo -e "${YELLOW}[lupio]${NC} $1" >&2; }
error()  { echo -e "${RED}[lupio]${NC} $1" >&2; exit 1; }

# ── Check requirements ────────────────────────────────────────
check_requirements() {
  log "Checking requirements..."
  command -v git  >/dev/null 2>&1 || error "git is required but not installed."
  command -v curl >/dev/null 2>&1 || error "curl is required but not installed."
  success "Requirements satisfied."
}

# Global var to avoid stdout-capture issues when running via bash <(curl ...)
LUPIO_SRC=""

# ── Download latest lupio-os ──────────────────────────────────
download_lupio() {
  log "Downloading Lupio OS v${LUPIO_VERSION}..."
  local tmp_base
  tmp_base=$(mktemp -d)
  local tmp_dir="$tmp_base/lupio-os"

  if git clone --depth=1 --branch "$LUPIO_BRANCH" "$LUPIO_REPO" "$tmp_dir" >/dev/null 2>&1; then
    success "Downloaded from GitHub."
    LUPIO_SRC="$tmp_dir"
  else
    error "Could not clone from GitHub: $LUPIO_REPO. Check your internet connection."
  fi
}

# ── Create .lupio directory structure ────────────────────────
create_lupio_dir() {
  log "Creating .lupio directory..."

  mkdir -p "$LUPIO_DIR"/{agents,commands,memory,context,workflows}

  # Create .gitignore for memory and context (project-specific, not committed)
  cat > "$LUPIO_DIR/.gitignore" << 'EOF'
memory/
context/
*.local.md
EOF

  success "Created .lupio/ directory structure."
}

# ── Install scripts ───────────────────────────────────────────
install_scripts() {
  local src="$1"
  log "Installing Lupio OS scripts..."

  mkdir -p "$LUPIO_DIR/scripts"
  if [ -d "$src/scripts" ]; then
    cp -r "$src/scripts/." "$LUPIO_DIR/scripts/"
    chmod +x "$LUPIO_DIR/scripts/"*.sh 2>/dev/null || true
    success "Scripts installed."
  fi
}

# ── Install agents ────────────────────────────────────────────
install_agents() {
  local src="$1"
  log "Installing AI agents..."

  if [ -d "$src/claude/agents" ]; then
    cp -r "$src/claude/agents/." "$LUPIO_DIR/agents/"
    count=$(ls "$LUPIO_DIR/agents/"*.md 2>/dev/null | wc -l | tr -d ' ')
    success "Installed $count agents."
  else
    warn "Agent source not found, skipping."
  fi
}

# ── Install commands ──────────────────────────────────────────
install_commands() {
  local src="$1"
  log "Installing commands..."

  if [ -d "$src/claude/commands" ]; then
    cp -r "$src/claude/commands/." "$LUPIO_DIR/commands/"
    count=$(ls "$LUPIO_DIR/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')
    success "Installed $count commands."
  else
    warn "Commands source not found, skipping."
  fi
}

# ── Install workflows ─────────────────────────────────────────
install_workflows() {
  local src="$1"
  log "Installing workflows..."

  if [ -d "$src/claude/workflows" ]; then
    cp -r "$src/claude/workflows/." "$LUPIO_DIR/workflows/"
    success "Installed workflows."
  fi
}

# ── Configure MCP ─────────────────────────────────────────────
configure_mcp() {
  local src="$1"
  log "Configuring MCP..."

  # Install MCP config to project root .mcp.json
  if [ -f "$src/mcp/config.json" ]; then
    if [ -f ".mcp.json" ]; then
      warn ".mcp.json already exists. Backing up to .mcp.json.bak"
      cp ".mcp.json" ".mcp.json.bak"
    fi
    cp "$src/mcp/config.json" ".mcp.json"
    success "MCP configuration installed."
  fi
}

# ── Copy project templates ────────────────────────────────────
copy_templates() {
  local src="$1"
  log "Copying project templates..."

  mkdir -p "$LUPIO_DIR/templates"
  if [ -d "$src/templates" ]; then
    cp -r "$src/templates/." "$LUPIO_DIR/templates/"
    success "Project templates installed."
  fi
}

# ── Install backend core modules ──────────────────────────────
install_core_modules() {
  local src="$1"
  log "Installing backend core modules..."

  mkdir -p "$LUPIO_DIR/core"
  if [ -d "$src/core" ]; then
    cp -r "$src/core/." "$LUPIO_DIR/core/"
    success "Backend core modules installed."
  fi
}

# ── Generate CLAUDE.md ────────────────────────────────────────
generate_claude_md() {
  log "Generating CLAUDE.md..."

  if [ -f "CLAUDE.md" ]; then
    warn "CLAUDE.md already exists. Creating .lupio/CLAUDE.lupio.md instead."
    CLAUDE_TARGET=".lupio/CLAUDE.lupio.md"
  else
    CLAUDE_TARGET="CLAUDE.md"
  fi

  cat > "$CLAUDE_TARGET" << 'CLAUDEEOF'
# Lupio OS — Claude Code Operating Instructions

This project uses Lupio OS. Read this file before taking any action.

## System Overview

You are operating within Lupio OS, an AI development orchestration system.
All agents, commands, and context files live in `.lupio/`.

## Startup Check (CRITICAL — run at the start of EVERY session)

At the very beginning of each conversation, before doing anything else, you MUST:

1. Run this command silently: `bash .lupio/scripts/check-updates.sh 2>/dev/null`
2. If the output contains `UPDATE_AVAILABLE`:
   - Immediately ask the user (copy exactly):

---
🔄 **Hay una nueva versión de Lupio OS disponible.**

Se detectaron mejoras en agentes, comandos y templates desde la última vez.
¿Quieres actualizar ahora? Solo toma unos segundos y no afecta tu proyecto.

Responde **sí** para actualizar, o **no** para continuar con la versión actual.

---

   - If user says **sí / yes / dale / ok / claro** → run: `bash .lupio/scripts/apply-update.sh`
   - If user says **no / skip / después** → continue without updating
3. If output is `UP_TO_DATE` → continue silently, do not mention it

**Do this check once per session only. Never ask twice.**

## Core Rules

1. **Load context minimally** — only load files relevant to the current task
2. **Write results to disk** — save all outputs to `.lupio/memory/` or the appropriate project folder
3. **Use defined agents** — delegate to the correct agent rather than doing everything yourself
4. **Follow command definitions** — when a user runs a command, follow the spec in `.lupio/commands/`
5. **Never ingest the full repository** — use targeted file reads only

## Auto-Learning Rule (CRITICAL — always follow)

After every significant block of work in this session, you MUST check the auto-learning trigger.

**Trigger conditions — check after completing ANY of these:**
- Generated or reviewed 3+ modules/features
- Fixed a bug that was validated as working
- Built a complete feature end-to-end
- Used a pattern not yet in `.lupio/templates/`
- The user said something like "perfecto", "listo", "great", "works", "done"

**When triggered:**
1. Check if `.lupio/memory/prompt-changelog.md` or `.lupio/memory/reusable-candidates.md` exist
2. If yes — ask the user this exact message (copy it exactly):

---
💡 **Lupio OS aprendió algo nuevo en esta sesión.**

Encontré patrones que mejorarían Lupio OS para futuros proyectos:
- [list 2-3 specific things learned this session]

¿Quieres que actualice Lupio OS automáticamente? Lo haré todo solo.

Responde **sí** para hacerlo ahora, o **no** para ignorarlo.

---

3. If user says **sí / yes / dale / ok / do it / claro** → run: `npx lupio-os contribute`
4. If user says **no / skip / después / later** → acknowledge and do NOT ask again this session

**Do not wait for the user to ask. Do not require any command. Just ask proactively.**

## Available Agents

Load an agent by reading its definition from `.lupio/agents/<name>.md`

| Agent | File |
|-------|------|
| Orchestrator | `.lupio/agents/orchestrator.md` |
| Product Discovery | `.lupio/agents/product-discovery.md` |
| Solution Architect | `.lupio/agents/solution-architect.md` |
| UX Reviewer | `.lupio/agents/ux-reviewer.md` |
| UI Reviewer | `.lupio/agents/ui-reviewer.md` |
| Frontend Lead | `.lupio/agents/frontend-lead.md` |
| Backend Lead | `.lupio/agents/backend-lead.md` |
| QA Lead | `.lupio/agents/qa-lead.md` |
| DevOps Lead | `.lupio/agents/devops-lead.md` |
| PM Controller | `.lupio/agents/pm-controller.md` |
| Cost Estimator | `.lupio/agents/cost-estimator.md` |
| Refactor Librarian | `.lupio/agents/refactor-librarian.md` |
| Learning Agent | `.lupio/agents/learning-agent.md` |

## Available Commands

Run a command by telling Claude: "Run /command-name"

| Command | Description |
|---------|-------------|
| `/bootstrap-project` | Scaffold a new project |
| `/generate-scope` | Create scope document |
| `/generate-architecture` | Design system architecture |
| `/generate-backend-module` | Generate a backend module |
| `/generate-frontend-module` | Generate a frontend module |
| `/generate-tests` | Create test suite |
| `/review-ux` | UX review |
| `/review-code` | Code quality review |
| `/review-qa` | QA readiness review |
| `/extract-reusable` | Extract reusable patterns |
| `/save-lessons` | Record lessons learned |
| `/update-knowledge` | Sync knowledge base |

## Memory & Context

- `.lupio/memory/` — persistent decisions, lessons, and knowledge
- `.lupio/context/` — current project state (tech stack, scope, decisions)
- Always read `.lupio/context/project.md` if it exists before starting work

## Token Optimization

- Load only files you need for the current task
- Summarize long files before passing to agents
- Write intermediate results to `.lupio/memory/` not to conversation
- Use `.lupio/context/decisions.md` as a decision summary instead of re-deriving
CLAUDEEOF

  success "Generated $CLAUDE_TARGET"
}

# ── Initialize project context ────────────────────────────────
init_project_context() {
  log "Initializing project context..."

  PROJECT_NAME=$(basename "$(pwd)")

  cat > "$LUPIO_DIR/context/project.md" << EOF
# Project Context

**Name:** $PROJECT_NAME
**Initialized:** $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Lupio OS Version:** $LUPIO_VERSION

## Tech Stack
<!-- Fill in after running /generate-architecture -->

## Key Decisions
<!-- Populated by agents during development -->

## Current Phase
discovery

## Active Agents
none
EOF

  cat > "$LUPIO_DIR/context/decisions.md" << 'EOF'
# Decision Log

Record all architectural and product decisions here.
Format: `## DECISION-001: <title>`

Each entry should include:
- **Date:**
- **Decision:**
- **Rationale:**
- **Alternatives considered:**
- **Impact:**
EOF

  success "Project context initialized."
}

# ── Print summary ─────────────────────────────────────────────
print_summary() {
  echo ""
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}  Lupio OS v${LUPIO_VERSION} installed successfully!${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo "  Installed to: $(pwd)/.lupio/"
  echo ""
  echo "  Next steps:"
  echo "    1. Open VS Code in this folder"
  echo "    2. Start Claude Code"
  echo "    3. Run: /bootstrap-project"
  echo ""
  echo -e "${BLUE}  Documentation: https://github.com/lupiodev/Lupio-os${NC}"
  echo ""
}

# ── Main ──────────────────────────────────────────────────────
main() {
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

  check_requirements

  download_lupio

  create_lupio_dir
  install_scripts "$LUPIO_SRC"
  install_agents "$LUPIO_SRC"
  install_commands "$LUPIO_SRC"
  install_workflows "$LUPIO_SRC"
  configure_mcp "$LUPIO_SRC"
  copy_templates "$LUPIO_SRC"
  install_core_modules "$LUPIO_SRC"
  generate_claude_md
  init_project_context

  print_summary
}

main "$@"
