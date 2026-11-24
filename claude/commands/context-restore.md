---
description: "Restaura un checkpoint guardado por `/context-save` para retomar trabajo en nueva ventana sin reescanear el proyecto."
---

# Command: /context-restore

Restaura un checkpoint guardado por `/context-save` para retomar trabajo en nueva ventana sin reescanear el proyecto.

## Cuándo invocar
- Al iniciar una nueva ventana después de "nueva ventana" recomendada
- Usuario dice "restore context", "/context-restore", "retomar"
- `/context-restore <fragmento>` → carga checkpoint cuyo título contenga el fragmento

## Qué hace
1. Listar checkpoints en `.lupio/checkpoints/` (máx 20 más recientes, ordenados por timestamp en filename)
2. Si no se pasó argumento → cargar el más reciente
3. Si se pasó fragmento → buscar match en título; si hay múltiples, mostrar opciones
4. Leer el checkpoint (no leer otros archivos del proyecto)
5. Mostrar resumen estructurado:

```
🔄 Checkpoint restaurado: <título>
Branch: <branch>  |  Hace: <tiempo>  |  Duración previa: <min>

📋 Trabajo previo:
<resumen>

🎯 Próximos pasos:
1. ...

⚠️ Notas:
<gotchas>

Archivos clave:
- path/to/file.ext
```

6. Continuar con el primer próximo paso del checkpoint, sin esperar (solo te detienes si ese paso implica una decisión de negocio pendiente)

## Reglas
- **No leer otros archivos del proyecto** más allá de los "Archivos clave" del checkpoint hasta que el siguiente paso lo requiera
- Ordenar por timestamp en el nombre del archivo (estable cross-machine), no por mtime
- Cap en 20 checkpoints listados (evita inflar contexto)
- Solo lectura: no modifica código ni git state
- Si `.lupio/checkpoints/` no existe o está vacío, indicar al usuario que use `/context-save` primero
