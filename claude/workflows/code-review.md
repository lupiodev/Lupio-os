# Workflow: Code Review

**Agents:** backend-lead or frontend-lead (by file type) + qa-lead
**Outputs:** `memory/code-review-<timestamp>.md`

## Steps

1. **Type** — `.ts` in `modules/` → backend-lead. `.tsx` in `app/` or `components/` → frontend-lead. Tests → qa-lead.

2. **Review** — Load target files only. Check by severity:
   - BLOCKER: security (injection, auth bypass), data loss, broken functionality
   - MAJOR: missing error handling, N+1 queries, missing tests, anti-patterns
   - MINOR: naming, style, missing comments on complex logic

3. **Test gap** (qa-lead) — If no tests exist for reviewed code, flag as MAJOR.

4. **Write** `memory/code-review-<timestamp>.md`: summary · BLOCKERs · MAJORs · MINORs · verdict (YES/NO/YES WITH FIXES).

5. **Offer** to fix BLOCKERs automatically if approved.

## Token Rules
- Load only files under review (max 10). Load `context/decisions.md` only for pattern compliance.
