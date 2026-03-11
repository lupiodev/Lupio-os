# Core Module: Tasks & Workflows

## Purpose
Task management with assignments, status tracking, and workflow automation.

## Data Model

```sql
CREATE TABLE tasks (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id      UUID REFERENCES organizations(id) ON DELETE CASCADE,
  title       VARCHAR(500) NOT NULL,
  description TEXT,
  status      VARCHAR(50) DEFAULT 'todo',  -- todo, in_progress, done, cancelled
  priority    VARCHAR(20) DEFAULT 'medium', -- low, medium, high, urgent
  assignee_id UUID REFERENCES users(id),
  created_by  UUID REFERENCES users(id),
  due_date    DATE,
  completed_at TIMESTAMPTZ,
  metadata    JSONB DEFAULT '{}',
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);
```

## API Endpoints

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| GET | `/tasks` | List tasks | Bearer |
| POST | `/tasks` | Create task | Bearer |
| GET | `/tasks/:id` | Get task | Bearer |
| PUT | `/tasks/:id` | Update task | Bearer |
| DELETE | `/tasks/:id` | Delete task | Bearer + `tasks:delete` |
| PUT | `/tasks/:id/assign` | Assign task | Bearer + `tasks:manage` |
| PUT | `/tasks/:id/complete` | Complete task | Bearer |

## Events
- `tasks.created`
- `tasks.updated`
- `tasks.completed`
- `tasks.assigned`
