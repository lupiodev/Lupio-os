# Context Schema Reference

All agents must read and write context files using these exact schemas.
This ensures consistency across agents and avoids re-deriving the same information.

---

## `.lupio/context/project.md`

```markdown
# Project Context

**Name:** [project name]
**Initialized:** [ISO date]
**Lupio OS Version:** [semver]

## Tech Stack
**Backend:** [framework + language, e.g. "Node.js + TypeScript + Express"]
**Frontend:** [framework, e.g. "Next.js 15 + Tailwind + shadcn/ui"]
**Database:** [e.g. "PostgreSQL 16 (Railway)"]
**Deployment:** [e.g. "Vercel (frontend) + Railway (backend)"]
**Auth:** [e.g. "JWT + refresh tokens"]
**State Management:** [e.g. "Zustand + React Query"]

## Current Phase
[discovery | architecture | foundation | development | qa | release]

## Last Completed Task
[brief description, e.g. "Generated auth module"]

## Active Sprint / Focus
[what is being worked on now]

## Repository Structure
[monorepo | separate repos | description]
```

---

## `.lupio/context/decisions.md`

```markdown
# Decision Log

## DECISION-001: [Title]
**Date:** YYYY-MM-DD
**Status:** accepted | deprecated | superseded by DECISION-XXX
**Deciders:** [who decided]

**Context:** [why this decision was needed]
**Decision:** [what was decided]
**Rationale:** [why this option]
**Alternatives:** [what else was considered]
**Consequences:** [positive and negative]

---

## DECISION-002: [Title]
...
```

Rules:
- Append only — never edit past decisions
- Mark as `deprecated` or `superseded` instead of deleting
- Keep each entry under 150 words

---

## `.lupio/memory/scope.md`

```markdown
# Product Scope

## Problem Statement
[2–3 sentences]

## Target Users
### Persona 1: [Name]
- Role: [description]
- Goal: [what they need]
- Pain: [what frustrates them]

## Use Cases (MVP)
1. [use case] — Priority: HIGH/MEDIUM/LOW
2. ...

## Out of Scope (v1)
- [explicitly excluded feature]

## Assumptions
- [assumption]

## Risks
- [risk and mitigation]

## Milestones
| Phase | Deliverable | Definition of Done |
|-------|-------------|-------------------|
| 1 | [name] | [criteria] |

## Open Questions
- [question] — Owner: [person]
```

---

## `.lupio/memory/architecture.md`

```markdown
# Architecture

## SUMMARY (load this section first — max 100 words)
[Brief system overview for quick agent loading]

## System Overview
[Full description]

## Component Map
[text diagram or list]

## Tech Stack
| Layer | Technology | Rationale |
|-------|-----------|-----------|

## Data Model Overview
[Entity list with key relationships]

## API Design
[REST / GraphQL / tRPC + key conventions]

## Infrastructure
[hosting, CDN, storage, monitoring]

## Architecture Decision Records
[Link to decisions.md entries]
```

---

## `.lupio/memory/backend-log.md`

```markdown
# Backend Development Log

## [module-name] — [date]
- Files created: [list]
- Endpoints: [N endpoints — list key ones]
- Tests: [N unit, N integration]
- Deviations from architecture: [none / description]
- Notes: [any important implementation detail]
```

---

## `.lupio/memory/qa-report.md`

```markdown
# QA Report

## Coverage Summary
| Module | Unit | Integration | E2E | Coverage % |
|--------|------|-------------|-----|-----------|

## Open Issues
| ID | Severity | Description | Status |
|----|----------|-------------|--------|

## Release Readiness
**Date:** YYYY-MM-DD
**Decision:** GO / NO-GO
**Conditions:** [if NO-GO, what must be fixed]
```

---

## Agent Loading Rules

| File | When to load | Max lines |
|------|-------------|-----------|
| `context/project.md` | Every session start | Full |
| `context/decisions.md` | When needing tech context | First 30 |
| `memory/scope.md` | Discovery, architecture phases | First 50 |
| `memory/architecture.md` | Development phases | SUMMARY section only |
| `memory/backend-log.md` | Backend work | Last 20 |
| `memory/qa-report.md` | QA phase | Full |
