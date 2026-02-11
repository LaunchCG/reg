---
name: playwright-testing
description: Expert in Playwright E2E testing with focus on best practices and test reliability
---

# Playwright Testing Skill

Expert guidance for writing reliable, maintainable E2E tests using Playwright.

## Core Philosophy

- Test user-visible behavior
- Complete test isolation
- Avoid third-party dependencies in tests
- Mock external APIs

## Key Principles

1. **Page Object Model** - Encapsulate page interactions
2. **Accessibility-first locators** - Use getByRole, getByLabel
3. **Auto-waiting** - Trust Playwright's built-in waits
4. **Web-first assertions** - Always use awaited assertions

## Test Organization

```
tests/
├── e2e/              # E2E test specs
├── pages/            # Page Object Models
├── fixtures/         # Test data
└── lib/              # Test utilities
```

## Locator Strategies (Priority Order)

1. getByRole() - Best for accessibility
2. getByLabel() - For form fields
3. getByPlaceholder() - When labels unavailable
4. getByText() - For visible text
5. getByTestId() - Custom data-testid (fallback)
6. CSS/XPath - Avoid (most fragile)

## Best Practices

- Keep PRs focused on single concern
- Use storageState for authentication
- Parallel execution for speed
- Trace viewer for debugging
- Network mocking for external APIs

<!-- To be populated from /Users/jim/Projects/draftbox/.claude/skills/playwright-testing/SKILL.md -->
<!-- 7 additional resource files available in draftbox -->
