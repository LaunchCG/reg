---
name: code-test-verify
description: Verify all tests pass and acceptance criteria are met following TDD verification
allowed-tools: []
---

# Code Test Verify Skill

Verifies that all tests pass and acceptance criteria are fully met, completing the TDD cycle's verification phase.

## When This Skill is Invoked

This skill is automatically invoked by the `code` agent during the VERIFY phase of the TDD cycle, after code has been implemented.

## Purpose

Verifies:
1. All tests pass (unit, integration, e2e)
2. All acceptance criteria are covered
3. Code quality meets standards
4. No regressions introduced
5. Implementation is complete

## Verification Process

### Step 1: Run Full Test Suite

```bash
# Run all tests
[test command - npm test, pytest, etc.]
```

**Collect Results:**
- Total tests run
- Tests passed
- Tests failed
- Test coverage percentage
- Execution time

### Step 2: Verify Test Results

```markdown
## Test Execution Results

### Test Summary
- **Total Tests:** [count]
- **Passed:** [count]
- **Failed:** [count]
- **Skipped:** [count]
- **Coverage:** [percentage]%
- **Duration:** [time]

### Test Breakdown

#### Unit Tests
- **Total:** [count]
- **Passed:** [count]
- **Failed:** [count]
- **Coverage:** [percentage]%

#### Integration Tests
- **Total:** [count]
- **Passed:** [count]
- **Failed:** [count]
- **Coverage:** [percentage]%

#### E2E Tests
- **Total:** [count]
- **Passed:** [count]
- **Failed:** [count]
- **Coverage:** [percentage]%
```

### Step 3: Map Tests to Acceptance Criteria

```markdown
## Acceptance Criteria Coverage

### AC 1: [Description]
> Given [context]
> When [action]
> Then [outcome]

**Tests:**
- `test_[test_name_1]` - PASS
- `test_[test_name_2]` - PASS

**Status:** FULLY COVERED

---

### AC 2: [Description]
> Given [context]
> When [action]
> Then [outcome]

**Tests:**
- `test_[test_name_3]` - PASS

**Status:** FULLY COVERED

---

### AC 3: [Description]
> Given [context]
> When [action]
> Then [outcome]

**Tests:**
- `test_[test_name_4]` - FAIL
  **Error:** [failure message]

**Status:** NOT COVERED
```

### Step 4: Analyze Test Failures

**For each failed test:**

```markdown
### Failed Test: [test_name]

**File:** `[test_file]`

**Test Code:**
```[language]
[Test that failed]
```

**Error Message:**
```
[Actual error output]
```

**Analysis:**
- **Expected:** [What test expected]
- **Actual:** [What actually happened]
- **Root Cause:** [Why it failed]

**Required Fix:**
```[language]
[Code change needed]
```

**Impact:** Blocks AC [number]
```

### Step 5: Check Code Quality

```markdown
## Code Quality Checks

### Linting
- **Status:** [PASS/FAIL]
- **Issues:** [count]
- **Critical:** [count]

### Code Coverage
- **Overall:** [percentage]%
- **Branches:** [percentage]%
- **Functions:** [percentage]%
- **Lines:** [percentage]%

**Target Coverage:** >= 80%
**Status:** [PASS/FAIL]

### Security Scan
- **Vulnerabilities:** [count]
- **Critical:** [count]
- **High:** [count]

**Status:** [PASS/FAIL]
```

## Output Format

Format results using the template in `templates/output.md`.

See the template file for the complete output structure and variables to populate.

## Integration

This skill is the third step in the code TDD cycle:
1. **code-test-create** - Generate failing tests
2. **code-build** - Implement code to pass tests
3. **code-test-verify** (this skill) - Run tests and verify they pass

**If verification fails:** Agent loops back to step 2 (build) with specific failures
**Maximum loops:** 3 cycles, then escalate with detailed blockers

## Verification Principles

### Be Thorough
Run all tests, check all AC, verify complete coverage

### Be Specific
For each failure, provide exact error, root cause, and fix needed

### Be Actionable
Every failure includes concrete next steps to resolve

### Be Helpful
Show what's working, not just what's broken

---

This skill ensures code implementation fully satisfies acceptance criteria with comprehensive test coverage following TDD principles.
