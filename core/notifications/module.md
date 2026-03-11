# Core Module: Notifications

## Purpose
Multi-channel notification system supporting in-app, email, and push notifications.

## Data Model

```sql
CREATE TABLE notification_templates (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        VARCHAR(100) UNIQUE NOT NULL,
  channel     VARCHAR(50) NOT NULL,     -- 'email', 'in_app', 'push'
  subject     VARCHAR(255),
  body        TEXT NOT NULL,            -- Handlebars template
  created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE notifications (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
  org_id      UUID REFERENCES organizations(id),
  template_id UUID REFERENCES notification_templates(id),
  channel     VARCHAR(50) NOT NULL,
  subject     VARCHAR(255),
  body        TEXT,
  data        JSONB DEFAULT '{}',
  read_at     TIMESTAMPTZ,
  sent_at     TIMESTAMPTZ,
  created_at  TIMESTAMPTZ DEFAULT now()
);
```

## API Endpoints

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| GET | `/notifications` | List my notifications | Bearer |
| PUT | `/notifications/:id/read` | Mark as read | Bearer |
| PUT | `/notifications/read-all` | Mark all read | Bearer |
| GET | `/notifications/unread-count` | Unread count | Bearer |

## Events
- `notifications.sent`
- `notifications.read`
