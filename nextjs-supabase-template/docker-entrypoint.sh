#!/bin/sh
set -e

# =============================================================================
# Docker Entrypoint Script for Next.js with Supabase Migrations
# =============================================================================
# This script runs database migrations using Supabase CLI before starting
# the application. It ensures the database is ready and migrations are applied.
#
# Environment Variables Required:
#   - DIRECT_URL: Direct PostgreSQL connection string (not pooled)
#
# Reference: https://supabase.com/docs/reference/cli/supabase-db-push
# =============================================================================

echo "=========================================="
echo "Starting deployment..."
echo "=========================================="

# Wait for database to be ready (max 60 seconds)
if [ -n "$DIRECT_URL" ]; then
    echo "Waiting for database connection..."
    max_attempts=30
    attempt=0

    until pg_isready -d "$DIRECT_URL" > /dev/null 2>&1 || [ $attempt -eq $max_attempts ]; do
        attempt=$((attempt + 1))
        echo "Database not ready, waiting... (attempt $attempt/$max_attempts)"
        sleep 2
    done

    if [ $attempt -eq $max_attempts ]; then
        echo "WARNING: Database connection timeout, proceeding anyway..."
    else
        echo "Database is ready!"
    fi
fi

# Run Supabase migrations if supabase folder exists
if [ -d "./supabase/migrations" ]; then
    if [ -z "$DIRECT_URL" ]; then
        echo "WARNING: supabase/migrations folder found but DIRECT_URL is not set."
        echo "Skipping migrations. Set DIRECT_URL to enable database migrations."
    else
        echo "Running Supabase migrations..."

        # Push migrations to the database using Supabase CLI
        # Flags:
        #   --db-url: Direct database connection (not pooled)
        #   --include-all: Include all migrations not found on remote history table
        #   yes |: Auto-confirm prompts for CI/non-interactive environments
        yes | PGSSLMODE=disable npx supabase db push --db-url "$DIRECT_URL" --include-all

        echo "Supabase migrations completed successfully."
    fi
else
    echo "No supabase/migrations folder found, skipping migrations."
fi

echo "=========================================="
echo "Starting application..."
echo "=========================================="

# Execute the main command (CMD)
exec "$@"
