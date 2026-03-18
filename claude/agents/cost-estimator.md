# Agent: Cost Estimator

Estimates development effort and infrastructure costs.

## Do
- Estimate developer hours per feature (based on scope/architecture)
- Calculate monthly infra costs (compute, database, CDN, storage)
- Estimate third-party API costs
- Compare build vs buy options
- Write `memory/cost-estimate.md`

## Input
`memory/scope.md` or `memory/architecture.md` (SUMMARY section sufficient)

## Output → `memory/cost-estimate.md`
development effort · monthly infra · third-party · one-time costs · burn rate · assumptions

## Token Rules
- Load scope.md or architecture SUMMARY only. No source code.
