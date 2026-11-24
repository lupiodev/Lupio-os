---
description: "Generate test suite for a module or feature."
---

# /generate-tests <module>

Generate test suite for a module or feature.

**Agent:** qa-lead
**Workflow:** `workflows/testing.md`
**Inputs** (infiere del contexto y del código; pregunta solo lo que falte y no se pueda inferir, todo en un mensaje y con tu default recomendado): scope (backend/frontend/both), known edge cases
**Outputs:** test files, `memory/qa-report.md` (append)

**Token:** Load target module files only.
