# Workflow: Product Discovery

**Trigger:** User provides a product brief, idea, or problem statement
**Agents:** product-discovery, pm-controller, cost-estimator
**Output files:** `.lupio/memory/scope.md`, `.lupio/memory/cost-estimate.md`, `.lupio/context/project.md` (updated)

---

## Steps

### Step 1 — Collect brief
Load: `.lupio/context/project.md`
Ask the user:
1. What problem does this product solve?
2. Who is the primary user?
3. What is the must-have for v1?
4. What is out of scope for v1?
5. Any tech constraints (existing stack, integrations)?
6. Rough budget/timeline?

Do NOT proceed until you have answers to 1–3 minimum.

### Step 2 — Run product-discovery agent
Load agent: `.lupio/agents/product-discovery.md`
Input: user brief answers
Produce:
- Problem statement (2–3 sentences)
- User personas (2–3 max)
- Use cases (top 5, ranked by value)
- MVP scope (what's IN)
- Out of scope list
- Assumptions
- Risks

Write to: `.lupio/memory/scope.md`

### Step 3 — Run pm-controller
Load agent: `.lupio/agents/pm-controller.md`
Input: scope.md
Produce:
- Milestones (3–5 phases)
- Definition of Done per phase
- Key decisions needed

Append to: `.lupio/memory/scope.md` under `## Project Milestones`

### Step 4 — Run cost-estimator
Load agent: `.lupio/agents/cost-estimator.md`
Input: scope.md
Produce:
- Rough effort estimate (hours/days)
- Infrastructure cost range
- Third-party service costs
- Total project cost range

Write to: `.lupio/memory/cost-estimate.md`

### Step 5 — Checkpoint
Present to user:
```
📋 Discovery complete.

Scope: [X use cases, Y personas]
Effort estimate: [Z weeks]
Infrastructure: ~$[N]/month

Files written:
- .lupio/memory/scope.md
- .lupio/memory/cost-estimate.md

Proceed to architecture? (yes/no/revise)
```

If **revise**: loop back to Step 2 with user feedback.
If **yes**: trigger `architecture` workflow.
If **no**: stop and preserve scope for later.

---

## Token Rules
- Load only `project.md` and user input
- Do NOT load any source code during discovery
- Write all outputs to `.lupio/memory/` before presenting summary
