# /bootstrap-project

Scaffold a new project end-to-end.

**Agents:** product-discovery → solution-architect → pm-controller → devops-lead
**Ask:** project name, type, brief description, tech stack, team size

**Steps:** collect brief → `workflows/discovery.md` → `workflows/architecture.md` → generate folder structure → package.json / .env.example → git hooks → milestones → CI config

**Outputs:** `src/`, `package.json`, `.env.example`, `.github/workflows/ci.yml`, `memory/scope.md`, `memory/architecture.md`, `memory/milestones.md`

**Token:** Load only `context/project.md`. No source scanning.
