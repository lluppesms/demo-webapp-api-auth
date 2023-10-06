import { test, expect } from '@playwright/test';
import { defineConfig } from '@playwright/test';
export default defineConfig({
  reporter: ['junit', { outputFile: 'test-results/e2e-junit-results.xml' }],
});

test('Login', async ({ page }) => {
  await page.goto('https://lll-playwright-web.azurewebsites.net/');
  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle('Sign in to your account');
  await page.getByLabel('Enter your email, phone, or Skype.').fill('TestUser@lyleluppes.onmicrosoft.com');
  await page.getByRole('button', { name: 'Next' }).click();
  await page.getByPlaceholder('Password').fill('8Y94!sXf');
  await page.getByRole('button', { name: 'Sign in' }).click();
  await page.getByRole('button', { name: 'Yes' }).click();
});

