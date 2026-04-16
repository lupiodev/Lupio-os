# CONTEXTO LUPIO OS - [MÓDULO/FEATURE]

## 1. IDENTIFICACIÓN
- **Proyecto:** [Mydessk | Goldden | Reventi | Revo | Peiloop]
- **Módulo:** [Dashboard | Invoices | Clients | Auth | Commission Portal | etc.]
- **Objetivo:** [Descripción clara y breve de qué necesitas]
- **Sesión iniciada:** [Fecha/Hora]

---

## 2. SCOPE Y ARCHIVOS INVOLUCRADOS
### Archivos a modificar (estima cantidad)
```
src/modules/[module]/
├── components/         [~X archivos]
├── hooks/             [~X archivos]
├── types.ts           [1 archivo]
└── [module].layout.tsx [1 archivo]

src/shared/ui/         [~X archivos a referenciar]
```

### Estimación de contexto
- **Archivos únicos:** ~[X] (lee esto)
- **Líneas estimadas:** ~[X]
- **Tokens estimados entrada:** ~[X,XXX] (ballpark)
- **Tokens estimados salida:** ~[X,XXX]-[X,XXX]

---

## 3. DECISIONES PREVIAS (VIGENTES - NO CAMBIAR)

### Brand & Design
- **Paleta:** Navy (#0F172A) + Cyan (#06B6D4) + Grays (#1F2937, #374151, #D1D5DB)
- **Tipografía:** Inter 400/600/700 (sans-serif)
- **Espaciado:** Tailwind defaults (4px base unit)
- **Breakpoints:** Mobile-first | sm: 640px | md: 768px | lg: 1024px

### Componentes base (no refactorizar sin aviso)
- **Button:** [ubicación] — props: variant, size, disabled, loading
- **Card:** [ubicación] — props: className, children
- **Modal:** [ubicación] — props: isOpen, onClose, children
- **Input:** [ubicación] — props: label, error, placeholder, disabled

### APIs & Integración
- **Backend host:** [env variable / URL]
- **Auth method:** [JWT | OAuth | Session]
- **DB:** [PostgreSQL | MySQL] — no toques schema sin aviso
- **Rate limits:** [Si aplica]

### State Management
- **Global state:** [Zustand | Redux | Context — dónde y cómo]
- **API client:** [Axios | fetch | Tanstack Query — configuración]
- **Caching:** [Si hay estrategia, cuál es]

---

## 4. RESTRICCIONES (LÍNEAS ROJAS)

- [ ] No alterar contratos de API (breaking changes requieren backend first)
- [ ] No cambiar props públicas de componentes sin deprecation
- [ ] Mantener responsive en mobile (test en sm/md/lg)
- [ ] No introducir dependencias nuevas sin aprobación
- [ ] Performance: No agregar renders innecesarios
- [ ] Accesibilidad: ARIA labels en controles interactivos

---

## 5. CAMBIOS A REALIZAR

### Cambio 1: [Nombre corto]
**Descripción:** [Qué necesitas y por qué]
**Archivos afectados:** [List] ~[X] archivos
**Complejidad estimada:** [Baja | Media | Alta]
**Modelo recomendado:** [Sonnet | Opus]

### Cambio 2: [Nombre corto]
**Descripción:**
**Archivos afectados:** ~[X] archivos
**Complejidad estimada:**
**Modelo recomendado:**

---

## 6. CRITERIOS DE ÉXITO

- [ ] [Criterio 1 — observable, testeable]
- [ ] [Criterio 2]
- [ ] [Criterio 3]
- [ ] Sin breaking changes
- [ ] Responsive OK en mobile + desktop
- [ ] No warnings en console

---

## 7. HISTORIAL (OPCIONAL - para continuidad futura)

| Fecha | Cambio | Tokens | Modelo | Notas |
|-------|--------|--------|--------|-------|
| 2026-04-16 | [Cambio anterior] | ~5K | Sonnet | Completado OK |
| 2026-04-15 | [Cambio anterior] | ~12K | Opus | Arquitectura refactored |

---

## LISTO PARA INICIAR
Cuando hayas completado este template, responde: **"Contexto cargado. Analiza la viabilidad de los cambios antes de proceder."**
