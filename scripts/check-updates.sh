#!/usr/bin/env bash
# ============================================================
# Lupio OS — Check for Updates
# Compara la VERSIÓN instalada (.lupio/context/version.json) contra la
# `version` publicada en .claude-plugin/plugin.json de main.
# (Antes comparaba SHAs de commit: cada commit `learn:` disparaba el aviso
#  y los SHAs de 7 vs 12 caracteres nunca coincidían.)
#
# Imprime:  UP_TO_DATE | UPDATE_AVAILABLE:<versión> | NOT_INSTALLED
# Exit:     0 = al día · 1 = hay actualización · 2 = no instalado
# Pregunta como máximo una vez cada 24 h.
# ============================================================

LUPIO_DIR=".lupio"
VERSION_FILE="$LUPIO_DIR/context/version.json"
VERSION_URL="${LUPIO_VERSION_URL:-https://raw.githubusercontent.com/lupiodev/Lupio-os/main/.claude-plugin/plugin.json}"
CACHE_TTL="${LUPIO_CHECK_TTL:-86400}"

[ -d "$LUPIO_DIR" ] || { echo "NOT_INSTALLED"; exit 2; }
command -v python3 >/dev/null 2>&1 || { echo "UP_TO_DATE"; exit 0; }

# Dentro del TTL no se toca la red ni se vuelve a preguntar.
FRESH=$(VERSION_FILE="$VERSION_FILE" CACHE_TTL="$CACHE_TTL" python3 - << 'PYEOF' 2>/dev/null
import json, os, time
try:
    d = json.load(open(os.environ["VERSION_FILE"]))
    print("yes" if time.time() - float(d.get("last_checked", 0)) < float(os.environ["CACHE_TTL"]) else "no")
except Exception:
    print("no")
PYEOF
)
[ "$FRESH" = "yes" ] && { echo "UP_TO_DATE"; exit 0; }

# Sin red = no molestar.
REMOTE_JSON=$(curl -sfL --max-time 5 "$VERSION_URL" 2>/dev/null || true)
[ -n "$REMOTE_JSON" ] || { echo "UP_TO_DATE"; exit 0; }

REMOTE_JSON="$REMOTE_JSON" VERSION_FILE="$VERSION_FILE" python3 - << 'PYEOF'
import json, os, re, sys, time

def parse(v):
    nums = re.findall(r"\d+", str(v or ""))[:3]
    return tuple(int(n) for n in nums) if nums else None

path = os.environ["VERSION_FILE"]
try:
    latest = str(json.loads(os.environ["REMOTE_JSON"]).get("version", ""))
except Exception:
    latest = ""
if parse(latest) is None:          # respuesta rara de la red: no molestar
    print("UP_TO_DATE"); sys.exit(0)

try:
    data = json.load(open(path))
except Exception:
    data = {}
local = data.get("version")        # ausente = instalación previa a 2.1 (por SHA)

data["last_checked"] = int(time.time())
data["latest_version"] = latest
try:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    json.dump(data, open(path, "w"), indent=2)
except Exception:
    pass

if parse(local) is None or parse(latest) > parse(local):
    print(f"UPDATE_AVAILABLE:{latest}"); sys.exit(1)
print("UP_TO_DATE"); sys.exit(0)
PYEOF
