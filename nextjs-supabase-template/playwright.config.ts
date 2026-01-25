import { defineConfig, devices } from '@playwright/test';
import dotenv from 'dotenv';

// Load .env file for local development
dotenv.config();

/**
 * Base URL priority:
 * 1. PLAYWRIGHT_BASE_URL (set in CI for Coolify preview URLs)
 * 2. NEXT_PUBLIC_FRONTEND_URL (from .env file, e.g., http://localhost:3700)
 * 3. Fallback to localhost:3000
 */
const BASE_URL =
  process.env.PLAYWRIGHT_BASE_URL ||
  process.env.NEXT_PUBLIC_FRONTEND_URL ||
  'http://localhost:3000';

/**
 * Skip starting local dev server when PLAYWRIGHT_BASE_URL is set,
 * meaning an external server (Docker, Coolify preview, etc.) is already running.
 */
const EXTERNAL_SERVER = !!process.env.PLAYWRIGHT_BASE_URL;

/**
 * Playwright Test configuration for Next.js + Supabase project.
 * See https://playwright.dev/docs/test-configuration
 */
export default defineConfig({
  testDir: './tests/e2e',

  /* Run tests in files in parallel */
  fullyParallel: true,

  /* Fail the build on CI if you accidentally left test.only in the source code */
  forbidOnly: !!process.env.CI,

  /* Retry on CI only */
  retries: process.env.CI ? 2 : 0,

  /* Opt out of parallel tests on CI */
  workers: process.env.CI ? 1 : undefined,

  /* Reporter to use. See https://playwright.dev/docs/test-reporters */
  reporter: [
    ['html', { outputFolder: 'playwright-report' }],
    ['list'],
  ],

  /* Shared settings for all the projects below. See https://playwright.dev/docs/api/class-testoptions */
  use: {
    /* Base URL to use in actions like `await page.goto('/')` */
    baseURL: BASE_URL,

    /* Collect trace when retrying the failed test. See https://playwright.dev/docs/trace-viewer */
    trace: 'on-first-retry',

    /* Take screenshot on failure */
    screenshot: 'only-on-failure',

    /* Record video on failure */
    video: 'retain-on-failure',
  },

  /* Configure projects for major browsers */
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    // Uncomment to test on more browsers:
    // {
    //   name: 'firefox',
    //   use: { ...devices['Desktop Firefox'] },
    // },
    // {
    //   name: 'webkit',
    //   use: { ...devices['Desktop Safari'] },
    // },
  ],

  /* Run your local dev server before starting the tests */
  /* Skip local server when PLAYWRIGHT_BASE_URL is set (Docker, Coolify preview, etc.) */
  webServer: EXTERNAL_SERVER
    ? undefined
    : {
        command: 'pnpm dev',
        url: BASE_URL,
        timeout: 120 * 1000,
        reuseExistingServer: true,
      },
});
