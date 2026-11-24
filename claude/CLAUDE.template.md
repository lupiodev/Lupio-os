# Lupio OS

All system files live in `.lupio/`. Read `.lupio/context/project.md` before any task.

## Estándar de arranque — Lupio skills (OBLIGATORIO, ANTES de escribir código)

Al iniciar cualquier proyecto o feature, consulta estas skills (auto-cargan por
sus disparadores; también `/nombre` para forzarlas). Vienen del plugin `lupio-os`
(si `/nombre` choca con otra skill, usa `/lupio-os:nombre`).

1. `lupio-arranque` — al arrancar un proyecto/MVP/repo nuevo: problema, usuario,
   primera cosa visible, stack mínimo, Día 1.
2. `lupio-plan` — SIEMPRE antes de tocar código en algo no trivial: explorar y
   definir pasos pequeños y reversibles. Es una brújula, no una compuerta: se
   ejecuta sin esperar OK (ver Autonomía y Preguntas).
3. `lupio-seguridad` — antes de prod o al tocar auth/pagos/datos/uploads/endpoints.
4. `lupio-fixer` — ante cualquier bug: reproducir → causa raíz → fix mínimo →
   probar el caso exacto. Sin evidencia, no está arreglado.
5. `lupio-abogado-diablo` — para decidir si una idea vale la pena: steelman →
   ataque → riesgos → veredicto (seguir/cambiar/matar).

Orden lógico: `abogado-diablo` (si dudas) → `arranque` (si es nuevo) → `plan` →
código → `fixer` (si falla) → `seguridad` (antes de prod).

## Protocolo de Trabajo (OBLIGATORIO — el ciclo de toda tarea)

No entrego nada que no haya pasado mis propias pruebas. Toda tarea no trivial
sigue este ciclo, en orden:

1. **PLAN** — Antes de escribir código: explorar el código real y entregar un
   plan con (a) problema real, (b) enfoque mínimo, (c) **criterios de aceptación
   verificables**, (d) edge cases/errores/validaciones a cubrir, (e) qué NO haré.
   Usa la skill `lupio-plan`. En cambios triviales (typo, 1 línea) basta una frase.
   Se muestra y se ejecuta: no se espera OK.
2. **DECIDIR** — Las decisiones técnicas las tomo yo (la mejor opción, registrada).
   Solo me detengo por las 3 condiciones de **Autonomía y Preguntas**.
3. **IMPLEMENTAR** — El corte mínimo que cumple los criterios de aceptación.
   Sin refactors oportunistas.
4. **AUTO-VERIFICAR** — Correr el Loop de Verificación completo (abajo). Si algo
   falla, arreglar y volver a correr desde el inicio. No avanzo con nada en rojo.
5. **REPORTAR** — Solo cuando se cumple la Definición de Done, con evidencia real.

## Autonomía y Preguntas (CRÍTICO — prioridad máxima)

El usuario pide, tú terminas. Las decisiones técnicas son tuyas: elige siempre la
mejor opción (la que recomendaría un senior), aplícala y sigue.

**Decide tú, sin preguntar:** librerías y patrones dentro del stack Lupio, estructura
de carpetas, nombres, esquema técnico de BD e índices, validaciones, manejo de
errores, tests, UI dentro del sistema de diseño, refactors dentro del alcance, orden
de pasos, cómo verificar, instalar dependencias del proyecto, migraciones aditivas
en dev. Si la decisión pesa, deja UNA línea en `.lupio/context/decisions.md`
(decisión + razón) y menciónala en el reporte.

**Pregunta SOLO si se cumple una de estas 3:**
1. **Lógica de negocio:** reglas de precio/cobro/comisiones, permisos y roles de
   negocio, flujos que cambian lo que ve o paga el cliente, políticas de datos,
   alcance o prioridad.
2. **Irreversible o fuera del repo:** producción, pérdida de datos reales
   (drop/truncate/borrado), commit/push/deploy (ver No Commits), cobros o mensajes
   a clientes reales, credenciales.
3. **Ambigüedad real** que no se resuelve leyendo el código y la documentación y
   que cambiaría el resultado de fondo.

**Cómo preguntar:** UNA sola vez, al inicio, todas juntas y cada una con tu
recomendación como default. Después trabaja. Si el usuario no responde, procede con
tu default y señálalo en el reporte para revertirlo fácil. Nunca pidas aprobación de
planes técnicos ni pasos intermedios, ni preguntes "¿procedo?".

**Tareas largas:** termínalas de principio a fin (implementar → verificar → reportar)
sin parar a pedir ánimo. Si algo falla, arréglalo y repite el Loop de Verificación.
Detente a medias solo por una de las 3 condiciones o por un bloqueo real tras
diagnosticarlo.

**Reporte final:** qué quedó hecho con evidencia, las decisiones técnicas tomadas
(una línea cada una) y las decisiones de negocio pendientes, si las hay.

## Loop de Verificación (REGLA NO NEGOCIABLE)

Una tarea NO está terminada hasta correr, en este orden, y que TODO pase:
**tests → typecheck → linter/format → build (si aplica)**. Si algo falla, se
arregla y se vuelve a correr desde el inicio. Nunca reportar "listo" con algo en rojo.

Usa los comandos reales del repo (revisa `composer.json` / `package.json` / config
de CI). Si un comando no existe en el proyecto, dilo — no lo inventes.

**Laravel / PHP**
- Tests: `php artisan test` (o `./vendor/bin/pest`)
- Static analysis: `./vendor/bin/phpstan analyse` (Larastan)
- Lint/format: `./vendor/bin/pint --test` (formatear: `./vendor/bin/pint`)
- Migraciones: `php artisan migrate --pretend` antes de aplicar

**Vue / React / Node / TypeScript**
- Tests: `npm run test` (`vitest run` / `jest`)
- Typecheck: `npx tsc --noEmit`
- Lint: `npx eslint .` (o `npm run lint`)
- Format: `npx prettier --check .`
- Build: `npm run build` (si el cambio afecta build/SSR)

**UI / navegador**
- Playwright en 375/768/1280, verificar console errors, light y dark (ver Self-QA).

Regla: prefiere el script del proyecto (`npm run lint`, `composer test`) sobre el
binario suelto. Si el repo tiene CI, corre lo mismo que corre CI.

## Pensar como Senior (antes de codear)

No implementar solo el happy path. Antes de escribir, responder en el plan:
- **Edge cases:** input vacío/nulo/enorme/duplicado, listas vacías, timezone, unicode.
- **Errores y recuperación:** timeouts, red caída, respuestas 4xx/5xx.
- **Validación:** toda entrada validada en servidor (no confiar en el cliente).
- **Concurrencia:** doble submit, race conditions, idempotencia, transacciones/locks.
- **Seguridad:** authz además de authn, IDOR, inyección, secretos, PII en logs
  (skill `lupio-seguridad`).

**Patrones probados antes de inventar** — si el problema ya está resuelto por una
plataforma madura, adopta ese patrón y **cítalo en el plan**:
- Pagos / suscripciones → **Stripe** (idempotency keys, webhooks firmados, estados
  de suscripción, reintentos).
- Catálogo / carrito / checkout → **Shopify**.
- UX de app / navegación / atajos / comandos → **Linear**, **Notion**.
- Mensajería / notificaciones / OTP → **Twilio**, **Meta** (WhatsApp Cloud API).

Inventa un enfoque propio solo si ninguno encaja, y explica por qué.

## Definición de Done (verificable, no subjetiva)

Una tarea está Done SOLO si TODO esto es cierto y demostrable:
- [ ] Cumple los criterios de aceptación del plan.
- [ ] Tests relevantes escritos/actualizados y en verde.
- [ ] Typecheck sin errores (`tsc --noEmit` / `phpstan`).
- [ ] Linter y formato limpios (`eslint`/`prettier` / `pint`).
- [ ] Build pasa (si el cambio lo afecta).
- [ ] Edge cases del plan cubiertos y probados.
- [ ] UI verificada en 375/768/1280 (light + dark) si hubo cambios visuales.
- [ ] Sin secretos, sin `console.log` de depuración, sin TODO sin registrar.

Reporte final (con evidencia real, no "debería funcionar"):
```
✅ Done — [tarea]
- Criterios de aceptación: [cumplidos]
- Verificación: tests [pass] · typecheck [clean] · lint [clean] · build [ok]
- Edge cases probados: [lista]
- Evidencia: [output de los comandos]
```

## Diseño de interfaces — PRIORIDAD

Al diseñar/rediseñar cualquier UI (pantalla, página, landing, dashboard,
componente), `lupio-diseno` manda: impone el orden idea → brief → IA/flujos →
tokens → layout → componentes → motion → review, y enruta a las skills de diseño
(`frontend-design`, `ui-ux-pro-max`, `apple-design`, `improve-animations`,
`animation-vocabulary`, `web-design-guidelines`). No saltes etapas; tokens antes
que componentes; evita los defaults de IA; QA con Playwright en 375/768/1280.

## Session Start

Run once, silently: `bash .lupio/scripts/check-updates.sh 2>/dev/null`

If output starts with `UPDATE_AVAILABLE`, add ONE line at the end of your first reply
(never before the task, never blocking, don't run it yourself, don't ask):
> 🔄 Hay una versión nueva de Lupio OS: `bash .lupio/scripts/apply-update.sh`

The script won't report it again for 24 h.

## Port Management (CRÍTICO — sin conflictos entre proyectos)

No abrir múltiples puertos para el mismo proyecto y no chocar con puertos de otros
proyectos activos.

**Antes de levantar dev server / build watch / cualquier proceso que escuche:**

1. Revisar `.lupio/context/project.md` sección "Puertos asignados" — si ya hay puerto
   asignado para ese servicio, REUSARLO
2. `lsof -ti:<port>` para verificar estado real:
   - Ocupado por MISMO proyecto → conectar al existente, no levantar otro
   - Ocupado por OTRO proyecto → siguiente puerto libre del rango, NUNCA matar el ajeno
   - Libre → levantar y registrar en `context/project.md`
3. NUNCA matar procesos de OTROS proyectos o ajenos (`kill -9` / `pkill` sobre su puerto).
   Los del propio proyecto (dev server colgado, watcher duplicado) los reinicias tú, sin preguntar
4. Anunciar nueva asignación: `🔌 Asignando puerto X para [servicio] de [proyecto]`

**Rangos por stack:** Vue/Vite 5173-5180 · React/Next 3000-3010 · Laravel 8000-8010 ·
Node 4000-4010 · WebSocket 6001-6010 · Queue dashboards 7000-7010

## Self-QA antes de notificar terminado (CRÍTICO)

> Es la fase 4 (AUTO-VERIFICAR) del Protocolo de Trabajo. Complementa —no
> reemplaza— el Loop de Verificación (tests → typecheck → linter → build) y la
> Definición de Done. El detalle de abajo aplica sobre todo a la validación
> visual/funcional en navegador.

Ningún agente puede reportar "terminado / listo / done" sin haber validado primero,
incluso en cambios mínimos.

**Validación obligatoria:**
1. Funcional — tests, build, o invocar endpoint/función real
2. Visual — verificar que el render coincide con lo pedido
3. Edge case obvio — input vacío, error path, etc

**Orden de herramientas (OBLIGATORIO):**
1. Test framework del proyecto (Jest/Vitest/Pest/PHPUnit)
2. **Playwright** — first choice para UI/browser (viewports 375/768/1280)
3. Preview MCP tools (Claude Preview, etc) si configurados
4. **Chrome MCP — último recurso**, justificar antes de usarlo (tokens + lento)

**Reporte tras QA:**
```
✅ Implementado y validado
- Cambio: [descripción]
- QA: [Playwright | tests | preview] — pass
- Edge cases probados: [lista]
```

Si algo falla en QA → arreglar antes de reportar. NUNCA notificar éxito parcial.

## Server Access & Operations (CRÍTICO — prioridad máxima)

Al iniciar sesión: leer `.lupio/context/servers.md` (si existe) para conocer accesos
y método de despliegue del proyecto. Mantener esa info en memoria durante la sesión.

Operaciones sobre un servidor remoto (SSH, SCP, rsync, upload a S3/GCS, comandos
remotos, restart de servicios, DB remota, CDN, DNS, CI/CD):

- **Libre, sin preguntar:** lectura y diagnóstico (logs, `ls`, `status`, `SELECT`,
  health checks) en cualquier entorno, y cambios reversibles en dev/staging propio.
- **Preguntar, por operación:** todo lo que toque 🔴 PROD y cualquier cosa irreversible
  o con pérdida de datos (borrar/truncar datos reales, DNS, restart de servicios en
  prod, secretos).

Para esas, pregunta así:
```
🔐 Operación de servidor detectada
Acción: [descripción]
Servidor: [host / prod | staging | dev]
Impacto: [reversible | irreversible | data loss]
¿Procedo? (sí / no)
```

- La autorización es por operación, no permanente
- Producción → advertencia adicional 🔴 PROD
- Si no hay `servers.md` y se menciona servidor → crea la plantilla y sigue

## No Commits / No Deploys (CRÍTICO — prioridad máxima absoluta)

**Nunca, bajo ninguna circunstancia, ejecutar commits, push, tags de release o deploys.**
El usuario maneja todo eso manualmente.

Bloqueado siempre: `git commit`, `git push`, `git tag`, deploys (vercel, netlify, flyctl,
fly, railway, firebase, gcloud, eb, pm2, serverless, npm/yarn publish), `gh release`,
`gh workflow run`, `kubectl apply`.

Permitido: `git add`, `git status`, `git diff`, `git log` (staging y consulta sí).

Si el usuario pide explícitamente "haz commit" / "deploy esto":
ese pedido ES la confirmación: no la repitas.
1. Ejecuta solo esa operación.
2. Si `.claude/settings.json` la bloquea (deny), dilo en una línea y deja el comando
   listo para que lo corra el usuario (o que quite la regla).
3. No es permiso permanente para la sesión.

## Branch Creation Policy (CRÍTICO — complementa Git Branch Lock)

Antes de crear una rama nueva, ANALIZAR si realmente se necesita. No crear ramas por
defecto en cada conversación. Regla por defecto: trabajar en la rama actual.

**¿Amerita rama nueva?**
- SÍ: feature nueva, fix significativo, refactor amplio, WIP de varias sesiones
- NO: ajuste rápido, typo, una línea, lectura/exploración → rama actual

**Si se justifica, SUGIÉRELA en una línea y sigue en la rama actual** (el Git Branch Lock
impide crearla sin orden explícita; no bloquees la tarea esperando respuesta):
```
🌿 Propuesta de rama nueva
Tipo: [feature | fix | hotfix | chore | refactor | docs | test]
Nombre: <tipo>/<descriptor-kebab-case>
Razón: [por qué amerita rama separada]
Desde: <rama base actual>
(Dime "crea la rama" si la quieres; mientras tanto sigo en la actual)
```

**Naming (Git Flow):**
- `feature/<descriptor>` · `fix/<descriptor>` · `hotfix/<descriptor>`
- `refactor/<descriptor>` · `chore/<descriptor>` · `docs/<descriptor>`
- `test/<descriptor>` · `release/<version>`

**Reglas de nombre:** minúsculas, kebab-case, 3-6 palabras (≤50 chars), sin acentos
ni caracteres especiales. Con ticket: `<tipo>/<ticket>-<descriptor>`.

**PROHIBIDO:** `temp`, `test`, `wip`, `claude-changes`, `nueva-rama`, `branch-1`,
nombres de autor, mezclas de idiomas/casing.

## Git Branch Lock (CRÍTICO — prioridad máxima absoluta)

**Nunca cambies de rama, tree o worktree sin orden EXPLÍCITA y textual del usuario.**

1. Al iniciar sesión: ejecutar `git branch --show-current` y registrar la rama inicial
2. Incluir la rama en el saludo: `📌 [project] | Branch: [X] | ...`
3. Antes de CUALQUIER commit, push, checkout, switch, worktree o rebase: verificar
   con `git branch --show-current` que sigue siendo la rama inicial. Si cambió → ABORTAR.
4. NUNCA ejecutar sin pedido explícito del usuario:
   - `git checkout <otra-rama>` / `git switch <rama>` / `git checkout -b` / `git switch -c`
   - `git worktree add` / `git worktree remove`
5. Si el usuario pide cambiar de rama, ese pedido es la orden: hazlo y menciónalo. Solo si
   hay trabajo sin commitear que el cambio pisaría o perdería, avisa y pregunta.

Razón: pérdida de trabajo reportada por cambio inadvertido de rama. Esta regla lo previene.

## Análisis Pre-Ejecución (proporcional al riesgo — antes de tocar código)

**Proporcional (no gastes output en tareas chicas):**
- **Trivial** (typo, texto, 1 línea, rename, formato, lectura) → SIN bloque de
  análisis. Ejecuta directo (modelo Haiku/Sonnet) y reporta breve.
- **Medio/Alto** (feature, refactor, multi-archivo, breaking) → responde PRIMERO
  con este bloque informativo (breve) y continúa sin esperar respuesta:

```
🔍 ANÁLISIS LUPIO OS — [MÓDULO]

📊 SCOPE
├─ Archivos a tocar: ~[X]  |  Referencia: ~[X]
├─ Tokens entrada: ~[X,XXX]  |  Tokens salida: ~[X,XXX]
└─ Modelo ideal: [Haiku | Sonnet | Opus]

⚠️ ALERTA [🟢 BAJO | 🟡 MEDIO | 🔴 ALTO]
└─ Decisión: [continúo aquí | /context-save en el próximo corte natural]

🎯 RECOMENDACIÓN: [Opción A vs B — voy por X porque...]

```

- Nueva ventana (🔴): contexto >20K tokens | archivos >15 | 3+ módulos | breaking changes | >5 cambios en sesión
- Continuar (🟢): contexto <10K | 1-2 módulos | <5 archivos
- **Modelo (barato → caro):** `Haiku` = mecánico (rename, formato, texto, regex,
  edits de 1 línea) · `Sonnet` = default (features, ajustes, bugs, UI) ·
  `Opus` = arquitectura/refactor grande/debugging complejo. Nunca Opus para tweaks.
- Override "Ignora análisis, adelante" → respeta pero loguea riesgo brevemente
- Nueva ventana la decides tú: `/context-save` en un corte natural (nunca a mitad de una
  tarea larga) y sugiérela en el reporte; en la nueva ventana, `/context-restore`

## Permisos sin interrupciones (CRÍTICO)

Los permisos de desarrollo ya vienen preconfigurados en `.claude/settings.json`
(`allow`: tests, build, lint, git de lectura, artisan, composer, docker compose, curl
local, MCP del proyecto). `deny`: commit/push/deploy. `ask`: borrados masivos y
operaciones destructivas.

- NO pidas aprobación por adelantado en texto ni listes lecturas/escrituras/comandos:
  ejecuta.
- Si el sistema muestra un prompt de permiso, es del sistema: no lo dupliques.
- Si prevés varias operaciones fuera de la allow-list (instalar global, escribir fuera
  del repo), agrúpalas y avísalo en UNA línea; no las pidas una por una.
- Si un comando que usarás seguido sigue pidiendo permiso, sugiere en el reporte
  la regla `allow` exacta para añadirla.

## Rules

1. Read `context/project.md` first
2. Load only files needed for the current task (max 10)
3. Delegate to agents — never implement everything yourself
4. Write all outputs to `memory/` or project folders, not to conversation
5. Load `memory/architecture.md` SUMMARY section only (first 30 lines)
6. Load `context/decisions.md` first 30 lines only

## Auto-Learning

Trigger after: 3+ modules built, bug fixed and working, full feature done, or user says "perfecto/listo/done/works".

Si `memory/prompt-changelog.md` tiene entradas nuevas, añade UNA línea al final del reporte
(nunca a mitad de la tarea ni como pregunta que bloquee):
> 💡 Hay aprendizajes nuevos de Lupio OS: `bash .lupio/scripts/auto-contribute.sh`

No lo ejecutes tú: ese script hace push directo al repo central.

## Before Modifying System Files

Read `.lupio/SYSTEM_MAP.md` first — it maps every editable element to its exact file and section.
No need to scan all files; use the Quick Lookup table to navigate directly.

**IDE tip:** Select the target section in the editor before asking for a change — Claude receives
it as context and skips the file read.

## Locations

- System map: `.lupio/SYSTEM_MAP.md` ← start here when editing system files
- Agents: plugin `lupio-os` → subagentes `lupio-os:<name>` (ver con `/agents`)
- Commands: plugin `lupio-os` → `/lupio-os:<name>` o `/<name>` (ver con `/skills`)
- Los agentes/comandos/skills NO se editan en el proyecto: se editan en el repo `lupiodev/Lupio-os`
  y llegan a todos los proyectos al actualizar el plugin.
- Workflows: `.lupio/workflows/<name>.md`
- Prompts: `.lupio/prompts/context-template.md` ← template manual (fallback)
- Checkpoints: `.lupio/checkpoints/` ← snapshots automáticos vía `/context-save`
- Core modules: `.lupio/core/<module>/module.md`
- Context: `.lupio/context/project.md`, `decisions.md`
- Memory: `.lupio/memory/`

## Continuity Commands

- `/context-save` — guarda checkpoint (~1-2KB) con git state, decisiones, próximos pasos
- `/context-restore` — restaura el último checkpoint en nueva ventana sin reescanear el proyecto
