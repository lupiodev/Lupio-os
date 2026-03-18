# Workflow: Testing

**Agent:** qa-lead
**Outputs:** test files, `memory/qa-report.md` (append)

## Steps

1. **Scope** — Ask: module/feature to test, backend/frontend/both, known edge cases.
   Read target source files only + `context/decisions.md` for test framework.

2. **Generate** (qa-lead):
   - Backend: unit (all service methods) + integration (endpoints: happy + error + edge)
   - Frontend: component tests + hook tests + E2E scenarios (critical journeys)

3. **Coverage** — List untested functions. Flag CRITICAL paths with no test.

4. **Log** — Append to `memory/qa-report.md`: module, unit count, integration count, E2E count, coverage %, gaps.

## Token Rules
- Load target module files only. Use `context/decisions.md` for framework — don't scan test suite.
