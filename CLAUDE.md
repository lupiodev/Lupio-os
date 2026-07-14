# CLAUDE.md — Lupio OS

Este repo **es** el sistema operativo de desarrollo de Lupio: distribuye agents,
commands, workflows y **skills** a cada proyecto vía `installer/install.sh`
(fuente en `claude/` y `.claude/skills/`, destino `.lupio/` y `.claude/skills/`
en cada proyecto).

Lupio es una empresa de desarrollo: plataformas digitales, SaaS, ecommerce,
automatización y soluciones con IA. Stack frecuente: React/Next.js/Tailwind/
SvelteKit · Strapi/WordPress/Medusa.js · Node.js/Laravel · PostgreSQL/MySQL/Redis
· AWS/DigitalOcean/Cloudflare/Contabo. **Prioridad: UX/UI, arquitectura limpia,
escalabilidad, MVPs rápidos e iterables. Evitar la sobre-ingeniería.**

---

## Estándar de arranque (OBLIGATORIO — cualquier modelo, Opus o Sonnet)

Al iniciar **cualquier proyecto o feature** de Lupio, ANTES de escribir código:

1. **`lupio-arranque`** — solo al arrancar un proyecto/MVP/repo nuevo. Define
   problema, usuario, la primera cosa visible, stack mínimo y el Día 1.
2. **`lupio-plan`** — SIEMPRE antes de tocar código en una tarea no trivial.
   Explora, hace las preguntas, propone pasos pequeños y reversibles y **espera
   tu OK**.

Y en sus momentos:

3. **`lupio-seguridad`** — antes de exponer a prod o al tocar auth, pagos, datos
   personales, uploads o endpoints públicos.
4. **`lupio-fixer`** — ante cualquier bug: reproducir → causa raíz → fix mínimo →
   probar con el caso exacto. Sin evidencia, no está arreglado.
5. **`lupio-abogado-diablo`** — cuando haya que decidir si una idea/feature vale
   la pena. Steelman → ataque → riesgos → veredicto (seguir/cambiar/matar).

Estas skills auto-cargan por sus disparadores (frontmatter `description`). Viven
en `.claude/skills/lupio-*/SKILL.md` y se instalan en cada proyecto.

## Diseño de interfaces (PRIORIDAD al diseñar UI)

Al diseñar/rediseñar cualquier interfaz, **`lupio-diseno` es prioritaria** e
impone el orden jerárquico: idea → brief → arquitectura de información/flujos →
tokens/sistema → layout/wireframe → componentes → motion → review. Enruta a las
skills de diseño curadas (ver `.claude/skills/ATTRIBUTION.md` para fuentes y licencias):

| Skill | Para | Origen |
|-------|------|--------|
| `lupio-diseno` | Conductor: orden jerárquico + routing (prioridad) | Lupio |
| `frontend-design` | Dirección visual, tipografía, estructura, copy | Anthropic (Apache-2.0) |
| `ui-ux-pro-max` | Reglas profesionales + checklist pre-entrega | WAAM (MIT, adaptada) |
| `apple-design` | Motion físico, gestos, materiales | emilkowalski (MIT) |
| `improve-animations` | Auditar/planear mejoras de motion | emilkowalski (MIT) |
| `animation-vocabulary` | Nombrar un efecto de animación | emilkowalski (MIT) |
| `review-animations` | Revisar motion de un diff | emilkowalski (MIT) |
| `web-design-guidelines` | Auditar UI vs. Web Interface Guidelines | Vercel |

Reglas: no saltar etapas · tokens antes que componentes · evitar defaults de IA ·
QA visual con Playwright en 375/768/1280 (light y dark). Se apoya en los agentes
`ux-reviewer` / `ui-reviewer` y en `/review-ux`.

### Cómo se invoca cada skill
- **Automático:** cargan solas cuando tu mensaje coincide con sus disparadores
  (p. ej. "nuevo proyecto" → `lupio-arranque`; "hay un bug" → `lupio-fixer`).
- **Manual (forzar):** escribe `/lupio-arranque`, `/lupio-plan`,
  `/lupio-seguridad`, `/lupio-abogado-diablo` o `/lupio-fixer`.
- **Verificar que están:** `ls .claude/skills/`.

### Orden lógico típico
```
idea dudosa → lupio-abogado-diablo → (seguir) → lupio-arranque (si es nuevo)
           → lupio-plan → [código] → lupio-fixer (si algo falla)
           → lupio-seguridad (antes de prod)
```

---

## Reglas de trabajo en ESTE repo (Lupio OS)

- **No commits / no deploys sin confirmación textual explícita.** El usuario los
  maneja. `git add/status/diff/log` sí; `git commit/push/tag` y deploys, no, salvo
  que el usuario lo pida en el momento.
- **Branch Creation Policy:** por defecto trabajar en la rama actual. Proponer
  rama nueva (y esperar confirmación) solo si el cambio es un feature/refactor
  significativo.
- **Editar una skill:** modifica `.claude/skills/<nombre>/SKILL.md` (fuente única).
  El instalador la propaga; no dupliques en `claude/`.
- **Verificación de este repo** (es markdown + shell, no una app):
  - `bash -n installer/install.sh` y `bash -n scripts/apply-update.sh` (sintaxis).
  - `shellcheck` si está disponible.
  - Skills: comprobar que cada `SKILL.md` tiene frontmatter `name` = carpeta y
    `description` con disparadores, y que aparecen al listar skills.
- **Al cambiar el sistema, mantén sincronizados:** `installer/install.sh`,
  `scripts/apply-update.sh` y este `CLAUDE.md`.
