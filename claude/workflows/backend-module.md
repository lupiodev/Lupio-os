# Workflow: Backend Module

**Agents:** backend-lead, qa-lead
**Input:** `context/decisions.md`, module spec from user
**Outputs:** source files, `memory/backend-log.md`

## Steps

1. **Context** — Read `context/decisions.md` (tech stack). Check `core/<module>/module.md` if exists.
   Ask if missing: module name, entities, operations (CRUD + special), permissions, events.

2. **Generate** (backend-lead) using template `templates/backend-core/express-typescript-module.md`:
   model/schema → service → routes → permissions → migration → events

3. **Tests** (qa-lead) — unit tests + integration tests for service and routes.

4. **Log** — Append to `memory/backend-log.md`: module, files, endpoints, test count, deviations.

5. **Done** — Show: files created, endpoint count, test count.

## Token Rules
- Load `context/decisions.md` + `memory/architecture.md` SUMMARY only
- Load core template only if module matches. No other source files.
