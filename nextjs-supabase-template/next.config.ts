import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Reference: https://nextjs.org/docs/app/api-reference/config/next-config-js/output
  output: "standalone",

  // Next.js 16: Recommended settings
  reactStrictMode: true,
};

export default nextConfig;
