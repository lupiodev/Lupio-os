# /review-qa

QA readiness review with GO/NO-GO decision.

**Agent:** qa-lead
**Workflow:** `workflows/qa-review.md`
**Input:** `memory/qa-report.md`, `memory/scope.md`
**Output:** `memory/qa-report.md` (append release decision)

**Token:** Load qa-report.md + scope.md first 30 lines only.
