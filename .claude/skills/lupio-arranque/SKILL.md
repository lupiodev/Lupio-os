---
name: lupio-arranque
description: >-
  Cómo arrancar en Lupio un proyecto que no se cae en un mes. Úsala al iniciar
  cualquier proyecto, MVP, repo nuevo, prototipo o "vamos a empezar X":
  bootstrap, scaffolding, elección de stack, primer deploy, estructura inicial.
  Disparadores: "nuevo proyecto", "empezar de cero", "arrancar", "montar el
  repo", "MVP", "bootstrap", "/bootstrap-project", "landing", "SaaS nuevo",
  "setup inicial". Combina siempre con lupio-plan antes de escribir código.
---

# lupio-arranque

Arrancar un proyecto Lupio que sobreviva el primer mes. Aburrido, reversible y
visible desde el día 1. **Cero sobre-ingeniería** (es la prioridad de Lupio).

> Antes de tocar código corre `lupio-plan`. Esta skill decide *qué montar*;
> `lupio-plan` decide *cómo y en qué orden*.

## Paso 0 — Problema, usuario y la primera cosa visible
No abras el editor sin esto escrito (una frase cada uno):
- **Problema real** que resuelve (no la feature: el dolor).
- **Usuario** concreto que lo sufre.
- **Primera cosa visible** que demuestra que funciona — el *walking skeleton*.
  Ejemplos: "un form que guarda en Postgres y se ve en pantalla", "un endpoint
  `/health` desplegado que responde 200", "una landing con un CTA que registra
  el lead". Si no puedes nombrarla, todavía no entiendes el proyecto.

Guarda esto en `.lupio/memory/scope.md` (o usa `/generate-scope`).

## Stack mínimo y aburrido (elige del stack Lupio)
Elige lo más simple que resuelve el problema, no lo más nuevo:
- **Frontend:** Next.js + Tailwind (default). SvelteKit solo si el equipo ya lo domina.
- **Backend/CMS:** Strapi o Medusa.js si el core es contenido/catálogo; Laravel si
  hay lógica de negocio densa; Node (API) si es integración/servicios. WordPress
  solo si el cliente lo exige (activa las WP skills).
- **Datos:** PostgreSQL por defecto. MySQL si el hosting lo impone. Redis solo
  cuando haya una razón medible (cola, cache, sesiones), no "por si acaso".
- **Infra:** Cloudflare Pages / Vercel para front; DigitalOcean o Contabo para
  backend con estado. Cloudflare delante siempre (DNS + CDN).

**Cada decisión de stack va a `.lupio/context/decisions.md`** con una línea de
*por qué* y *cómo se revierte* (ver `templates/docs/decision-record.md`). Si una
decisión no es reversible en un día, márcala 🔴 y trátala con `lupio-abogado-diablo`.

## Día 1 — No negociable
En este orden, todo en la primera sesión:
1. **git + primer commit.** `git init` (si aplica) y commit del esqueleto vacío.
   Respeta la Branch Creation Policy del CLAUDE.md: por defecto rama actual.
2. **CLAUDE.md** en la raíz (lo genera el instalador de Lupio, o créalo). Es el
   contrato de arranque para el próximo modelo.
3. **Estructura explicada.** Carpetas con un `README` de una línea cada una. Que
   un dev nuevo entienda el mapa en 2 minutos.
4. **Deploy temprano.** Despliega el walking skeleton HOY, aunque muestre "Hello".
   Un pipeline que despliega vacío vale más que features sin deploy. Registra
   URL y método en `.lupio/context/servers.md`.

## Cero sobre-ingeniería (lo que NO se hace en el arranque)
- Nada de microservicios, event sourcing, ni k8s en un MVP.
- Nada de auth propia si un proveedor lo resuelve (Auth.js, Laravel Breeze, Clerk).
- Nada de abstracciones "para cuando escale": escala cuando duela, no antes.
- Nada de caché/colas sin métrica que lo justifique.
- Una base de datos, un repo, un deploy. Monolito modular > distribuido prematuro.

## Checklist de salida (no cierres el arranque sin esto)
- [ ] Problema, usuario y walking skeleton escritos en `scope.md`.
- [ ] Stack elegido y justificado en `decisions.md` (con cómo se revierte).
- [ ] Primer commit hecho.
- [ ] CLAUDE.md en la raíz.
- [ ] Estructura de carpetas legible y documentada.
- [ ] Walking skeleton **desplegado** y su URL en `servers.md`.
- [ ] Comando de dev y de verificación anotados (los usará `lupio-plan`/`lupio-fixer`).

Si algo falla, `lupio-fixer`. Si dudas de la idea entera, `lupio-abogado-diablo`.
