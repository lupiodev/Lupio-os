# Postmortem — 500 intermitentes en producción por `cache:clear` en cada deploy

**Fecha:** 2026-09-14
**Repo:** seshub-backend
**Síntoma reportado:** un usuario no podía iniciar sesión ("error de servidor"), mientras que
desde otras computadoras sí funcionaba. Se sospechó bloqueo por IP (157.100.126.35).

## Diagnóstico

- No hay ningún bloqueo de IP: fail2ban no está instalado, no hay reglas iptables DROP/REJECT,
  y el nginx `access.log` no tiene **ninguna** petición de esa IP — el bloqueo, si existe, es
  de red/firewall del lado del usuario, no del servidor.
- En el log de Laravel de HOY se encontraron **41 ocurrencias** de:
  ```
  Unable to create lockable file: .../storage/framework/cache/data/XX/YY/<hash>.
  Please ensure you have permission to create files in this location.
  ```
- Verificado que NO es un problema de permisos persistente (0 archivos con dueño distinto a
  `www-data` en `storage/framework/cache` al momento de revisar; los directorios `XX/YY`
  específicos que fallaron ya ni existen).
- Causa real: **race condition**. `deploy.yml` corre `sudo php artisan cache:clear` en cada
  deploy a `develop` y `master` (líneas ~96 y ~277), intencional para que los datos de
  migraciones nuevas se vean de inmediato. Con `CACHE_DRIVER=file`, esto borra recursivamente
  el árbol de caché en disco **mientras el servidor sigue sirviendo tráfico real**. Si un
  request (ej. login) intenta crear/leer un lock file justo cuando `cache:clear` borra ese
  directorio, revienta con este error → 500 intermitente para ese request puntual.
- Agravante: en esta sesión se hicieron muchísimos pushes a `master` solo para iterar
  diagnósticos (workflows one-off tipo `diag-*.yml`), y cada uno disparaba un deploy completo
  con su propio `cache:clear` — multiplicando las ventanas de riesgo en un solo día.

## Fix aplicado hoy (alcance acotado, ya en master)

`deploy.yml`: se agregó `paths-ignore: ['.github/workflows/**']` al trigger `on: push:`, para
que un push que solo modifica archivos de workflow (diagnósticos, scripts one-off) NO dispare
un deploy completo. Esto reduce drásticamente la frecuencia de `cache:clear` en producción sin
tocar la lógica del deploy en sí. Reversible con solo quitar esas dos líneas.

## Pendiente — root fix real (no se tocó hoy, requiere su propia sesión/revisión)

1. **Migrar `CACHE_DRIVER=file` → `redis` (preferido) o `database`.**
   - Elimina el problema de raíz: esas operaciones son atómicas a nivel de driver, no hay
     directorios que borrar ni lock files de filesystem que puedan desaparecer a mitad de un
     request.
   - Requiere: confirmar que Redis está disponible/instalado en el servidor de prod (o
     provisionarlo), configurar `REDIS_HOST`/`REDIS_PASSWORD`/`REDIS_PORT` en `.env`, probar en
     `develop` primero, y verificar que nada dependa de rutas de archivo de caché directamente.
   - Riesgo: cambio de infraestructura, no solo de código — no apto para un fix rápido.

2. **Revisar si `cache:clear` post-migración realmente necesita ser un `cache:clear` completo.**
   - Alternativa más quirúrgica: usar `Cache::tags(...)->flush()` (si se migra a un driver que
     soporte tags, como Redis) para invalidar solo las claves afectadas por la migración, en vez
     de vaciar TODO el cache store en cada deploy.

3. **Considerar mover `cache:clear` (y el resto del pipeline pesado: migrate, seeders,
   notifications:reconcile) a una ventana de mantenimiento o a un paso que ponga el servidor en
   modo `php artisan down` brevemente**, si Redis/database no se adopta pronto. Esto es un
   parche, no el fix real, pero evita el race mientras se decide la migración de driver.

4. **Confirmar con el usuario** si el volumen de deploys a `master` desde múltiples sesiones
   Claude concurrentes debería reducirse/agruparse (varios diagnósticos en un solo push en vez
   de uno por uno) — no es un fix de código, es un ajuste de flujo de trabajo que habría evitado
   gran parte de las 41 ocurrencias de hoy.

## Nota aparte (no relacionada, mismo hallazgo)

El usuario de la IP 157.100.126.35 específicamente parece tener un bloqueo de red de su lado
(firewall corporativo/ISP) — no hay nada que arreglar en nuestra infraestructura para ese caso
puntual. Pedir que pruebe desde otra red (datos móviles) para confirmar.
