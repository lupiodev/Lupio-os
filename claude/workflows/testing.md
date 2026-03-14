# Workflow: Test Generation

**Trigger:** `/generate-tests <module-or-feature>`
**Agents:** qa-lead
**Input:** Source files for the target module/feature
**Output:** Test files + `.lupio/memory/qa-report.md` update

---

## Steps

### Step 1 — Identify scope
Ask user:
1. What module or feature to test?
2. Backend only, frontend only, or both?
3. Any known edge cases or tricky business rules?

Read (targeted):
- Target source files only (service + routes for backend; page + hooks for frontend)
- `.lupio/context/decisions.md` for test framework (Jest, Vitest, Playwright)

### Step 2 — Run qa-lead agent
Load agent: `.lupio/agents/qa-lead.md`

**For backend:**
Generate:
- Unit tests for service layer (all public methods)
- Integration tests for API endpoints (happy path + error cases)
- Edge cases: empty input, unauthorized, not-found, constraint violations

**For frontend:**
Generate:
- Component tests (renders correctly, user interactions)
- Hook tests (data loading states, error states)
- E2E test scenarios (Playwright) for critical user journeys

### Step 3 — Coverage check
After generating tests, estimate coverage:
- List untested functions/branches
- Flag any CRITICAL paths with no test

### Step 4 — Update qa-report
Append to `.lupio/memory/qa-report.md`:
```
## <module> Test Coverage — <date>
- Unit tests: N
- Integration tests: N
- E2E scenarios: N
- Estimated coverage: N%
- Untested critical paths: [list or "none"]
```

### Step 5 — Summary
```
✅ Tests generated for <module>.

Unit: N tests
Integration: N tests
E2E: N scenarios
Coverage estimate: ~N%

Run: npm test -- <module>
```

---

## Token Rules
- Load ONLY the target module files
- Do not load entire test suite to check patterns — use decisions.md for framework choice
- Write test files to disk before updating qa-report
