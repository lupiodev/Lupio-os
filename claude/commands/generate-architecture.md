# /generate-architecture

Design system architecture from scope and constraints.

**Agents:** solution-architect, cost-estimator
**Workflow:** `workflows/architecture.md`
**Input:** `memory/scope.md`
**Outputs:** `memory/architecture.md`, `context/decisions.md` (append), `memory/cost-estimate.md` (update)

**Token:** Load `memory/scope.md` first 50 lines only.
