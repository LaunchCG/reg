# frontend-qa

Playwright E2E testing package with TDD enforcement and QA agent.

## Overview

Comprehensive E2E testing toolkit including:
- Playwright testing expertise and best practices
- TDD enforcement (mandatory Red-Green-Refactor cycle)
- Dedicated QA agent for test development
- Test command for running Playwright tests

## Contents

### Skills
- **playwright-testing** - Expert guidance for Playwright E2E testing

### Rules
- **test-driven-development** - Mandatory TDD workflow enforcement

### Agents
- **frontend-qa** - E2E testing specialist with Playwright expertise

### Commands
- **test** - Run Playwright E2E tests

## Dependencies

- `typescript@^0.2.0` - For TypeScript testing support
- `base-dev@^0.4.0` - For commit standards and MCP servers

## Installation

Add to your `dex.hcl`:

```hcl
plugin "frontend-qa" {
  registry = "dex-dev-registry"
  version  = "^0.1.0"
}
```

## Usage

### Running Tests

Use the `/test` command or run directly:
```bash
npx playwright test
```

### TDD Workflow

1. **Red** - Write failing test
2. **Green** - Make test pass
3. **Refactor** - Clean up code

### QA Agent

The frontend-qa agent specializes in:
- Writing E2E test suites
- Debugging flaky tests
- Optimizing test performance
- Enforcing TDD practices

## Best Practices

- Test user-visible behavior, not implementation
- Use accessibility-first locators (getByRole, getByLabel)
- Keep tests isolated and independent
- Mock external API calls
- Use Page Object Model for maintainability

## Version History

### 0.1.0 (Initial Release)
- Playwright testing skill
- TDD enforcement rule
- Frontend QA agent
- Test command

## Note

This package contains placeholder content. Full content should be populated from:
- `/Users/jim/Projects/draftbox/.claude/skills/playwright-testing/`
- `/Users/jim/Projects/draftbox/.claude/agents/qa.md`
- `/Users/jim/Projects/draftbox/.claude/commands/test.md`
- `/Users/jim/Projects/draftbox/.claude/rules/test/test-driven-development.md`
