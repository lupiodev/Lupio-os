# Workflow: Architecture

**Agents:** solution-architect, cost-estimator
**Input:** `memory/scope.md`
**Outputs:** `memory/architecture.md`, `context/decisions.md` (append)

## Steps

1. **Load** `memory/scope.md`. Ask if not in context: backend language, frontend framework, database, deployment target, external integrations.

2. **Design** (solution-architect) — Write `memory/architecture.md`:
   SUMMARY (max 50 words) · component map · tech stack + rationale · data model overview · API approach · infra · ADRs

3. **Decisions** — Append ADRs to `context/decisions.md`.

4. **Cost** (cost-estimator) — Update `memory/cost-estimate.md` with infra line items.

5. **Checkpoint** — Show stack, component count, monthly infra.
   revise → step 2 | yes → proceed to foundation | no → stop

## Token Rules
- Load `memory/scope.md` first 50 lines only. No source code.
