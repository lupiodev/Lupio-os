# Core Module: Users & Profiles

## Purpose
User management including profiles, preferences, invitations, and account settings.

## Data Model

```sql
-- User Profiles (extends auth users table)
CREATE TABLE user_profiles (
  user_id     UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  bio         TEXT,
  phone       VARCHAR(50),
  timezone    VARCHAR(100) DEFAULT 'UTC',
  locale      VARCHAR(10) DEFAULT 'en',
  preferences JSONB DEFAULT '{}',
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- Invitations
CREATE TABLE invitations (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email       VARCHAR(255) NOT NULL,
  org_id      UUID REFERENCES organizations(id) ON DELETE CASCADE,
  role_id     UUID REFERENCES roles(id),
  invited_by  UUID REFERENCES users(id),
  token       VARCHAR(255) UNIQUE NOT NULL,
  expires_at  TIMESTAMPTZ NOT NULL,
  accepted_at TIMESTAMPTZ,
  created_at  TIMESTAMPTZ DEFAULT now()
);
```

## API Endpoints

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| GET | `/users` | List users (admin) | Bearer + `users:read` |
| GET | `/users/:id` | Get user | Bearer |
| PUT | `/users/:id` | Update user | Bearer (own) or `users:write` |
| DELETE | `/users/:id` | Delete user | Bearer (own) or `users:delete` |
| GET | `/users/:id/profile` | Get profile | Bearer |
| PUT | `/users/:id/profile` | Update profile | Bearer (own) |
| POST | `/invitations` | Invite user | Bearer + `users:invite` |
| GET | `/invitations/:token` | Validate invite | Public |
| POST | `/invitations/:token/accept` | Accept invite | Bearer |

## Permissions
- Users can only read/update their own data unless they have admin permissions
- Soft delete: users are deactivated, not deleted

## Events
- `users.user_updated`
- `users.user_deleted`
- `users.profile_updated`
- `users.invited`
- `users.invitation_accepted`
