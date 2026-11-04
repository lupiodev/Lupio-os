# Prompt Changelog

## Change — 2026-09-24
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: addition (CRÍTICO — regla de oro, complementa la de deduplicación)
Change: "RESPUESTAS SILENCIADAS en handlers de vue-infinite-loading: un interceptor de Axios puede resolver una petición cancelada con una respuesta que PARECE exitosa pero viene vacía (en seshub, `src/config/Api.js` deduplica GETs y devuelve `Promise.resolve({ data: {} })`). Por eso: (1) destructurar SIEMPRE con fallback — `const { X } = response.data || {};`; (2) validar la forma antes de usarla — `if (!Array.isArray(X)) { $state.loaded(); return; }`, o el equivalente según el shape real (si `X` es un paginador, comprobar que sus campos no sean `undefined`); (3) resolver `$state` en TODOS los caminos, incluido el `catch`. Un `catch { return false; }` que se traga un TypeError deja `$state` sin resolver y el infinite-loading colgado PARA SIEMPRE: la lista no vuelve a cargar hasta recargar la página entera. Ojo: usar `$state.loaded()` y NO `$state.complete()` para una respuesta cancelada — `complete()` apaga el scroll infinito de forma permanente igual que el cuelgue."
Reason: 10 componentes de Ventas/Documentos en seshub quedaban colgados tras cualquier GET cancelado por deduplicación. Síntoma reportado: "creé el documento, dice que salió bien, pero no aparece hasta que recargo". El `catch { return false; }` ocultaba el TypeError, así que no había error visible en consola que delatara la causa. Fix verificado (lint limpio + compilación) y desplegado a PROD en `6d9fa79`.
Status: PENDING

---

## Change — 2026-09-24
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: addition
Change: "GUARD DE $refs antes de resetear infinite-loading: todo `this.$refs.infiniteLoading.stateChanger.reset()` va precedido de `if (!this.$refs.infiniteLoading) return;`. Estos resets suelen dispararse desde avisos de refresco con debounce o desde watchers de Vuex, y para cuando corren el componente puede haberse desmontado por navegación — el `$refs` ya es `undefined` y revienta. Aplica igual a cualquier `$refs.X.<método>()` invocado desde un callback diferido."
Reason: Mismo barrido en seshub. Las columnas de Ventas reciben el aviso de refresco con debounce vía la bandera Vuex `notification`; si el usuario navega fuera antes de que corra, el reset explota sobre un `$refs` vacío.
Status: PENDING

---

## Change — 2026-05-05
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: addition (CRÍTICO — regla de oro)
Change: "REGLA API PARAMS en *Columns.vue: SIEMPRE pasar `this.requestFilters` (no `this.searchFilters`) al hacer el API call. `searchFilters` es el estado crudo de UI que contiene `keyRangeDates`, `orderBy`, etc. que el backend no espera. `requestFilters` es el computed que filtra nulls y mapea solo los campos válidos."
Reason: WithholdingColumns enviaba searchFilters raw al API causando params inesperados; bug detectado en producción con filtros que parecían no funcionar.
Status: PENDING

---

## Change — 2026-05-05
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: addition (CRÍTICO — naming contract)
Change: "NAMING CONTRACT Vuex ↔ DrawerFilter: La clave en `documentFilters` del store DEBE ser `clientId` (no `client`). DrawerFilter emite `{ clientId }`. El action de Vuex MERGEA el estado — si el nombre difiere, ambas claves acumulan y el filtro nunca se limpia. Verificar en PR que el nombre emitido === nombre inicial en store."
Reason: Vuex tenía `client: ''` pero DrawerFilter emitía `clientId`, acumulando ambas claves en estado. Filtro de empresa no funcionaba en producción.
Status: PENDING

---

## Change — 2026-05-05
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: addition (z-index global)
Change: "Element UI z-index: `Vue.use(Element, { locale, zIndex: 2205 })` en main.js. Jerarquía: navbar(1020) → ipf-fullscreen(2100) → ipf-dropdown-menu(2200) → El overlay(2205) → El dialog(2206). NUNCA bajar zIndex del Element UI por debajo de 2205 en este proyecto."
Reason: Modal de anulación de factura aparecía detrás del panel fullscreen de preview (z-index 2100). Configuración global evita fijar z-index en cada modal individualmente.
Status: PENDING

---

## Change — 2026-03-21
Agent/Command: `.lupio/agents/backend-lead.md`
Type: improvement
Change: Agregar en sección de debugging: "Si el error es 'Unknown column X in where clause' pero la columna existe en `$fillable` y en una migración, ejecutar `php artisan migrate` — la migración probablemente no se ha corrido en esta instancia de DB."
Reason: Se perdió tiempo debuggeando `alternative_code` que tenía migración pero no estaba aplicada.
Status: APPLIED

---

## Change — 2026-03-21
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: improvement
Change: Agregar regla: "En componentes con prop `readOnly: Boolean`, revisar que TODOS los controles interactivos (switches, radios, inputs, dropdowns) tengan `v-if="!readOnly"`. No es suficiente con omitir event handlers."
Reason: DocumentCalculator tenía SwitchDiscount con el guard pero SwitchTax sin él — bug en producción silencioso.
Status: APPLIED

---

## Change — 2026-03-21
Agent/Command: `.lupio/workflows/frontend-module.md`
Type: addition
Change: Agregar sección "Documentos de solo lectura": "Vistas de documentos (View, Preview, Print) NUNCA deben usar controles de formulario (el-radio, el-checkbox, el-input) con v-model. Usar texto plano o componentes de display. Los controles de formulario en vistas de solo lectura confunden al usuario y pueden modificar el estado accidentalmente."
Reason: QuoteView e InvoiceView usaban el-radio con v-model para mostrar forma de pago en vista read-only.
Status: APPLIED

---

## Change — 2026-03-21
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: addition
Change: Agregar patrón para responsive de documentos: "Para tablas de ítems en documentos, usar patrón dual: `d-none d-md-block` para tabla desktop + `d-block d-md-none` para tarjetas mobile. En mobile: nombre(bold, flex:1) + precio(bold, white-space:nowrap) en flex space-between, detalles en gris debajo."
Reason: Patrón aplicado exitosamente en QuoteView e InvoiceView — replicable en CreditNote, DebitNote, Liquidation.
Status: APPLIED

---

## Change — 2026-03-21
Agent/Command: `.lupio/agents/backend-lead.md`
Type: addition
Change: Agregar patrón KPI con fallback: "Para métricas de período, si `count < threshold` retornar null y hacer fallback a 12 meses en la capa superior. Firma: `protected function metricInRange(Carbon $from, Carbon $to): ?float { ... if (count < 3) return null; ... }`"
Reason: Patrón de avgCloseDays con fallback resolvió "Sin datos suficientes" cuando había 260 registros históricos pero solo 2 en el mes actual.
Status: APPLIED

---

## Change — 2026-03-22
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: critical-pattern
Change: Agregar regla: "Todo el-dialog y el-drawer que se renderice dentro de un card o componente con @click handler DEBE tener `append-to-body`. Sin esto, los clicks del modal se propagan al card padre causando navigation o flickering."
Reason: Bug de modales que aparecían y desaparecían en InvoiceOptionsByStatus. Root cause: modales dentro del DOM del card sin append-to-body.
Status: APPLIED

---

## Change — 2026-03-22
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: critical-pattern
Change: Agregar regla: "Después de un `await` que modifique data reactiva (como cargar un modelo), SIEMPRE hacer `await this.$nextTick()` antes de abrir modales. El re-render de Vue puede interrumpir la apertura del modal."
Reason: getInvoice() modificaba this.invoice causando re-render que cerraba modales recién abiertos.
Status: APPLIED

---

## Change — 2026-03-22
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: bug-prevention
Change: Agregar regla: "NUNCA usar toggle (!value) para cerrar modales en @close handlers. Usar asignación directa: `true` para abrir, `false` para cerrar. El toggle puede causar loops si el modal emite close automáticamente."
Reason: InvoicePreview @close llamaba handleCommand que hacía toggle, creando un loop open→close.
Status: APPLIED

---

## Change — 2026-03-22
Agent/Command: `.lupio/agents/backend-lead.md`
Type: pattern
Change: Agregar patrón PDF: "Crear un PdfGeneratorTrait con safePdfLoadView() que suprime warnings de dompdf. Usar template Blade unificado con datos normalizados para todos los documentos transaccionales."
Reason: dompdf 0.9 genera warnings con PHP 8.5 que se promueven a TypeError. Template unificado evita mantener 5 vistas diferentes.
Status: APPLIED

---

## Change — 2026-03-27
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: improvement
Change: Agregar regla UI: "NUNCA usar fondo oscuro (#1e1c42) en headers de modales fullscreen. Usar fondo blanco/transparente con texto oscuro y boton X con fondo gris claro (#f0f1f5). El usuario rechaza consistentemente los headers oscuros."
Reason: Header oscuro en checkout modal fue rechazado 2 veces. El usuario prefiere interfaces limpias sin fondos de color.
Status: APPLIED

---

## Change — 2026-03-27
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: critical-pattern
Change: Agregar regla: "Cuando el-dialog fullscreen tiene display:none en el header por regla global (.el-dialog.is-fullscreen .el-dialog__header), agregar override especifico con selector mas especifico: `.mi-clase .el-dialog.is-fullscreen .el-dialog__header { display: block !important }`"
Reason: Se perdio tiempo debuggeando por que el header del checkout modal no aparecia — una regla global lo ocultaba con !important.
Status: APPLIED

---

## Change — 2026-03-27
Agent/Command: `.lupio/agents/ui-reviewer.md`
Type: addition
Change: Agregar regla de diseno: "El fondo global del body de la app debe ser $--color-bg-gray (#f7f8f9) — gris neutro sin tinte azul. Todas las vistas deben heredar este fondo. No usar #f6f9ff ni otros tonos azulados."
Reason: Se unifico el fondo de todas las secciones de la plataforma para consistencia visual.
Status: APPLIED

---

## Change — 2026-03-27
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: bug-prevention
Change: Agregar regla: "No confiar en invoice_interval del API para determinar tipo de plan. Derivar el tipo desde el slug: `slug.includes('-yearly') ? 'yearly' : 'month'`. El API puede retornar valores inconsistentes."
Reason: Todos los planes yearly mostraban "/ mes" porque invoice_interval del API no retornaba "year".
Status: APPLIED

---

## Change — 2026-04-01
Agent/Command: `installer/install.sh`
Type: critical-pattern
Change: Agregar paso al instalador que cree `.claude/commands/` con skills delegadores para cada comando en `claude/commands/`. Cada skill debe instruir a Claude a leer el agente + workflow correspondiente en runtime.
Reason: Los 13 comandos de Lupio OS nunca funcionaron como skills ejecutables. El puente `.lupio/commands/` → `.claude/commands/` debe ser automático en la instalación.
Status: APPLIED

---

## Change — 2026-04-01
Agent/Command: `.lupio/scripts/apply-update.sh`
Type: improvement
Change: Agregar sincronización de `.claude/commands/` al script de actualización. Después de actualizar `.lupio/`, regenerar los skills en `.claude/commands/` para reflejar cambios en agentes/workflows.
Reason: Si se agrega un nuevo comando o se modifica un agente, los skills de Claude Code deben actualizarse automáticamente sin intervención manual.
Status: APPLIED

---

## Change — 2026-04-01
Agent/Command: `.lupio/agents/orchestrator.md`
Type: addition
Change: Agregar regla: "Al inicio de sesión, verificar que `.claude/commands/` exista y contenga los 13 skills. Si falta alguno, regenerarlo desde `.lupio/commands/` usando el patrón skill-delegator."
Reason: Prevenir que sesiones futuras operen sin skills activos. Self-healing del sistema.
Status: APPLIED

---

## Change — 2026-04-03
Agent/Command: `.lupio/agents/backend-lead.md`
Type: critical-pattern
Change: Agregar regla: "En proyectos Laravel con API + Admin (Filament/Nova), el Authenticate middleware DEBE retornar JSON para rutas API, NUNCA redirect. El `redirectTo()` debe verificar `$request->is('api/*')` y retornar null para forzar 401 JSON. Sin esto, un token expirado causa 500 con HTML de Symfony en vez de 401 JSON, y el frontend muestra 'Error de conexión' porque Axios no puede parsear HTML."
Reason: Bug crítico en producción — `route('admin.login')` no existía, causando RouteNotFoundException 500. El frontend interpretaba el HTML como error de red y mostraba "Error de conexión. Verifica tu internet." en toda la app. Afecta TODOS los endpoints autenticados.
Status: APPLIED

---

## Change — 2026-04-03
Agent/Command: `.lupio/agents/backend-lead.md`
Type: critical-pattern
Change: Agregar regla: "Toda ruta API protegida por auth middleware DEBE probarse SIN token como parte del QA. Verificar que retorna 401 JSON limpio (`{\"message\":\"Unauthenticated.\"}`) y no un redirect HTML o 500. Comando de verificación: `curl -s -o /dev/null -w '%{http_code}' http://localhost:8000/api/ENDPOINT`"
Reason: El bug de Authenticate.php pasó desapercibido en QA porque solo se probaban endpoints con token válido. Los endpoints sin token devolvían 500 silenciosamente.
Status: APPLIED

---

## Change — 2026-04-07
Agent/Command: `.lupio/agents/backend-lead.md`
Type: critical-pattern
Change: Agregar regla: "El archivo `env` (o `.env`) NUNCA debe commitearse. Verificar que esté en `.gitignore` antes de hacer `git add`. Si aparece en `git status`, agregarlo a `.gitignore` inmediatamente."
Reason: El archivo `env` apareció como modified en git status del backend — riesgo de exponer credenciales.
Status: APPLIED

---

## Change — 2026-04-07
Agent/Command: `.lupio/agents/backend-lead.md`
Type: addition
Change: Agregar patrón de custom Mail Transport: "Para servicios de email no soportados nativamente en Laravel 8 (como Resend), crear custom Transport en `app/Mail/Transport/`. Registrar en AppServiceProvider via `Mail::extend()`. No depender de paquetes community si el transport es simple (POST a API con headers)."
Reason: La integración de Resend necesitó transport custom porque Laravel 8 no lo soporta nativamente.
Status: APPLIED

---

## Change — 2026-04-07
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: addition
Change: Agregar regla: "Para configuraciones complejas con múltiples secciones (templates, integraciones, preferencias), usar patrón de tabs separados — un componente por tab, lazy-loaded. No meter todo en un componente monolítico."
Reason: Templates de notificación se dividieron en TemplateDesign, TemplateDocuments, TemplateEmails como tabs — UX mucho más clara.
Status: APPLIED

---

## Change — 2026-04-09
Agent/Command: `.lupio/scripts/apply-update.sh`
Type: critical-pattern
Change: El script debe hacer merge inteligente en agentes: preservar secciones marcadas como "## *Rules — Mydessk*" o "## Project-Specific" y solo actualizar secciones base. Actualmente sobreescribe todo y se pierden lecciones del proyecto.
Reason: Después de cada `apply-update.sh` hay que re-aplicar `/update-knowledge` manualmente. Se perdieron 16+ lecciones aplicadas a 6 archivos.
Status: PENDING (requiere cambio en repo externo de Lupio OS)

---

## Change — 2026-04-09
Agent/Command: `.lupio/agents/backend-lead.md`
Type: addition
Change: Agregar regla: "Verificar `.gitignore` del backend antes de commitear. Si `git status -s` muestra más de 100 archivos, es probable que vendor/, storage/framework/, o node_modules/ estén siendo trackeados por error."
Reason: Backend mostró 782 archivos cambiados con -81,505 líneas — posible tracking de vendor/ o limpieza masiva accidental.
Status: APPLIED

---

## Change — 2026-04-10
Agent/Command: `.lupio/agents/devops-lead.md`
Type: critical-pattern
Change: Agregar regla: "En deploy Laravel, ejecutar `rm -f bootstrap/cache/packages.php bootstrap/cache/services.php` después de `composer install` y ANTES de cualquier `php artisan`. Un provider removido que sigue en el cache causa fallo en TODOS los artisan commands."
Reason: DKulyk\Nova\TabsServiceProvider removido pero en cache — cada artisan command fallaba con Class not found. rm directo resolvió lo que `php artisan cache:clear` no podía porque artisan mismo no arrancaba.
Status: APPLIED

---

## Change — 2026-04-10
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: critical-pattern
Change: Agregar regla: "Correr `npm run lint` localmente ANTES de hacer push. PdfViewer.vue tenía 6+ errores de prettier que requirieron 4 deploys fallidos para resolver uno a uno. Un solo `npm run lint --fix` local los habría resuelto todos."
Reason: Cada error de lint en CI requiere commit + cherry-pick + 3 min de build. Es 10x más costoso que detectarlo local.
Status: APPLIED

---

## Change — 2026-04-15
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: pattern
Change: Agregar patrón: "Para secciones con dual-view (analytics + listado), usar sub-tabs internos con estado local (`activeSubTab`) y `v-show`. No crear rutas separadas ni contaminar el estado global de tabs. Permite reusar componentes de otros módulos directamente."
Reason: Gastos en Reportes combinó GastosListView (ventas) + ExpensesReport con sub-tabs locales — cero duplicación, UX clara.
Status: APPLIED

---

## Change — 2026-04-03
Agent/Command: `.lupio/agents/qa-lead.md`
Type: addition
Change: Agregar al checklist de QA backend: "Test de respuesta sin autenticación — Para cada endpoint nuevo con auth, verificar que sin token devuelve 401 JSON (no 500, no HTML, no redirect). Si devuelve 500, revisar Authenticate.php middleware."
Reason: Error de conexión fantasma causado por 500 en Authenticate middleware. El QA nunca detectó este patrón porque solo testeaba con auth.
Status: APPLIED

---

## Change — 2026-04-17
Agent/Command: `.lupio/agents/orchestrator.md` + `.lupio/agents/backend-lead.md` + `.lupio/agents/devops-lead.md`
Type: critical-safety
Change: AGREGAR REGLA DE SEGURIDAD MÁXIMA: "NUNCA ejecutar operaciones irreversibles (DROP DATABASE, DELETE [sin WHERE], TRUNCATE, RESET, git reset --hard, rm -rf) sin aprobación explícita del usuario. SIEMPRE pedir autorización primero con descripción clara de QUÉ será eliminado y POR QUÉ. Si hay duda, tratar como producción y proteger."
Reason: Se ejecutó `DROP DATABASE mydessk_prod` sin permiso, perdiendo TODOS los datos reales de producción (usuarios, transacciones, historiales). El usuario tuvo que señalar manualmente que fue un error inaceptable. Esto es el peor error posible en un sistema.
Status: APPLIED

## 2026-04-18 — Regla: No modificar estilos sin pedirlo

**Contexto:** Se modificó el layout del modal de Copilot (de pantalla completa a modal centrado con bordes redondeados) sin que el usuario lo pidiera.

**Lección:** NUNCA modificar estilos, layout ni diseño visual si el usuario no lo pidió explícitamente. Solo arreglar exactamente lo que se reporta. Si algo "se ve mal", preguntar antes de cambiar el diseño general.

**Regla:** Cuando el usuario reporta un bug de UI, arreglar SOLO ese bug. No rediseñar el componente.

---

## Change — 2026-04-23
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: addition (critical)
Change: Regla obligatoria antes de commit Vue: "ANTES de `git commit`, correr `npx prettier --write <archivos>` y `grep -n 'console\.' <archivos>` — los builds de Amplify con `eslint-loader` + `no-console` rompen por `console.log/warn/error` olvidados o por indentación desalineada. Esta sesión tuvo 3 builds fallidos consecutivos por esto."
Reason: 4 builds de Amplify fallaron (198-200) por console statements y prettier warnings.
Status: PENDING

---

## Change — 2026-04-23
Agent/Command: `.lupio/agents/devops-lead.md` (o workflow devops)
Type: addition (critical)
Change: Regla para deploy.yml de CI/CD: "NUNCA incluir `php artisan db:seed --force` en el step de deploy. Los seeders son setup inicial. Correr seeders específicos solo manualmente con `db:seed --class=NombreSeeder --force`. El deploy automático SOLO corre `migrate --force`."
Reason: Seeder destructivo corrió en produccion + crash por ambiguous column.
Status: PENDING

---

## Change — 2026-04-23
Agent/Command: `.lupio/agents/backend-lead.md`
Type: addition
Change: Regla para operaciones post-response: "Sync pesados (N+1, llamadas externas, updateLastLogin) tras login/acciones críticas deben ir en `app()->terminating(function() use ($vars) { ... })` para no bloquear la respuesta. Previene 504 del ALB y errores CORS fantasma."
Reason: Hotfix 1b697267 en producción resolvió login timeout de 60s+ en usuarios con 1000+ clientes.
Status: PENDING

---

## Change — 2026-04-23
Agent/Command: `.lupio/agents/backend-lead.md`
Type: addition
Change: Regla para seeders con queries JOIN: "Cuando un seeder use `$model->relation()->pluck('column')` y la relación sea BelongsToMany (con pivot), SIEMPRE calificar la tabla: `pluck('tabla_principal.column')`. La columna `id` es ambigua sin calificar por el JOIN con la pivot."
Reason: ConnectRelationshipsSeeder falló con "Column 'id' is ambiguous" en permissions ↔ permission_role.
Status: PENDING

---

## Change — 2026-05-01
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: addition (CRÍTICO — regla de oro)
Change: "REGLA DE ORO — Infinite scroll con vue-infinite-loading: En page > 1, NUNCA hacer push directo. SIEMPRE: `const existingIds = new Set(array.map(x => x.id)); const newItems = data.filter(i => !existingIds.has(i.id)); if (newItems.length === 0) { $state.complete(); return; } newItems.forEach(i => array.push(i));` — Esto previene duplicados cuando el API devuelve la misma página repetida. Este patrón NO debe removerse ni simplificarse bajo ninguna circunstancia."
Reason: Bug crítico en módulo Ventas — 9 tipos de documento repetían registros infinitamente al scrollear. Fix probado y verificado por usuario.
Status: PENDING

---

## Change — 2026-05-01
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: addition
Change: "requestFilters() computed: NUNCA retornar objeto con claves null/undefined. Usar: `const f = {}; if (val) f.key = val; return f;` — Parámetros null en Axios causan paginación errática en el backend."
Reason: Filtros null enviados al API causaban resultados impredecibles en módulo Ventas.
Status: PENDING

---

## Change — 2026-05-01
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: addition
Change: "Sort default de listas de documentos: SIEMPRE por created_at descendente cuando no hay orderBy explícito. La API ordena por ID y los documentos pueden tener fechas retroactivas. Agregar al final del sort comparator: `const dA = a.created_at ? new Date(a.created_at) : new Date(0); const dB = b.created_at ? new Date(b.created_at) : new Date(0); return dB - dA;`"
Reason: Meses mezclados en listados de Ventas por ordenamiento por ID en lugar de fecha del documento.
Status: PENDING

---
Fecha: 2026-10-25
Agent/Command: `.lupio/agents/devops-lead.md`
Type: addition
Change: "Antes de crear un vhost HTTPS en un servidor existente, inspeccionar cómo se atiende el 443 (`ss -ltnp`, `nginx -T | grep -n listen`). Si hay un `stream` con `ssl_preread`, el vhost va en el puerto interno (8443) y el dominio se registra en el map de dominios conocidos; certbot se usa con `certonly` para que no reescriba el vhost."
Reason: En mydessk-app-DEV el 443 es un stream por SNI; `certbot --nginx` escribió `listen 443`, nginx no pudo recargar y el ambiente nuevo quedó sin HTTPS durante varios deploys.
Status: PENDING

---
Fecha: 2026-10-25
Agent/Command: `.lupio/agents/devops-lead.md`
Type: addition
Change: "Todo bootstrap de deploy mide el disco antes de construir (`df -m /`), aborta por debajo de un umbral (1,5 GB para Next) y nunca ejecuta dos builds en la misma corrida (no re-ejecutar el script tras certbot). Los `.env` copiados deben ser legibles por el usuario de php-fpm (www-data), no 600 de root."
Reason: Un build doble llenó el disco de DEV (19 GB) y tumbó develop.crm; un `.env` 600 de root hizo que Laravel arrancara sin APP_KEY y respondiera 500.
Status: PENDING

## 2026-10-25 — Tramo 4 CRM unificado (PENDING)
- Agentes paralelos sobre el mismo working tree: preparar ANTES los archivos compartidos (proxies, middleware, navegación) y un archivo de reglas comunes; cada agente con carpetas propias. Funcionó con 6 agentes sin conflictos.
- La QA real en el ambiente copia encontró dos bugs que ningún agente vio sin navegador (FK a la tabla equivocada y fachada de librería de otra versión): siempre probar el flujo de guardado de punta a punta tras portar.
- En Laravel 8 de este proyecto `db:seed --class` exige el namespace completo.

## 2026-11-03 — Requisitos de firma electrónica (KYC) en CRM nuevo + Filament (PENDING)
- Agent/Command: `.lupio/agents/qa-lead.md` — Type: addition — Change: "Para QA de acciones de Filament 3 sin contraseña: script PHP que arranca el kernel, fija el panel (`Filament::setCurrentPanel`), hace `Auth::guard('web')->setUser(admin)` y usa `Livewire::test(Page::class, ['record'=>id])->callAction(...)`; para páginas GET, enlazar el request (`$app->instance('request', $req)`) antes de setUser." Reason: permitió probar lista, detalle, descargas y cambio de estado del admin sin login manual.
- Agent/Command: `.lupio/agents/backend-lead.md` — Type: addition — Change: "Al generar tokens Passport desde scripts en PHP 8.5, los avisos Deprecated salen por stdout y contaminan el token: filtrar con `grep -oE 'eyJ[A-Za-z0-9_.-]+'` o `error_reporting(E_ALL & ~E_DEPRECATED)`. En Mydessk, `User::isAdmin()` es el rol de laravel-roles (no hay columna is_admin)." Reason: se perdió tiempo con 401 por un token corrupto y una consulta a una columna inexistente.
- Agent/Command: `.lupio/agents/backend-lead.md` — Type: addition — Change: "Documentos sensibles subidos por clientes (cédulas, selfies): disco privado configurable, nunca `public`; servirlos solo por una ruta que verifique admin; validar `mimes` del lado servidor (revisa contenido real) y limitar tamaño por archivo pensando en post_max_size del servidor." Reason: flujo KYC de firma; el backend rechazó correctamente archivos con extensión falsa.
