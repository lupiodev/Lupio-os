# Core Module: Media & File Management

## Purpose
File upload, storage, and management with support for images, documents, and any binary assets.

## Data Model

```sql
CREATE TABLE media (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id      UUID REFERENCES organizations(id),
  user_id     UUID REFERENCES users(id),
  filename    VARCHAR(255) NOT NULL,
  original_name VARCHAR(255) NOT NULL,
  mime_type   VARCHAR(100),
  size        BIGINT,                     -- bytes
  storage_key VARCHAR(500) NOT NULL,      -- path in storage provider
  url         VARCHAR(500),               -- public URL
  metadata    JSONB DEFAULT '{}',         -- width, height, duration, etc.
  created_at  TIMESTAMPTZ DEFAULT now()
);
```

## API Endpoints

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| POST | `/media/upload` | Upload file | Bearer |
| GET | `/media/:id` | Get file metadata | Bearer |
| DELETE | `/media/:id` | Delete file | Bearer + owner |
| GET | `/media` | List org files | Bearer + `media:read` |

## Storage Providers
Configured via env var `STORAGE_PROVIDER`: `local`, `s3`, `gcs`, `cloudflare-r2`

## Events
- `media.uploaded`
- `media.deleted`
