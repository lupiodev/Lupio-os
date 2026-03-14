# Workflow: Code Review

**Trigger:** `/review-code <file-or-module-path>`
**Agents:** backend-lead or frontend-lead (based on file type), qa-lead
**Input:** Target files
**Output:** `.lupio/memory/code-review-<timestamp>.md`

---

## Steps

### Step 1 — Identify file type
Determine from file extension and path:
- `.ts` in `src/modules/` → backend review (backend-lead)
- `.tsx` in `src/app/` or `src/components/` → frontend review (frontend-lead)
- `.test.ts` / `.spec.ts` → test quality review (qa-lead)
- Mixed → run both agents on their respective files

### Step 2 — Load minimal context
Read:
- Target files only
- `.lupio/context/decisions.md` for agreed patterns (skip if file is self-contained)
- Do NOT load other source files unless a specific integration issue requires it

### Step 3 — Run appropriate lead agent
Load agent: `.lupio/agents/backend-lead.md` or `.lupio/agents/frontend-lead.md`

Review for:
- **BLOCKER:** Security vulnerabilities, data loss risk, broken functionality
- **MAJOR:** Performance issues, missing error handling, anti-patterns
- **MINOR:** Style, naming, missing comments on complex logic, small optimizations

Backend checklist:
- [ ] Input validation (Zod schemas present)
- [ ] SQL injection prevention (parameterized queries)
- [ ] Auth middleware applied to protected routes
- [ ] Error handling (no unhandled promise rejections)
- [ ] Pagination on list endpoints
- [ ] Rate limiting on sensitive endpoints

Frontend checklist:
- [ ] No hardcoded API URLs (use env vars or lib/api)
- [ ] Loading and error states handled
- [ ] No sensitive data in localStorage
- [ ] Forms have validation feedback
- [ ] Accessible (aria labels, keyboard nav)

### Step 4 — Run qa-lead for test gap check
Load agent: `.lupio/agents/qa-lead.md`
Check if tests exist for the reviewed code.
If no tests: flag as MAJOR finding.

### Step 5 — Write review
Write to: `.lupio/memory/code-review-<timestamp>.md`
Format:
```
# Code Review — <file/module> — <date>

## Summary
[1–2 sentence overall assessment]

## BLOCKERS (must fix before merge)
- [ ] [finding] — [file:line] — [fix suggestion]

## MAJOR (should fix before merge)
- [ ] [finding] — [file:line] — [fix suggestion]

## MINOR (nice to fix, low priority)
- [ ] [finding] — [file:line]

## Approved for merge: YES / NO / YES WITH FIXES
```

### Step 6 — Report to user
Present summary and list blockers/majors.
Offer to fix BLOCKERS automatically if approved.

---

## Token Rules
- Load ONLY the files under review
- Load decisions.md only if pattern compliance is relevant
- Never load more than 10 files per review session
