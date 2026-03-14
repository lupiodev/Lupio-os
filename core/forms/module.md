# Core Module: Dynamic Forms

**Purpose:** Build and manage dynamic forms with custom fields, validations, and submissions — useful for onboarding flows, surveys, contact forms, data collection

---

## Data Model

```sql
-- Form definitions
CREATE TABLE forms (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id       UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name         VARCHAR(255) NOT NULL,
  slug         VARCHAR(255) NOT NULL,
  description  TEXT,
  status       VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  settings     JSONB,   -- { allowMultiple, requireAuth, notifyEmail, redirectUrl, closeAt }
  created_by   UUID REFERENCES users(id),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(org_id, slug)
);

-- Form fields (ordered)
CREATE TABLE form_fields (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  form_id      UUID NOT NULL REFERENCES forms(id) ON DELETE CASCADE,
  key          VARCHAR(100) NOT NULL,   -- machine name, e.g. "first_name"
  label        VARCHAR(255) NOT NULL,
  type         VARCHAR(50) NOT NULL CHECK (type IN (
                 'text', 'textarea', 'email', 'number', 'phone',
                 'select', 'multiselect', 'radio', 'checkbox',
                 'date', 'datetime', 'file', 'url', 'hidden'
               )),
  placeholder  VARCHAR(255),
  help_text    TEXT,
  options      JSONB,    -- for select/radio: [{ label, value }]
  validations  JSONB,    -- { required, min, max, minLength, maxLength, pattern, custom }
  is_required  BOOLEAN DEFAULT FALSE,
  is_visible   BOOLEAN DEFAULT TRUE,
  sort_order   INTEGER DEFAULT 0,
  metadata     JSONB,
  UNIQUE(form_id, key)
);

-- Form submissions
CREATE TABLE form_submissions (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  form_id      UUID NOT NULL REFERENCES forms(id),
  org_id       UUID NOT NULL REFERENCES organizations(id),
  user_id      UUID REFERENCES users(id),   -- null if anonymous
  data         JSONB NOT NULL,              -- { field_key: value }
  metadata     JSONB,                       -- { ip, userAgent, referrer }
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_form_fields_form_id ON form_fields(form_id, sort_order);
CREATE INDEX idx_form_submissions_form_id ON form_submissions(form_id);
CREATE INDEX idx_form_submissions_org_id ON form_submissions(org_id, submitted_at DESC);
```

---

## API Endpoints

```
# Form management
GET    /forms                         — List org forms (bearer + forms:read)
POST   /forms                         — Create form (bearer + forms:create)
GET    /forms/:id                     — Get form with fields
PUT    /forms/:id                     — Update form settings (bearer + forms:update)
DELETE /forms/:id                     — Archive form (bearer + forms:delete)
PUT    /forms/:id/publish             — Publish form
PUT    /forms/:id/unpublish           — Unpublish form

# Fields
GET    /forms/:id/fields              — Get fields (ordered)
POST   /forms/:id/fields              — Add field (bearer + forms:update)
PUT    /forms/:id/fields/:fieldId     — Update field
DELETE /forms/:id/fields/:fieldId     — Remove field
PUT    /forms/:id/fields/reorder      — Reorder fields { order: [id, id, ...] }

# Submissions
GET    /forms/:id/submissions         — List submissions (bearer + forms:read)
POST   /forms/:slug/submit            — Submit form (public if published)
GET    /forms/:id/submissions/:subId  — Get submission detail
DELETE /forms/:id/submissions/:subId  — Delete submission (bearer + forms:manage)
GET    /forms/:id/submissions/export  — Export CSV (bearer + forms:manage)
```

---

## Permissions

| Action | Permission |
|--------|-----------|
| View forms | `forms:read` |
| Create/update forms | `forms:create` / `forms:update` |
| Delete/archive forms | `forms:delete` |
| View submissions | `forms:read` |
| Export submissions | `forms:manage` |
| Submit a published form | public (or authenticated if `requireAuth: true`) |

---

## Events

```typescript
forms.created          // { formId, orgId, name }
forms.published        // { formId, orgId }
forms.archived         // { formId, orgId }
forms.submitted        // { submissionId, formId, orgId, userId? }
```

---

## Validation Schema Example

```json
{
  "required": true,
  "minLength": 3,
  "maxLength": 100,
  "pattern": "^[a-zA-Z ]+$",
  "custom": "Must contain only letters and spaces"
}
```

---

## Migration Example

```bash
npx knex migrate:make create_forms_module
npx knex migrate:latest
```

---

## Implementation Notes

- Submissions store data as JSONB — validate against form_fields on write
- `settings.closeAt` — auto-unpublish form at this datetime
- `settings.allowMultiple` — if false, prevent same user from submitting twice
- `settings.notifyEmail` — send email notification on each submission
- For file type fields: store file key in media module, save media.id in submission data
- Export CSV: flatten JSONB data, use field labels as column headers
