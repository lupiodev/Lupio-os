# Core Module: Authentication

## Purpose
JWT-based authentication with refresh tokens, supporting email/password and OAuth providers.

## Data Model

```sql
-- Users
CREATE TABLE users (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email       VARCHAR(255) UNIQUE NOT NULL,
  password    VARCHAR(255),          -- null for OAuth-only users
  name        VARCHAR(255),
  avatar_url  VARCHAR(500),
  is_active   BOOLEAN DEFAULT true,
  email_verified_at TIMESTAMPTZ,
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- OAuth Accounts
CREATE TABLE oauth_accounts (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
  provider    VARCHAR(50) NOT NULL,  -- 'google', 'github', 'apple'
  provider_id VARCHAR(255) NOT NULL,
  access_token TEXT,
  refresh_token TEXT,
  expires_at  TIMESTAMPTZ,
  UNIQUE(provider, provider_id)
);

-- Refresh Tokens
CREATE TABLE refresh_tokens (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
  token       VARCHAR(500) UNIQUE NOT NULL,
  expires_at  TIMESTAMPTZ NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT now()
);
```

## API Endpoints

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| POST | `/auth/register` | Register with email/password | Public |
| POST | `/auth/login` | Login, returns JWT + refresh | Public |
| POST | `/auth/logout` | Invalidate refresh token | Bearer |
| POST | `/auth/refresh` | Exchange refresh for new JWT | Refresh token |
| POST | `/auth/forgot-password` | Send reset email | Public |
| POST | `/auth/reset-password` | Reset with token | Public |
| GET  | `/auth/me` | Get current user | Bearer |
| GET  | `/auth/oauth/:provider` | OAuth redirect | Public |
| GET  | `/auth/oauth/:provider/callback` | OAuth callback | Public |

## Permissions
- All endpoints are public except those requiring `Bearer` token
- Rate limiting: 5 attempts per 15 minutes on `/auth/login`
- Refresh tokens expire in 30 days
- JWT access tokens expire in 15 minutes

## Events
- `auth.user_registered`
- `auth.user_logged_in`
- `auth.user_logged_out`
- `auth.password_reset_requested`
- `auth.password_reset_completed`
- `auth.oauth_linked`
