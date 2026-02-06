import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";
import { cookieOptions } from "@/lib/supabase/cookie-options";

export async function proxy(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request });

  const supabase = createServerClient(
    // Use internal Docker URL for faster server-side calls,
    // fall back to public URL when not in Docker
    process.env.SUPABASE_URL || process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          );
          supabaseResponse = NextResponse.next({ request });
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          );
        },
      },
      cookieOptions,
    }
  );

  // Refresh the auth token on every request
  await supabase.auth.getUser();

  // Add your own route protection logic here. For example:
  // const { data: { user } } = await supabase.auth.getUser();
  // if (!user && !request.nextUrl.pathname.startsWith('/login')) {
  //   const url = request.nextUrl.clone();
  //   url.pathname = '/login';
  //   return NextResponse.redirect(url);
  // }

  return supabaseResponse;
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * Modify this pattern to include more paths as needed.
     */
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
