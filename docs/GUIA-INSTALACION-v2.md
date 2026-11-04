# Lupio OS v2 — Guía de instalación

Lupio OS ahora tiene **dos partes**:

| Parte | Qué trae | Dónde vive | Se actualiza |
|---|---|---|---|
| **Plugin `lupio-os`** | 13 agentes, 15 comandos, skills | Caché de Claude Code (no en tu repo) | Solo, desde GitHub |
| **Instalador** | `.lupio/`, `CLAUDE.md`, `.claude/settings.json` | Dentro de cada proyecto | Con `apply-update.sh` |

Regla simple: **lo que es igual en todos los proyectos va en el plugin; lo que es propio del proyecto va en el repo del proyecto.**

---

## Momento 1 — Publicar la v2 (una sola vez)

En tu clon local de `lupiodev/Lupio-os`:

```bash
git checkout -b plugin-v2
# copia aquí el contenido del zip (reemplaza archivos)
git add -A
git commit -m "Lupio OS v2: plugin + marketplace"
git push origin plugin-v2
```

Prueba en un proyecto de prueba (ver Momento 3) y luego haz merge a `main`.

> El instalador descarga desde `main`. Hasta que hagas merge, los proyectos siguen recibiendo v1.

---

## Momento 2 — Cada máquina / desarrollador (una sola vez)

1. Actualiza Claude Code: `npm install -g @anthropic-ai/claude-code`
2. Si antes pusiste `"defaultMode": "bypassPermissions"` en `~/.claude/settings.json`, **quítalo**. Aplica a todos los repos, incluidos los de clientes.
3. Abre Claude Code en cualquier proyecto con Lupio OS → `/plugin` → **Marketplaces** → `lupio` → **Enable auto-update**.

Listo. Desde aquí, cada cambio que publiques le llega solo.

---

## Momento 3 — Cada proyecto nuevo

Desde la carpeta del proyecto:

```bash
bash <(curl -s https://raw.githubusercontent.com/lupiodev/Lupio-os/main/installer/install.sh)
```

Después:

1. Abre `claude` en la carpeta.
2. Si te pregunta por el plugin `lupio-os`, acepta.
3. Verifica: `/plugin` (debe decir `lupio-os` enabled) y `/agents` (deben salir los 13).
4. Haz commit de `CLAUDE.md`, `.claude/settings.json` y `.lupio/`.

Cuando otro dev clone el repo y abra Claude Code, el plugin se le ofrece solo.

---

## Momento 4 — Proyectos que ya tienen Lupio OS v1

Ejecuta **el mismo comando** del Momento 3. El instalador:

- Mueve `.lupio/agents/`, `.lupio/commands/` y las skills Lupio de `.claude/skills/` a `.lupio/checkpoints/legacy-v1-*` (respaldo).
- Respeta tus skills propias del proyecto, tu `CLAUDE.md`, contexto y memoria.
- Fusiona `.claude/settings.json` sin borrar lo que ya tenías.

Si tu `CLAUDE.md` es el viejo, compáralo con `.lupio/CLAUDE.lupio.md` o ejecuta:

```bash
bash .lupio/scripts/apply-update.sh --refresh-claude-md
```

---

## Momento 5 — Cuando mejoras Lupio OS

| Cambias… | Archivo | Para publicar |
|---|---|---|
| Un agente | `agents/<nombre>.md` | Sube `version` en `.claude-plugin/plugin.json` y haz push |
| Un comando | `claude/commands/<nombre>.md` | Igual |
| Una skill | `.claude/skills/<nombre>/SKILL.md` | Igual |
| Workflows, templates, core | `claude/workflows/`, `templates/`, `core/` | Push. En cada proyecto: `bash .lupio/scripts/apply-update.sh` |
| Reglas del proyecto | `claude/CLAUDE.template.md` | Push. En cada proyecto: `apply-update.sh --refresh-claude-md` |

**Sin subir `version`, el plugin no se actualiza.** Usa: arreglo → 2.0.1 · mejora → 2.1.0 · cambio grande → 3.0.0. Mantén igual el número en `package.json`.

> Los agentes y comandos ya **no se editan dentro de los proyectos** (viven en el plugin). Se editan aquí, en el repo de Lupio OS.

---

## Qué queda en cada proyecto

```
mi-proyecto/
├── CLAUDE.md                 reglas (commit)
├── .claude/
│   ├── settings.json         activa plugin + permisos (commit)
│   └── settings.local.json   solo tu máquina (no commit)
├── .mcp.json                 MCP (solo si no existía)
└── .lupio/
    ├── context/  memory/     propios del proyecto (gitignored)
    ├── workflows/ templates/ core/ prompts/ scripts/
    └── SYSTEM_MAP.md
```

---

## Opciones del instalador

| Variable | Efecto |
|---|---|
| `LUPIO_YES=true` | Instala sin preguntas (CI) |
| `LUPIO_BYPASS=true` | `bypassPermissions` solo en tu máquina (`settings.local.json`). No se comparte con el equipo |

Ejemplo: `LUPIO_YES=true bash <(curl -s https://raw.githubusercontent.com/lupiodev/Lupio-os/main/installer/install.sh)`

Por defecto el modo es `acceptEdits`: Claude edita archivos sin preguntar, pero los comandos de terminal piden permiso. Los commits, pushes y deploys siguen bloqueados.

---

## Comandos útiles

| Comando (dentro de Claude Code) | Para qué |
|---|---|
| `/plugin` | Ver, actualizar o desactivar `lupio-os` |
| `/agents` | Ver los 13 agentes |
| `/skills` | Ver skills y comandos activos |
| `/lupio-os:review-code` | Forma larga de un comando, si `/review-code` choca con otro |
| `/doctor` | Detectar skills que no cargan o consumen mucho contexto |

---

## Si algo falla

| Síntoma | Solución |
|---|---|
| No aparece `lupio-os` en `/plugin` | `/plugin install lupio-os@lupio` |
| No llegan cambios nuevos | ¿Subiste `version`? Luego `/plugin` › Marketplaces › `lupio` › Update |
| Un comando ejecuta otra cosa | Usa la forma larga `/lupio-os:<comando>` |
| Necesito volver a v1 | Copia de vuelta desde `.lupio/checkpoints/legacy-v1-*` |
