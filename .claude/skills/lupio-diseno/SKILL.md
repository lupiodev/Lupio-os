---
name: lupio-diseno
description: >-
  PRIORIDAD al diseñar cualquier interfaz en Lupio. Skill conductora: impone el
  orden jerárquico idea → diseño final y enruta a las skills de diseño en cada
  etapa. Úsala SIEMPRE que se vaya a diseñar, rediseñar o construir UI: una
  pantalla, página, landing, dashboard, panel admin, app, flujo, componente
  visual o "diséñame/hazme la interfaz de X". Disparadores: "diseña", "diseñar
  interfaz", "nueva UI", "rediseño", "pantalla", "página", "landing", "dashboard",
  "maqueta", "wireframe", "cómo se ve", "look and feel", "UI de".
---

# lupio-diseño — conductor de diseño de interfaces

Al diseñar una interfaz en Lupio, esta skill manda: **antes de escribir JSX/CSS
se avanza por etapas, en orden, sin saltarlas.** No se salta a "código bonito"
sin brief ni sistema. Prioridad de Lupio: **UX/UI excelente, sin sobre-ingeniería.**

Stack por defecto: Next.js + Tailwind + **shadcn/ui** (SvelteKit si el equipo lo
domina). CMS: Strapi/Medusa. Se apoya en los agentes `ux-reviewer` y `ui-reviewer`
y el comando `/review-ux`.

## Flujo jerárquico (idea → diseño final)

### 0. ¿Vale la pena? (si la idea es dudosa)
→ `lupio-abogado-diablo`. No diseñes algo que debería morir.

### 1. Idea → brief
Fija (una frase c/u): qué producto es, para quién, y el trabajo único de esta
pantalla. Si el brief no lo pinta, lo pintas tú y lo declaras.
→ **`frontend-design`** (sección "Ground it in the subject").

### 2. Arquitectura de información & flujos
Antes de pixeles: qué contenido/acciones hay, jerarquía, y el recorrido del
usuario. Valida fricción y casos vacíos/error.
→ agente `ux-reviewer` + `/review-ux`. Personas en `.lupio/memory/scope.md`.

### 3. Sistema de diseño (tokens)
Define ANTES de componer: paleta (4–6 hex nombrados), tipografía (display + body
+ utilitaria), escala de espaciado, radios, sombras, y el **elemento firma**.
→ **`frontend-design`** (proceso brainstorm→plan) + **`ui-ux-pro-max`** (reglas de
color/tipografía/contraste). Registra los tokens en el proyecto (Tailwind config /
CSS vars) y la decisión en `.lupio/context/decisions.md`.

### 4. Layout & wireframe
Concepto de layout en prosa + wireframe ASCII para comparar opciones antes de
codear. Mobile-first, grid consistente.
→ **`frontend-design`** + **`ui-ux-pro-max`** (layout & responsive).

### 5. Componentes (alta fidelidad)
Construye con shadcn/ui + Tailwind. Reutiliza antes de crear (revisa
`src/components/ui/`). Un solo lugar para la audacia; el resto, disciplinado.
→ **`frontend-design`** (restraint) + **`ui-ux-pro-max`** (errores comunes + checklist).

### 6. Motion & detalle
El pulido que hace que "se sienta bien". Micro-interacciones 150–300ms, animar
`transform`/`opacity`, respetar `prefers-reduced-motion`.
→ **`apple-design`** (motion físico/gestos) · **`improve-animations`** (auditar/plan) ·
**`animation-vocabulary`** (nombrar el efecto exacto).

### 7. Review & QA (puerta de salida)
No entregues sin auditar:
→ **`web-design-guidelines`** (audita el código UI vs. Web Interface Guidelines) +
agente `ui-reviewer` + checklist pre-entrega de **`ui-ux-pro-max`**.
Prueba con **Playwright** en 375/768/1280 (Self-QA del CLAUDE.md). Light y dark.

## Reglas del conductor
- **No saltar etapas.** Si el usuario pide "solo la pantalla ya", igual pasa por
  brief → tokens → layout → componentes (rápido, pero en orden).
- **Tokens antes que componentes.** Ningún color/tipo se decide dentro de un
  componente; sale del sistema de la etapa 3.
- **Evita los defaults de IA** (cream+serif+terracota / negro+acid-green /
  broadsheet). Ver `frontend-design`.
- **Planea con `lupio-plan`** el corte de implementación y espera OK antes de codear.
- **Cero sobre-ingeniería:** no design system de 200 tokens para una landing.
  Escala el sistema al tamaño del producto.

## Mapa rápido de skills de diseño
| Skill | Para |
|-------|------|
| `frontend-design` | Dirección visual, tipografía, estructura, proceso, copy |
| `ui-ux-pro-max` | Reglas profesionales + checklist pre-entrega |
| `apple-design` | Motion físico, gestos, materiales, profundidad |
| `improve-animations` | Auditar y planear mejoras de motion |
| `animation-vocabulary` | Nombrar un efecto de animación |
| `web-design-guidelines` | Auditar UI contra guidelines (accesibilidad/best practices) |
