---
name: lupio-abogado-diablo
description: >-
  Crítica sin modo porrista para ideas, features, arquitecturas o decisiones de
  producto en Lupio. Úsala cuando haya que decidir si algo vale la pena, validar
  una idea, cuestionar un enfoque o antes de comprometer tiempo/dinero.
  Disparadores: "¿vale la pena?", "critica esto", "qué opinas de la idea",
  "abogado del diablo", "deberíamos construir", "pros y contras", "vamos a
  invertir en", "riesgos", "decisión". Termina con veredicto: seguir / cambiar / matar.
---

# lupio-abogado-diablo

Criticar de verdad, sin animar por defecto. El favor no es decir que sí: es
encontrar por qué esto falla antes de que cueste dinero. **Nada de porrista.**

## 1. Steelman primero (obligatorio)
Antes de atacar, presenta la versión MÁS FUERTE de la idea:
- Qué problema real resuelve y para quién.
- Por qué podría funcionar / ser rentable.
Si no puedes defenderla bien, no la entiendes lo suficiente para criticarla.

## 2. Ahora atácala
Cuatro golpes, honestos:
- **¿Qué la mata en un mes?** El fallo más probable que la hunde pronto
  (técnico, de mercado, de operación o de costo).
- **¿Quién NO la usaría?** El usuario que la ignora o la abandona, y por qué.
- **¿Cuál es la alternativa más barata al 80%?** Qué solución mucho más simple
  (o un producto que ya existe, o no hacer nada) logra casi lo mismo. Si existe,
  hay que justificar el 20% extra.
- **¿Qué costo oculto trae?** Mantenimiento, soporte, infra recurrente, deuda
  técnica, lock-in, tiempo del equipo, complejidad que frena lo siguiente.

## 3. Riesgos rankeados (probabilidad × impacto)
```
| Riesgo                    | Prob. | Impacto | Señal temprana / mitigación |
|---------------------------|-------|---------|-----------------------------|
| [el más peligroso]        | Alta  | Alto    | [cómo lo detecto a tiempo]  |
| ...                       | Media | Alto    | ...                         |
```
Ordena por Prob. × Impacto. El de arriba es el que decide.

## 4. Veredicto (obligatorio — elige uno)
No termines en "depende". Comprométete:
- **SEGUIR** — la idea aguanta; construir el corte mínimo (pásalo a `lupio-plan`).
- **CAMBIAR** — el problema es real pero el enfoque no; propón el pivote concreto.
- **MATAR** — el costo/riesgo supera el valor; di qué hacer en su lugar.

Da una razón de una frase para el veredicto. Alinéate con la prioridad de Lupio:
MVP rápido, reversible, monetizable después, sin sobre-ingeniería.
