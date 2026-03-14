# Workflow: DevOps Setup

**Trigger:** After architecture approval or explicitly requested
**Agents:** devops-lead
**Input:** `.lupio/memory/architecture.md`, `.lupio/context/decisions.md`
**Output:** CI/CD configs, Dockerfile, deployment scripts

---

## Steps

### Step 1 — Load context
Read:
- `.lupio/context/decisions.md` (deployment target, environment structure)
- `.lupio/memory/architecture.md` lines 1–40 (infra section)

Ask user:
1. Deployment target? (Vercel, Railway, Fly.io, AWS, GCP, other)
2. Environments needed? (default: dev, staging, production)
3. Existing CI provider? (default: GitHub Actions)
4. Database provider? (Railway PostgreSQL, Supabase, AWS RDS, other)
5. Secrets management? (GitHub Secrets, Vault, Doppler)

### Step 2 — Run devops-lead agent
Load agent: `.lupio/agents/devops-lead.md`

Generate based on deployment target:

**GitHub Actions CI:**
- `.github/workflows/ci.yml` — lint + test + build on PR
- `.github/workflows/deploy.yml` — deploy to staging on main push, production on tag

**Docker:**
- `Dockerfile` — multi-stage build (build → production)
- `.dockerignore`

**Environment:**
- `.env.example` — all required env vars documented
- `scripts/setup-env.sh` — local dev environment setup

**Deployment target specific:**
- Vercel: `vercel.json`
- Railway: `railway.json` + service config
- Fly.io: `fly.toml`
- AWS: basic ECS task definition template

### Step 3 — Generate deployment runbook
Write `docs/deployment-runbook.md`:
- How to deploy to staging
- How to deploy to production
- How to rollback
- Environment variable setup
- Database migration procedure

### Step 4 — Safety check
Verify:
- No secrets hardcoded in generated files
- Production deploy requires manual approval (not auto-deploy)
- Database migrations are not auto-run on deploy

### Step 5 — Summary
```
✅ DevOps setup complete.

Target: <platform>
CI: GitHub Actions (lint → test → build → deploy)

Files created:
- .github/workflows/ci.yml
- .github/workflows/deploy.yml
- Dockerfile
- .env.example
- docs/deployment-runbook.md

⚠️ Before first deploy: set secrets in GitHub → Settings → Secrets
Required secrets: [list from .env.example]
```

---

## Token Rules
- Load architecture infra section only (not full file)
- Never generate deploy-to-production scripts that run automatically
- Write all files before presenting summary
