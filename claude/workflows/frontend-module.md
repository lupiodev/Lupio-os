# Workflow: Frontend Module

**Agents:** frontend-lead, ui-reviewer
**Input:** `context/decisions.md`, feature spec
**Outputs:** source files

## Steps

1. **Context** — Read `context/decisions.md` (frontend stack). List existing component names only.
   Ask: feature name/route, data displayed, user actions, Figma/Lovable URL (optional).

2. **Design ref** — If Figma URL: extract layout + tokens. If Lovable: treat as draft, validate vs design system.

3. **Generate** (frontend-lead): page → feature components → data hook → API client → loading/error states.

4. **UI Review** (ui-reviewer) — Check: design tokens, responsive (375/768/1280), accessibility, consistency.
   Fix BLOCKERs + MAJORs. Log MINORs as TODO comments.

5. **Done** — Show: files created, UI review verdict.

## Token Rules
- Load component names list only (not contents). Load design ref once, don't reload.
