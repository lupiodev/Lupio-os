# Core Module: Audit Logs

## Purpose
Immutable audit trail of all significant actions in the system.

## Data Model

```sql
CREATE TABLE audit_logs (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id      UUID REFERENCES organizations(id),
  user_id     UUID REFERENCES users(id),
  action      VARCHAR(100) NOT NULL,    -- e.g. 'products.created'
  resource    VARCHAR(100),             -- e.g. 'products'
  resource_id UUID,
  changes     JSONB,                    -- {before: {}, after: {}}
  ip_address  INET,
  user_agent  TEXT,
  created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_audit_org      ON audit_logs(org_id, created_at DESC);
CREATE INDEX idx_audit_user     ON audit_logs(user_id, created_at DESC);
CREATE INDEX idx_audit_resource ON audit_logs(resource, resource_id, created_at DESC);
```

## API Endpoints

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| GET | `/audit-logs` | List logs (paginated) | Bearer + `audit:read` |
| GET | `/audit-logs/:id` | Get single log | Bearer + `audit:read` |

## Usage Pattern

```typescript
// Log an action from any service
await auditLog.record({
  userId: req.user.id,
  orgId: req.user.orgId,
  action: 'products.updated',
  resource: 'products',
  resourceId: product.id,
  changes: { before: oldProduct, after: newProduct },
  ip: req.ip,
  userAgent: req.headers['user-agent']
});
```

## Retention
- Default: 90 days
- Configurable per org via settings
- Export to CSV available for compliance
