---
description: "Generate a complete frontend feature."
---

# /generate-frontend-module <name>

Generate a complete frontend feature.

**Agents:** frontend-lead, ui-reviewer
**Workflow:** `workflows/frontend-module.md`
**Inputs** (infiere del contexto y del código; pregunta solo lo que falte y no se pueda inferir, todo en un mensaje y con tu default recomendado): route, data needed, user actions, Figma/Lovable URL (optional)
**Outputs:** page, components, hook, API client, `memory/frontend-log.md`

**Token:** Load component name list only (not contents). Design ref loaded once.
