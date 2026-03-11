# Template: Next.js App Project Structure

```
project-root/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── (auth)/
│   │   │   ├── login/
│   │   │   └── register/
│   │   ├── (dashboard)/
│   │   │   ├── layout.tsx
│   │   │   └── [feature]/
│   │   ├── api/
│   │   │   └── [...]/          # API routes if using Next.js API
│   │   ├── layout.tsx
│   │   └── page.tsx
│   ├── components/
│   │   ├── ui/                 # Base design system components
│   │   ├── [feature]/          # Feature-specific components
│   │   └── shared/             # Shared composite components
│   ├── hooks/
│   ├── lib/
│   │   ├── api.ts              # API client
│   │   ├── auth.ts
│   │   └── utils.ts
│   ├── stores/                 # State management (Zustand)
│   └── types/
├── public/
├── .env.local.example
├── next.config.ts
├── tailwind.config.ts
└── package.json
```

## Key Conventions
- App Router with route groups for auth vs. dashboard layouts
- shadcn/ui for base components
- Zustand for global state
- React Query / SWR for server state
- Tailwind CSS with design tokens
