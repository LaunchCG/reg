# Test-Driven Development (TDD)

## Mandatory Requirement

**All code changes MUST follow the Red-Green-Refactor cycle.**

Tests must be written BEFORE implementation. This is non-negotiable.

## Red-Green-Refactor Cycle

### 1. Red - Write a Failing Test

- Write a test that describes the desired behavior
- Run the test and verify it fails
- The failure should be meaningful (not due to syntax errors)

```typescript
test('user can login with valid credentials', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.login('user@example.com', 'password123');
  await expect(page).toHaveURL('/dashboard');
});
```

### 2. Green - Make the Test Pass

- Write the minimum code needed to make the test pass
- Don't add extra features or optimize yet
- Focus only on making the test green

### 3. Refactor - Clean Up

- Improve the code quality without changing behavior
- Extract common patterns
- Remove duplication
- Keep all tests passing

## Why TDD?

- **Confidence**: Tests verify the code works as expected
- **Design**: Writing tests first leads to better API design
- **Documentation**: Tests document how code should be used
- **Regression Prevention**: Catch bugs before they reach production

## Anti-Patterns

❌ Writing tests after implementation
❌ Skipping the failing test step
❌ Writing tests that always pass
❌ Not refactoring after getting to green
❌ Testing implementation details instead of behavior

## Enforcement

- Code reviews must verify TDD was followed
- CI must run tests before allowing merges
- Tests must have meaningful assertions
- Test coverage should increase with each PR

<!-- To be populated from /Users/jim/Projects/draftbox/.claude/rules/test/test-driven-development.md -->
