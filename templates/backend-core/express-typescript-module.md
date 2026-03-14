# Template: Express + TypeScript Backend Module

**Use this template as the scaffold for every `/generate-backend-module` command.**
Adapt names and business logic — structure must remain consistent.

---

## File: `src/modules/<name>/<name>.model.ts`

```typescript
import { z } from 'zod'

// ── Zod Schemas (validation) ──────────────────────────────────
export const Create<Name>Schema = z.object({
  name:        z.string().min(1).max(255),
  description: z.string().optional(),
  // Add fields specific to this module
})

export const Update<Name>Schema = Create<Name>Schema.partial()

export const <Name>QuerySchema = z.object({
  page:   z.coerce.number().int().min(1).default(1),
  limit:  z.coerce.number().int().min(1).max(100).default(20),
  search: z.string().optional(),
})

// ── TypeScript Types ──────────────────────────────────────────
export type Create<Name>Input = z.infer<typeof Create<Name>Schema>
export type Update<Name>Input = z.infer<typeof Update<Name>Schema>
export type <Name>QueryInput  = z.infer<typeof <Name>QuerySchema>

// ── DB Row Type ───────────────────────────────────────────────
export interface <Name>Row {
  id:          string
  org_id:      string
  name:        string
  description: string | null
  created_by:  string
  created_at:  Date
  updated_at:  Date
}
```

---

## File: `src/modules/<name>/<name>.service.ts`

```typescript
import { db } from '@/config/database'
import { emit } from '@/shared/events'
import { paginate } from '@/shared/utils/pagination'
import type { Create<Name>Input, Update<Name>Input, <Name>QueryInput } from './<name>.model'

export async function list<Name>s(orgId: string, query: <Name>QueryInput) {
  const { page, limit, search } = query

  let q = db('<name>s')
    .where({ org_id: orgId })
    .orderBy('created_at', 'desc')

  if (search) {
    q = q.where('name', 'ilike', `%${search}%`)
  }

  return paginate(q, { page, limit })
}

export async function get<Name>(id: string, orgId: string) {
  const item = await db('<name>s').where({ id, org_id: orgId }).first()
  if (!item) throw new NotFoundError('<Name> not found')
  return item
}

export async function create<Name>(data: Create<Name>Input, orgId: string, userId: string) {
  const [item] = await db('<name>s')
    .insert({ ...data, org_id: orgId, created_by: userId })
    .returning('*')

  emit('<name>s.created', { id: item.id, orgId, name: item.name })
  return item
}

export async function update<Name>(id: string, data: Update<Name>Input, orgId: string) {
  const [item] = await db('<name>s')
    .where({ id, org_id: orgId })
    .update({ ...data, updated_at: new Date() })
    .returning('*')

  if (!item) throw new NotFoundError('<Name> not found')
  emit('<name>s.updated', { id, changes: data })
  return item
}

export async function delete<Name>(id: string, orgId: string) {
  const count = await db('<name>s').where({ id, org_id: orgId }).delete()
  if (!count) throw new NotFoundError('<Name> not found')
  emit('<name>s.deleted', { id, orgId })
}
```

---

## File: `src/modules/<name>/<name>.routes.ts`

```typescript
import { Router } from 'express'
import { authenticate } from '@/shared/middleware/auth'
import { authorize } from '@/shared/middleware/authorize'
import { validate } from '@/shared/middleware/validate'
import { Create<Name>Schema, Update<Name>Schema, <Name>QuerySchema } from './<name>.model'
import * as service from './<name>.service'

const router = Router()

router.get('/',
  authenticate,
  authorize('<name>s:read'),
  validate({ query: <Name>QuerySchema }),
  async (req, res) => {
    const items = await service.list<Name>s(req.user.orgId, req.query as any)
    res.json(items)
  }
)

router.post('/',
  authenticate,
  authorize('<name>s:create'),
  validate({ body: Create<Name>Schema }),
  async (req, res) => {
    const item = await service.create<Name>(req.body, req.user.orgId, req.user.id)
    res.status(201).json(item)
  }
)

router.get('/:id',
  authenticate,
  authorize('<name>s:read'),
  async (req, res) => {
    const item = await service.get<Name>(req.params.id, req.user.orgId)
    res.json(item)
  }
)

router.put('/:id',
  authenticate,
  authorize('<name>s:update'),
  validate({ body: Update<Name>Schema }),
  async (req, res) => {
    const item = await service.update<Name>(req.params.id, req.body, req.user.orgId)
    res.json(item)
  }
)

router.delete('/:id',
  authenticate,
  authorize('<name>s:delete'),
  async (req, res) => {
    await service.delete<Name>(req.params.id, req.user.orgId)
    res.status(204).send()
  }
)

export default router
```

---

## File: `src/modules/<name>/<name>.permissions.ts`

```typescript
// Register permissions for RBAC
export const <name>Permissions = [
  { resource: '<name>s', action: 'read',   description: 'View <name>s' },
  { resource: '<name>s', action: 'create', description: 'Create <name>s' },
  { resource: '<name>s', action: 'update', description: 'Update <name>s' },
  { resource: '<name>s', action: 'delete', description: 'Delete <name>s' },
  { resource: '<name>s', action: 'manage', description: 'Full <name> management' },
]
```

---

## File: `migrations/<timestamp>_create_<name>s.sql`

```sql
CREATE TABLE <name>s (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id      UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name        VARCHAR(255) NOT NULL,
  description TEXT,
  created_by  UUID REFERENCES users(id),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_<name>s_org_id ON <name>s(org_id);

-- Insert permissions
INSERT INTO permissions (resource, action, description) VALUES
  ('<name>s', 'read',   'View <name>s'),
  ('<name>s', 'create', 'Create <name>s'),
  ('<name>s', 'update', 'Update <name>s'),
  ('<name>s', 'delete', 'Delete <name>s'),
  ('<name>s', 'manage', 'Full <name> management');
```

---

## File: `src/modules/<name>/<name>.test.ts`

```typescript
import { describe, it, expect, beforeEach, vi } from 'vitest'
import * as service from './<name>.service'

const mockDb = vi.mock('@/config/database')
const ORG_ID = 'org-test-123'
const USER_ID = 'user-test-456'

describe('<Name>Service', () => {
  describe('create<Name>', () => {
    it('should create a <name> with valid data', async () => {
      const input = { name: 'Test <Name>' }
      const result = await service.create<Name>(input, ORG_ID, USER_ID)
      expect(result.name).toBe(input.name)
      expect(result.org_id).toBe(ORG_ID)
    })

    it('should emit <name>s.created event', async () => {
      const emit = vi.spyOn(events, 'emit')
      await service.create<Name>({ name: 'Test' }, ORG_ID, USER_ID)
      expect(emit).toHaveBeenCalledWith('<name>s.created', expect.objectContaining({ orgId: ORG_ID }))
    })
  })

  describe('get<Name>', () => {
    it('should throw NotFoundError for unknown id', async () => {
      await expect(service.get<Name>('unknown-id', ORG_ID)).rejects.toThrow('not found')
    })
  })

  describe('delete<Name>', () => {
    it('should throw NotFoundError if <name> belongs to different org', async () => {
      await expect(service.delete<Name>('some-id', 'other-org')).rejects.toThrow('not found')
    })
  })
})
```

---

## Conventions

- Replace `<name>` with lowercase module name (e.g. `product`)
- Replace `<Name>` with PascalCase (e.g. `Product`)
- All routes are multi-tenant: always filter by `org_id`
- Events use format `<module>.past_tense` (e.g. `products.created`)
- Pagination is cursor-based for large datasets, offset for small datasets
- Never return raw DB errors to client — use error middleware
