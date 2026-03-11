# Command: /bootstrap-project

## Description
Scaffolds a new project with folder structure, initial configuration, and a project context file.

## Required Context
- User provides: project name, type (web app, API, mobile, etc.), tech stack preferences
- Reads: `.lupio/context/project.md`

## Agents Involved
1. `product-discovery` — extracts requirements from the brief
2. `solution-architect` — designs initial architecture
3. `pm-controller` — sets up milestones
4. `devops-lead` — creates initial CI/CD and environment setup

## Execution Steps
1. Ask user for: project name, type, brief description, tech stack, team size
2. Run `product-discovery` to create scope.md
3. Run `solution-architect` to create architecture.md
4. Create project folder structure based on architecture
5. Generate package.json / pyproject.toml / go.mod as appropriate
6. Create `.env.example` with required variables
7. Set up initial git hooks
8. Run `pm-controller` to create milestones.md
9. Run `devops-lead` to create initial CI config

## Expected Output
- `src/` folder structure
- `package.json` (or equivalent)
- `.env.example`
- `.github/workflows/ci.yml`
- `.lupio/memory/scope.md`
- `.lupio/memory/architecture.md`
- `.lupio/memory/milestones.md`

## File Outputs
All files written to project root and `.lupio/memory/`
