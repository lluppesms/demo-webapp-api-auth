import { test, expect } from '@playwright/test';
import { defineConfig } from '@playwright/test';
export default defineConfig({
  reporter: ['junit', { outputFile: 'test-results/e2e-junit-results.xml' }],
});

// BASE_URL = 'https://lll-playwright-web.azurewebsites.net/'
// USERNAME = 'TestUser@lyleluppes.onmicrosoft.com'
// PASSWORD = '8Y94!sXf'
test('Login', async ({ page }) => {
  await page.goto(process.env.BASE_URL);
  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle('Sign in to your account');
  await page.getByLabel('Enter your email, phone, or Skype.').fill(process.env.USERNAME);
  await page.getByRole('button', { name: 'Next' }).click();
  await page.getByPlaceholder('Password').fill(process.env.PASSWORD);
  await page.getByRole('button', { name: 'Sign in' }).click();
  await page.getByRole('button', { name: 'Yes' }).click();
});

