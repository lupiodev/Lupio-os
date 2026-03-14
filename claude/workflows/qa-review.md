# Workflow: QA Review & Release Readiness

**Trigger:** `/review-qa` or before a release
**Agents:** qa-lead
**Input:** `.lupio/memory/qa-report.md`, `.lupio/memory/scope.md`
**Output:** Updated `qa-report.md` with GO/NO-GO decision

---

## Steps

### Step 1 — Load context
Read:
- `.lupio/memory/qa-report.md` (existing test coverage report)
- `.lupio/memory/scope.md` lines 1–30 (MVP use cases and acceptance criteria)

### Step 2 — Run qa-lead agent
Load agent: `.lupio/agents/qa-lead.md`

Run against all defined acceptance criteria from scope.md:
- For each use case: mark TESTED / UNTESTED / FAILING
- Check regression coverage for previously fixed bugs
- Verify E2E flows cover critical user journeys

### Step 3 — Assess release readiness

**GO criteria (all must pass):**
- [ ] All BLOCKER use cases have passing tests
- [ ] No open BLOCKER bugs
- [ ] Auth and permissions tested
- [ ] Error states handled and tested
- [ ] Performance acceptable (no obvious N+1 queries, no large unoptimized loads)

**NO-GO triggers:**
- Any untested BLOCKER use case
- Known BLOCKER bugs open
- Auth/security gaps

### Step 4 — Update qa-report.md
Append release readiness section:
```
## Release Readiness — <date>

### Checklist
- [ ] Use case coverage: N/N
- [ ] BLOCKER bugs: 0
- [ ] Auth tested: YES/NO
- [ ] E2E flows: N passing

### Known Issues
[list or "none"]

### Decision: GO ✅ / NO-GO ❌

### Conditions (if NO-GO)
[what must be fixed before GO]
```

### Step 5 — Report
Present decision clearly with reasons.
If NO-GO: list exactly what needs fixing before re-review.

---

## Token Rules
- Load ONLY qa-report.md and scope.md summary
- Do not re-read source files unless a specific gap requires investigation
- Decision must be written to disk before presenting to user
