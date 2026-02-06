import "server-only";

import { createClient } from "@supabase/supabase-js";

// Admin client with service role key — bypasses RLS.
// Uses internal Docker URL for fast server-side calls.
// No cookie handling needed — for server-only admin operations.
export function createAdminClient() {
  return createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_KEY!,
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    }
  );
}
