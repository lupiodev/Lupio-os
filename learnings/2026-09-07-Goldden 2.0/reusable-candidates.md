# Reusable Candidates

Format: `## [name] | type | source | description | seen: N | STATUS`

## backend-core-intocable | rule | Goldden 2.0 | Protege módulos de cálculo financiero (cotización/prima/póliza/cobertura/financiamiento) y schema Prisma; exige plan robusto + aprobación explícita antes de modificar | seen: 1 | CANDIDATE

## preflight-permisos-bloque | workflow | Goldden 2.0 | Solicita LECTURAS+ESCRITURAS+COMANDOS en un único bloque al inicio; elimina interrupciones por permission-prompts durante ejecución | seen: 1 | CANDIDATE

## monorepo-multi-superficie | architecture | Goldden 2.0 | Separa apps por superficie (Back/Front/Admin/Scraper/Infra) en directorios hermanos del repo, sin workspace tooling forzado; permite reglas Lupio distintas por app | seen: 1 | CANDIDATE

## analisis-pre-ejecucion | workflow | Goldden 2.0 | Antes de tocar código, devolver bloque con scope (archivos/tokens), nivel de alerta (🟢🟡🔴) y recomendación nueva-ventana-vs-continuar; reduce sesiones que se rompen por overflow de contexto | seen: 1 | CANDIDATE

## prefer-front-over-back | rule | Goldden 2.0 | Si el frontend necesita datos nuevos, primero intentar transformar en front con lo que back ya expone; tocar back solo si es estrictamente imposible | seen: 1 | CANDIDATE

## api-versionada-v1 | pattern | Goldden 2.0 | Backend NestJS con módulos bajo `src/v1/<dominio>/`; permite romper compat sin migrar consumidores existentes | seen: 1 | CANDIDATE
