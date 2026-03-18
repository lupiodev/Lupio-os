# Workflow: QA Review

**Agent:** qa-lead
**Input:** `memory/qa-report.md`, `memory/scope.md`
**Outputs:** `memory/qa-report.md` (append GO/NO-GO)

## Steps

1. **Load** `memory/qa-report.md` + `memory/scope.md` first 30 lines (use cases + acceptance criteria).

2. **Review** (qa-lead) — For each use case: TESTED / UNTESTED / FAILING. Check regressions + E2E flows.

3. **GO criteria** (all must pass):
   - All BLOCKER use cases have passing tests
   - Zero open BLOCKER bugs
   - Auth and permissions tested
   - No obvious performance issues

4. **Append** to `memory/qa-report.md`:
   use case coverage · BLOCKER bugs · auth tested · E2E count · **GO / NO-GO** · conditions if NO-GO

## Token Rules
- Load qa-report.md + scope.md only. No source files unless gap requires investigation.
