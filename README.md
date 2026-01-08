# Supabase Coolify Template

The open source Firebase alternative - Latest version for Coolify deployment.

## Features

- Latest Supabase components (Studio, Auth, Storage, Realtime, REST API)
- Automatic JWT token generation via Coolify's magic variables
- MinIO S3-compatible storage backend
- Connection pooling with Supavisor
- Analytics with Logflare

## Auto-Generated Secrets

This template uses Coolify's magic environment variables for automatic secure credential generation:

| Variable | Description |
|----------|-------------|
| `SERVICE_PASSWORD_JWT` | JWT secret for signing tokens |
| `SERVICE_SUPABASEANON_KEY` | Anonymous API key (valid JWT signed with JWT secret) |
| `SERVICE_SUPABASESERVICE_KEY` | Service role API key (valid JWT signed with JWT secret) |
| `SERVICE_PASSWORD_POSTGRES` | PostgreSQL password |
| `SERVICE_PASSWORD_ADMIN` | Dashboard admin password |
| `SERVICE_USER_ADMIN` | Dashboard admin username |

All generated values appear in Coolify's Environment Variables UI and can be customized if needed.

## Deployment

1. In Coolify, create a new service from Docker Compose
2. Paste or import this `docker-compose.yml`
3. Deploy - Coolify will auto-generate all secrets
4. Access Supabase Studio at your configured domain

## Services Included

| Service | Description | Port |
|---------|-------------|------|
| Kong | API Gateway | 8000 |
| Studio | Dashboard UI | 3000 |
| Auth (GoTrue) | Authentication | 9999 |
| REST (PostgREST) | REST API | 3000 |
| Realtime | WebSocket subscriptions | 4000 |
| Storage | File storage API | 5000 |
| PostgreSQL | Database | 5432 |
| MinIO | S3-compatible storage | 9000 |
| Supavisor | Connection pooler | 4000 |
| Analytics | Logging (Logflare) | 4000 |

## Configuration

### Email (SMTP)

Configure email by setting these environment variables in Coolify:

```
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=your-smtp-user
SMTP_PASS=your-smtp-password
SMTP_ADMIN_EMAIL=admin@example.com
SMTP_SENDER_NAME=Supabase
```

### Auth Settings

```
DISABLE_SIGNUP=false
ENABLE_EMAIL_SIGNUP=true
ENABLE_EMAIL_AUTOCONFIRM=false
ENABLE_ANONYMOUS_USERS=false
ENABLE_PHONE_SIGNUP=true
ADDITIONAL_REDIRECT_URLS=
```

### Database

```
POSTGRES_DB=postgres
POSTGRES_PORT=5432
```

## Accessing Your API Keys

After deployment, find your API keys in Coolify's Environment Variables:

- **Anon Key**: `SERVICE_SUPABASEANON_KEY` - Use in frontend applications
- **Service Key**: `SERVICE_SUPABASESERVICE_KEY` - Use in backend/server-side only (has full access)
- **JWT Secret**: `SERVICE_PASSWORD_JWT` - For verifying/signing custom JWTs

## Links

- [Supabase Documentation](https://supabase.com/docs)
- [Self-Hosting Guide](https://supabase.com/docs/guides/self-hosting/docker)
- [Coolify Documentation](https://coolify.io/docs)
