# Severity Levels

CRITICAL, WARNING, SUGGESTION.

## Definitions

**CRITICAL**: MUST fix before merge
- Security vulnerabilities
- Application crashes
- Data loss/corruption
- Breaking API changes
- Resource leaks

**WARNING**: SHOULD fix
- Code quality issues
- Performance problems
- Maintainability concerns
- Missing tests

**SUGGESTION**: Optional
- Alternative approaches
- Minor optimizations
- Style preferences

## Classification

### Always CRITICAL

**Security**: SQL injection, XSS, command injection, missing auth, hardcoded secrets, weak crypto
**Crashes**: Null dereference, division by zero, buffer overflow, unhandled errors
**Data loss**: Race conditions, transaction errors, resource leaks
**Breaking changes**: API signature changes, removing public methods

### Usually WARNING

**Performance**: N+1 queries (>10 items), O(n²) when O(n) possible (>100 items), memory leaks
**Quality**: Functions >50 lines, nesting >3 levels, magic numbers (2+), duplicate code (3+ blocks)
**Design**: Tight coupling, god classes (>10 responsibilities), SOLID violations
**Testing**: No tests for critical paths, missing edge cases

### Usually SUGGESTION

**Alternatives**: Modern syntax, standard library vs custom
**Optimizations**: Early returns, const vs let
**Style**: Destructuring, explicit types

## Examples

### CRITICAL
```typescript
// SQL Injection
const q = `SELECT * FROM users WHERE email = '${email}'`;
// Fix: Use parameterized queries

// Null dereference
return user.email; // Crashes if null
// Fix: return user?.email ?? 'unknown'

// XSS vulnerability
element.innerHTML = userInput; // Allows script injection!
// Fix: element.textContent = userInput
```

### WARNING
```go
// N+1 queries
for _, user := range users {
    posts := db.Query("SELECT * WHERE user_id = ?", user.ID)
}
// Fix: Single JOIN query

// Magic numbers
total := qty * 29.99 * 1.08
// Fix: const PRICE = 29.99; const TAX = 1.08
```

### SUGGESTION
```typescript
// Arrow function
users.map(function(u) { return u.name })
// Could use: users.map(u => u.name)
```

## Decision Tree

```
Security/crash/data loss? → CRITICAL
Performance/quality/standards? → WARNING
Alternative/preference? → SUGGESTION
```

## Context Matters

**Escalate to CRITICAL**: Sensitive data, mission-critical, affects many users
**De-escalate to WARNING**: Prototype, isolated, planned refactor
**De-escalate to SUGGESTION**: Multiple valid approaches, marginal gain

## Quick Reference

| Issue | Severity |
|-------|----------|
| SQL injection | CRITICAL |
| Null dereference | CRITICAL |
| Resource leak | CRITICAL |
| N+1 queries | WARNING |
| Magic numbers | WARNING |
| Long function | WARNING |
| Arrow function | SUGGESTION |

## Feedback Format

**CRITICAL**: `[CRITICAL] Security: SQL Injection. Fix: Use parameterized queries`
**WARNING**: `[WARNING] Performance: N+1 queries. For 100 users = 101 calls. Use JOIN`
**SUGGESTION**: `[SUGGESTION] Consider arrow function for brevity`

## Boundary Cases

**CRITICAL vs WARNING**:
```typescript
// CRITICAL: Actual data loss
async function deleteUser(id: string) {
  await db.query(`DELETE FROM users WHERE id = ${id}`); // SQL injection!
}

// WARNING: Inefficient but works
async function deleteUser(id: string) {
  const user = await User.findById(id);
  await user.delete(); // Slower but safe
}
```

```python
# CRITICAL: Crashes in production
def divide(a, b):
    return a / b  # Division by zero crashes

# WARNING: Poor error message
def divide(a, b):
    if b == 0:
        raise ValueError("Error")  # Generic message
```

**WARNING vs SUGGESTION**:
```typescript
// WARNING: Violates team standards
function processData(data) {  // No type annotations (team requires types)
  return data.map(x => x * 2);
}

// SUGGESTION: Personal preference
const names = users.map(function(u) { return u.name; });
// Could use: users.map(u => u.name)
```

## Summary

CRITICAL = Blocks merge | WARNING = Should fix | SUGGESTION = Optional
