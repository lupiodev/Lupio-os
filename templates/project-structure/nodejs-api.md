# Template: Node.js API Project Structure

```
project-root/
├── src/
│   ├── modules/
│   │   ├── auth/
│   │   ├── users/
│   │   ├── organizations/
│   │   └── [feature]/
│   │       ├── [feature].model.ts
│   │       ├── [feature].routes.ts
│   │       ├── [feature].service.ts
│   │       ├── [feature].schema.ts    # Zod validation
│   │       └── [feature].test.ts
│   ├── shared/
│   │   ├── middleware/
│   │   │   ├── auth.middleware.ts
│   │   │   ├── error.middleware.ts
│   │   │   └── rate-limit.middleware.ts
│   │   ├── utils/
│   │   │   ├── logger.ts
│   │   │   ├── pagination.ts
│   │   │   └── response.ts
│   │   └── types/
│   │       └── index.ts
│   ├── config/
│   │   ├── database.ts
│   │   ├── env.ts
│   │   └── app.ts
│   └── index.ts
├── migrations/
├── tests/
│   └── helpers/
├── .env.example
├── package.json
├── tsconfig.json
└── Dockerfile
```

## Key Conventions
- One module per feature domain
- Services contain business logic, routes handle HTTP
- Zod schemas for all request validation
- Centralized error handling via middleware
- Structured logging via logger utility
