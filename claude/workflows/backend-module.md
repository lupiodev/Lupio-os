# Workflow: Backend Module Generation

**Trigger:** `/generate-backend-module <module-name>`
**Agents:** backend-lead, qa-lead
**Input:** `.lupio/memory/architecture.md`, `.lupio/context/decisions.md`, module spec from user
**Output:** Source files + `.lupio/memory/backend-log.md`

---

## Steps

### Step 1 — Load context (minimal)
Read ONLY:
- `.lupio/context/decisions.md` (tech stack, patterns decided)
- `.lupio/memory/architecture.md` lines 1–50 (overview + data model)
- Check if module exists in `core/` (e.g. `core/auth/module.md`)

Ask user if not already specified:
1. Module name?
2. What entities does it manage?
3. What are the key operations (CRUD + any special actions)?
4. Any special permissions required?
5. Does it need to emit events for other modules?

### Step 2 — Check core/ template
If a matching module exists in `.lupio/core/<module>/module.md`:
Load it as reference implementation.
Adapt to project's specific needs — do not copy verbatim.

### Step 3 — Run backend-lead agent
Load agent: `.lupio/agents/backend-lead.md`
Input: module spec + core template (if found) + decisions.md
Generate in this order:
1. `src/modules/<module>/<module>.model.ts` — data model + Zod schema
2. `src/modules/<module>/<module>.service.ts` — business logic
3. `src/modules/<module>/<module>.routes.ts` — HTTP handlers
4. `src/modules/<module>/<module>.permissions.ts` — RBAC rules
5. `migrations/<timestamp>_create_<module>.sql` — migration
6. `src/modules/<module>/<module>.events.ts` — events emitted

### Step 4 — Run qa-lead for test generation
Load agent: `.lupio/agents/qa-lead.md`
Input: generated service + routes files
Generate:
- `src/modules/<module>/<module>.test.ts` — unit tests
- `src/modules/<module>/<module>.integration.test.ts` — integration tests (if complex)

### Step 5 — Update backend-log
Append to `.lupio/memory/backend-log.md`:
```
## <module> — <date>
- Files created: [list]
- Endpoints: [list]
- Tests: [N unit, N integration]
- Decisions: [any deviations from architecture]
```

### Step 6 — Summary
```
✅ Module <name> generated.

Files created:
- src/modules/<name>/ (6 files)
- migrations/ (1 file)

Endpoints: [N]
Tests: [N]

Run tests: npm test -- <module>
```

---

## Token Rules
- Load ONLY decisions.md + architecture overview (not full file)
- Load core template only if relevant module exists
- Do NOT scan other source files unless explicitly needed for integration
- Write files to disk immediately, do not hold in context
