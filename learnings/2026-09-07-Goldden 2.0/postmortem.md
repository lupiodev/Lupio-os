# Postmortem — 2026-05-09 — Goldden 2.0 (Setup + Operativa)

## Qué se construyó
Setup inicial de Lupio OS 1.1.0 sobre monorepo de seguros (Back NestJS + Front Bun/React + Admin + Scraper + web + infra), con regla "Backend Core Intocable" ya formalizada como DECISION-001 antes de la fase de arquitectura.

## Qué funcionó
- **Protección temprana del cálculo financiero:** la regla de oro en `CLAUDE.md` se escribió antes de tocar código; evita el patrón clásico de "primero rompemos, luego documentamos".
- **Estructura por apps separadas:** Back / Front / Admin / Scraper / web / infra desacopladas — permite que Lupio OS aplique reglas distintas por superficie sin contaminación.
- **Pre-flight de permisos en bloque:** elimina la fricción de aprobar tool-by-tool durante ejecución.

## Qué no funcionó
- `memory/` quedó vacío durante semanas — el flujo de auto-learning no se disparó porque no hubo trigger explícito ("perfecto/listo/done").
- `context/project.md` sigue con `Tech Stack: <!-- Fill in -->` y `Current Phase: discovery` aunque hay 13+ módulos backend ya implementados (coberturas, policies, quotes, etc.). El contexto está desactualizado vs. la realidad del repo.
- No hay `architecture.md` ni postmortems previos — la memoria de Lupio OS no refleja el estado real del proyecto.

## Mejoras encontradas (accionables)
1. **Auto-sync de fase:** detectar módulos en `Goldden Back/src/v1/` y promover automáticamente la fase de `discovery` a `development` en `project.md`.
2. **Trigger de learning más laxo:** al cabo de N sesiones sin postmortem, sugerirlo aunque no haya "perfecto/listo".
3. **Validar coherencia memoria↔repo:** comando que detecte desfase entre `project.md` y la estructura real.

## Patrones reusables detectados
- **Backend-Core-Intocable rule** — aplicable a cualquier sistema con cálculo financiero/contable.
- **Pre-flight de permisos en bloque** — UX superior al permission-prompt-per-action.
- **Monorepo multi-app por superficie** (Back/Front/Admin/Scraper/Infra) — separación clara de responsabilidades.
