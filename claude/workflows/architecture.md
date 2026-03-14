# Workflow: Architecture Design

**Trigger:** `/generate-architecture` or after discovery checkpoint approval
**Agents:** solution-architect, cost-estimator, ux-reviewer (optional)
**Input:** `.lupio/memory/scope.md`
**Output files:** `.lupio/memory/architecture.md`, `.lupio/context/decisions.md` (updated)

---

## Steps

### Step 1 — Load context
Read: `.lupio/memory/scope.md`
If missing: run discovery workflow first, then return here.

Ask user:
1. Preferred backend language/framework? (default: Node.js + TypeScript)
2. Preferred frontend framework? (default: Next.js)
3. Database preference? (default: PostgreSQL)
4. Deployment target? (Vercel, Railway, AWS, Fly.io, other)
5. Any existing systems to integrate?

### Step 2 — Run solution-architect
Load agent: `.lupio/agents/solution-architect.md`
Input: scope.md + tech answers
Produce:
- System overview (one paragraph)
- Component map (services, databases, external APIs)
- Tech stack with rationale
- Data model overview (entities and relationships)
- API design approach (REST/GraphQL/tRPC)
- Infrastructure diagram (text-based)
- Architecture Decision Records (ADRs) for key choices

Write to: `.lupio/memory/architecture.md`

### Step 3 — Update decisions.md
Load: `.lupio/context/decisions.md`
Append all ADRs from architecture.md.

### Step 4 — Run cost-estimator on infrastructure
Load agent: `.lupio/agents/cost-estimator.md`
Input: architecture.md
Update: `.lupio/memory/cost-estimate.md` with infrastructure line items

### Step 5 — Optional: UX flow review
If user provided wireframes, Figma link, or Lovable prototype:
Load agent: `.lupio/agents/ux-reviewer.md`
Run review and append findings to `.lupio/memory/ux-review.md`

### Step 6 — Checkpoint
Present:
```
🏗️ Architecture complete.

Stack: [backend] + [frontend] + [database]
Components: [N services]
Monthly infra: ~$[N]

Files written:
- .lupio/memory/architecture.md
- .lupio/context/decisions.md (updated)
- .lupio/memory/cost-estimate.md (updated)

Proceed to foundation setup? (yes/no/revise)
```

---

## Token Rules
- Load scope.md summary only (first 100 lines if large)
- Never load source code
- Write architecture.md before asking for approval
- decisions.md = append only, never rewrite
