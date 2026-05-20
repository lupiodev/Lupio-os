# Server Access — [Project Name]

⚠️ **NO commit this file** — está en `.lupio/.gitignore`. Contiene info de accesos y despliegue de este proyecto.
⚠️ **No guardes passwords aquí** — usa referencias a `~/.ssh/config`, gestores de secretos o variables de entorno.

## Production
- **Host / IP:** [hostname o IP]
- **SSH:** `ssh user@host` o alias en `~/.ssh/config` (ej. `ssh prod-mydessk`)
- **Identity file:** [path o referencia]
- **Path en servidor:** [/var/www/...]
- **Web stack:** [Nginx | Apache | Caddy] + [PHP-FPM | Node | Gunicorn]
- **Deploy method:** [manual ssh + git pull | rsync | CI/CD via X | container registry]
- **Restart services:** [comando exacto, ej. `sudo systemctl restart php-fpm nginx`]
- **DB host:** [host:port — name — user] (sin password)
- **CDN:** [Cloudflare | Bunny | etc — zona/pool]
- **DNS provider:** [donde se gestiona]
- **Logs:** [ruta o comando para verlos]
- **Backups:** [estrategia y ubicación]

## Staging
- **Host / IP:**
- **Path:**
- **Deploy method:**
- **DB:**

## Development (remoto, si aplica)
- **Host / IP:**

## CI/CD
- **Provider:** [GitHub Actions | GitLab CI | Bitbucket Pipelines | etc]
- **Workflow file:** [.github/workflows/deploy.yml]
- **Trigger:** [push to main | tag v* | manual workflow_dispatch]
- **Secrets requeridos:** [SSH_KEY, DEPLOY_USER, etc — nombres, no valores]
- **Estado actual:** [activo | desactivado | en pausa]

## Notas operativas
<!-- gotchas, mantenimiento, ventanas de despliegue, contactos -->
- [ ]

## Reglas (no modificar)
- Toda acción que modifique servidor → Claude debe preguntar al usuario primero
- Deploys: el usuario los ejecuta manualmente (commits y deploys deshabilitados)
- Producción: confirmación verbal explícita siempre, sin excepciones
