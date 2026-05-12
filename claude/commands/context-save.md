# Command: /context-save

Captura el estado de la sesión actual en un checkpoint para retomar en una nueva ventana sin reescanear archivos.

## Cuándo invocar
- Usuario dice "guardar progreso", "save state", "/context-save"
- Antes de cerrar la sesión o cambiar de rama
- Cuando el orchestrator recomiende "nueva ventana" (alerta 🔴)

## Qué genera
Archivo en `.lupio/checkpoints/YYYYMMDD-HHMMSS-<slug>.md`:

```markdown
---
title: <título corto>
branch: <git branch>
timestamp: <ISO-8601>
session_duration: <minutos>
modified_files: [list]
---

## Resumen del trabajo
<2-4 líneas: qué se estaba haciendo>

## Decisiones tomadas
<bullets: decisiones arquitectónicas o de scope>

## Próximos pasos
1. <paso prioritario>
2. <siguiente>
3. <opcional>

## Archivos clave de la sesión
- `path/to/file.ext` — <por qué importa>

## Notas / gotchas
<warnings, edge cases, bugs encontrados, etc>
```

## Pasos de ejecución
1. Obtener git state: `git branch --show-current`, `git status --short`, `git log --oneline -5`
2. Inferir título corto del trabajo (3-5 palabras, slug `a-z0-9-`)
3. Si ya existe checkpoint con mismo timestamp, agregar sufijo random
4. Escribir el archivo
5. Confirmar al usuario con el path del checkpoint

## Reglas
- No consume tokens en runtime: lee git (rápido) + memoria de conversación, no relee proyecto
- Tamaño objetivo: 1-3 KB por checkpoint
- Append-only: nunca sobrescribir checkpoints existentes
- NO modificar código, solo capturar estado
- Si la rama está limpia y no hay decisiones tomadas, avisar y no crear checkpoint vacío
