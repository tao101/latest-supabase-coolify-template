/** @type {import('next').NextConfig} */
const nextConfig = {
  // REQUIRED for Docker deployment
  // NOTE: This setting ONLY affects production builds (`next build`).
  // It has NO impact on development mode (`npm run dev`).
  // No conditional logic needed - safe to keep enabled unconditionally.
  //
  // Reference: https://nextjs.org/docs/app/api-reference/config/next-config-js/output
  output: 'standalone',

  // Next.js 16: Recommended settings
  reactStrictMode: true,

  // Next.js 16: Turbopack is now configured at the top level (no longer experimental)
  // Uncomment to enable Turbopack with custom options:
  // turbopack: {
  //   // options
  // },

  // =============================================================================
  // Optional: Image optimization domains
  // =============================================================================
  // Add your Supabase storage domain for optimized image loading
  // images: {
  //   domains: ['your-supabase-domain.com'],
  //   remotePatterns: [
  //     {
  //       protocol: 'https',
  //       hostname: '**.supabase.co',
  //       pathname: '/storage/v1/object/public/**',
  //     },
  //   ],
  // },

  // =============================================================================
  // Optional: Environment variables validation
  // =============================================================================
  // Uncomment to ensure required env vars are present at build time
  // env: {
  //   NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
  //   NEXT_PUBLIC_SUPABASE_ANON_KEY: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
  // },
};

// CommonJS export (works with both .js and .mjs)
// For ES modules (Next.js 16 default), use: export default nextConfig;
module.exports = nextConfig;
