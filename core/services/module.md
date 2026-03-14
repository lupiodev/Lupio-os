# Core Module: Services / Service Catalog

**Purpose:** Manage a catalog of services offered by an organization (e.g. consulting services, SaaS plans, professional services)

---

## Data Model

```sql
-- Service catalog
CREATE TABLE services (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id      UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name        VARCHAR(255) NOT NULL,
  slug        VARCHAR(255) NOT NULL,
  description TEXT,
  category    VARCHAR(100),
  status      VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'archived')),
  pricing     JSONB,        -- { type: 'fixed'|'hourly'|'custom', amount, currency, billing_period }
  metadata    JSONB,        -- flexible attributes
  created_by  UUID REFERENCES users(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(org_id, slug)
);

-- Service offerings / packages
CREATE TABLE service_packages (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  service_id  UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
  name        VARCHAR(255) NOT NULL,
  description TEXT,
  features    JSONB,        -- array of feature strings
  price       DECIMAL(12,2),
  currency    CHAR(3) DEFAULT 'USD',
  is_active   BOOLEAN DEFAULT TRUE,
  sort_order  INTEGER DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Service subscriptions / engagements
CREATE TABLE service_subscriptions (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id       UUID NOT NULL REFERENCES organizations(id),
  service_id   UUID NOT NULL REFERENCES services(id),
  package_id   UUID REFERENCES service_packages(id),
  user_id      UUID NOT NULL REFERENCES users(id),  -- subscriber
  status       VARCHAR(20) DEFAULT 'active' CHECK (status IN ('pending', 'active', 'paused', 'cancelled')),
  started_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at   TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  metadata     JSONB,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_services_org_id ON services(org_id);
CREATE INDEX idx_services_status ON services(status);
CREATE INDEX idx_service_subscriptions_org_id ON service_subscriptions(org_id);
CREATE INDEX idx_service_subscriptions_user_id ON service_subscriptions(user_id);
```

---

## API Endpoints

```
# Service Catalog
GET    /services                    — List active services (public within org)
POST   /services                    — Create service (bearer + services:create)
GET    /services/:id                — Get service detail
PUT    /services/:id                — Update service (bearer + services:update)
DELETE /services/:id                — Archive service (bearer + services:delete)

# Packages
GET    /services/:id/packages       — List packages for service
POST   /services/:id/packages       — Add package (bearer + services:update)
PUT    /services/:id/packages/:pkgId — Update package
DELETE /services/:id/packages/:pkgId — Remove package

# Subscriptions
GET    /subscriptions               — List my subscriptions (bearer)
POST   /subscriptions               — Subscribe to service (bearer)
GET    /subscriptions/:id           — Get subscription detail
PUT    /subscriptions/:id/cancel    — Cancel subscription
GET    /services/:id/subscribers    — List subscribers (bearer + services:manage)
```

---

## Permissions

| Action | Permission Required |
|--------|-------------------|
| List services | public (org member) |
| Create service | `services:create` |
| Update/delete service | `services:update` / `services:delete` |
| Subscribe to service | authenticated |
| View subscribers | `services:manage` |

---

## Events

```typescript
services.created        // { serviceId, orgId, name }
services.updated        // { serviceId, changes }
services.archived       // { serviceId, orgId }
services.subscribed     // { subscriptionId, serviceId, userId }
services.unsubscribed   // { subscriptionId, serviceId, userId }
```

---

## Migration Example

```bash
# Generate migration
npx knex migrate:make create_services_module

# Apply
npx knex migrate:latest
```

---

## Implementation Notes

- `pricing.type = 'custom'` means contact sales — no amount required
- Service `slug` must be unique per org for clean URLs
- Subscriptions support expiry dates for time-limited access
- Package `sort_order` controls display order in catalog
- When a service is archived, existing subscriptions are NOT cancelled automatically — handle separately
