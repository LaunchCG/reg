---
name: test
description: Run Playwright E2E tests
---

# Test Command

Run Playwright E2E test suite.

## Usage

```bash
# Run all tests
npx playwright test

# Run specific test file
npx playwright test tests/e2e/login.spec.ts

# Run tests in headed mode
npx playwright test --headed

# Run tests in debug mode
npx playwright test --debug

# Run tests in UI mode
npx playwright test --ui

# Run specific browser
npx playwright test --project=chromium
npx playwright test --project=firefox
npx playwright test --project=webkit
```

## Test Organization

Tests should be organized by feature or user workflow:

```
tests/
├── e2e/
│   ├── auth.spec.ts          # Authentication flows
│   ├── dashboard.spec.ts     # Dashboard features
│   ├── profile.spec.ts       # User profile
│   └── settings.spec.ts      # Settings
```

## Before Running Tests

1. **Install dependencies**
   ```bash
   npm install
   ```

2. **Install Playwright browsers**
   ```bash
   npx playwright install
   ```

3. **Start dev server** (if needed)
   ```bash
   npm run dev
   ```

## Debugging Failed Tests

1. **View trace** - Check trace files for failed tests
   ```bash
   npx playwright show-trace trace.zip
   ```

2. **Use UI mode** - Interactive test exploration
   ```bash
   npx playwright test --ui
   ```

3. **Run in headed mode** - See browser actions
   ```bash
   npx playwright test --headed
   ```

## CI Integration

Tests run automatically on:
- Every commit
- Pull requests
- Before merges to main

<!-- To be populated from /Users/jim/Projects/draftbox/.claude/commands/test.md -->
