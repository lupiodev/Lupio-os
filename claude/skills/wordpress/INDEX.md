# WordPress Skills (auto-loaded solo en proyectos WordPress)

Conocimiento experto de WordPress (fuente: WordPress/agent-skills). Estos skills se instalan
en `.lupio/skills/wordpress/` SOLO cuando se detecta un proyecto WordPress (`wp-config.php`
o `wp-content/`). Cargar bajo demanda — no en cada sesión.

| Skill | Cargar cuando |
|-------|---------------|
| `wp-plugin-development.md` | Plugins: arquitectura, hooks, CPTs, Settings API, shortcodes, seguridad (nonces/caps/sanitización) |
| `wp-rest-api.md` | Endpoints REST: rutas, schema, auth, response shaping |
| `wp-performance.md` | Caching, transients, object cache, optimización de WP_Query y DB |
| `wp-abilities-api.md` | Permisos por capability, auth de REST API |
| `wp-wpcli-and-ops.md` | WP-CLI, automatización, multisite, search-replace |
| `wp-phpstan.md` | Análisis estático PHPStan (config, baselines, typing WP) |

## Cuándo usarlos
El orchestrator / backend-lead / frontend-lead deben cargar el skill relevante ANTES de
trabajar sobre archivos en `wp-content/plugins/` o `wp-content/themes/`. Aplican las reglas
de seguridad de WordPress (escaping, nonces, capabilities) por defecto.

## Descartados (no aplican a nuestros proyectos)
- `wordpress-router`, `wp-project-triage` — duplican el routing del orchestrator
- `wp-playground`, `blueprint` — usamos Local by Flywheel
- `wp-plugin-directory-guidelines` — no publicamos al directorio público
- `wp-block-development`, `wp-block-themes`, `wp-interactivity-api`, `wpds` — Gutenberg/blocks,
  no usados actualmente (reactivar si se adopta block development)
