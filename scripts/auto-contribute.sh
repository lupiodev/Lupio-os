#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Lupio OS — Auto Contribute
# Full end-to-end: save lessons + open PR in one command
# Called automatically by the Orchestrator after user says "yes"
# ============================================================

LUPIO_DIR=".lupio"
DATE=$(date +%Y-%m-%d)
PROJECT_NAME=$(basename "$(pwd)")

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()    { echo -e "${BLUE}[lupio]${NC} $1"; }
success(){ echo -e "${GREEN}[lupio]${NC} $1"; }
warn()   { echo -e "${YELLOW}[lupio]${NC} $1"; }
error()  { echo -e "${RED}[lupio]${NC} $1"; exit 1; }

# ── Validate environment ──────────────────────────────────────
[ -d "$LUPIO_DIR" ]                     || error ".lupio/ not found."
command -v gh >/dev/null 2>&1           || error "gh CLI not found. Run: brew install gh && gh auth login"
gh auth status >/dev/null 2>&1          || error "Not authenticated with GitHub. Run: gh auth login"

# ── Check there is something to contribute ───────────────────
HAS_CONTENT=false
[ -f "$LUPIO_DIR/memory/prompt-changelog.md" ]   && HAS_CONTENT=true
[ -f "$LUPIO_DIR/memory/reusable-candidates.md" ] && HAS_CONTENT=true
ls "$LUPIO_DIR/memory/postmortem-"*.md 2>/dev/null | head -1 | grep -q . && HAS_CONTENT=true

if [ "$HAS_CONTENT" = false ]; then
  warn "Nothing to contribute yet. Use /save-lessons in Claude Code first."
  exit 0
fi

# ── Show what will be contributed ────────────────────────────
echo ""
log "Preparing contribution from project: ${PROJECT_NAME}"
echo ""
[ -f "$LUPIO_DIR/memory/prompt-changelog.md" ]   && log "  ✓ prompt-changelog.md"
[ -f "$LUPIO_DIR/memory/reusable-candidates.md" ] && log "  ✓ reusable-candidates.md"
LATEST_PM=$(ls "$LUPIO_DIR/memory/postmortem-"*.md 2>/dev/null | tail -1 || echo "")
[ -n "$LATEST_PM" ] && log "  ✓ $(basename "$LATEST_PM")"
echo ""

# ── Clone lupio-os ────────────────────────────────────────────
LUPIO_REPO="https://github.com/lupiodev/Lupio-os.git"
BRANCH="learning/${DATE}-${PROJECT_NAME}"

log "Cloning Lupio OS..."
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

GIT_TERMINAL_PROMPT=0 git clone --depth=1 "$LUPIO_REPO" "$TMP_DIR" 2>/dev/null \
  || error "Could not clone Lupio OS. Check your internet connection."

cd "$TMP_DIR"
git checkout -b "$BRANCH"

# ── Copy learnings ────────────────────────────────────────────
ORIG_DIR=$(cd - && pwd)
DEST="$TMP_DIR/learnings/${DATE}-${PROJECT_NAME}"
mkdir -p "$DEST"

[ -f "$ORIG_DIR/$LUPIO_DIR/memory/prompt-changelog.md" ] \
  && cp "$ORIG_DIR/$LUPIO_DIR/memory/prompt-changelog.md" "$DEST/"

[ -f "$ORIG_DIR/$LUPIO_DIR/memory/reusable-candidates.md" ] \
  && cp "$ORIG_DIR/$LUPIO_DIR/memory/reusable-candidates.md" "$DEST/"

[ -n "$LATEST_PM" ] \
  && cp "$LATEST_PM" "$DEST/postmortem.md"

GH_USER=$(gh api user --jq '.login' 2>/dev/null || echo "unknown")

cat > "$DEST/meta.md" << EOF
# Learning Contribution

**Project:** ${PROJECT_NAME}
**Date:** ${DATE}
**Contributed by:** ${GH_USER}
**Auto-contributed:** yes (triggered by Orchestrator)
EOF

# ── Commit and push ───────────────────────────────────────────
git add .
git commit -m "learn: ${PROJECT_NAME} (${DATE})"
git push origin "$BRANCH" 2>/dev/null

# ── Open PR ───────────────────────────────────────────────────
cd "$ORIG_DIR"

PR_URL=$(gh pr create \
  --repo lupiodev/Lupio-os \
  --head "$BRANCH" \
  --base main \
  --title "Learning: ${PROJECT_NAME} — ${DATE}" \
  --body "$(cat << EOF
## Auto-Learning Contribution

Contributed automatically by the Lupio OS Orchestrator after detecting significant progress in project \`${PROJECT_NAME}\`.

### Contents
$([ -f "$ORIG_DIR/$LUPIO_DIR/memory/prompt-changelog.md" ]   && echo "- **prompt-changelog.md** — prompt improvements discovered during development")
$([ -f "$ORIG_DIR/$LUPIO_DIR/memory/reusable-candidates.md" ] && echo "- **reusable-candidates.md** — reusable patterns worth adding to templates")
$([ -n "$LATEST_PM" ] && echo "- **postmortem.md** — phase retrospective")

### Review checklist
- [ ] Changes are generic (no project-specific logic)
- [ ] No secrets or private data included
- [ ] Prompt changes improve agent quality
- [ ] Reusable patterns work across different projects

> Auto-contributed by Lupio OS — merge to propagate to all projects
EOF
)" 2>&1)

# ── Mark as contributed in local memory ──────────────────────
TRACKER="$LUPIO_DIR/memory/contributions.md"
cat >> "$TRACKER" << EOF

## ${DATE} — ${PROJECT_NAME}
- **PR:** ${PR_URL}
- **Status:** pending merge
EOF

# ── Done ──────────────────────────────────────────────────────
echo ""
success "Done! Lupio OS will improve once you merge the PR."
echo ""
echo "  PR: ${PR_URL}"
echo ""
echo "  After merging, any project can get these improvements with:"
echo "  npx lupio-os update"
echo ""
