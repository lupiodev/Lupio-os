# Workflow: New Product

## Trigger
User runs `/bootstrap-project` on an empty repository.

## Phases

### Phase 1: Discovery
1. Run `product-discovery` with user brief
2. Run `pm-controller` to set milestones
3. Run `cost-estimator` for initial budget estimate
4. **Checkpoint:** Present scope.md and estimate to user for approval

### Phase 2: Architecture
1. Run `solution-architect` with approved scope
2. Run `ux-reviewer` on initial flow sketches (if provided)
3. Run `cost-estimator` on infrastructure design
4. **Checkpoint:** Present architecture.md for approval

### Phase 3: Foundation
1. Run `devops-lead` to set up CI/CD and environments
2. Run `backend-lead` to generate core modules (auth, users, roles)
3. Run `frontend-lead` to generate project scaffold and design system setup
4. **Checkpoint:** Demo running project foundation

### Phase 4: Feature Development
Repeat per feature:
1. `/generate-backend-module` for data layer
2. `/generate-frontend-module` for UI
3. `/review-code` on output
4. `/generate-tests` for the feature

### Phase 5: QA & Release
1. `/review-qa` for release readiness
2. Run `devops-lead` for deployment
3. `/save-lessons` for the project
4. `/extract-reusable` to bank patterns

## Memory Files Produced
- `.lupio/memory/scope.md`
- `.lupio/memory/architecture.md`
- `.lupio/memory/milestones.md`
- `.lupio/memory/cost-estimate.md`
- `.lupio/memory/backend-log.md`
- `.lupio/memory/qa-report.md`
- `.lupio/memory/postmortem-<date>.md`
