# Reusable Candidates

## columns-api-params-contract — 2026-05-05
- **Type:** frontend rule (Vue 2 pattern)
- **Found In:** Todos los `*Columns.vue` del módulo Ventas (9 archivos)
- **Seen:** 9
- **Description:** En cualquier `*Columns.vue`, el API call usa `this.requestFilters` (computed que retorna solo campos con valor, sin nulls). NUNCA usar `this.searchFilters` directamente. Bug crítico: WithholdingColumns enviaba `keyRangeDates`, `orderBy`, `clientId` al backend que no los esperaba.
- **Extraction Complexity:** low
- **Recommended Action:** Regla obligatoria para cualquier nuevo Column component. Revisar en code review.
- **Status:** CANDIDATE

## vuex-filter-key-alignment — 2026-05-05
- **Type:** architecture rule (Vuex + component contract)
- **Found In:** `store/index.js` documentFilters + `DrawerFilter.vue`
- **Seen:** 1 (crítico)
- **Description:** La clave del filtro de empresa en `documentFilters` del store DEBE llamarse igual que la que emite el componente. Vuex action MERGEA estado — si nombres difieren, ambas claves coexisten indefinidamente. Nombre correcto: `clientId` (como emite DrawerFilter). Verificar con grep antes de renombrar cualquier campo de filtro.
- **Extraction Complexity:** low
- **Recommended Action:** Añadir comentario en store/index.js documentando el contrato de naming.
- **Status:** CANDIDATE

## element-ui-zindex-hierarchy — 2026-05-05
- **Type:** config rule (Element UI + CSS z-index)
- **Found In:** `src/main.js` + `InvoicePreview.vue`
- **Seen:** 1 (proyecto-wide)
- **Description:** Jerarquía fija de z-index: navbar(1020) → ipf-fullscreen(2100) → ipf-dropdown-menu(2200) → El overlay(2205) → El dialog(2206). Configurar `Vue.use(Element, { locale, zIndex: 2205 })` en main.js. No tocar sin actualizar toda la jerarquía.
- **Extraction Complexity:** low
- **Recommended Action:** Documentar en CLAUDE.md o architecture.md como regla fija del proyecto.
- **Status:** CANDIDATE

---

## doc-mobile-card — 2026-03-21
- **Type:** component
- **Found In:** QuoteView.vue, InvoiceView.vue (idéntico)
- **Repetitions:** 2
- **Description:** Layout de ítem de documento para mobile. Nombre bold izquierda + precio bold derecha en misma línea (flexbox space-between). Cantidad×precio en gris debajo si qty>1. Detalle/descripción en gris debajo.
- **Extraction Complexity:** low
- **Recommended Action:** extract → `DocumentItemMobile.vue` con props: `name`, `total`, `quantity`, `unitPrice`, `detail`
- **Status:** CANDIDATE
- **Files:** `seshub/src/modules/dashboard/sales/pages/quotes/pages/QuoteView.vue`, `seshub/src/modules/dashboard/sales/pages/invoices/pages/InvoiceView.vue`

---

## custom-fullscreen-modal — 2026-03-21
- **Type:** component
- **Found In:** ExpiredQuotesModal.vue, DormantClientsModal.vue, OverdueInvoicesModal.vue
- **Seen:** 5+
- **Description:** Modal fullscreen custom (no usa el-dialog). Overlay fixed z-index 9999, contenedor flex column, header sticky con título+X, filtros sticky debajo, body flex:1 overflow-y:auto, bulk-bar o footer sticky bottom. Cierre con Escape y click en overlay.
- **Extraction Complexity:** medium
- **Recommended Action:** extract → `FullscreenModal.vue` con slots: header, filters, body, footer
- **Status:** CANDIDATE
- **Files:** `seshub/src/modules/dashboard/reports/components/ExpiredQuotesModal.vue`, `seshub/src/modules/dashboard/reports/components/DormantClientsModal.vue`

---

## kpi-fallback-pattern — 2026-03-21
- **Type:** utility / backend pattern
- **Found In:** DashboardService.php → `avgCloseDays()`, `getFunnel()`
- **Repetitions:** 2
- **Description:** Si una métrica calculada en el período seleccionado tiene datos insuficientes (count < threshold), hacer fallback a los últimos 12 meses. Retorna null si no hay datos en ningún período.
- **Extraction Complexity:** low
- **Recommended Action:** document — patrón a incluir en template de `generate-backend-module` para KPIs
- **Status:** CANDIDATE
- **Files:** `seshub-backend/app/Services/DashboardService.php`

---

## nested-modal-zindex — 2026-03-21
- **Type:** utility / CSS pattern
- **Found In:** BulkMessageModal.vue sobre ExpiredQuotesModal, DormantClientsModal
- **Repetitions:** 2
- **Description:** Cuando un `el-dialog` (Element UI) debe aparecer sobre un modal custom con z-index 9999: usar `append-to-body` en el-dialog + bloque `<style>` no-scoped con clase única → `z-index: 10001 !important`. El overlay del modal custom actúa como backdrop.
- **Extraction Complexity:** low
- **Recommended Action:** document — agregar como nota en template de modales
- **Status:** CANDIDATE
- **Files:** `seshub/src/modules/dashboard/reports/components/BulkMessageModal.vue`

---

## readonly-control-guard — 2026-03-21
- **Type:** pattern / Vue 2
- **Found In:** DocumentCalculator.vue (SwitchTax, SwitchDiscount)
- **Repetitions:** 2+ (encontrado en SwitchDiscount pero faltaba en SwitchTax)
- **Description:** En componentes Vue 2 con prop `readOnly`, todos los controles interactivos (switches, inputs, dropdowns) deben tener `v-if="!readOnly"`. No asumir que la ausencia de eventos es suficiente — el control sigue renderizando y confunde al usuario final.
- **Extraction Complexity:** low
- **Recommended Action:** document — regla en checklist de code review
- **Status:** CANDIDATE
- **Files:** `seshub/src/modules/dashboard/sales/components/DocumentCalculator.vue`

---

## carousel-responsive-grid — 2026-03-27
- **Type:** pattern / CSS
- **Found In:** plans/pages/Main/Main.scss
- **Seen:** 1
- **Description:** CSS grid en desktop (4 cols), carousel horizontal con scroll-snap en tablet/mobile (<=1024px). Items con flex: 0 0 300px, scroll-snap-align: center, scrollbar oculto. Padding-top extra para badges absolutos que hacen overflow.
- **Extraction Complexity:** low
- **Recommended Action:** document — agregar como patron CSS reutilizable para cualquier grid de cards que necesite ser carousel en mobile
- **Status:** CANDIDATE
- **Files:** `seshub/src/modules/dashboard/plans/pages/Main/Main.scss`

---

## skeleton-card-shimmer — 2026-03-27
- **Type:** component
- **Found In:** PlanCardSkeleton.vue, NotificationDrawer.vue
- **Seen:** 2
- **Description:** Componente skeleton con shimmer animation (linear-gradient 200% animado). Replica la estructura visual del card real con bloques grises redondeados. Keyframe `shimmer` 1.5s infinite. Colores: #f0f2f7 base, #e8ecf5 highlight.
- **Extraction Complexity:** low
- **Recommended Action:** extract — crear mixin SCSS `@mixin shimmer-block` reutilizable para cualquier skeleton
- **Status:** CANDIDATE
- **Files:** `seshub/src/modules/dashboard/plans/components/PlanCardSkeleton.vue`, `seshub/src/components/NotificationDrawer.vue`

---

## slug-based-type-derivation — 2026-03-27
- **Type:** pattern / data
- **Found In:** plans/store/index.js, PlanCard.vue
- **Seen:** 2
- **Description:** Derivar el tipo de plan (monthly/yearly) desde el slug (`-yearly` suffix) en lugar de confiar en invoice_interval del API, que puede retornar valores incorrectos. Patron: `slug.includes('-yearly') ? 'yearly' : 'month'`.
- **Extraction Complexity:** low
- **Recommended Action:** document — regla para el store de planes
- **Status:** CANDIDATE
- **Files:** `seshub/src/modules/dashboard/plans/store/index.js`, `seshub/src/modules/dashboard/plans/components/PlanCard.vue`

---

## skill-delegator-pattern — 2026-04-01
- **Type:** pattern / meta
- **Found In:** .claude/commands/ (13 archivos)
- **Seen:** 13
- **Description:** Skill de Claude Code que no hardcodea lógica sino que instruye a Claude a leer el agente (`.lupio/agents/*.md`) + workflow (`.lupio/workflows/*.md`) correspondiente en runtime. Mantiene sincronización automática: si actualizas el agente, el skill refleja los cambios sin edición manual.
- **Extraction Complexity:** low
- **Recommended Action:** document — incluir como patrón estándar en el instalador de Lupio OS para generar `.claude/commands/` automáticamente
- **Status:** CANDIDATE
- **Files:** `.claude/commands/*.md`

---

## multi-channel-notification — 2026-04-07
- **Type:** pattern / architecture
- **Found In:** NotificationService.php, WhatsAppService.php, BulkEmailController.php
- **Seen:** 2
- **Description:** NotificationService como dispatcher central + canales (email, WhatsApp, push) como strategies independientes. Cada canal tiene su propio Job asíncrono, modelo de log, y configuración tenant-level.
- **Extraction Complexity:** medium
- **Recommended Action:** document — patrón arquitectónico para template de backend-module con notificaciones
- **Status:** CANDIDATE
- **Files:** `seshub-backend/app/Services/NotificationService.php`, `seshub-backend/app/Services/WhatsAppService.php`

---

## admin-tenant-config-split — 2026-04-07
- **Type:** pattern / architecture
- **Found In:** WhatsappPlatformConfig (admin), UserBusinessConfigWhatsApp (tenant), IntegrationSetting
- **Seen:** 3
- **Description:** Configuración de plataforma (credenciales API, settings globales) separada de configuración de negocio (preferencias por tenant). Admin configura en Filament, tenant configura en su dashboard. Patrón aplicable a cualquier integración third-party.
- **Extraction Complexity:** low
- **Recommended Action:** document — patrón para generate-backend-module cuando involucre integraciones externas
- **Status:** CANDIDATE
- **Files:** `seshub-backend/app/Models/WhatsappPlatformConfig.php`, `seshub-backend/app/Models/UserBusinessConfigWhatsApp.php`

---

## document-signing-flow — 2026-04-09
- **Type:** pattern / architecture
- **Found In:** DocumentService, SignatureService, PdfStampingService, Document models
- **Seen:** 1
- **Description:** Modelo Document → Signers → AuditLog con estados (draft, pending, signed, declined, expired). Flujo público con token único para firma sin auth. PdfStampingService estampa firma visual + hash SHA-256 + timestamp + IP.
- **Extraction Complexity:** high
- **Recommended Action:** document — patrón completo para generate-backend-module de firma electrónica
- **Status:** CANDIDATE
- **Files:** `seshub-backend/app/Services/DocumentService.php`, `seshub-backend/app/Services/SignatureService.php`

---

## admin-impersonation — 2026-04-09
- **Type:** pattern / security
- **Found In:** ImpersonateController, AdminImpersonation model
- **Seen:** 1
- **Description:** Permite a admins operar como usuarios con trazabilidad completa. Genera token temporal, registra inicio/fin en AdminImpersonation, y logea todas las acciones durante la sesión impersonada.
- **Extraction Complexity:** low
- **Recommended Action:** document — patrón para cualquier SaaS que necesite soporte admin
- **Status:** CANDIDATE
- **Files:** `seshub-backend/app/Http/Controllers/API/Admin/ImpersonateController.php`

---

## ai-usage-metering — 2026-04-09
- **Type:** pattern / architecture
- **Found In:** AiService, AiFeatureConfig, AiPlanLimit, AiUsageLog, AiLimitExceededException
- **Seen:** 1
- **Description:** Sistema de metering de AI por plan y feature. AiFeatureConfig define features habilitadas, AiPlanLimit define límites por plan (requests/día, tokens/mes), AiUsageLog registra cada uso. AiLimitExceededException se lanza al exceder límite. Configurable desde Filament (AiSettings).
- **Extraction Complexity:** medium
- **Recommended Action:** extract — patrón reutilizable para cualquier SaaS con AI integrado y planes de suscripción
- **Status:** CANDIDATE
- **Files:** `seshub-backend/app/Services/AiService.php`, `seshub-backend/app/Models/AiPlanLimit.php`

---

## copilot-architecture — 2026-04-09
- **Type:** pattern / full-stack
- **Found In:** CopilotService, CopilotController, CopilotChat.vue, CopilotModal.vue, CopilotSidebar.vue, copilot.js store
- **Seen:** 1
- **Description:** Backend: CopilotService (sessions + messages + contexto) + AiService (ejecución). Frontend: Vuex store + 3 componentes UI (Chat, Modal, Sidebar). Sessions persisten conversación, messages guardan historial para contexto.
- **Extraction Complexity:** high
- **Recommended Action:** document — patrón completo para cualquier app que quiera copilot AI integrado
- **Status:** CANDIDATE
- **Files:** `seshub-backend/app/Services/CopilotService.php`, `seshub/src/components/Copilot/`

---

## deploy-bootstrap-cache-clear — 2026-04-10
- **Type:** pattern / devops
- **Found In:** seshub-backend/.github/workflows/deploy.yml
- **Seen:** 1
- **Description:** En deploy Laravel, `rm -f bootstrap/cache/packages.php bootstrap/cache/services.php` debe ejecutarse después de `composer install` y ANTES de cualquier `php artisan`. Sin esto, si hay un provider removido en el composer pero todavía en el cache, todos los artisan commands fallan con "Class not found".
- **Extraction Complexity:** low
- **Recommended Action:** document — agregar como paso estándar en template de deploy Laravel
- **Status:** CANDIDATE
- **Files:** `seshub-backend/.github/workflows/deploy.yml`

---

## internal-subtabs — 2026-04-15
- **Type:** pattern / Vue 2 / UX
- **Found In:** reports/pages/Main.vue (expenses section)
- **Seen:** 1
- **Description:** Sub-tabs internos dentro de un tab principal usando estado local (`expensesSubTab`). Botones con `border-bottom` indicator de color primario, `v-show` para preservar estado al cambiar. No requiere router, no contamina estado global. Permite combinar vista analytics + listado en una sola sección.
- **Extraction Complexity:** low
- **Recommended Action:** document — patrón para cualquier sección con dual-view (charts + tabla)
- **Status:** CANDIDATE
- **Files:** `seshub/src/modules/dashboard/reports/pages/Main.vue`

---

## filament-test-connection — 2026-04-10
- **Type:** pattern / backend / Filament
- **Found In:** AiSettings.php
- **Seen:** 1
- **Description:** Método `testConnection()` en Filament Page que envía request mínimo a API externa con la key configurada y muestra Notification success/danger con el resultado. Patrón reutilizable para validar cualquier integración (Anthropic, Resend, WhatsApp, etc.) sin salir del panel admin.
- **Extraction Complexity:** low
- **Recommended Action:** document — patrón para cualquier Filament settings page con integración externa
- **Status:** CANDIDATE
- **Files:** `seshub-backend/app/Filament/Pages/AiSettings.php`

---

## deferred-post-response-sync — 2026-04-23
- **Type:** backend pattern
- **Found In:** AuthController@login (sync notificaciones post-login)
- **Seen:** 2+ (login, potencialmente otros endpoints con sync pesado)
- **Description:** Mover operaciones pesadas (sync N+1, updateLastLogin) dentro de `app()->terminating(function() use ($user) { ... })` para que corran después de enviar response. Evita 504 timeouts del ALB que stripean headers CORS.
- **Extraction Complexity:** low
- **Recommended Action:** documentar como regla en backend-lead.md — cualquier sync >1s post-acción debe ir en `terminating()`
- **Status:** CANDIDATE
- **Files:** `seshub-backend/app/Http/Controllers/API/Auth/AuthController.php`

---

## fail-open-ai-logging — 2026-04-23
- **Type:** backend pattern
- **Found In:** AiService@call, AiService@checkGlobalAiCredits
- **Seen:** 2
- **Description:** Wrappear operaciones auxiliares (logUsage, checkLimit) en try/catch dentro del flow principal para que FK constraints, DB outages, o errores menores no traguen la respuesta principal.
- **Extraction Complexity:** low
- **Recommended Action:** regla en backend-lead.md — logging y métricas siempre fail-open, nunca fail-closed
- **Status:** CANDIDATE
- **Files:** `seshub-backend/app/Services/AiService.php`

---

## infinite-scroll-dedup — 2026-05-01
- **Type:** frontend pattern (Vue 2 / Infinite Loading)
- **Found In:** InvoiceColumns, QuoteColumns, PaymentColumns, WithholdingColumns, CreditNoteColumns, DebitNoteColumns, LiquidationColumns, RemissionColumns (9 archivos)
- **Seen:** 9 (todos los módulos de documentos Ventas)
- **Description:** Al paginar con vue-infinite-loading, NUNCA hacer `push` directo. Siempre construir `new Set(this.array.map(x => x.id))`, filtrar los nuevos items contra ese Set, y si `newItems.length === 0` llamar `$state.complete()`. Esto previene duplicados cuando el API devuelve la misma página repetida (paginación incorrecta o pocos resultados filtrados).
- **Extraction Complexity:** low
- **Recommended Action:** Aplicar este patrón a CUALQUIER componente nuevo que use infinite-loading. Mover a mixin o composable si el proyecto crece.
- **Status:** CANDIDATE
- **Files:** `seshub/src/modules/dashboard/sales/pages/*/components/*Columns.vue`

---

## default-date-sort — 2026-05-01
- **Type:** frontend pattern (Vue 2 computed sort)
- **Found In:** Todos los filterXxx() computed en módulo Ventas (9 archivos)
- **Seen:** 9
- **Description:** El sort por defecto de un listado de documentos SIEMPRE debe ser por fecha descendente (`created_at` desc). La API ordena por ID que no coincide con fecha cuando los documentos tienen fechas retroactivas. El `filterXxx()` computed debe terminar con: `const dateA = a.created_at ? new Date(a.created_at) : new Date(0); return dateB - dateA;`
- **Extraction Complexity:** low
- **Recommended Action:** Regla para todos los nuevos módulos de documentos.
- **Status:** CANDIDATE
- **Files:** `seshub/src/modules/dashboard/sales/pages/*/components/*Columns.vue`

---

## request-filters-null-clean — 2026-05-01
- **Type:** frontend pattern (API params)
- **Found In:** requestFilters() computed en todos los *Columns.vue de Ventas
- **Seen:** 9
- **Description:** El computed `requestFilters()` NUNCA debe retornar un objeto con claves de valor `null`/`undefined`. Usar construcción condicional: `const filters = {}; if (value) filters.key = value; return filters;`. Enviar `null` en params de Axios puede causar que el API ignore filtros o devuelva resultados inesperados.
- **Extraction Complexity:** low
- **Recommended Action:** Regla obligatoria para cualquier computed que construya parámetros de API.
- **Status:** CANDIDATE
- **Files:** `seshub/src/modules/dashboard/sales/pages/*/components/*Columns.vue`
