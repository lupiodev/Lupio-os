# Core Module: Organizations

## Purpose
Multi-tenant organization management with member management and org-scoped data.

## Data Model

```sql
CREATE TABLE organizations (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        VARCHAR(255) NOT NULL,
  slug        VARCHAR(100) UNIQUE NOT NULL,
  logo_url    VARCHAR(500),
  plan        VARCHAR(50) DEFAULT 'free',
  settings    JSONB DEFAULT '{}',
  is_active   BOOLEAN DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE org_members (
  org_id      UUID REFERENCES organizations(id) ON DELETE CASCADE,
  user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
  role_id     UUID REFERENCES roles(id),
  joined_at   TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (org_id, user_id)
);
```

## API Endpoints

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| POST | `/organizations` | Create org | Bearer |
| GET | `/organizations/:id` | Get org | Bearer + member |
| PUT | `/organizations/:id` | Update org | Bearer + `org:manage` |
| DELETE | `/organizations/:id` | Delete org | Bearer + `org:owner` |
| GET | `/organizations/:id/members` | List members | Bearer + member |
| DELETE | `/organizations/:id/members/:userId` | Remove member | Bearer + `org:manage` |

## Events
- `org.created`
- `org.updated`
- `org.deleted`
- `org.member_joined`
- `org.member_removed`
