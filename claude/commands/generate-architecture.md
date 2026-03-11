# Command: /generate-architecture

## Description
Designs system architecture from scope document and constraints.

## Required Context
- Reads: `.lupio/memory/scope.md`
- User provides: tech stack preferences, team skills, timeline

## Agents Involved
- `solution-architect` — primary
- `cost-estimator` — validates infrastructure cost

## Execution Steps
1. Read scope.md
2. Ask user for tech constraints if not in project.md
3. Run `solution-architect`
4. Present architecture.md for review
5. Run `cost-estimator` on infrastructure section
6. Finalize and record decisions

## Expected Output
`.lupio/memory/architecture.md` with:
- System components
- Tech stack with rationale
- Data models (high level)
- API design
- Infrastructure plan
- ADRs

## File Outputs
`.lupio/memory/architecture.md`
`.lupio/context/decisions.md` (updated)
