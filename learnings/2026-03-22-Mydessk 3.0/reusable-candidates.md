# Reusable Candidates

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
- **Found In:** ExpiredQuotesModal.vue, DormantClientsModal.vue
- **Repetitions:** 2
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
