#!/bin/bash
# =============================================================================
# Auto-configure ports for git worktree based on directory name
# Usage: ./setup-worktree.sh
# =============================================================================
# No arguments needed! The script automatically:
# 1. Hashes the current directory name to get a unique offset (0-49)
# 2. Same directory always gets the same ports (deterministic)
# 3. Creates/updates .env with the calculated ports
# =============================================================================

set -e

# Get the current directory name (last component of path)
DIR_NAME=$(basename "$(pwd)")

# Hash the directory name to get a number 0-49
# Using cksum for portability, mod 50 for range
OFFSET=$(echo "$DIR_NAME" | cksum | awk '{print $1 % 50}')

# Calculate ports based on offset
NEXTJS_PORT=$((3001 + OFFSET))
KONG_PORT=$((8000 + OFFSET))
POSTGRES_PORT=$((5432 + OFFSET))
POOLER_PORT=$((6543 + OFFSET))

# Sanitize directory name for COMPOSE_PROJECT_NAME (alphanumeric + dash only)
PROJECT_NAME=$(echo "$DIR_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')

# Create .env from example if it doesn't exist
if [ ! -f .env ] && [ -f .env.example ]; then
    cp .env.example .env
    echo "Created .env from .env.example"
fi

# Function to update or add an environment variable
update_env_var() {
    local key=$1
    local value=$2
    if [ -f .env ]; then
        if grep -q "^${key}=" .env; then
            # Variable exists (uncommented), update all occurrences
            sed -i "s/^${key}=.*/${key}=${value}/" .env
        elif grep -q "^# *${key}=" .env; then
            # Variable is commented out, uncomment and update only the first occurrence
            sed -i "0,/^# *${key}=.*/s/^# *${key}=.*/${key}=${value}/" .env
        else
            # Variable doesn't exist, append to file
            echo "${key}=${value}" >> .env
        fi
    else
        # No .env file, create one with just this variable
        echo "${key}=${value}" >> .env
    fi
}

# Function to generate a random secret (32 chars alphanumeric)
generate_secret() {
    openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32
}

# Function to add a variable only if it doesn't exist (for secrets)
generate_if_missing() {
    local key=$1
    local value=$2
    if [ -f .env ]; then
        if ! grep -q "^${key}=" .env; then
            echo "${key}=${value}" >> .env
        fi
    else
        echo "${key}=${value}" >> .env
    fi
}

# =============================================================================
# Supabase JWT credentials (must match - keys are signed with the secret)
# Using official Supabase demo credentials (same as `supabase init`)
# For production (Coolify), these are auto-populated via SERVICE_* variables
# =============================================================================
SUPABASE_JWT_SECRET="super-secret-jwt-token-with-at-least-32-characters-long"
SUPABASE_ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"
SUPABASE_SERVICE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU"

# Generate all required SERVICE_* variables (only if they don't exist)
generate_if_missing "SERVICE_PASSWORD_POSTGRES" "$(generate_secret)"
generate_if_missing "SERVICE_PASSWORD_JWT" "$SUPABASE_JWT_SECRET"
generate_if_missing "SERVICE_SUPABASEANON_KEY" "$SUPABASE_ANON_KEY"
generate_if_missing "SERVICE_SUPABASESERVICE_KEY" "$SUPABASE_SERVICE_KEY"
generate_if_missing "SERVICE_PASSWORD_LOGFLARE" "$(generate_secret)"
generate_if_missing "SERVICE_PASSWORD_METACRYPTO" "$(generate_secret)"
generate_if_missing "SERVICE_PASSWORD_REALTIME" "$(generate_secret)"
generate_if_missing "SERVICE_PASSWORD_SUPAVISORSECRET" "$(generate_secret)"
generate_if_missing "SERVICE_PASSWORD_VAULTENC" "$(generate_secret)"
generate_if_missing "SERVICE_USER_MINIO" "minioadmin"
generate_if_missing "SERVICE_PASSWORD_MINIO" "$(generate_secret)"
generate_if_missing "SERVICE_USER_ADMIN" "admin"
generate_if_missing "SERVICE_PASSWORD_ADMIN" "$(generate_secret)"

# Update the port variables
update_env_var "COMPOSE_PROJECT_NAME" "$PROJECT_NAME"
update_env_var "NEXTJS_PORT" "$NEXTJS_PORT"
update_env_var "KONG_PORT" "$KONG_PORT"
update_env_var "POSTGRES_PORT" "$POSTGRES_PORT"
update_env_var "POOLER_PORT" "$POOLER_PORT"

echo "=========================================="
echo "Worktree configured: $DIR_NAME"
echo "=========================================="
echo "Project:    $PROJECT_NAME (offset: $OFFSET)"
echo ""
echo "Ports:"
echo "  Next.js:    http://localhost:${NEXTJS_PORT}"
echo "  Supabase:   http://localhost:${KONG_PORT}"
echo "  PostgreSQL: localhost:${POSTGRES_PORT}"
echo "  Pooler:     localhost:${POOLER_PORT}"
echo ""
echo "Run: docker compose -f docker-compose.development.yml up"
echo "=========================================="
