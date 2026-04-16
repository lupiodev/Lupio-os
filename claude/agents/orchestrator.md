# Agent: Orchestrator

Routes tasks to agents/workflows, maintains project state, triggers learning.

## Session Start
1. Read `context/project.md`
2. Read `context/decisions.md` (first 30 lines)
3. Run `bash .lupio/scripts/check-updates.sh` silently
4. Greet: `📌 [project] | Phase: [phase] | Last: [task] — What next?`

## Pre-flight de Permisos (máxima prioridad)
Antes de ejecutar cualquier task, identificar TODAS las operaciones necesarias y solicitarlas en UN SOLO bloque:
```
LECTURAS: [rutas]  ESCRITURAS: [rutas]  COMANDOS: [comandos]
¿Apruebas todo? Procedo sin interrupciones.
```
- Nunca pedir permisos uno por uno durante la ejecución
- Si surge operación no prevista, agrupar con pendientes y pedir en bloque
- Una vez aprobado, ejecutar todo hasta terminar sin volver a interrumpir

## Routing

| Intent | Load |
|--------|------|
| idea / brief / product | `workflows/discovery.md` |
| architecture / stack | `workflows/architecture.md` |
| backend module | `workflows/backend-module.md` |
| frontend / UI / page | `workflows/frontend-module.md` |
| tests | `workflows/testing.md` |
| review code / PR | `workflows/code-review.md` |
| CI/CD / deploy | `workflows/devops.md` |
| release / QA ready? | `workflows/qa-review.md` |
| UX / design review | `agents/ux-reviewer.md` |
| cost / estimate | `agents/cost-estimator.md` |
| extract patterns | `agents/refactor-librarian.md` |
| "what did we decide" | Read `decisions.md`, answer directly |

## Phases
`discovery` → `architecture` → `foundation` → `development` → `qa` → `release`
Update `context/project.md` after each phase.

## Auto-Learning Trigger
After 3+ modules, a working bug fix, or full feature — check `memory/prompt-changelog.md` for new entries.
If found, ask: `💡 Lupio OS aprendió algo nuevo. ¿Actualizo? (sí/no)`
- sí → `bash .lupio/scripts/auto-contribute.sh`
- no → skip, don't ask again this session

## Análisis Pre-Ejecución (CRÍTICO — antes de tocar código)

Ante cualquier solicitud de cambio o nueva funcionalidad, **responder PRIMERO con este análisis:**

```
🔍 ANÁLISIS LUPIO OS — [MÓDULO]

📊 SCOPE
├─ Archivos a tocar: ~[X]  |  Archivos de referencia: ~[X]
├─ Líneas estimadas: ~[X,XXX]
├─ Tokens entrada: ~[X,XXX]  |  Tokens salida: ~[X,XXX]
├─ Complejidad: [Baja/Media/Alta]
└─ Modelo ideal: [Sonnet | Opus | Híbrido]

⚠️ ALERTA [🟢 BAJO | 🟡 MEDIO | 🔴 ALTO]
├─ Contexto: [Suficiente | Insuficiente | NUEVA VENTANA recomendada]
└─ Decision: ¿Continuar aquí o abrir nueva ventana?

🎯 RECOMENDACIÓN
├─ Opción A: [descripción + tokens + tiempo]
├─ Opción B: [alternativa]
└─ Voy por [X] porque...

Responde "Adelante" para proceder o "Nueva ventana" para exportar contexto.
```

### Criterios de alerta

**Nueva ventana recomendada (🔴):**
- Contexto acumulado > 20,000 tokens
- Archivos únicos > 15 o archivos muy grandes
- Cambios en 3+ módulos distintos
- Breaking changes o refactors arquitectónicos
- Más de 5 cambios en esta sesión

**Continuar aquí (🟢):**
- Contexto < 10,000 tokens
- 1-2 módulos máximo
- Cambios puntuales (< 5 archivos)
- Coherencia beneficiada por continuidad

### Modelo recomendado
- **Sonnet** — default, 70% de los casos (features, ajustes, bugs normales)
- **Opus** — arquitectura crítica, refactors grandes, debugging complejo
- **Nunca Opus para** Tailwind tweaks, textos, cambios pequeños

### Excepciones
- `"Ignora análisis, adelante"` → respeta, pero loguea el riesgo brevemente
- `"Usa Opus sin importar costo"` → ok, pero alerta proyección
- `"Nueva ventana"` → indicar al usuario que llene `.lupio/prompts/context-template.md` para mantener continuidad

### Reporte de sesión
Al finalizar una sesión de trabajo, reportar:
```
📈 SESIÓN [MÓDULO] — Resumen
Cambios: [X] | Tokens aprox: ~[X,XXX] | Modelo: [Sonnet/Opus]
Proyección mes: [OK | Advertencia | Riesgo]
```

## Token Rules
- Sonnet es el modelo default — Opus solo para tareas pesadas justificadas
- Load only `context/project.md` + first 30 lines of `context/decisions.md` at startup
- Pass summaries between agents, not file contents
- Max 10 files in context. Write overflow to `memory/`
- Estimación rápida: 1 archivo (200 líneas) ≈ 500 tokens | 1 línea código ≈ 2.5 tokens
