---
description: "Generate a complete backend module."
---

# /generate-backend-module <name>

Generate a complete backend module.

**Agents:** backend-lead, qa-lead
**Workflow:** `workflows/backend-module.md`
**Template:** `templates/backend-core/express-typescript-module.md`
**Inputs** (infiere del contexto y del código; pregunta solo lo que falte y no se pueda inferir, todo en un mensaje y con tu default recomendado): entities, operations, permissions, events
**Outputs:** `src/modules/<name>/` (model, service, routes, permissions, events), migration, tests, `memory/backend-log.md`

**Token:** Load `context/decisions.md` + architecture SUMMARY + matching `core/` template only.
