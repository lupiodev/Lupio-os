# Core Module: Products

## Purpose
Product catalog management with categories, variants, pricing, and media.

## Data Model

```sql
CREATE TABLE products (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id      UUID REFERENCES organizations(id) ON DELETE CASCADE,
  name        VARCHAR(255) NOT NULL,
  slug        VARCHAR(255) NOT NULL,
  description TEXT,
  status      VARCHAR(50) DEFAULT 'draft',  -- draft, active, archived
  metadata    JSONB DEFAULT '{}',
  created_by  UUID REFERENCES users(id),
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now(),
  UNIQUE(org_id, slug)
);

CREATE TABLE product_variants (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id  UUID REFERENCES products(id) ON DELETE CASCADE,
  sku         VARCHAR(100),
  name        VARCHAR(255),
  price       DECIMAL(10,2),
  currency    VARCHAR(3) DEFAULT 'USD',
  stock       INTEGER DEFAULT 0,
  attributes  JSONB DEFAULT '{}',
  is_active   BOOLEAN DEFAULT true
);
```

## API Endpoints

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| GET | `/products` | List products | Bearer |
| POST | `/products` | Create product | Bearer + `products:write` |
| GET | `/products/:id` | Get product | Bearer |
| PUT | `/products/:id` | Update product | Bearer + `products:write` |
| DELETE | `/products/:id` | Archive product | Bearer + `products:delete` |
| POST | `/products/:id/variants` | Add variant | Bearer + `products:write` |

## Events
- `products.created`
- `products.updated`
- `products.archived`
- `products.variant_added`
