#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Lupio OS — Contribute Learnings
# Packages lessons from .lupio/memory/ and opens a PR
# against the central lupiodev/Lupio-os repository
# ============================================================

LUPIO_REPO="https://github.com/lupiodev/Lupio-os.git"
LUPIO_DIR=".lupio"
DATE=$(date +%Y-%m-%d)
BRANCH="learning/${DATE}-$(basename "$(pwd)")"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()    { echo -e "${BLUE}[lupio-learn]${NC} $1"; }
success(){ echo -e "${GREEN}[lupio-learn]${NC} $1"; }
warn()   { echo -e "${YELLOW}[lupio-learn]${NC} $1"; }
error()  { echo -e "${RED}[lupio-learn]${NC} $1"; exit 1; }

# ── Validations ───────────────────────────────────────────────
[ -d "$LUPIO_DIR" ] || error ".lupio/ not found. Run 'npx lupio-os init' first."
command -v gh >/dev/null 2>&1 || error "GitHub CLI (gh) is required. Run: brew install gh"
gh auth status >/dev/null 2>&1 || error "Not authenticated. Run: gh auth login"

# ── Check for learnings to contribute ────────────────────────
CHANGELOG="$LUPIO_DIR/memory/prompt-changelog.md"
CANDIDATES="$LUPIO_DIR/memory/reusable-candidates.md"
POSTMORTEM=$(ls "$LUPIO_DIR/memory/postmortem-"*.md 2>/dev/null | tail -1 || echo "")

if [ ! -f "$CHANGELOG" ] && [ ! -f "$CANDIDATES" ] && [ -z "$POSTMORTEM" ]; then
  error "No learnings found. Run /save-lessons first inside Claude Code."
fi

log "Found learnings to contribute:"
[ -f "$CHANGELOG" ] && log "  - prompt-changelog.md"
[ -f "$CANDIDATES" ] && log "  - reusable-candidates.md"
[ -n "$POSTMORTEM" ] && log "  - $(basename "$POSTMORTEM")"

# ── Clone lupio-os and create branch ─────────────────────────
log "Cloning Lupio OS repository..."
TMP_DIR=$(mktemp -d)
git clone --depth=1 "$LUPIO_REPO" "$TMP_DIR" 2>/dev/null
cd "$TMP_DIR"
git checkout -b "$BRANCH"

# ── Copy learnings into the repo ─────────────────────────────
PROJECT_NAME=$(basename "$(cd - && pwd)")
LEARNING_DIR="learnings/${DATE}-${PROJECT_NAME}"
mkdir -p "$LEARNING_DIR"

[ -f "$(cd - && pwd)/$CHANGELOG" ]  && cp "$(cd - && pwd)/$CHANGELOG"  "$LEARNING_DIR/prompt-changelog.md"
[ -f "$(cd - && pwd)/$CANDIDATES" ] && cp "$(cd - && pwd)/$CANDIDATES" "$LEARNING_DIR/reusable-candidates.md"
[ -n "$POSTMORTEM" ]                 && cp "$POSTMORTEM"                "$LEARNING_DIR/postmortem.md"

# ── Write summary file ────────────────────────────────────────
cat > "$LEARNING_DIR/meta.md" << EOF
# Learning Contribution

**Project:** $PROJECT_NAME
**Date:** $DATE
**Contributed by:** $(gh api user --jq '.login' 2>/dev/null || echo "unknown")

## Contents
$([ -f "$LEARNING_DIR/prompt-changelog.md" ]   && echo "- prompt-changelog.md")
$([ -f "$LEARNING_DIR/reusable-candidates.md" ] && echo "- reusable-candidates.md")
$([ -f "$LEARNING_DIR/postmortem.md" ]          && echo "- postmortem.md")
EOF

# ── Commit and push ───────────────────────────────────────────
git add .
git commit -m "learn: add learnings from project ${PROJECT_NAME} (${DATE})"
git push origin "$BRANCH"

# ── Open PR ───────────────────────────────────────────────────
cd - > /dev/null
PR_URL=$(gh pr create \
  --repo lupiodev/Lupio-os \
  --head "$BRANCH" \
  --base main \
  --title "Learning contribution: ${PROJECT_NAME} (${DATE})" \
  --body "$(cat << EOF
## Automated Learning Contribution

**Source project:** \`${PROJECT_NAME}\`
**Date:** ${DATE}

### Files included
$([ -f "$LUPIO_DIR/memory/prompt-changelog.md" ]   && echo "- \`prompt-changelog.md\` — prompt improvements")
$([ -f "$LUPIO_DIR/memory/reusable-candidates.md" ] && echo "- \`reusable-candidates.md\` — reusable patterns")
$([ -n "$POSTMORTEM" ] && echo "- \`postmortem.md\` — phase retrospective")

### Review checklist
- [ ] Prompt changes improve agent quality
- [ ] Reusable candidates are generic enough for other projects
- [ ] No project-specific secrets or data included

> Contributed automatically by Lupio OS learning-agent
EOF
)" 2>&1)

rm -rf "$TMP_DIR"

echo ""
success "Learning contribution submitted!"
echo ""
echo "  PR: $PR_URL"
echo ""
echo "  Review and merge it at GitHub to propagate to all projects."
echo "  Once merged, anyone can get it with: npx lupio-os update"
echo ""
