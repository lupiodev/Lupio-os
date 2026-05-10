# Prompt Changelog

Format: `## [date] | [agent/command] | [exact change] | [reason] | STATUS`

## 2026-05-09 | CLAUDE.md (root) | Añadir sección "Backend Core Intocable" con protocolo de plan robusto antes de tocar módulos de cálculo financiero | Sistemas con lógica matemática sensible (seguros, finanzas, contabilidad) requieren guardrail explícito que sobreviva al "modo agente autónomo" | APPLIED

## 2026-05-09 | CLAUDE.md (root) | Añadir "Pre-flight de Permisos" — solicitar LECTURAS+ESCRITURAS+COMANDOS en un bloque al inicio | Reduce interrupciones tool-by-tool y mantiene flow de ejecución | APPLIED

## 2026-05-09 | CLAUDE.md (root) | Añadir "Análisis Pre-Ejecución" con scope/tokens/alerta/recomendación nueva-ventana | Previene sesiones rotas por overflow de contexto y elige modelo (Sonnet/Opus) por costo-beneficio | APPLIED

## 2026-05-09 | learning-agent.md | Considerar trigger adicional: "memory/ vacío + N sesiones desde init" → sugerir /save-lessons aunque no haya frase-disparador | Proyectos largos pueden no decir "perfecto/listo" y la memoria queda en cero indefinidamente | PENDING

## 2026-05-09 | bootstrap-project.md | Detectar módulos ya implementados en `<app>/src/v1/` y promover `Current Phase` automáticamente de discovery → development en `context/project.md` | Evita desfase entre memoria Lupio y realidad del repo (caso real: 13+ módulos backend con phase=discovery) | PENDING

## 2026-05-09 | orchestrator.md (o nuevo /sync-context) | Comando para validar coherencia entre `context/project.md` y estructura real del repo; reportar drift | La memoria desactualizada es peor que ausente: induce decisiones equivocadas | PENDING

## 2026-05-09 | save-lessons.md | Permitir documentar aprendizajes "de setup/operativa" (no solo de feature completada); útil cuando el aprendizaje es sobre el proceso, no sobre código entregado | Caso real: usuario pidió documentar aprendizajes con memory/ vacío y sin postmortem previo | PENDING
