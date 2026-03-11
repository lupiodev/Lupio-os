#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Lupio OS — Auto Contribute (Direct Push)
# Saves learnings and pushes directly to main.
# No PR, no review — fully automatic when user says "sí".
# ============================================================

LUPIO_DIR=".lupio"
DATE=$(date +%Y-%m-%d)
PROJECT_NAME=$(basename "$(pwd)")
LUPIO_REPO="https://github.com/lupiodev/Lupio-os.git"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()    { echo -e "${BLUE}[lupio]${NC} $1"; }
success(){ echo -e "${GREEN}[lupio]${NC} $1"; }
warn()   { echo -e "${YELLOW}[lupio]${NC} $1"; }
error()  { echo -e "${RED}[lupio]${NC} $1"; exit 1; }

# ── Validate ──────────────────────────────────────────────────
[ -d "$LUPIO_DIR" ] || error ".lupio/ not found."

# Check for gh token or GH_TOKEN env var
if [ -n "${GH_TOKEN:-}" ]; then
  AUTH_HEADER="Authorization: token $GH_TOKEN"
elif gh auth status >/dev/null 2>&1; then
  GH_TOKEN=$(gh auth token 2>/dev/null || echo "")
  AUTH_HEADER="Authorization: token $GH_TOKEN"
else
  # Try reading stored token from gh config
  GH_TOKEN=$(cat ~/.config/gh/hosts.yml 2>/dev/null | grep 'oauth_token' | awk '{print $2}' | head -1 || echo "")
  if [ -z "$GH_TOKEN" ]; then
    error "No GitHub auth found. Run: gh auth login"
  fi
  AUTH_HEADER="Authorization: token $GH_TOKEN"
fi

# ── Check for content to contribute ──────────────────────────
HAS_CONTENT=false
[ -f "$LUPIO_DIR/memory/prompt-changelog.md" ]    && HAS_CONTENT=true
[ -f "$LUPIO_DIR/memory/reusable-candidates.md" ] && HAS_CONTENT=true
ls "$LUPIO_DIR/memory/postmortem-"*.md 2>/dev/null | head -1 | grep -q . && HAS_CONTENT=true

if [ "$HAS_CONTENT" = false ]; then
  warn "Nada que contribuir aún. Usa /save-lessons primero en Claude Code."
  exit 0
fi

# ── Clone and push directly to main ──────────────────────────
log "Aplicando aprendizajes a Lupio OS..."

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

ORIG_DIR="$(pwd)"

# Clone with token embedded in URL for auth
REPO_URL="https://${GH_TOKEN}@github.com/lupiodev/Lupio-os.git"
git clone --depth=1 "$REPO_URL" "$TMP_DIR" 2>/dev/null \
  || error "No se pudo clonar el repositorio. Verifica tu conexión."

# Copy learnings
DEST="$TMP_DIR/learnings/${DATE}-${PROJECT_NAME}"
mkdir -p "$DEST"

[ -f "$ORIG_DIR/$LUPIO_DIR/memory/prompt-changelog.md" ] \
  && cp "$ORIG_DIR/$LUPIO_DIR/memory/prompt-changelog.md" "$DEST/"

[ -f "$ORIG_DIR/$LUPIO_DIR/memory/reusable-candidates.md" ] \
  && cp "$ORIG_DIR/$LUPIO_DIR/memory/reusable-candidates.md" "$DEST/"

LATEST_PM=$(ls "$ORIG_DIR/$LUPIO_DIR/memory/postmortem-"*.md 2>/dev/null | tail -1 || echo "")
[ -n "$LATEST_PM" ] && cp "$LATEST_PM" "$DEST/postmortem.md"

# Write meta
cat > "$DEST/meta.md" << EOF
# Learning Contribution

**Project:** ${PROJECT_NAME}
**Date:** ${DATE}
**Auto-contributed:** yes
EOF

# Update learning history
cat >> "$TMP_DIR/LEARNING_HISTORY.md" << EOF

## ${DATE} — ${PROJECT_NAME}
$([ -f "$DEST/prompt-changelog.md" ]    && echo "- prompt-changelog.md")
$([ -f "$DEST/reusable-candidates.md" ] && echo "- reusable-candidates.md")
$([ -f "$DEST/postmortem.md" ]          && echo "- postmortem.md")
EOF

# Commit and push directly to main
cd "$TMP_DIR"
git config user.name "lupio-learning-bot"
git config user.email "bot@lupio-os"
git add .
git commit -m "learn: ${PROJECT_NAME} (${DATE})" --quiet
git push origin main --quiet 2>/dev/null \
  || error "No se pudo hacer push. Verifica que el token tiene permisos de escritura en el repo."

cd "$ORIG_DIR"

# Mark as contributed locally
cat >> "$LUPIO_DIR/memory/contributions.md" << EOF

## ${DATE} — ${PROJECT_NAME}
- **Status:** pushed to main ✓
- **Files:** $(ls "$DEST" | tr '\n' ' ')
EOF

# Done
echo ""
success "¡Lupio OS actualizado!"
echo ""
echo "  Los aprendizajes de '${PROJECT_NAME}' ya están en main."
echo "  Cualquier proyecto puede recibirlos con:"
echo ""
echo "    npx lupio-os update"
echo ""
