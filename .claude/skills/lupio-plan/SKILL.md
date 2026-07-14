---
name: lupio-plan
description: >-
  Las preguntas antes de construir en Lupio. Úsala ANTES de escribir código en
  cualquier feature, cambio o tarea no trivial: planear, diseñar el enfoque,
  "cómo lo hago", "qué approach", estimar, romper una tarea en pasos.
  Disparadores: "cómo implemento", "plan", "vamos a hacer X", "necesito una
  feature", "refactor", "antes de empezar", "propón un enfoque". Produce un plan
  en pasos pequeños y reversibles; espera OK antes de tocar código.
---

# lupio-plan

Pensar antes de construir. El objetivo no es un plan bonito: es no construir lo
que no había que construir. **Explora primero, propón después.**

## 1. Explorar antes de proponer
No propongas nada sin leer la realidad del proyecto:
- `.lupio/context/project.md` — stack, fase, puertos asignados.
- `.lupio/context/decisions.md` — qué ya se decidió y por qué (no lo contradigas
  sin señalarlo).
- El **código real** de la zona afectada. Nombres, patrones y convenciones que
  ya existen mandan sobre tus preferencias.
- `.lupio/core/` y `templates/` — ¿ya existe un módulo/patrón reutilizable?

## 2. Las preguntas (respóndelas por escrito)
1. **Problema real vs. lo pedido.** ¿Qué duele de verdad? A veces lo pedido no
   es la mejor solución al problema. Dilo.
2. **Lo mínimo que lo resuelve.** El corte más pequeño que entrega valor.
3. **Qué se rompe.** Qué código, datos, contratos o flujos toca este cambio.
4. **Casos límite.** Input vacío, nulo, duplicado, concurrencia, permisos,
   estado de error, offline, datos grandes.
5. **Cómo se verifica** (con los comandos reales del stack, ver abajo).
6. **Qué NO se hace y por qué.** El scope que se deja fuera a propósito. Esto es
   tan importante como lo que sí se hace — evita la sobre-ingeniería.

## 3. Cómo se verifica (comandos reales por stack)
Ata cada paso a un comando concreto de ESTE proyecto:
- **Next.js / React / SvelteKit:** `npm run dev`, `npm run build`, `npm test`
  (Vitest/Jest), y UI con **Playwright** en viewports 375 / 768 / 1280.
- **Laravel:** `php artisan serve`, `php artisan test` (Pest/PHPUnit), migraciones
  con `php artisan migrate --pretend` antes de aplicar.
- **Node API:** `npm run dev`, test del endpoint real (curl/httpie) + su edge case.
- **Strapi / Medusa:** levantar en dev y golpear el endpoint/admin real.
- Respeta la gestión de puertos del CLAUDE.md (reusar puerto asignado, no matar
  procesos ajenos). Orden de herramientas de QA: framework del proyecto →
  Playwright → preview MCP → Chrome MCP (último recurso).

## 4. Formato del plan
Entrega el plan así y **espera OK antes de tocar código**:

```
## Plan: [tarea]
Problema real: [una frase]
Enfoque mínimo: [una frase]
Qué NO haré: [lista corta + por qué]

Pasos (cada uno reversible + su verificación):
1. [cambio pequeño] → verifico con `[comando]`
2. [cambio pequeño] → verifico con `[comando]`
...
Riesgos: [lo que podría salir mal]
```

Reglas del plan:
- Pasos **pequeños y reversibles**. Si un paso no se puede deshacer fácil,
  divídelo o márcalo 🔴 y valida con `lupio-abogado-diablo`.
- Cada paso trae su verificación. Un paso sin forma de verificarse no es un paso.
- Nada de refactors oportunistas mezclados con la feature.

## 5. Puertas
- Si la idea entera es dudosa → `lupio-abogado-diablo` antes del plan.
- Si el cambio toca superficie sensible (auth, pagos, datos) → `lupio-seguridad`.
- Si estás arrancando el proyecto → `lupio-arranque` primero.
