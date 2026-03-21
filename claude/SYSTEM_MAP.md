# Lupio OS — System Map

Read this file first. Use it to navigate directly to the section you need — no full-file scanning.

> **IDE tip:** Select the target section in the editor before asking for a change — Claude receives it as context and skips the file read entirely.

---

## Quick Lookup — "I want to change..."

| What to change | File | Section |
|----------------|------|---------|
| How tasks are routed to agents/workflows | `agents/orchestrator.md` | `## Routing` |
| Session greeting / startup behavior | `agents/orchestrator.md` | `## Session Start` |
| Phase names (discovery → release) | `agents/orchestrator.md` | `## Phases` |
| Auto-learning trigger threshold | `agents/orchestrator.md` | `## Auto-Learning Trigger` |
| What an agent does / its responsibilities | `agents/<name>.md` | `## Do` |
| What files an agent is allowed to load | `agents/<name>.md` | `## Token Rules` |
| Agent output format / memory file written | `agents/<name>.md` | `## Output` |
| Agent safety boundaries (what it must NOT do) | `agents/<name>.md` | `## Boundaries` |
| Command input questions (what Claude asks) | `commands/<name>.md` | `## Ask` |
| Command execution steps | `commands/<name>.md` | `## Steps` or `## Action` |
| Command output files | `commands/<name>.md` | `## Outputs` |
| Workflow step sequence | `workflows/<name>.md` | `## Steps` |
| Workflow checkpoint / approval gate | `workflows/<name>.md` | `## Steps` (last step) |
| Code review severity definitions (BLOCKER/MAJOR/MINOR) | `workflows/code-review.md` | `## Steps` → step 3 |
| GO/NO-GO release criteria | `workflows/qa-review.md` | `## Steps` → step 3 |
| CI/CD safety rules | `workflows/devops.md` | `## Steps` → step 5 |
| UI breakpoints / contrast ratio thresholds | `agents/ui-reviewer.md` | `## Checklist` |
| Lovable draft handling | `agents/ui-reviewer.md` | `## Lovable Rules` |
| Figma token extraction rules | `agents/ui-reviewer.md` | `## Figma Rules` |
| Backend module file structure | `workflows/backend-module.md` | `## Steps` → step 3 |
| Frontend generation order | `workflows/frontend-module.md` | `## Steps` → step 3 |
| Test types generated per scope | `workflows/testing.md` | `## Steps` → step 2 |
| Architecture document sections | `agents/solution-architect.md` | `## Do` |
| Cost estimation output format | `agents/cost-estimator.md` | `## Output` |
| Reusable pattern detection threshold | `agents/refactor-librarian.md` | `## Do` |
| Learning trigger commands | `agents/learning-agent.md` | `## Triggers` |
| Postmortem / changelog / contribution steps | `agents/learning-agent.md` | `## Step 1` – `## Step 5` |
| New project scaffold sequence | `workflows/new-product.md` | `## Phases` |
| Milestone format | `agents/pm-controller.md` | `## Do` |
| Decision record format (ADR) | `agents/pm-controller.md` | `## Output` |

---

## File Index

### Agents — `agents/`

| File | Role | Key sections |
|------|------|--------------|
| `orchestrator.md` | Entry point, task router, phase tracker | Session Start · Routing · Phases · Auto-Learning Trigger · Token Rules |
| `backend-lead.md` | Backend codegen & review | Do · Input · Boundaries · Token Rules |
| `frontend-lead.md` | Frontend codegen & review | Do · Input · Boundaries · Token Rules |
| `qa-lead.md` | Tests, coverage, GO/NO-GO | Do · Input · Output · Token Rules |
| `devops-lead.md` | CI/CD, Docker, infra, runbook | Do · Boundaries · Input · Token Rules |
| `solution-architect.md` | Architecture design & ADRs | Do · Input · Output · Token Rules |
| `product-discovery.md` | Requirements → scope doc | Do · Input · Output · Token Rules |
| `pm-controller.md` | Milestones, scope, decisions | Do · Input · Output · Token Rules |
| `ux-reviewer.md` | UX flows, accessibility | Do · Input · Output · Token Rules |
| `ui-reviewer.md` | Design system compliance | Lovable Rules · Figma Rules · Checklist · Output · Token Rules |
| `cost-estimator.md` | Effort & infra cost | Do · Input · Output · Token Rules |
| `refactor-librarian.md` | Pattern extraction → templates | Do · Input · Output · Token Rules |
| `learning-agent.md` | Lessons, changelog, contribution | Triggers · Step 1–5 · Token Rules |

### Commands — `commands/`

| File | Invoked as | Agents used |
|------|-----------|-------------|
| `bootstrap-project.md` | `/bootstrap-project` | product-discovery → solution-architect → pm-controller → devops-lead |
| `generate-scope.md` | `/generate-scope` | product-discovery · pm-controller |
| `generate-architecture.md` | `/generate-architecture` | solution-architect · cost-estimator |
| `generate-backend-module.md` | `/generate-backend-module` | backend-lead · qa-lead |
| `generate-frontend-module.md` | `/generate-frontend-module` | frontend-lead · ui-reviewer |
| `generate-tests.md` | `/generate-tests` | qa-lead |
| `review-code.md` | `/review-code` | backend-lead / frontend-lead / qa-lead (auto-selected) |
| `review-qa.md` | `/review-qa` | qa-lead |
| `review-ux.md` | `/review-ux` | ux-reviewer |
| `save-lessons.md` | `/save-lessons` | learning-agent (Steps 1–3) |
| `extract-reusable.md` | `/extract-reusable` | refactor-librarian |
| `update-knowledge.md` | `/update-knowledge` | learning-agent (Step 4) |
| `contribute-learnings.md` | `/contribute-learnings` | learning-agent (Step 5) |

### Workflows — `workflows/`

| File | Trigger | Agents | Key decision point |
|------|---------|--------|--------------------|
| `discovery.md` | `/generate-scope` | product-discovery · pm-controller · cost-estimator | Step 5: approve scope → architecture or stop |
| `architecture.md` | `/generate-architecture` | solution-architect · cost-estimator | Step 5: approve stack → foundation or revise |
| `backend-module.md` | `/generate-backend-module` | backend-lead · qa-lead | Step 5: log to memory/backend-log.md |
| `frontend-module.md` | `/generate-frontend-module` | frontend-lead · ui-reviewer | Step 5: fix BLOCKERs before done |
| `testing.md` | `/generate-tests` | qa-lead | Step 4: flag CRITICAL untested paths |
| `code-review.md` | `/review-code` | (auto-selected) | Step 3: BLOCKER = block merge |
| `qa-review.md` | `/review-qa` | qa-lead | Step 3: all 5 GO criteria must pass |
| `devops.md` | `/bootstrap-project` or manual | devops-lead | Step 5: prod deploy = manual trigger only |
| `new-product.md` | `/bootstrap-project` on empty repo | all agents | Phase checkpoints at end of each phase |

---

## Memory & Context Files

| Path | Written by | Contents |
|------|-----------|----------|
| `context/project.md` | Orchestrator | Tech stack · current phase · last task |
| `context/decisions.md` | pm-controller · solution-architect | ADRs, append-only |
| `memory/scope.md` | product-discovery | Problem · personas · use cases · MVP |
| `memory/architecture.md` | solution-architect | Load SUMMARY section only (first 30 lines) |
| `memory/cost-estimate.md` | cost-estimator | Effort · infra · third-party costs |
| `memory/backend-log.md` | backend-lead | Module name · files · endpoints · test count |
| `memory/frontend-log.md` | frontend-lead | Feature · files · UI verdict |
| `memory/qa-report.md` | qa-lead | Coverage · bugs · GO/NO-GO |
| `memory/code-review-<ts>.md` | review workflow | BLOCKERs · MAJORs · MINORs · verdict |
| `memory/ux-review.md` | ux-reviewer | Score · issues by priority |
| `memory/ui-review.md` | ui-reviewer | Compliance · token map · verdict |
| `memory/milestones.md` | pm-controller | Phases + definition of done |
| `memory/postmortem-YYYY-MM-DD.md` | learning-agent | What worked · what didn't · lessons |
| `memory/reusable-candidates.md` | refactor-librarian | Detected patterns pending extraction |
| `memory/prompt-changelog.md` | learning-agent | PENDING → APPLIED prompt improvements |
| `memory/contributions.md` | learning-agent | PRs pushed to lupiodev/Lupio-os |
