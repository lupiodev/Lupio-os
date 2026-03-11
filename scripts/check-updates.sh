#!/usr/bin/env bash
# ============================================================
# Lupio OS — Check for Updates
# Compares local version against latest commit on GitHub.
# Exits 0 = up to date, exits 1 = update available
# Prints: "UPDATE_AVAILABLE" or "UP_TO_DATE"
# ============================================================

LUPIO_DIR=".lupio"
VERSION_FILE="$LUPIO_DIR/context/version.json"
REPO_API="https://api.github.com/repos/lupiodev/Lupio-os/commits/main"
CACHE_TTL=3600  # check at most once per hour

# No .lupio = not installed
[ -d "$LUPIO_DIR" ] || { echo "NOT_INSTALLED"; exit 2; }

# Read local version
LOCAL_SHA=""
LAST_CHECKED=0
if [ -f "$VERSION_FILE" ]; then
  LOCAL_SHA=$(python3 -c "import json,sys; d=json.load(open('$VERSION_FILE')); print(d.get('sha',''))" 2>/dev/null || echo "")
  LAST_CHECKED=$(python3 -c "import json,sys; d=json.load(open('$VERSION_FILE')); print(d.get('last_checked',0))" 2>/dev/null || echo "0")
fi

# Respect cache TTL — don't hit GitHub on every message
NOW=$(date +%s)
ELAPSED=$(( NOW - LAST_CHECKED ))
if [ "$ELAPSED" -lt "$CACHE_TTL" ] && [ -n "$LOCAL_SHA" ]; then
  echo "UP_TO_DATE"
  exit 0
fi

# Fetch latest SHA from GitHub (silent, timeout 5s)
LATEST_SHA=$(curl -sf --max-time 5 \
  -H "Accept: application/vnd.github.v3+json" \
  "$REPO_API" 2>/dev/null | python3 -c "import json,sys; print(json.load(sys.stdin)['sha'][:12])" 2>/dev/null || echo "")

# No network = skip silently
[ -z "$LATEST_SHA" ] && { echo "UP_TO_DATE"; exit 0; }

# Write updated check time
python3 - << EOF
import json, os
path = "$VERSION_FILE"
data = {}
try:
    with open(path) as f: data = json.load(f)
except: pass
data['last_checked'] = $NOW
data['latest_sha'] = '$LATEST_SHA'
if not data.get('sha'): data['sha'] = '$LATEST_SHA'
os.makedirs(os.path.dirname(path), exist_ok=True)
with open(path, 'w') as f: json.dump(data, f, indent=2)
EOF

# Compare
if [ -z "$LOCAL_SHA" ] || [ "$LOCAL_SHA" != "$LATEST_SHA" ]; then
  echo "UPDATE_AVAILABLE:$LATEST_SHA"
  exit 1
else
  echo "UP_TO_DATE"
  exit 0
fi
