# Lupio OS

An AI-powered development operating system for Claude Code and Cursor. Installs into any project repository and orchestrates the full lifecycle of digital product development.

## What it does

Lupio OS gives AI assistants a structured operating environment with:

- **13 specialized AI agents** covering every phase of development
- **13 executable commands** for common development tasks
- **9 development workflows** (discovery → architecture → backend → frontend → testing → QA → DevOps)
- **Reusable backend core modules** (auth, users, roles, products, and more)
- **Self-learning architecture** that improves prompts and templates over time
- **MCP integrations** for filesystem, git, GitHub, memory, and more
- **Cursor and VS Code support** with editor-specific configuration
- **Token optimization** rules to keep context lean and costs low

---

## Installation

From any project folder:

```bash
bash <(curl -s https://raw.githubusercontent.com/lupiodev/Lupio-os/main/installer/install.sh)
```

### The installation is interactive

The installer will:

1. **Detect your project directory** and show you exactly where files will be created
2. **Detect your editor** (Cursor or VS Code) and configure it automatically
3. **Show you what will be installed** before touching anything
4. **Ask for your confirmation** before creating any files
5. **Check for Claude Code CLI** and offer to install it if missing

Example output:

```
  Lupio OS — AI Development Operating System — v1.1.0
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Detected project directory:
  /Users/you/my-project

  Detected editors:
  ✔  Cursor
  ✔  VS Code

  The following folders will be installed:

  .lupio/
  .lupio/agents/          13 AI agent definitions
  .lupio/commands/         13 executable commands
  .lupio/workflows/        9 development workflows
  .lupio/context/          project context (preserved if exists)
  .lupio/memory/           agent memory (preserved if exists)
  .cursor/               Cursor AI operating rules
  .vscode/               VS Code settings (merged, not overwritten)

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Continue installation? (y/n):
```

If you answer **n**, the installer stops without modifying anything.

---

## What gets installed

```
.lupio/
├── agents/          AI agent definitions (13 agents)
├── commands/        Executable command files (13 commands)
├── workflows/       Development workflow guides (9 workflows)
├── memory/          Persistent agent memory (project-specific, gitignored)
├── context/         Project state, decisions, tech stack (gitignored)
├── scripts/         Update and learning contribution scripts
├── templates/       Reusable code templates
└── core/            Backend module templates (auth, users, roles, etc.)

CLAUDE.md            Claude Code operating instructions (project root)
.mcp.json            MCP server configuration (project root)
.cursor/rules.md     Cursor AI rules (if Cursor detected)
.vscode/settings.json VS Code settings (if VS Code detected, merged safely)
```

---

## Editor Support

### VS Code
- Creates `.vscode/settings.json` with sensible defaults
- If `settings.json` already exists, merges Lupio OS entries without overwriting your settings
- Works with Claude Code extension

### Cursor
- Creates `.cursor/rules.md` with Lupio OS operating rules
- Rules tell Cursor's AI assistant how to navigate the project context, decisions, and agent system
- Only created if not already present

---

## Updating Lupio OS

When a new version of Lupio OS is available, Claude will detect it automatically at the start of your session and ask:

```
🔄 Hay una nueva versión de Lupio OS disponible.
¿Quieres actualizar ahora? (sí / no)
```

Say **sí** and Claude handles everything. No manual steps needed.

You can also update manually at any time:

```bash
bash .lupio/scripts/apply-update.sh
```

This updates agents, commands, workflows, templates, and core modules — without touching your project's `memory/` or `context/` files.

---

## Agents

| Agent | Role |
|-------|------|
| `orchestrator` | Coordinates all agents and routes tasks |
| `product-discovery` | Gathers requirements and defines scope |
| `solution-architect` | Designs system architecture |
| `ux-reviewer` | Validates user experience flows |
| `ui-reviewer` | Reviews UI against Figma/Lovable designs |
| `frontend-lead` | Generates and reviews frontend code |
| `backend-lead` | Generates and reviews backend code |
| `qa-lead` | Creates test plans and reviews quality |
| `devops-lead` | Configures CI/CD and infrastructure |
| `pm-controller` | Manages scope, milestones, and decisions |
| `cost-estimator` | Estimates time and infrastructure costs |
| `refactor-librarian` | Extracts reusable components and patterns |
| `learning-agent` | Updates prompts, templates, and checklists |

---

## Commands

```
/bootstrap-project       Start a new project with full scaffolding
/generate-scope          Create scope document from requirements
/generate-architecture   Design system architecture
/generate-backend-module Generate a complete backend module
/generate-frontend-module Generate a frontend component/page
/generate-tests          Create test suite for a module
/review-ux               UX review of flows or wireframes
/review-code             Code quality review
/review-qa               QA readiness and release decision
/extract-reusable        Extract reusable patterns from code
/save-lessons            Record lessons learned
/update-knowledge        Apply lessons to agents and templates
/contribute-learnings    Push learnings back to Lupio OS
```

---

## Workflows

Each workflow is a step-by-step guide that Claude follows for a given phase:

| Workflow | What it does |
|----------|-------------|
| `discovery` | Product brief → personas → scope → cost estimate |
| `architecture` | Scope → tech stack → component map → ADRs |
| `backend-module` | Module spec → model → service → routes → tests |
| `frontend-module` | Feature spec → page → components → hooks → UI review |
| `testing` | Source files → unit + integration + E2E tests |
| `code-review` | File(s) → BLOCKER/MAJOR/MINOR findings → fix offer |
| `qa-review` | Test coverage → acceptance criteria → GO/NO-GO decision |
| `devops` | Stack → CI/CD → Dockerfile → deployment runbook |
| `new-product` | Full lifecycle from discovery to release |

---

## Backend Core Modules

Pre-built templates for 13 common backend modules:

| Module | What it includes |
|--------|-----------------|
| `auth` | JWT + refresh tokens, OAuth, rate limiting |
| `users` | Profiles, preferences, invitations |
| `roles` | RBAC, granular permissions, multi-tenant |
| `organizations` | Multi-tenant orgs, member management |
| `products` | Catalog, variants, pricing |
| `services` | Service catalog, packages, subscriptions |
| `dashboard` | Aggregated metrics, activity feed |
| `media` | File upload, S3/R2/GCS storage |
| `notifications` | Email, in-app, push, templates |
| `audit` | Immutable audit trail, compliance export |
| `activity` | User-facing activity timeline |
| `tasks` | Task management, assignments, status |
| `forms` | Dynamic forms, field builder, submissions |

---

## Self-Learning

After significant work, Lupio OS automatically detects new learnings and asks:

```
💡 Lupio OS aprendió algo nuevo en esta sesión.

Encontré patrones que mejorarían Lupio OS para futuros proyectos:
- [specific improvements found]

¿Quieres que actualice Lupio OS automáticamente? (sí / no)
```

Say **sí** and Claude will:
1. Write a postmortem with lessons learned
2. Extract reusable patterns to the template library
3. Update the prompt changelog
4. Push improvements directly to the Lupio OS GitHub repo

Every future project benefits from what was learned.

---

## MCP Integrations

**Required:** `filesystem`, `git`, `github`, `memory`, `fetch`, `time`

**Optional:** `postgres`, `playwright`, `figma`, `stripe`, `supabase`

---

## Lovable + Figma

| Tool | Use it for |
|------|-----------|
| **Lovable** | Rapid UI prototyping, landing pages, initial dashboards, early validation |
| **Figma** | Design system, tokens, final component structure, UX flows |

Claude validates Lovable output against the design system and extracts Figma tokens before implementation.

---

## Token Optimization

- Agents load only files relevant to the current task
- Architecture files use a SUMMARY section for fast loading
- Decisions are summarized in `context/decisions.md` — not re-derived
- All outputs are written to disk, not held in conversation context
- Max 10 files loaded per task

---

## License

MIT
