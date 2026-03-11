# Command: /generate-backend-module

## Description
Generates a complete backend module including data model, API endpoints, permissions, and tests.

## Required Context
- User provides: module name, data fields, business rules
- Reads: `.lupio/memory/architecture.md`, `.lupio/core/<module>/` template

## Agents Involved
- `backend-lead` — primary
- `qa-lead` — generates test cases

## Execution Steps
1. Ask for: module name, entity fields, relationships, auth rules
2. Check `.lupio/core/` for matching template
3. Generate data model / schema
4. Generate API endpoints (CRUD + business logic)
5. Generate permission rules
6. Generate service layer
7. Generate migration file
8. Run `qa-lead` to generate test file
9. Write summary to backend-log.md

## Expected Output
For module `products` on a Node/Express stack:
- `src/modules/products/product.model.ts`
- `src/modules/products/product.routes.ts`
- `src/modules/products/product.service.ts`
- `src/modules/products/product.permissions.ts`
- `migrations/YYYYMMDD_create_products.sql`
- `tests/products.test.ts`

## File Outputs
All files in project `src/` and `tests/`
`.lupio/memory/backend-log.md` (updated)
