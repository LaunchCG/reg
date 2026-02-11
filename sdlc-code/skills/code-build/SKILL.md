---
name: code-build
description: Implement code to pass tests created in test-create phase following TDD GREEN phase
allowed-tools: []
---

# Code Build Skill

Implements code to pass the tests created in the test-create phase, following TDD's GREEN phase principle of writing minimal code to make tests pass.

## When This Skill is Invoked

This skill is automatically invoked by the `code` agent during the BUILD (GREEN) phase of the TDD cycle, after tests have been created and are failing.

## Purpose

Implements code that:
1. Makes all failing tests pass
2. Follows minimal implementation principle
3. Covers all acceptance criteria
4. Maintains code quality standards
5. Is ready for refactoring phase

## Implementation Process

### Step 1: Review Documentation Context

**CRITICAL: Before implementing, review any documentation context passed from the code agent.**

**Expected Documentation Context:**
- Architecture overview (system type, component boundaries)
- Relevant ADRs (past decisions affecting implementation)
- API contracts (existing interfaces to match)
- Code patterns (error handling, logging, testing conventions)
- **Coding conventions** (framework-specific standards)

**Apply Documentation to Implementation:**

| Documentation | How to Apply |
|---------------|--------------|
| ARCHITECTURE.md | Place code in correct component/layer |
| ADRs | Follow documented decisions (e.g., "use repository pattern") |
| API contracts | Match existing endpoint/schema patterns |
| CONTRIBUTING.md | Follow code style and naming conventions |
| Testing docs | Use documented test patterns and frameworks |
| **docs/conventions/coding-standards.md** | Follow framework-specific patterns |
| **docs/conventions/naming-conventions.md** | Use documented naming rules |

**If No Documentation Provided:**
- Fall back to codebase analysis
- Match existing patterns in similar files
- Use standard conventions for detected stack

### Step 2: Review Test Suite

- Read all generated tests
- Understand expected behavior
- Identify implementation order
- Note dependencies between tests
- **Match tests to documented patterns**

### Step 3: Plan Implementation

**Implementation Strategy:**
1. Start with simplest test
2. Write minimal code to pass
3. Run test to verify GREEN
4. Move to next test
5. Repeat until all tests pass

**Order Tests By:**
- Dependencies (foundation first)
- Complexity (simple to complex)
- Risk (high-risk first)

### Step 4: Implement Incrementally

**For Each Test:**

```markdown
## Implementing Test: [test_name]

### Test Requirement
```[language]
[Test code showing what needs to pass]
```

### Minimal Implementation
```[language]
[Code that makes test pass]
```

### Verification
```bash
# Run this specific test
[command to run single test]

# Expected: PASS
```

**Status:** [PASS/FAIL]
**Next:** [Move to next test / Debug failure]
```

### Step 5: Follow Implementation Patterns

**Unit Test Implementation:**
```
1. Create module/class structure
2. Implement function with minimal logic
3. Return expected values
4. Handle edge cases only as needed
```

**Integration Test Implementation:**
```
1. Set up component interactions
2. Implement data flow
3. Handle external dependencies
4. Add error handling
```

**E2E Test Implementation:**
```
1. Implement full user flow
2. Connect all components
3. Add UI elements (if needed)
4. Ensure end-to-end functionality
```

## Example Implementations

### JavaScript/TypeScript Example

**Test to Pass:**
```javascript
it('should export customer health scores to CSV with correct columns', () => {
  const customers = [
    { id: 1, name: 'Acme Corp', health_score: 85, last_contact: '2025-01-15' }
  ];
  const userService = new UserService();
  const csv = userService.exportHealthScores(customers);

  expect(csv).toContain('customer_id,name,health_score,last_contact_date');
  expect(csv).toContain('1,Acme Corp,85,2025-01-15');
});
```

**Minimal Implementation:**
```javascript
// src/services/userService.js

class UserService {
  exportHealthScores(customers) {
    // Minimal implementation to pass test
    const headers = 'customer_id,name,health_score,last_contact_date';
    const rows = customers.map(c =>
      `${c.id},${c.name},${c.health_score},${c.last_contact}`
    );
    return [headers, ...rows].join('\n');
  }
}

module.exports = UserService;
```

**Test to Pass (Edge Case):**
```javascript
it('should show error message when no customers to export', () => {
  const customers = [];
  const userService = new UserService();

  expect(() => userService.exportHealthScores(customers))
    .toThrow('No data to export');
});
```

**Implementation Update:**
```javascript
exportHealthScores(customers) {
  // Add edge case handling
  if (customers.length === 0) {
    throw new Error('No data to export');
  }

  const headers = 'customer_id,name,health_score,last_contact_date';
  const rows = customers.map(c =>
    `${c.id},${c.name},${c.health_score},${c.last_contact}`
  );
  return [headers, ...rows].join('\n');
}
```

### Python Example

**Test to Pass:**
```python
def test_exports_customer_health_scores_to_csv_with_correct_columns(self):
    customers = [
        {'id': 1, 'name': 'Acme Corp', 'health_score': 85, 'last_contact': '2025-01-15'}
    ]
    user_service = UserService()
    csv = user_service.export_health_scores(customers)

    assert 'customer_id,name,health_score,last_contact_date' in csv
    assert '1,Acme Corp,85,2025-01-15' in csv
```

**Minimal Implementation:**
```python
# src/services/user_service.py

class UserService:
    def export_health_scores(self, customers):
        """Export customer health scores to CSV format."""
        headers = 'customer_id,name,health_score,last_contact_date'
        rows = [
            f"{c['id']},{c['name']},{c['health_score']},{c['last_contact']}"
            for c in customers
        ]
        return '\n'.join([headers] + rows)
```

## TDD Principles

### Write Minimal Code
```
Don't: Implement features not required by tests
Do: Write just enough to make current test pass
```

### One Test at a Time
```
Don't: Implement all features at once
Do: Make one test pass, then move to next
```

### Keep It Simple
```
Don't: Add abstractions, patterns, or optimization early
Do: Simple, direct implementation first
```

### Run Tests Frequently
```
Don't: Implement multiple functions without testing
Do: Run tests after each small change
```

## Output Format

Format results using the template in `templates/output.md`.

See the template file for the complete output structure and variables to populate.

## Code Quality Standards

### Follow Documented Architecture
- Place code in the component/layer specified by ARCHITECTURE.md
- Follow patterns documented in ADRs
- Match API contracts and schemas
- Use error handling patterns from docs
- If ADR conflicts with test requirements, note the conflict

### Follow Project Conventions

**Check `docs/conventions/` for documented standards:**

| Convention File | Apply To |
|-----------------|----------|
| `coding-standards.md` | Framework patterns, error handling, security |
| `naming-conventions.md` | Variable, function, file naming |
| `testing-conventions.md` | Test structure (used by test-create) |

**When conventions exist:**
- Follow documented framework patterns exactly
- Use prescribed naming conventions
- Match error handling patterns
- Follow security standards (input validation, parameterized queries)

**When conventions don't exist:**
- Match existing code style in the repository
- Use project's implicit naming conventions
- Follow folder structure
- Respect linting rules from configs

### Keep It Simple
- Direct, readable implementation
- Avoid premature optimization
- No unnecessary abstractions
- Clear variable names

### Handle Errors Gracefully
- Implement error handling from AC
- Provide clear error messages
- Don't catch errors tests expect to be thrown

### Write Self-Documenting Code
- Clear function/method names
- Descriptive variable names
- Comments only where logic is complex
- Follow language idioms

## Integration

This skill is the second step in the code TDD cycle:
1. **code-test-create** - Generate failing tests
2. **code-build** (this skill) - Implement code to pass tests
3. **code-test-verify** - Run tests and verify they pass

## Error Handling

### Test Won't Pass After Implementation
```markdown
**Error:** Test [test_name] still failing after implementation

**Test Output:**
```
[Test failure message]
```

**Current Implementation:**
```[language]
[Code that was written]
```

**Analysis:**
[What's wrong with implementation]

**Suggested Fix:**
```[language]
[Corrected implementation]
```

**Action:** Retrying implementation with fix...
```

### Missing Dependencies
```markdown
**Error:** Cannot implement - missing dependencies

**Required:**
- [Package/module 1]
- [Package/module 2]

**Action:** Install dependencies:
```bash
[install command]
```

**Then:** Retry implementation
```

### Implementation Blocked by External Factor
```markdown
**Error:** Implementation blocked

**Blocker:** [Describe blocker - e.g., external API not available]

**Impact:** Cannot complete AC: [which AC]

**Options:**
1. Mock external dependency for now
2. Skip this AC temporarily
3. Request access/setup of external resource

**Recommendation:** [Which option to take]
```

---

This skill implements code following TDD's GREEN phase, ensuring all tests pass with minimal, clean code.
