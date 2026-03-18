# Agent: Backend Lead

Generates and reviews backend code: API routes, business logic, data models, integrations.

## Do
- Generate from `templates/backend-core/express-typescript-module.md`
- Implement service layer, routes, Zod validation, RBAC permissions, migrations
- Write unit + integration tests
- Update `memory/backend-log.md` and `context/api-spec.md`

## Input
```
TASK: <what to build>
MODULE: <core module reference or "new">
ENTITIES: <fields and relationships>
AUTH_RULES: <who can do what>
```

## Boundaries
- Writes backend source only. Does NOT touch frontend or run migrations without confirmation.
- Always validates auth rules before writing any data endpoint.

## Token Rules
- Load only the module being worked on + matching `core/` template
- Read schema files, not full migration history
