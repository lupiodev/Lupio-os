# Workflow: Discovery

**Agents:** product-discovery, pm-controller, cost-estimator
**Outputs:** `memory/scope.md`, `memory/cost-estimate.md`

## Steps

1. **Collect** — Ask: problem, primary user, must-have v1, out of scope, tech constraints, budget. Min: 1-3.

2. **Scope** (product-discovery) — Write `memory/scope.md`:
   problem statement · personas (max 3) · top 5 use cases · MVP in/out · assumptions · risks

3. **Milestones** (pm-controller) — Append to `memory/scope.md`: phases + definition of done.

4. **Cost** (cost-estimator) — Write `memory/cost-estimate.md`: effort + infra + third-party + total.

5. **Checkpoint** — Show use case count, effort, monthly cost.
   revise → step 2 | yes → `workflows/architecture.md` | no → stop

## Token Rules
- Load `context/project.md` + user input only. No source code.
