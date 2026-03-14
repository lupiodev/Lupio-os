# Lupio OS — Improvement Plan

**Date:** 2026-03-14
**Version:** 1.0.0 → 1.1.0
**Based on:** docs/lupio-os-analysis.md

---

## 1. Improvements Made in This Update

### Workflows (Critical Gap — Now Filled)

| Workflow | File | Status |
|----------|------|--------|
| Product Discovery | `claude/workflows/discovery.md` | ✅ Added |
| Architecture Design | `claude/workflows/architecture.md` | ✅ Added |
| Backend Module | `claude/workflows/backend-module.md` | ✅ Added |
| Frontend Module | `claude/workflows/frontend-module.md` | ✅ Added |
| Test Generation | `claude/workflows/testing.md` | ✅ Added |
| Code Review | `claude/workflows/code-review.md` | ✅ Added |
| QA Review | `claude/workflows/qa-review.md` | ✅ Added |
| DevOps Setup | `claude/workflows/devops.md` | ✅ Added |

Before this update: 1 workflow existed. Now: 9 workflows covering the full SDLC.

### Core Modules (Gaps Filled)

| Module | File | Status |
|--------|------|--------|
| Services / Service Catalog | `core/services/module.md` | ✅ Added |
| Dynamic Forms | `core/forms/module.md` | ✅ Added |

All 13 core modules now have complete definitions.

### Templates (backend-core filled)

| Template | File | Status |
|----------|------|--------|
| Express + TypeScript module scaffold | `templates/backend-core/express-typescript-module.md` | ✅ Added |
| Context schema reference | `templates/docs/context-schema.md` | ✅ Added |

### Agent Improvements

| Agent | Improvement |
|-------|------------|
| `orchestrator.md` | Added startup protocol, task routing table, phase management, explicit file loading rules |
| `ui-reviewer.md` | Added complete Lovable integration rules, Figma integration rules, review checklist, token rules |
| `learning-agent.md` | Restructured as step-by-step process, capped postmortem at 500 words, explicit output files |

### Documentation

| File | Status |
|------|--------|
| `docs/lupio-os-analysis.md` | ✅ Created — system strengths, weaknesses, gaps, token inefficiencies |
| `docs/lupio-os-improvement-plan.md` | ✅ This file |

---

## 2. Recommended Next Improvements

### High Priority

**A. Merge contribute.sh and auto-contribute.sh**
Two scripts do the same job via different mechanisms (PR vs direct push). Should be one script with `--pr` flag for cases where review is wanted.
- File: `scripts/contribute.sh`
- Action: Add `--direct` / `--pr` flags, deprecate `auto-contribute.sh`

**B. Add `/generate-devops` command**
DevOps has a workflow but no dedicated command entry point. Users can't discover it.
- File: `claude/commands/generate-devops.md`
- Action: Create command following same pattern as other commands

**C. Improve `generate-scope` command**
Currently thin. Should drive the full discovery workflow including persona generation and use case ranking.
- File: `claude/commands/generate-scope.md`
- Action: Reference `workflows/discovery.md` explicitly

**D. Fix CLAUDE.md command table**
`/update-knowledge` is missing from the command reference table in the generated CLAUDE.md.
- File: `installer/install.sh` (CLAUDE.md template section)
- Action: Add update-knowledge to the commands table

### Medium Priority

**E. Add context validation on install**
When install runs, generate a validated `project.md` and `decisions.md` from the context schema. Currently uses a basic template.
- File: `installer/install.sh` `init_project_context()` function
- Action: Reference `templates/docs/context-schema.md` for generated files

**F. Add `architecture.md` SUMMARY section to solution-architect**
Large architecture files slow down agents. The SUMMARY section (defined in context-schema.md) should be generated first and agents instructed to load only that section initially.
- File: `claude/agents/solution-architect.md`
- Action: Add rule to always write SUMMARY section at top of architecture.md

**G. Add frontend-core template for shadcn/ui + Zustand**
The existing `nextjs-app.md` template describes structure but doesn't include a starter component template or store template.
- File: `templates/frontend-core/`
- Action: Add `shadcn-component.md` and `zustand-store.md` templates

### Low Priority

**H. Add LEARNING_HISTORY.md tracking**
The `ci-apply-learnings.js` script appends to `LEARNING_HISTORY.md` but this file is not initialized. Add it to the repo with a header.

**I. Add `/status` command**
A quick command for Claude to report current project state:
- Current phase
- Last 3 completed tasks
- Open decisions
- Any pending learning contributions

**J. Figma MCP auto-detection**
When user provides a Figma URL, the orchestrator should automatically route to `ui-reviewer` with Figma context rather than requiring the user to know which command to use.

---

## 3. Future Architecture Roadmap

### v1.2 — Multi-Project Intelligence
Allow the learning system to aggregate patterns across multiple projects on the same machine. The learning-agent currently operates per-project. A cross-project index would allow Lupio OS to suggest: "You solved this problem in project-X — want to reuse that pattern?"

### v1.3 — Agent Memory Persistence
Currently each Claude Code session starts fresh. The MCP `memory` server is configured but not deeply integrated. Agents should persist key facts (tech stack, key decisions, recurring patterns) to MCP memory so they survive session restarts without reloading files.

### v1.4 — Team Mode
Currently single-user. Team mode would allow multiple developers on the same project to:
- Share the `.lupio/context/` via git
- Have separate `.lupio/memory/` per developer
- Merge learnings from team members

### v1.5 — Template Marketplace
Allow the community to contribute templates via PR to `lupiodev/Lupio-os`. Add a `templates/community/` directory and a review process for community-submitted modules and patterns.

### v2.0 — Agent Specialization by Stack
Today all agents are stack-agnostic. v2.0 would allow loading stack-specific agent variants:
- `backend-lead-django.md` for Python projects
- `backend-lead-rails.md` for Ruby projects
- `frontend-lead-vue.md` for Vue projects
The orchestrator would load the correct variant based on `project.md` tech stack.

---

## 4. Missing Capabilities (Not Yet Implemented)

| Capability | Priority | Complexity |
|-----------|----------|-----------|
| `/generate-devops` command | HIGH | Low |
| Cross-project pattern aggregation | MEDIUM | High |
| MCP memory deep integration | MEDIUM | Medium |
| Automated context validation | MEDIUM | Low |
| Stack-specific agent variants | LOW | High |
| Community template marketplace | LOW | Medium |
| Team mode / shared context | LOW | High |
| Figma URL auto-detection in orchestrator | MEDIUM | Low |

---

## 5. Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-03-11 | Initial release — 13 agents, 13 commands, 11 core modules, installer |
| 1.1.0 | 2026-03-14 | +8 workflows, +2 core modules, +2 templates, improved orchestrator, ui-reviewer, learning-agent, analysis docs |
