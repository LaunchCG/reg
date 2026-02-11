---
name: tdd-workflow
description: Guides Test-Driven Development implementation following RED-GREEN-REFACTOR cycle
allowed-tools: []
---

# TDD Workflow Skill

This skill guides the Test-Driven Development implementation process, ensuring strict adherence to the RED-GREEN-REFACTOR cycle for high-quality, well-tested code.

## When This Skill is Invoked

This skill will be used when you mention:
- "test-driven development"
- "TDD workflow"
- "red green refactor"
- "write tests first"
- "failing tests"

## TDD Principles

### The RED-GREEN-REFACTOR Cycle

**RED Phase: Write Failing Tests**
- Write the minimum test that captures the requirement
- Verify the test fails for the right reason
- Tests should be specific and focused

**GREEN Phase: Make Tests Pass**
- Write the minimum code to make tests pass
- Don't optimize or add extra features
- Focus on making tests green quickly

**REFACTOR Phase: Improve Code Quality**
- Remove duplication
- Improve naming and structure
- Ensure tests still pass after changes

## How to Use This Skill

### Step 1: Understand the Requirement
```markdown
## TDD Session: [STORY-KEY] [Feature Name]

**User Story:**
As a [persona]
I want [capability]
So that [benefit]

**Acceptance Criteria:**
1. Given [context], When [action], Then [outcome]
2. Given [context], When [action], Then [outcome]
3. Given [context], When [action], Then [outcome]

**Technical Approach:**
- [High-level implementation strategy]
- [Key components or functions needed]
- [Integration points]
```

### Step 2: Break Down into Test Cases
```markdown
## Test Case Planning

### Test Case 1: [Happy Path]
**What it tests:** [Core functionality]
**Input:** [Test data]
**Expected Output:** [Expected result]
**Test Name:** `test_[specific_behavior]`

### Test Case 2: [Edge Case]
**What it tests:** [Boundary condition]
**Input:** [Edge case data]
**Expected Output:** [Expected behavior]
**Test Name:** `test_[edge_case_behavior]`

### Test Case 3: [Error Handling]
**What it tests:** [Error scenarios]
**Input:** [Invalid data]
**Expected Output:** [Error handling]
**Test Name:** `test_[error_scenario]`
```

### Step 3: Execute TDD Cycles

For each test case, follow the RED-GREEN-REFACTOR cycle:

## TDD Cycle Examples

### JavaScript/Jest Example

**RED Phase: Write Failing Test**
```javascript
// tests/userService.test.js
describe('UserService', () => {
  describe('validateEmail', () => {
    it('should return true for valid email format', () => {
      // Arrange
      const userService = new UserService();
      const validEmail = 'user@example.com';

      // Act
      const result = userService.validateEmail(validEmail);

      // Assert
      expect(result).toBe(true);
    });
  });
});
```

**Run Test: FAIL (Expected - UserService not defined)**

**GREEN Phase: Minimal Implementation**
```javascript
// src/userService.js
class UserService {
  validateEmail(email) {
    return true; // Minimal implementation to pass test
  }
}

module.exports = UserService;
```

**Run Test: PASS**

**Add More Specific Test (RED):**
```javascript
it('should return false for invalid email format', () => {
  const userService = new UserService();
  const invalidEmail = 'invalid-email';

  const result = userService.validateEmail(invalidEmail);

  expect(result).toBe(false);
});
```

**Run Tests: FAIL (New test fails - returns true for invalid email)**

**Update Implementation (GREEN):**
```javascript
class UserService {
  validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }
}
```

**Run Tests: ALL PASS**

**REFACTOR Phase: Improve Quality**
```javascript
class UserService {
  validateEmail(email) {
    if (!email || typeof email !== 'string') {
      return false;
    }

    const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return EMAIL_PATTERN.test(email.trim().toLowerCase());
  }
}
```

**Run Tests: STILL PASS**

### Python/pytest Example

**RED Phase:**
```python
# tests/test_user_service.py
import pytest
from services.user_service import UserService

class TestUserService:
    def test_validate_email_returns_true_for_valid_format(self):
        # Arrange
        user_service = UserService()
        valid_email = "user@example.com"

        # Act
        result = user_service.validate_email(valid_email)

        # Assert
        assert result is True
```

**GREEN Phase:**
```python
# services/user_service.py
class UserService:
    def validate_email(self, email):
        return True  # Minimal implementation
```

**REFACTOR Phase:**
```python
import re

class UserService:
    EMAIL_PATTERN = re.compile(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')

    def validate_email(self, email):
        if not isinstance(email, str):
            return False
        return bool(self.EMAIL_PATTERN.match(email.strip().lower()))
```

## TDD Best Practices

### 1. Test Names Should Be Descriptive
```javascript
// Poor test names
it('should work', () => { ... });
it('test email', () => { ... });

// Good test names
it('should return true when email has valid format', () => { ... });
it('should throw error when email is null', () => { ... });
it('should handle edge case of email with multiple dots', () => { ... });
```

### 2. Follow Arrange-Act-Assert Pattern
```javascript
it('should calculate tax correctly for standard rate', () => {
  // Arrange
  const calculator = new TaxCalculator();
  const income = 50000;
  const expectedTax = 10000;

  // Act
  const actualTax = calculator.calculateTax(income);

  // Assert
  expect(actualTax).toBe(expectedTax);
});
```

### 3. One Test, One Concept
```javascript
// Testing multiple concepts
it('should validate email and save user', () => {
  // Tests both email validation AND user saving
});

// Separate concepts
it('should validate email format correctly', () => { ... });
it('should save user when data is valid', () => { ... });
```

### 4. Write Minimum Code in GREEN Phase
```javascript
// Over-implementation in GREEN phase
function calculateDiscount(price, userType) {
  // Complex logic with multiple user types
  // when only one test case exists
}

// Minimal implementation for current tests
function calculateDiscount(price, userType) {
  return price * 0.1; // Just enough to pass current test
}
```

## TDD Workflow Checklist

### Before Starting
- [ ] Understand all acceptance criteria
- [ ] Break down into small, testable units
- [ ] Set up test environment
- [ ] Choose appropriate test framework

### For Each Feature/Function
- [ ] **RED:** Write one failing test
- [ ] **RED:** Verify test fails for the right reason
- [ ] **GREEN:** Write minimal code to pass
- [ ] **GREEN:** Verify test passes
- [ ] **REFACTOR:** Clean up code
- [ ] **REFACTOR:** Verify tests still pass
- [ ] Repeat for next test case

### Quality Gates
- [ ] All tests pass (100% pass rate)
- [ ] Code coverage meets standards (>80%)
- [ ] No duplicate code
- [ ] Clear, descriptive test names
- [ ] Fast test execution (<1 second per test)

## Common TDD Mistakes

### Writing Implementation First
```javascript
// Wrong: Write function first, then tests
function validateEmail(email) { /* complex logic */ }

// Right: Write test first, then minimal implementation
it('should validate email format', () => { ... });
```

### Writing Tests That Pass Immediately
```javascript
// Wrong: Test that passes without implementation
it('should return true', () => {
  expect(true).toBe(true); // Always passes
});

// Right: Test that fails without proper implementation
it('should validate email format', () => {
  const result = validateEmail('test@email.com');
  expect(result).toBe(true); // Will fail until implemented
});
```

### Skip REFACTOR Phase
```javascript
// Wrong: Leave code messy after GREEN phase
function processData(data) {
  let result = [];
  for (let i = 0; i < data.length; i++) {
    if (data[i] !== null && data[i] !== undefined) {
      result.push(data[i].toString().toUpperCase());
    }
  }
  return result;
}

// Right: Refactor for clarity
function processData(data) {
  return data
    .filter(item => item != null)
    .map(item => item.toString().toUpperCase());
}
```

### Testing Implementation Details
```javascript
// Wrong: Testing internal methods
it('should call validateInput method', () => {
  spyOn(service, 'validateInput');
  service.processUser(userData);
  expect(service.validateInput).toHaveBeenCalled();
});

// Right: Testing behavior
it('should reject invalid user data', () => {
  const invalidData = { email: 'invalid' };
  expect(() => service.processUser(invalidData))
    .toThrow('Invalid email format');
});
```

## Integration with Development Workflow

### 1. Story Kickoff
- Review acceptance criteria
- Identify test scenarios
- Set up test structure

### 2. Development Sessions
- Follow RED-GREEN-REFACTOR for each scenario
- Commit after each complete cycle
- Run full test suite regularly

### 3. Story Completion
- All acceptance criteria have corresponding tests
- All tests pass
- Code is clean and well-structured

### 4. Code Review
- Tests are clear and comprehensive
- Implementation is minimal and focused
- Refactoring improved code quality

---

This skill ensures disciplined TDD practice, leading to better design, fewer bugs, and more maintainable code.
