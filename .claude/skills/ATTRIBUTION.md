# Atribución — skills de diseño de terceros

Las skills de diseño de Lupio incluyen material de terceros, curado y (en un caso)
adaptado. Se conservan sus licencias. Gracias a los autores.

## Instaladas verbatim
| Skill (carpeta) | Fuente | Licencia |
|-----------------|--------|----------|
| `frontend-design` | [anthropics/skills](https://github.com/anthropics/skills) → `skills/frontend-design` | Apache-2.0 (ver `frontend-design/LICENSE.txt`) |
| `web-design-guidelines` | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) → `skills/web-design-guidelines` | Sin LICENSE explícita en el repo. No se copió código de reglas: la skill hace WebFetch de las guidelines en vivo. |
| `apple-design` | [emilkowalski/skills](https://github.com/emilkowalski/skills) | MIT (ver `apple-design/LICENSE`) |
| `animation-vocabulary` | emilkowalski/skills | MIT (ver `animation-vocabulary/LICENSE`) |
| `improve-animations` | emilkowalski/skills | MIT (ver `improve-animations/LICENSE`) |
| `review-animations` | emilkowalski/skills | MIT (ver `review-animations/LICENSE`) |

## Instalada adaptada
| Skill | Fuente | Qué se cambió |
|-------|--------|---------------|
| `ui-ux-pro-max` | [WAAMEngineer/ui-ux-pro-max-skill](https://github.com/WAAMEngineer/ui-ux-pro-max-skill) (MIT) | Se conservó la inteligencia estática (reglas por prioridad, errores comunes, checklist). Se **omitió** el motor CLI/Python y los CSVs (~468K) para no inflar cada proyecto; viewports alineados a 375/768/1280 de Lupio. Para la base de datos completa, ver el repo original. |

## Descartadas (con motivo)
| Fuente | Motivo |
|--------|--------|
| `emilkowalski/skills` → `emil-design-eng` | Se solapa con `apple-design`; incluye un "gate" de respuesta inicial que estorba en el flujo de Lupio. Disponible en el repo original si se quiere. |
| [alchaincyf/huashu-design](https://github.com/alchaincyf/huashu-design) (MIT) | Enfocada en producción cinematográfica / video / slides / PPTX con TTS y render, no en UI de aplicación web. Fuera del alcance de "diseñar interfaces". Reconsiderar si Lupio necesita diseño de presentaciones/marketing en video. |

## Conductor propio
`lupio-diseno` es una skill original de Lupio que impone el orden jerárquico
idea → diseño final y enruta a las anteriores. No deriva de terceros.
