---
name: ui-ux-pro-max
description: >-
  Reglas de UI/UX profesional listas para aplicar: prioridades (accesibilidad,
  interacción táctil, performance, layout, tipografía/color, animación), errores
  comunes que hacen ver una interfaz amateur, y checklist pre-entrega. Úsala al
  construir o revisar componentes/páginas: botones, modales, navbar, sidebar,
  cards, tablas, forms, dashboards, landing. Disparadores: "diseñar UI",
  "componente", "revisar interfaz", "accesibilidad", "hover", "dark mode",
  "responsive", "checklist de UI".
---

# UI/UX Pro Max — reglas de interfaz profesional (adaptado a Lupio)

> Adaptado de [WAAMEngineer/ui-ux-pro-max](https://github.com/WAAMEngineer/ui-ux-pro-max-skill)
> (MIT). Esta versión conserva la inteligencia estática de reglas y checklist;
> se omitió el motor de búsqueda CLI/Python + CSVs para no inflar cada proyecto.
> Si necesitas la base de datos completa (50 estilos, 97 paletas, 57 pairings de
> fuentes, etc.), consulta el repo original. Ver `ATTRIBUTION.md`.

Reglas frecuentemente olvidadas que separan una UI profesional de una amateur.
Aplican al stack Lupio (Tailwind/shadcn sobre React/Next/SvelteKit).

## Prioridades (revisa en este orden)
| # | Categoría | Impacto |
|---|-----------|---------|
| 1 | Accesibilidad | CRÍTICO |
| 2 | Interacción táctil | CRÍTICO |
| 3 | Performance | ALTO |
| 4 | Layout & responsive | ALTO |
| 5 | Tipografía & color | MEDIO |
| 6 | Animación | MEDIO |
| 7 | Selección de estilo | MEDIO |

### 1. Accesibilidad (CRÍTICO)
- Contraste ≥ 4.5:1 en texto normal, 3:1 en texto grande.
- Focus ring visible en todo elemento interactivo (nada de `outline: none` sin reemplazo).
- `alt` descriptivo en imágenes con significado; `aria-label` en botones solo-icono.
- Orden de tabulación = orden visual. `<label for>` en todos los inputs.

### 2. Interacción táctil (CRÍTICO)
- Touch target mínimo 44×44px.
- `cursor-pointer` en todo lo clickable (incluidas cards).
- Deshabilita el botón durante operaciones async (evita doble submit).
- Feedback de error claro y cerca del problema.

### 3. Performance (ALTO)
- Imágenes: WebP/AVIF, `srcset`, lazy loading. En Next usa `next/image`.
- Respeta `prefers-reduced-motion`.
- Reserva espacio para contenido async (evita layout shift / CLS).

### 4. Layout & responsive (ALTO)
- Probar en **375 / 768 / 1280** (viewports estándar de Lupio; ver Self-QA en CLAUDE.md).
- Texto de cuerpo ≥ 16px en móvil. Sin scroll horizontal.
- Escala de z-index definida (10/20/30/50), no números mágicos.
- `max-width` de contenedor consistente en todo el sitio.

### 5. Tipografía & color (MEDIO)
- `line-height` 1.5–1.75 en cuerpo. Longitud de línea 65–75 caracteres.
- Empareja personalidades de fuente heading/body (ver `frontend-design`).

### 6. Animación (MEDIO)
- Micro-interacciones 150–300ms. Anima `transform`/`opacity`, nunca `width`/`height`.
- Estados de carga: skeleton o spinner. (Profundiza con `apple-design`/`improve-animations`.)

## Errores comunes que hacen ver amateur una UI
| Regla | Haz | No hagas |
|-------|-----|----------|
| Iconos | SVG (Lucide/Heroicons) | Emojis 🎨🚀 como iconos |
| Hover | Transición de color/opacidad | `scale` que desplaza el layout |
| Cursor | `cursor-pointer` en clickables | Cursor default en interactivos |
| Transiciones | `transition-colors duration-200` | Cambios instantáneos o >500ms |
| Glass en light | `bg-white/80`+ | `bg-white/10` (invisible) |
| Texto light | slate-900 `#0F172A` | slate-400 en cuerpo |
| Bordes light | `border-gray-200` | `border-white/10` (invisible) |
| Navbar flotante | `top-4 left-4 right-4` | Pegada a `top-0` sin aire |

## Checklist pre-entrega (no reportes "listo" sin esto)
**Visual:** sin emojis-icono · set de iconos consistente · logos correctos ·
hover sin layout shift.
**Interacción:** `cursor-pointer` en clickables · feedback de hover · transiciones
150–300ms · focus visible por teclado.
**Light/Dark:** contraste ≥4.5:1 en light · elementos glass visibles en light ·
bordes visibles en ambos modos · probar los dos.
**Layout:** elementos flotantes con aire · nada oculto tras navbars fijos ·
responsive 375/768/1280 · sin scroll horizontal en móvil.
**Accesibilidad:** alt en imágenes · labels en inputs · el color no es el único
indicador · `prefers-reduced-motion` respetado.

Esto complementa el Self-QA del CLAUDE.md y la auditoría de `web-design-guidelines`.
