# /generate-backend-module <name>

Generate a complete backend module.

**Agents:** backend-lead, qa-lead
**Workflow:** `workflows/backend-module.md`
**Template:** `templates/backend-core/express-typescript-module.md`
**Ask:** entities, operations, permissions, events
**Outputs:** `src/modules/<name>/` (model, service, routes, permissions, events), migration, tests, `memory/backend-log.md`

**Token:** Load `context/decisions.md` + architecture SUMMARY + matching `core/` template only.
