---
name: code-review
description: Orchestrates multi-dimensional code reviews across languages. Performs context gathering, language detection, universal quality analysis, severity classification, and structured reporting. Use when reviewing pull requests or code changes.
---

# Code Review Orchestration Skill

Expert orchestration for thorough, multi-dimensional code reviews across languages.

## Review Process (6 Phases)

### Phase 1: Context Gathering

**Required Actions**:
1. Run `git diff main...HEAD` - see all changes
2. Read commit messages - understand intent
3. Check PR description - extract goals, linked issues
4. Categorize change type - Feature | BugFix | Refactor | Performance | Docs | Tests

**Change Size Thresholds**:
- Small (<100 lines) → Standard review
- Medium (100-500 lines) → Thorough review
- Large (500-1000 lines) → Extra scrutiny
- Very Large (>1000 lines) → Request split

**Decision Criteria**:
- IF change type = "Security" OR "Performance" → Increase depth
- IF files changed >20 → Request architectural review
- IF breaking changes detected → Verify migration path

### Phase 2: Language Detection

Scan file extensions and map to language-specific skills:

```
.py/.pyw → python     .js/.jsx → javascript     .ts/.tsx → typescript
.go → go              .rs → rust                .java → java
.rb → ruby            .php → php                .kt → kotlin
```

### Phase 3: Universal Review

Apply 6 Universal Dimensions (detailed below):
1. Code Quality - Readability, naming, complexity
2. Architecture & Design - Structure, patterns, scalability
3. Module Organization - File structure, dependencies
4. Testing - Coverage, quality, edge cases
5. Security - Vulnerabilities, input validation
6. Performance - Efficiency, optimization

### Phase 4: Language-Specific Analysis

**Dynamic Skill Invocation**:
```
For each language detected:
  1. Check if language skill exists (e.g., python, typescript, go)
  2. If exists: Invoke with file paths and context
  3. If not: Apply general best practices, note limitation
```

**Context Passed to Language Skills**:
- File paths for this language
- Change type (feature/bugfix/refactor)
- Project framework detected

### Phase 5: Severity Classification

**[CRITICAL]** - MUST fix before merge:
- Security: SQL injection, XSS, auth bypass, hardcoded secrets
- Data integrity: Loss, corruption risks
- Breaking changes: No migration path
- Resource leaks: Memory, connections, file handles

**[ERROR]** - MUST fix before merge:
- Functional bugs in code logic
- Unhandled exceptions
- Build/test failures
- Missing critical tests
- Type safety violations

**[WARNING]** - SHOULD fix before merge:
- Functions >50 lines OR cyclomatic complexity >10
- N+1 queries, O(n²) on user input
- Test coverage <80%
- Missing error handling
- Poor naming, code duplication

**[SUGGESTION]** - MAY defer:
- Refactoring opportunities
- Minor optimizations
- Additional edge case tests
- Documentation enhancements

**Decision Tree**:
```
Security issue? → Exploitable? → CRITICAL : WARNING
Data loss/corruption? → CRITICAL
Breaks functionality? → Critical path? → CRITICAL : ERROR
Prevents build? → ERROR
Performance impact >20%? → User-facing? → WARNING : SUGGESTION
Reduces maintainability? → Significantly? → WARNING : SUGGESTION
```

### Phase 6: Being Critical

**MUST**:
- Read every changed line
- Question assumptions and edge cases
- Think like attacker (security), user (UX), maintainer (6 months later)
- Provide file:line references with WHY explanation
- Include concrete fix examples

**MUST NOT**:
- Skim or approve without reading
- Make vague comments ("looks wrong")
- Skip security/test analysis
- Focus only on style (linting handles this)

## Universal Review Dimensions

### 1. Code Quality

**Key Checks**:
- **Naming**: Descriptive names (❌ `x`, `data`, `tmp` → ✅ `userId`, `activeUsers`)
- **Complexity**: Functions ≤50 lines, ≤5 parameters, cyclomatic ≤10
- **Duplication**: Same logic 3+ times → Extract function
- **Magic values**: Numbers/strings → Named constants (exception: 0, 1, true, false)

**Example**:
```python
# ❌ ERROR: Poor naming, magic values
def p(x, y):
    if x > 18 and y < 100:
        return True
    return False

# ✅ GOOD: Clear names, constants
MIN_AGE = 18
MAX_AGE = 100

def is_valid_age(age: int, max_allowed: int) -> bool:
    return MIN_AGE <= age <= min(max_allowed, MAX_AGE)
```

### 2. Architecture & Design

**Key Checks**:
- **Separation of concerns**: Controllers handle HTTP, services handle logic, repos handle data
- **Dependencies**: No circular imports
- **Modularity**: Components testable independently

**Example**:
```typescript
// ❌ CRITICAL: Business logic in controller
app.post('/users', (req, res) => {
    if (!req.body.email?.includes('@')) throw new Error('Invalid');
    const hash = bcrypt.hashSync(req.body.password, 10);
    db.insert('users', { email: req.body.email, password: hash });
});

// ✅ GOOD: Layered architecture
app.post('/users', authenticateUser, async (req, res) => {
    const user = await userService.create(req.body);
    res.json(user);
});
```

### 3. Module Organization

**Key Checks**:
- **No circular dependencies**: A → B → A
- **Clear boundaries**: Public vs private APIs
- **Cohesion**: Related code together

### 4. Testing

**Coverage Thresholds**:
- <50% → ERROR
- 50-79% → WARNING
- 80-89% → GOOD
- ≥90% → EXCELLENT

**CRITICAL code MUST have ≥90% coverage**:
- Payment processing
- Authentication/authorization
- Data validation
- Encryption
- Financial calculations

**Test Quality** (AAA pattern):
```typescript
// ✅ GOOD: Arrange, Act, Assert
test('calculateDiscount applies 10% for premium users', () => {
    // Arrange
    const user = { type: 'premium', amount: 100 };

    // Act
    const discount = calculateDiscount(user);

    // Assert
    expect(discount).toBe(10);
});
```

**MUST test edge cases**:
- Boundary values (min, max, zero)
- Empty/null inputs
- Error paths
- Concurrent access (if applicable)

### 5. Security

**MUST check** (priority order):

**1. Injection Attacks**:
```python
# 🔴 CRITICAL: SQL injection
query = f"SELECT * FROM users WHERE id = {user_id}"

# ✅ SAFE: Parameterized
query = "SELECT * FROM users WHERE id = ?"
cursor.execute(query, (user_id,))
```

**2. Authentication & Authorization**:
```typescript
// 🔴 ERROR: Missing auth check
app.delete('/api/users/:id', async (req, res) => {
    await User.delete(req.params.id);
});

// ✅ SAFE: Auth + authz
app.delete('/api/users/:id', authenticateUser, async (req, res) => {
    if (!req.user || (req.user.id !== req.params.id && !req.user.isAdmin)) {
        return res.status(403).json({ error: 'Forbidden' });
    }
    await User.delete(req.params.id);
});
```

**3. Secrets Management**:
```python
# 🔴 CRITICAL: Hardcoded secret
JWT_SECRET = "my-secret-key-123"

# ✅ SAFE: Environment variable
import os
JWT_SECRET = os.environ['JWT_SECRET']
if not JWT_SECRET:
    raise ValueError("JWT_SECRET required")
```

**4. Input Validation**:
- Type check → Format validation → Range validation → Sanitization

**5. Dependency Security**:
- Run: `npm audit`, `pip-audit`, `cargo audit`
- CVSS 9.0-10.0 → CRITICAL
- CVSS 7.0-8.9 → ERROR
- CVSS 4.0-6.9 → WARNING

**6. Error Messages**:
```python
# 🔴 CRITICAL: Reveals internals
except Exception as e:
    return f"DB error: {str(e)}"

# ✅ SAFE: Generic message
except Exception as e:
    logger.error(f"DB error: {e}")
    return "An error occurred"
```

**Security Checklist**:
- [ ] No SQL/command injection
- [ ] Auth + authz on protected endpoints
- [ ] No hardcoded secrets
- [ ] Input validated
- [ ] XSS prevention (sanitized output)
- [ ] Rate limiting on sensitive endpoints

### 6. Performance

**Thresholds**:
- Response time: <100ms good, 100ms-1s acceptable, >1s ERROR
- DB queries: 1-3 good, 4-10 WARNING, >10 ERROR
- Memory per request: <10MB good, 10-50MB WARNING, >50MB ERROR

**Key Checks**:

**1. Algorithm Complexity**:
- O(1), O(log n), O(n) → GOOD
- O(n log n) → Acceptable for sorting
- O(n²) when n >100 → ERROR

**2. N+1 Queries**:
```typescript
// 🔴 ERROR: N+1 (1 + 100 queries)
const posts = await Post.findAll();
for (const post of posts) {
    post.author = await User.findById(post.authorId);
}

// ✅ GOOD: Eager loading (2 queries)
const posts = await Post.findAll({
    include: [{ model: User, as: 'author' }]
});
```

**3. Resource Management**:
```go
// 🔴 CRITICAL: File handle leak
func processFile(path string) error {
    file, _ := os.Open(path)
    data, _ := ioutil.ReadAll(file)
    return processData(data)
}

// ✅ GOOD: Guaranteed cleanup
func processFile(path string) error {
    file, _ := os.Open(path)
    defer file.Close()
    data, _ := ioutil.ReadAll(file)
    return processData(data)
}
```

**4. Pagination**:
- Response >100 items → WARNING
- Response >1000 items → ERROR
- Default page size: 20-50, Max: 100

## Output Format Template

```markdown
# Code Review Report

## Summary
**Files Changed**: 12 | **Lines**: +543/-201 | **Type**: Feature - User authentication
**Languages**: Python (8), TypeScript (3), YAML (1)
**Assessment**: 🔴 BLOCKED - Critical security issues

---

## Critical Issues (Must Fix)

### [CRITICAL] Security: SQL Injection Vulnerability
**File**: `src/api/auth.py:67`

User input concatenated into SQL query without parameterization.

**Current**:
```python
query = f"SELECT * FROM users WHERE username = '{username}'"
```

**Fix**:
```python
query = "SELECT * FROM users WHERE username = ?"
cursor.execute(query, (username,))
```

---

## Errors (Block Merge)

### [ERROR] Missing Tests for Critical Path
**File**: `src/services/payment.py` (0% coverage)

New payment logic has no tests. Required:
- Successful payment
- Payment declined
- Network timeout
- Duplicate prevention

---

## Warnings (Should Fix)

### [WARNING] Performance: N+1 Query
**File**: `src/api/posts.ts:123`

Loading posts then fetching author for each (1 + N queries).

**Fix**: Use eager loading (reduces 101 queries to 2).

---

## Suggestions (Nice to Have)

### [SUGGESTION] Consider Caching
**File**: `src/services/analytics.py:200`

Dashboard stats recalculated on every request (3s). Consider 5-min TTL cache.

---

## Test Coverage
**Overall**: 73% (target: 90%)

**Below Threshold**:
- `src/services/notification.ts`: 0% 🔴
- `src/utils/encryption.ts`: 45% ⚠️

---

## Recommendations

**Before Merge** (Required):
1. Fix SQL injection (auth.py:67)
2. Add payment service tests
3. Fix N+1 query (posts.ts:123)

**Follow-up** (Create Issues):
1. Improve test coverage to 90%
2. Add caching to analytics

**Status**: 🔴 CHANGES REQUESTED
```

## Integration Notes

**Coordinates with**:
- Language skills: python, typescript, go, rust, java
- Static analysis: ESLint, mypy, clippy, golangci-lint
- Security scanners: npm audit, Snyk, safety

**Adapts based on**:
- Change size (larger = more thorough)
- Change type (security = stricter)
- Available language skills (deeper when exists)

---

**RFC 2119 Keywords**: MUST = required (CRITICAL/ERROR), SHOULD = recommended (WARNING), MAY = optional (SUGGESTION)
