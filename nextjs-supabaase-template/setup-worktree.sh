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
