# Prompt Changelog

## Change — 2026-03-21
Agent/Command: `.lupio/agents/backend-lead.md`
Type: improvement
Change: Agregar en sección de debugging: "Si el error es 'Unknown column X in where clause' pero la columna existe en `$fillable` y en una migración, ejecutar `php artisan migrate` — la migración probablemente no se ha corrido en esta instancia de DB."
Reason: Se perdió tiempo debuggeando `alternative_code` que tenía migración pero no estaba aplicada.
Status: PENDING

---

## Change — 2026-03-21
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: improvement
Change: Agregar regla: "En componentes con prop `readOnly: Boolean`, revisar que TODOS los controles interactivos (switches, radios, inputs, dropdowns) tengan `v-if="!readOnly"`. No es suficiente con omitir event handlers."
Reason: DocumentCalculator tenía SwitchDiscount con el guard pero SwitchTax sin él — bug en producción silencioso.
Status: PENDING

---

## Change — 2026-03-21
Agent/Command: `.lupio/workflows/frontend-module.md`
Type: addition
Change: Agregar sección "Documentos de solo lectura": "Vistas de documentos (View, Preview, Print) NUNCA deben usar controles de formulario (el-radio, el-checkbox, el-input) con v-model. Usar texto plano o componentes de display. Los controles de formulario en vistas de solo lectura confunden al usuario y pueden modificar el estado accidentalmente."
Reason: QuoteView e InvoiceView usaban el-radio con v-model para mostrar forma de pago en vista read-only.
Status: PENDING

---

## Change — 2026-03-21
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: addition
Change: Agregar patrón para responsive de documentos: "Para tablas de ítems en documentos, usar patrón dual: `d-none d-md-block` para tabla desktop + `d-block d-md-none` para tarjetas mobile. En mobile: nombre(bold, flex:1) + precio(bold, white-space:nowrap) en flex space-between, detalles en gris debajo."
Reason: Patrón aplicado exitosamente en QuoteView e InvoiceView — replicable en CreditNote, DebitNote, Liquidation.
Status: PENDING

---

## Change — 2026-03-21
Agent/Command: `.lupio/agents/backend-lead.md`
Type: addition
Change: Agregar patrón KPI con fallback: "Para métricas de período, si `count < threshold` retornar null y hacer fallback a 12 meses en la capa superior. Firma: `protected function metricInRange(Carbon $from, Carbon $to): ?float { ... if (count < 3) return null; ... }`"
Reason: Patrón de avgCloseDays con fallback resolvió "Sin datos suficientes" cuando había 260 registros históricos pero solo 2 en el mes actual.
Status: PENDING

---

## Change — 2026-03-22
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: critical-pattern
Change: Agregar regla: "Todo el-dialog y el-drawer que se renderice dentro de un card o componente con @click handler DEBE tener `append-to-body`. Sin esto, los clicks del modal se propagan al card padre causando navigation o flickering."
Reason: Bug de modales que aparecían y desaparecían en InvoiceOptionsByStatus. Root cause: modales dentro del DOM del card sin append-to-body.
Status: PENDING

---

## Change — 2026-03-22
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: critical-pattern
Change: Agregar regla: "Después de un `await` que modifique data reactiva (como cargar un modelo), SIEMPRE hacer `await this.$nextTick()` antes de abrir modales. El re-render de Vue puede interrumpir la apertura del modal."
Reason: getInvoice() modificaba this.invoice causando re-render que cerraba modales recién abiertos.
Status: PENDING

---

## Change — 2026-03-22
Agent/Command: `.lupio/agents/frontend-lead.md`
Type: bug-prevention
Change: Agregar regla: "NUNCA usar toggle (!value) para cerrar modales en @close handlers. Usar asignación directa: `true` para abrir, `false` para cerrar. El toggle puede causar loops si el modal emite close automáticamente."
Reason: InvoicePreview @close llamaba handleCommand que hacía toggle, creando un loop open→close.
Status: PENDING

---

## Change — 2026-03-22
Agent/Command: `.lupio/agents/backend-lead.md`
Type: pattern
Change: Agregar patrón PDF: "Crear un PdfGeneratorTrait con safePdfLoadView() que suprime warnings de dompdf. Usar template Blade unificado con datos normalizados para todos los documentos transaccionales."
Reason: dompdf 0.9 genera warnings con PHP 8.5 que se promueven a TypeError. Template unificado evita mantener 5 vistas diferentes.
Status: PENDING
