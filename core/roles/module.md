# Core Module: Roles & Permissions

## Purpose
RBAC (Role-Based Access Control) with support for custom roles, granular permissions, and multi-tenant scoping.

## Data Model

```sql
-- Roles
CREATE TABLE roles (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        VARCHAR(100) NOT NULL,
  description TEXT,
  org_id      UUID REFERENCES organizations(id) ON DELETE CASCADE,
  is_system   BOOLEAN DEFAULT false,  -- system roles cannot be deleted
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- Permissions
CREATE TABLE permissions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  resource    VARCHAR(100) NOT NULL,  -- e.g. 'products', 'users'
  action      VARCHAR(50) NOT NULL,   -- e.g. 'read', 'write', 'delete', 'manage'
  description TEXT,
  UNIQUE(resource, action)
);

-- Role Permissions (junction)
CREATE TABLE role_permissions (
  role_id       UUID REFERENCES roles(id) ON DELETE CASCADE,
  permission_id UUID REFERENCES permissions(id) ON DELETE CASCADE,
  PRIMARY KEY (role_id, permission_id)
);

-- User Roles
CREATE TABLE user_roles (
  user_id    UUID REFERENCES users(id) ON DELETE CASCADE,
  role_id    UUID REFERENCES roles(id) ON DELETE CASCADE,
  org_id     UUID REFERENCES organizations(id) ON DELETE CASCADE,
  granted_by UUID REFERENCES users(id),
  granted_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, role_id, org_id)
);
```

## API Endpoints

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| GET | `/roles` | List roles | Bearer + `roles:read` |
| POST | `/roles` | Create role | Bearer + `roles:write` |
| PUT | `/roles/:id` | Update role | Bearer + `roles:write` |
| DELETE | `/roles/:id` | Delete role | Bearer + `roles:delete` |
| GET | `/roles/:id/permissions` | Get role permissions | Bearer + `roles:read` |
| PUT | `/roles/:id/permissions` | Set permissions | Bearer + `roles:manage` |
| POST | `/users/:id/roles` | Assign role to user | Bearer + `roles:manage` |
| DELETE | `/users/:id/roles/:roleId` | Remove role | Bearer + `roles:manage` |

## System Roles (pre-seeded)
- `super_admin` — full access
- `org_admin` — manage own org
- `member` — basic access
- `viewer` — read-only

## Events
- `roles.role_created`
- `roles.role_updated`
- `roles.role_deleted`
- `roles.permission_changed`
- `roles.user_role_assigned`
- `roles.user_role_removed`
