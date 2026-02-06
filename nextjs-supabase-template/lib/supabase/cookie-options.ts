// Fixed cookie name so server (internal Docker URL) and browser (public URL)
// use the same cookie, preventing auth mismatch in Docker networking setups.
//
// Without this, @supabase/ssr derives cookie names from the Supabase URL.
// Server uses http://supabase-kong:8000 (internal Docker) while browser uses
// the public URL — different URLs = different cookie names = broken auth.
export const COOKIE_NAME = "sb-self-hosted-auth-token";

export const cookieOptions = {
  name: COOKIE_NAME,
};
