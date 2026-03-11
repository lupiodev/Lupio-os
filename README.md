# Lupio OS

An AI-powered development operating system for Claude Code. Installs into any project repository and orchestrates the full lifecycle of digital product development.

## What it does

Lupio OS gives Claude Code a structured operating environment with:

- **13 specialized AI agents** covering every phase of development
- **12 executable commands** for common development tasks
- **Reusable backend core modules** (auth, users, roles, products, etc.)
- **Self-learning architecture** that improves prompts and templates over time
- **MCP integrations** for filesystem, git, GitHub, memory, and more
- **Token optimization** rules to keep context lean and costs low

## Installation

From any project folder:

```bash
npx lupio-os init
```

Or manually:

```bash
bash <(curl -s https://raw.githubusercontent.com/your-org/lupio-os/main/installer/install.sh)
```

## What gets installed

Running the installer creates a `.lupio/` folder in your project:

```
.lupio/
├── agents/          # AI agent definitions
├── commands/        # Executable command files
├── memory/          # Persistent agent memory
├── context/         # Project-specific context files
└── workflows/       # Multi-step workflow definitions
```

It also creates a `CLAUDE.md` at your project root that tells Claude Code how to operate within Lupio OS.

## Agents

| Agent | Role |
|-------|------|
| `orchestrator` | Coordinates all agents and routes tasks |
| `product-discovery` | Gathers requirements and defines scope |
| `solution-architect` | Designs system architecture |
| `ux-reviewer` | Validates user experience flows |
| `ui-reviewer` | Reviews visual design and component structure |
| `frontend-lead` | Generates and reviews frontend code |
| `backend-lead` | Generates and reviews backend code |
| `qa-lead` | Creates test plans and reviews quality |
| `devops-lead` | Configures CI/CD and infrastructure |
| `pm-controller` | Manages scope, milestones, and decisions |
| `cost-estimator` | Estimates time and infrastructure costs |
| `refactor-librarian` | Extracts reusable components and patterns |
| `learning-agent` | Updates prompts, templates, and checklists |

## Commands

```
/bootstrap-project     Start a new project with full scaffolding
/generate-scope        Create scope document from requirements
/generate-architecture Design system architecture
/generate-backend-module  Generate a backend module
/generate-frontend-module Generate a frontend component/page
/generate-tests        Create test suite for a module
/review-ux             UX review of flows or wireframes
/review-code           Code quality review
/review-qa             QA readiness review
/extract-reusable      Extract reusable patterns from code
/save-lessons          Record lessons learned
/update-knowledge      Sync knowledge base with new learnings
```

## Backend Core Modules

Pre-built module templates for:
- Authentication & authorization
- Users & profiles
- Roles & permissions
- Organizations & teams
- Products & services
- Dashboard & analytics
- Media & file management
- Notifications
- Audit logs
- Dynamic forms
- Tasks & workflows
- Activity timeline

## MCP Integrations

Required: `filesystem`, `git`, `github`, `memory`, `fetch`, `time`
Optional: `postgres`, `playwright`, `figma`, `jira`, `stripe`, `supabase`

## Lovable + Figma Rules

**Use Lovable for:** rapid UI prototyping, landing pages, initial dashboards, early validation
**Use Figma for:** design system, tokens, component structure, final UX flows

## Token Optimization

Agents load only relevant files, never ingest full repositories, use summarized decision files, and write all results to disk.

## Self-Learning

After each project phase, Lupio OS generates:
- `postmortem.md` — what worked, what didn't
- `reusable-candidates.md` — patterns worth extracting
- `prompt-changelog.md` — prompt improvements

The `learning-agent` applies these to update prompts, templates, and checklists automatically.

## License

MIT
