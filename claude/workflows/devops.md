# Workflow: DevOps Setup

**Agent:** devops-lead
**Input:** `memory/architecture.md` (infra section), `context/decisions.md`
**Outputs:** CI/CD configs, Dockerfile, `.env.example`, `docs/deployment-runbook.md`

## Steps

1. **Context** — Read `memory/architecture.md` infra section. Ask: deployment target, environments (default: dev/staging/prod), CI provider (default: GitHub Actions), secrets manager.

2. **Generate** (devops-lead) based on target:
   - `.github/workflows/ci.yml` — lint + test + build on PR
   - `.github/workflows/deploy.yml` — staging on main push, prod on tag (manual approval)
   - `Dockerfile` + `.dockerignore` — multi-stage build
   - `.env.example` — all required vars documented
   - Target config: `vercel.json` / `railway.json` / `fly.toml` as appropriate

3. **Runbook** — Write `docs/deployment-runbook.md`: deploy steps, rollback, migration procedure, required secrets.

4. **Safety check** — No hardcoded secrets. Prod deploy requires manual trigger.

5. **Done** — Show: files created, required secrets list.

## Token Rules
- Load architecture infra section only (not full file). Never auto-deploy to production.
