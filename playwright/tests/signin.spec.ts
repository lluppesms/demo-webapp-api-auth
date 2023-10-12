import { test, expect } from '@playwright/test';
import { defineConfig } from '@playwright/test';

export default defineConfig({
  //reporter: ['junit', { outputFile: './test-results/e2e-junit-results.xml' }]
  reporter: [
    'junit', { outputFile: './test-results/e2e-junit-results.xml' },
    'html', {outputFile: './test-results/test-results.html'}
  ]
});

console.log("COMPUTERNAME: ", process.env.COMPUTERNAME)
if (process.env.COMPUTERNAME?.startsWith("DESKTOP")){
  require('dotenv').config({path: '.env'});
}

console.log("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*")
console.log("BASE_URL: ", process.env.BASE_URL)
console.log("TESTUSER: ", process.env.TESTUSER)
console.log("*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*")

test('Login', async ({ page }) => {
  await page.goto(process.env.BASE_URL);
  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle('Sign in to your account');
  await page.getByLabel('Enter your email, phone, or Skype.').fill(process.env.TESTUSER);
  await page.getByRole('button', { name: 'Next' }).click();
  await page.getByPlaceholder('Password').fill(process.env.TESTPASSWORD);
  await page.getByRole('button', { name: 'Sign in' }).click();
  await page.getByRole('button', { name: 'Yes' }).click();
});

