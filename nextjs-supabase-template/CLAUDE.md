# Project Guidelines

## Constitution (Never Break)

1. Never modify database schemas without explicit approval
2. Always use environment variables for secrets
3. Run tests before committing code changes
4. Never commit sensitive data or credentials
5. Follow existing code patterns in the codebase

## Priority

1. Security first - validate all inputs, sanitize outputs
2. User experience - fast, responsive, accessible
3. Code maintainability - readable, documented, testable
4. Performance - optimize database queries, minimize bundle size

## Framework & Technology Stack

- **Next.js 16** with Turbopack support, standalone output for Docker deployment
- **Supabase self-hosted** (PostgreSQL 15, GoTrue Auth, PostgREST REST API, Realtime WebSockets, Storage API)
- **Trigger.dev** for background jobs and scheduled tasks
- **TypeScript** with strict mode enabled
- **Node.js 22** runtime in Docker containers
- **Connection pooling** via Supavisor - use pooled URL for queries, direct URL for migrations
- **Package managers**: bun (preferred), pnpm, yarn, npm (auto-detected)

## Philosophy

- Prefer composition over inheritance
- Write small, focused functions
- Use TypeScript strict mode
- Handle errors explicitly, never silently fail
- Optimize for readability over cleverness

## Code Standards

- Use meaningful variable and function names
- Keep functions under 50 lines when possible
- Add JSDoc comments for public APIs
- Use async/await over raw promises
- Prefer const over let, never use var

## Environment Variables

- Store all secrets in `.env.local` (never commit)
- Use `.env.example` as template for required variables
- Access via `process.env.VARIABLE_NAME`
- Validate required env vars at startup

## File Organization

```
app/               # Next.js App Router pages and layouts
components/        # Reusable React components
services/          # Application services
lib/               # Utility functions and helpers
hooks/             # Custom React hooks
types/             # TypeScript type definitions
styles/            # Global styles and CSS modules
jobs/              # Trigger.dev background jobs
supabase/
├── migrations/    # Database migrations
└── seed.sql       # Seed data
```

- **Services**: in the `services/` folder, create a folder for each service with its files inside
- **Actions**:
  - Reusable actions: `app/actions/[action-name]/`
  - Page-specific actions: `app/[page-name]/actions/[action-name].ts`
- **Components**:
  - Reusable components: `components/`
  - Page-specific components: `app/[page-name]/components/[component-name].tsx`
- **Background jobs**: use Trigger.dev, create a folder for each job in `jobs/`

## Commands

```bash
# Initial Setup (auto-configures ports, secrets, starts services)
./setup-worktree.sh

# Start development environment
docker compose -f docker-compose.development.yml up -d

# Stop services (preserves data)
docker compose -f docker-compose.development.yml down

# Stop and remove all data
docker compose -f docker-compose.development.yml down -v

# View logs
docker compose -f docker-compose.development.yml logs -f
docker compose -f docker-compose.development.yml logs -f nextjs-app

# Restart services
docker compose -f docker-compose.development.yml restart

# Cleanup worktree
./cleanup-worktree.sh

# Database migrations (run inside container or with direct DB access)
npx supabase migration new <migration_name>
npx supabase db push
```

## Error Handling

- Use try/catch blocks for async operations
- Return meaningful error messages to users
- Log errors with context for debugging
- Use error boundaries for React components
- Never expose stack traces in production

## Documentation

- Update README.md when adding features
- Document API endpoints with request/response examples
- Keep CLAUDE.md updated with project-specific guidelines
- Add inline comments for complex business logic
