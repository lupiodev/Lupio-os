---
name: lupio-seguridad
description: >-
  Chequeo de seguridad con evidencia, no opiniones, para proyectos Lupio. Úsala
  al revisar seguridad, antes de exponer algo a producción, o al tocar auth,
  pagos, datos personales, subida de archivos o endpoints públicos.
  Disparadores: "revisa seguridad", "es seguro", "security review", "auth",
  "login", "permisos", "antes de prod", "expuesto", "vulnerabilidad", "pentest",
  "/review-code" sobre superficie sensible. Cada hallazgo con archivo, línea,
  severidad y cómo se explota.
---

# lupio-seguridad

Seguridad con pruebas, no corazonadas. Cada hallazgo se sostiene con **archivo,
línea, severidad y una frase de cómo se explota**. Sin eso, es una opinión.

## 1. Mapear la superficie expuesta
Antes de revisar, lista qué puede tocar un atacante:
- Endpoints/rutas públicas y autenticadas (API routes de Next, controllers de
  Laravel, rutas de Strapi/Medusa, REST de WP).
- Entradas: forms, query params, headers, webhooks, uploads, mensajes de cola.
- Salidas: respuestas JSON, logs, mensajes de error, correos.
- Secretos y accesos (`.env`, keys, tokens, credenciales de `servers.md`).

## 2. Revisar en ESTE orden (fijo)
1. **Secretos.** ¿Keys/tokens hardcodeados o commiteados? ¿`.env` en `.gitignore`?
   En Next, ¿algo sensible bajo `NEXT_PUBLIC_` (se envía al cliente)?
2. **Validación de entradas.** Todo input se valida en servidor (Zod, class-validator,
   FormRequest de Laravel). El cliente no cuenta.
3. **Autorización, no solo autenticación.** ¿Estar logueado ≠ tener permiso? Busca
   IDOR: `GET /orders/:id` sin comprobar dueño. En Laravel: Policies/Gates. En WP:
   `current_user_can()`. Recurso por recurso.
4. **Inyección.** SQL/NoSQL (usar queries parametrizadas / ORM, nunca concatenar),
   XSS (escapar salida; en React cuidado con `dangerouslySetInnerHTML`), SSRF en
   fetch de URLs de usuario, command injection en `exec`.
5. **Fugas en logs y respuestas.** Stack traces, tokens, PII o SQL en logs o en
   errores 500 devueltos al cliente. `APP_DEBUG=false` en prod.
6. **Dependencias con CVEs.** `npm audit` / `pnpm audit`, `composer audit`. Fija
   las críticas y de alto riesgo explotables desde la superficie expuesta.

## 3. Formato de cada hallazgo
```
[SEVERIDAD: CRÍTICA|ALTA|MEDIA|BAJA] archivo:línea
Qué: [el defecto en una frase]
Cómo se explota: [una frase concreta — el paso del atacante]
Fix: [el cambio mínimo]
```
Ordena por severidad. Sin línea y sin vector de explotación, no lo reportes como
hallazgo: márcalo como sospecha a verificar.

## 4. Verificación adversarial
Antes de dar por bueno un hallazgo (o un fix), intenta refutarlo:
- ¿Hay ya una capa que lo mitiga (middleware, WAF de Cloudflare, policy)?
- ¿El vector es realmente alcanzable desde fuera, o requiere acceso que ya rompe todo?
- Reproduce el fix: el input malicioso que antes pasaba, ¿ahora se rechaza? Muestra
  el output. Un fix sin prueba se trata como no aplicado (ver `lupio-fixer`).

## 5. Lista honesta de lo que NO se revisó
Cierra SIEMPRE declarando el alcance:
```
Revisado: [zonas]
NO revisado: [infra/DNS/Cloudflare, dependencias transitivas, lógica de negocio X,
  código de terceros, ...]
Confianza: [alta/media/baja] y por qué.
```
Nunca insinúes "está seguro". Di qué miraste, qué encontraste y qué quedó fuera.
