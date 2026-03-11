# Core Module: Activity Timeline

## Purpose
A user-facing activity feed showing recent actions across the org (distinct from audit logs which are admin-only).

## Data Model

```sql
CREATE TABLE activities (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id      UUID REFERENCES organizations(id) ON DELETE CASCADE,
  user_id     UUID REFERENCES users(id),
  type        VARCHAR(100) NOT NULL,   -- activity type for rendering
  subject     JSONB NOT NULL,          -- {type: 'product', id: '...', name: '...'}
  description TEXT,
  data        JSONB DEFAULT '{}',
  created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_activities_org ON activities(org_id, created_at DESC);
```

## API Endpoints

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| GET | `/activity` | Get org activity feed | Bearer |
| GET | `/activity/me` | Get my activity | Bearer |

## Pagination
Cursor-based pagination using `created_at` + `id` for stable ordering.

## Auto-Recording
Activities are automatically recorded via event listeners from other modules. Do not call this API directly from business logic — emit events instead.
