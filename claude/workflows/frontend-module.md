# Workflow: Frontend Module Generation

**Trigger:** `/generate-frontend-module <feature-name>`
**Agents:** frontend-lead, ui-reviewer
**Input:** `.lupio/context/decisions.md`, `.lupio/memory/architecture.md`, feature spec
**Output:** Source files + UI review notes

---

## Steps

### Step 1 — Load context (minimal)
Read ONLY:
- `.lupio/context/decisions.md` (frontend stack, component library, state management)
- List existing components in `src/components/` (names only, not contents)

Ask user:
1. Feature name and route (e.g. `/dashboard/orders`)?
2. What data does this page display?
3. What actions can the user take?
4. Is there a Figma frame or Lovable prototype to reference?
5. Any responsive requirements beyond default?

### Step 2 — Check Figma/Lovable reference
If user provides Figma URL: read design context, extract layout and component structure.
If user provides Lovable prototype: treat as visual reference, validate against design system.
If neither: generate from functional spec using design system defaults.

### Step 3 — Run frontend-lead agent
Load agent: `.lupio/agents/frontend-lead.md`
Input: feature spec + design reference + decisions.md
Generate in this order:
1. `src/app/(dashboard)/<feature>/page.tsx` — main page
2. `src/components/<feature>/` — feature-specific components
3. `src/hooks/use-<feature>.ts` — data fetching hook
4. `src/lib/api/<feature>.ts` — API client functions
5. Loading and error state components

### Step 4 — Run ui-reviewer
Load agent: `.lupio/agents/ui-reviewer.md`
Input: generated component files
Check:
- Design system compliance (spacing, typography, color tokens)
- Responsive design (mobile, tablet, desktop)
- Accessibility basics (aria labels, keyboard nav, contrast)
- Consistency with existing components

Output: inline comments on generated files OR separate review notes

### Step 5 — Apply UI fixes
Apply any BLOCKER or MAJOR findings from ui-reviewer before completing.
Log MINOR findings as TODO comments in the generated files.

### Step 6 — Summary
```
✅ Feature <name> generated.

Files created:
- src/app/(dashboard)/<name>/page.tsx
- src/components/<name>/ (N components)
- src/hooks/use-<name>.ts
- src/lib/api/<name>.ts

UI Review: [PASSED / N issues fixed / N minor TODOs]
```

---

## Token Rules
- Load component LIST only (not file contents) to check for existing reuse
- Load design reference once, extract key specs, do not reload
- Generate all files before running UI review
- Write files immediately, do not hold generated code in context
