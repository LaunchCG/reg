---
name: code-test-create
description: Create TDD test suite for code implementation based on story acceptance criteria
allowed-tools: []
---

# Code Test Create Skill

Generates comprehensive test suite (unit, integration, e2e) for code implementation following TDD principles based on story acceptance criteria.

## When This Skill is Invoked

This skill is automatically invoked by the `code` agent at the start of the TDD cycle to create failing tests before implementation.

## Purpose

Creates test suite that:
1. Covers all acceptance criteria from Jira story
2. Includes unit, integration, and e2e tests
3. Follows project's test framework conventions
4. Fails initially (RED phase of TDD)
5. Provides clear failure messages

## Test Generation Process

### Step 1: Fetch Story from Jira

- Use MCP Atlassian tool to fetch story by key
- Extract acceptance criteria
- Parse Given/When/Then scenarios
- Identify test data requirements
- Note technical approach

### Step 2: Review Documentation Context

**CRITICAL: Use documentation context from the code agent to inform test design.**

**Documentation to Consider:**

| Document | Impact on Tests |
|----------|-----------------|
| ARCHITECTURE.md | Where tests should live, component boundaries to test |
| ADRs | Architectural decisions that constrain test approaches |
| Testing docs | Required test patterns, frameworks, coverage expectations |
| API contracts | Expected request/response formats to validate |
| Data flow diagrams | Integration points to test |
| **docs/conventions/testing-conventions.md** | Test patterns, naming, mock strategies |
| **docs/conventions/coding-standards.md** | Framework patterns that affect test structure |

**Apply to Test Generation:**
- **Test file location:** Match documented test structure (from conventions or codebase)
- **Test patterns:** Use patterns from `docs/conventions/testing-conventions.md`
- **Mock strategies:** Follow documented approach for mocking external services
- **Coverage expectations:** Meet documented coverage thresholds
- **Naming conventions:** Follow test naming patterns from conventions
- **Integration testing:** Test documented integration points

**If Conventions Exist (`docs/conventions/testing-conventions.md`):**
- Use documented test file naming patterns
- Follow documented test structure (describe/it, AAA pattern, etc.)
- Use documented mock strategies for databases, APIs, file systems
- Meet documented coverage requirements

**If No Conventions:**
- Fall back to codebase analysis for patterns
- Use standard conventions for detected framework
- Note in test plan that conventions were not available

### Step 3: Analyze Project Test Structure

- Detect test framework (Jest, pytest, RSpec, JUnit, etc.)
- Identify test file naming conventions
- Find existing test patterns
- Determine mock/stub approach
- Locate test data fixtures

### Step 4: Map AC to Test Types

**For each acceptance criterion, determine test type:**

| Scenario Type | Test Type | Rationale |
|---------------|-----------|-----------|
| Happy path, single function | Unit Test | Tests isolated functionality |
| Multiple components | Integration Test | Tests component interaction |
| Full user flow | E2E Test | Tests complete user journey |
| Error handling | Unit/Integration | Tests error boundaries |
| Edge cases | Unit Test | Tests boundary conditions |

### Step 5: Generate Test Plan

```markdown
# Test Plan for [STORY-KEY]: [Story Title]

## Story Summary
**As a** [persona]
**I want** [capability]
**So that** [benefit]

---

## Documentation Context Applied

### Architecture Constraints
- **Component:** [Where this code belongs based on ARCHITECTURE.md]
- **Integration Points:** [Systems to test against based on docs]

### Relevant ADRs
- **ADR-XXX:** [Decision that affects test approach]
- **ADR-YYY:** [Another relevant decision]

### Testing Conventions Applied
> From `docs/conventions/testing-conventions.md` (if exists)

- **File Naming:** [Pattern from conventions, e.g., `*.test.ts`, `test_*.py`]
- **Test Structure:** [Pattern from conventions, e.g., describe/it, class-based]
- **Naming Convention:** [Pattern from conventions, e.g., `should_X_when_Y`]
- **Mock Strategy:** [From conventions, e.g., jest.mock, unittest.mock]
- **Coverage Target:** [Documented minimum coverage, e.g., 80%]

### Testing Standards (from docs)
- **Framework:** [Documented test framework]
- **Coverage Target:** [Documented minimum coverage]
- **Mock Strategy:** [Documented approach to mocking]

---

## Acceptance Criteria Test Mapping

### AC 1: [Happy Path]
> Given [context]
> When [action]
> Then [outcome]

**Test Type:** [Unit/Integration/E2E]
**Test File:** `[path/to/test_file]`
**Test Name:** `test_[specific_behavior]`

**Test Steps:**
1. Arrange: [Setup needed]
2. Act: [Action to perform]
3. Assert: [Expected outcome]

**Expected Failure Message:** `[What RED phase should show]`

---

### AC 2: [Edge Case]
> Given [edge context]
> When [action]
> Then [outcome]

**Test Type:** [Unit/Integration/E2E]
**Test File:** `[path/to/test_file]`
**Test Name:** `test_[specific_edge_case]`

**Test Steps:**
1. Arrange: [Setup edge case]
2. Act: [Trigger edge case]
3. Assert: [Expected behavior]

**Expected Failure Message:** `[What RED phase should show]`

---

### AC 3: [Error Handling]
> Given [error condition]
> When [action]
> Then [error handling]

**Test Type:** [Unit/Integration/E2E]
**Test File:** `[path/to/test_file]`
**Test Name:** `test_[error_scenario]`

**Test Steps:**
1. Arrange: [Setup error condition]
2. Act: [Trigger error]
3. Assert: [Expected error handling]

**Expected Failure Message:** `[What RED phase should show]`

---

## Test Suite Structure

### Unit Tests
**Location:** `tests/unit/`
**Files:**
- `test_[module1].py`
- `test_[module2].py`

**Coverage:** [Core business logic, utilities, helpers]

### Integration Tests
**Location:** `tests/integration/`
**Files:**
- `test_[integration_scenario].py`

**Coverage:** [Component interactions, API calls, database operations]

### E2E Tests
**Location:** `tests/e2e/`
**Files:**
- `test_[user_flow].py`

**Coverage:** [Complete user journeys, full workflows]

---

## Test Data Requirements

**Fixtures Needed:**
- [Fixture 1: Description]
- [Fixture 2: Description]

**Mock Objects:**
- [External API: mock responses]
- [Database: test data]

---

## Expected TDD Cycle

### RED Phase (Current)
1. Generate all tests
2. Run tests - ALL should fail
3. Verify failure messages are clear
4. **Success criteria:** All tests fail with expected messages

### GREEN Phase (Next)
1. Implement minimal code to pass each test
2. Run tests after each implementation
3. Verify tests pass
4. **Success criteria:** All tests pass

### REFACTOR Phase (Final)
1. Improve code quality
2. Remove duplication
3. Ensure tests still pass
4. **Success criteria:** Clean code, all tests pass

---

**Test Plan Created:** [timestamp]
**Total Tests:** [count]
**Ready for Test Generation:** Yes
```

## Example Test Generation

### JavaScript/Jest Example

```javascript
// tests/unit/userService.test.js

describe('UserService', () => {
  describe('exportHealthScores', () => {
    // AC 1: Happy Path
    it('should export customer health scores to CSV with correct columns', () => {
      // Arrange
      const customers = [
        { id: 1, name: 'Acme Corp', health_score: 85, last_contact: '2025-01-15' }
      ];
      const userService = new UserService();

      // Act
      const csv = userService.exportHealthScores(customers);

      // Assert
      expect(csv).toContain('customer_id,name,health_score,last_contact_date');
      expect(csv).toContain('1,Acme Corp,85,2025-01-15');
    });

    // AC 2: Edge Case - No Data
    it('should show error message when no customers to export', () => {
      // Arrange
      const customers = [];
      const userService = new UserService();

      // Act & Assert
      expect(() => userService.exportHealthScores(customers))
        .toThrow('No data to export');
    });

    // AC 3: Error Handling
    it('should handle export service unavailability', async () => {
      // Arrange
      const customers = [{ id: 1 }];
      const userService = new UserService();
      mockExportService.exportToCSV.mockRejectedValue(new Error('Service unavailable'));

      // Act
      const result = await userService.exportHealthScores(customers);

      // Assert
      expect(result.error).toBe('Export failed, please try again');
    });
  });
});
```

### Python/pytest Example

```python
# tests/unit/test_user_service.py

import pytest
from services.user_service import UserService

class TestUserService:
    class TestExportHealthScores:
        # AC 1: Happy Path
        def test_exports_customer_health_scores_to_csv_with_correct_columns(self):
            # Arrange
            customers = [
                {'id': 1, 'name': 'Acme Corp', 'health_score': 85, 'last_contact': '2025-01-15'}
            ]
            user_service = UserService()

            # Act
            csv = user_service.export_health_scores(customers)

            # Assert
            assert 'customer_id,name,health_score,last_contact_date' in csv
            assert '1,Acme Corp,85,2025-01-15' in csv

        # AC 2: Edge Case - No Data
        def test_raises_error_when_no_customers_to_export(self):
            # Arrange
            customers = []
            user_service = UserService()

            # Act & Assert
            with pytest.raises(ValueError, match='No data to export'):
                user_service.export_health_scores(customers)

        # AC 3: Error Handling
        def test_handles_export_service_unavailability(self, mocker):
            # Arrange
            customers = [{'id': 1}]
            user_service = UserService()
            mocker.patch('services.export_service.export_to_csv',
                        side_effect=Exception('Service unavailable'))

            # Act
            result = user_service.export_health_scores(customers)

            # Assert
            assert result['error'] == 'Export failed, please try again'
```

## Output Format

Format results using the template in `templates/output.md`.

See the template file for the complete output structure and variables to populate.

## Integration

This skill is the first step in the code TDD cycle:
1. **code-test-create** (this skill) - Generate failing tests
2. **code-build** - Implement code to pass tests
3. **code-test-verify** - Run tests and verify they pass

## Error Handling

### Story Not Found in Jira
```markdown
**Error:** Unable to fetch story [STORY-KEY] from Jira

**Possible Causes:**
- Invalid story key
- No Jira access permissions
- Network connectivity issue

**Action:** Verify story key and ensure Atlassian MCP OAuth is properly configured
```

### No Acceptance Criteria
```markdown
**Error:** Story [STORY-KEY] has no acceptance criteria

**Problem:** Cannot generate tests without testable AC

**Required:** Story must have Given/When/Then acceptance criteria

**Action:** Use `/story test [STORY-KEY]` to validate story first, then `/story [STORY-KEY]` to refine
```

### Test Framework Not Detected
```markdown
**Warning:** Cannot detect test framework

**Action Required:** Please specify test framework:
- Jest (JavaScript/TypeScript)
- pytest (Python)
- RSpec (Ruby)
- JUnit (Java)
- [Other]

**Or:** Provide path to existing test file as template
```

---

This skill ensures comprehensive test coverage is created BEFORE implementation, following true TDD principles (RED-GREEN-REFACTOR).
