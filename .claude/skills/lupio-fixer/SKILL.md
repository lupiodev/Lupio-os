---
name: lupio-fixer
description: >-
  Arreglar bugs con prueba en mano en proyectos Lupio. Úsala ante cualquier
  error, fallo, comportamiento raro, test roto o "no funciona".
  Disparadores: "hay un bug", "no funciona", "arregla", "error", "falla",
  "se rompió", "debug", "por qué pasa esto", "fix", "regresión", "excepción",
  "500", "pantalla en blanco". Reproduce antes de tocar; sin evidencia del
  arreglo, se trata como NO arreglado.
---

# lupio-fixer

Arreglar con evidencia, no con esperanza. La regla de oro: **sin prueba de que
el bug desapareció, no está arreglado** — da igual lo seguro que te sientas.

## 1. Reproducir ANTES de tocar nada
No edites código hasta reproducir el fallo:
- Consigue el caso exacto: input, ruta, estado, rol, entorno.
- Ejecútalo y **observa el fallo real** (error, log, screenshot, respuesta).
- Si no puedes reproducirlo, ese es el primer problema a resolver. No adivines.

## 2. Causa raíz, no síntoma
- Sigue el error hasta su origen (stack trace, `git log -p` de la zona, logs).
- Pregunta "¿por qué?" hasta que la respuesta sea una causa, no otro síntoma.
- Un `try/catch` que oculta el error, un `?.` que tapa un `undefined`, o un
  valor por defecto que enmascara datos malos → NO son fixes, son parches.

## 3. Arreglo mínimo
- El cambio más pequeño que ataca la causa raíz. Nada más.
- **Cero refactors oportunistas.** Si ves algo más que mejorar, anótalo aparte;
  no lo mezcles con el fix (mantiene el diff revisable y reversible).
- Respeta convenciones del código existente (naming, patrón, estilo).

## 4. Probar con el caso exacto que fallaba
- Corre otra vez **el caso que fallaba** y muestra el output que ahora pasa.
- Añade/actualiza el test que lo cubre (Vitest/Jest/Pest/PHPUnit) para que no
  vuelva. UI: reproduce con **Playwright** en el viewport donde fallaba.
- Comprueba que no rompiste lo de al lado (suite relevante, no todo el mundo).
- Orden de herramientas: framework del proyecto → Playwright → preview MCP →
  Chrome MCP (último recurso).

## 5. Regla anti "ya quedó"
Prohibido reportar "arreglado / listo / ya funciona" sin evidencia. El reporte es:
```
🐛 Bug: [síntoma]
Reproducción: [caso exacto] → fallaba con [error observado]
Causa raíz: [la causa real, no el síntoma]
Fix: archivo:línea — [cambio mínimo]
Evidencia: [output/test/screenshot que AHORA pasa]
Regresión cubierta por: [test]
```
Sin el bloque de evidencia, el bug sigue abierto. Esto complementa el Self-QA
obligatorio del CLAUDE.md. Si el bug era de seguridad, cierra con `lupio-seguridad`.
