# Code Review Dimensions

Six dimensions for evaluating code quality.

## 1. Correctness

**Flag when**: Wrong results, crashes, mishandled edge cases.

**Critical**: Null dereference, off-by-one, unhandled async errors, race conditions
**Warning**: Missing validation, incorrect logic

**Example**:
```typescript
// CRITICAL: Null dereference
return user.email; // Crashes if null
// Fix: return user?.email ?? 'unknown'

// WARNING: Unhandled error
async function fetch(url) {
  const res = await fetch(url);
  return res.json(); // No error handling
}
// Fix: Add try-catch and check res.ok
```

## 2. Security

**Flag when**: Vulnerabilities, insecure data handling.

**Critical**: SQL injection, XSS, command injection, missing auth, hardcoded secrets

**Example**:
```python
# CRITICAL: SQL injection
query = f"SELECT * FROM users WHERE email = '{email}'"
# Fix: Use parameterized query with placeholders

# CRITICAL: Command injection
os.system(f"cp {filename} /backup/")
# Fix: subprocess.run(['cp', filename, '/backup/'])
```

```typescript
// CRITICAL: XSS vulnerability
function displayMessage(msg: string) {
  document.getElementById('output').innerHTML = msg; // User input!
}
// Fix: Use textContent
document.getElementById('output').textContent = msg;
```

```python
# CRITICAL: Path traversal
import os
def read_user_file(filename):
    path = f"/data/users/{filename}"
    with open(path) as f:
        return f.read()
# Fix: Validate and sanitize
def read_user_file(filename):
    safe_name = os.path.basename(filename)  # Remove path separators
    path = os.path.join("/data/users", safe_name)
    if not os.path.realpath(path).startswith("/data/users"):
        raise ValueError("Invalid path")
    with open(path) as f:
        return f.read()
```

## 3. Performance

**Flag when**: Inefficient algorithms, unnecessary resource usage.

**Critical**: Resource leaks
**Warning**: O(n²) when O(n) possible, N+1 queries, loading large datasets into memory

**Example**:
```go
// WARNING: O(n²)
for _, x := range a {
    for _, y := range b {
        if x == y { result = append(result, x) }
    }
}
// Fix: Use map for O(n)

// WARNING: No preallocation
var items []int
for i := 0; i < n; i++ {
    items = append(items, i) // Repeated reallocation
}
// Fix: items := make([]int, 0, n)
```

```typescript
// WARNING: N+1 query problem
async function getUsersWithPosts() {
  const users = await db.query('SELECT * FROM users');
  for (const user of users) {
    user.posts = await db.query('SELECT * FROM posts WHERE user_id = ?', [user.id]);
  }
  return users;
}
// Fix: Single query with JOIN
async function getUsersWithPosts() {
  return await db.query(`
    SELECT u.*, p.*
    FROM users u
    LEFT JOIN posts p ON p.user_id = u.id
  `);
}
```

## 4. Maintainability

**Flag when**: Hard to read, understand, or modify.

**Warning**: Functions >50 lines, nesting >3 levels, magic numbers, duplicate code (3+ blocks)

**Example**:
```typescript
// WARNING: Magic numbers
function calc(qty) {
  return qty * 29.99 * 1.08;
}
// Fix: const PRICE = 29.99; const TAX = 1.08;

// WARNING: Deep nesting
if (user) {
  if (user.active) {
    if (user.verified) {
      // Do something
    }
  }
}
// Fix: Guard clauses
if (!user || !user.active || !user.verified) return;
// Do something
```

## 5. Design

**Flag when**: Violates SOLID, architectural issues.

**Warning**: Tight coupling, god classes (>10 responsibilities), no dependency injection

**Example**:
```java
// WARNING: Tight coupling
class Service {
    private DB db = new MySQL(); // Hardcoded!
}
// Fix: Inject DB interface via constructor

// WARNING: Single Responsibility violation
class User {
    void saveToDatabase() { } // DB logic
    void sendEmail() { }      // Email logic
}
// Fix: Separate UserRepository, EmailService
```

## 6. Testing

**Flag when**: Missing tests, poorly designed tests.

**Warning**: No tests for critical paths, missing edge cases, only happy path, test interdependence

**Example**:
```python
# WARNING: Only happy path
def test_divide():
    assert divide(10, 2) == 5

# Fix: Test edge cases
@pytest.mark.parametrize("a,b,expected", [
    (10, 2, 5),
    (-10, 2, -5),
])
def test_divide_success(a, b, expected):
    assert divide(a, b) == expected

def test_divide_by_zero():
    with pytest.raises(ValueError):
        divide(10, 0)
```

## Thresholds

| Issue | Severity | Threshold |
|-------|----------|-----------|
| Null dereference | CRITICAL | Always |
| SQL injection | CRITICAL | Always |
| Resource leak | CRITICAL | Always |
| N+1 queries | WARNING | >10 items |
| Function length | WARNING | >50 lines |
| Nesting depth | WARNING | >3 levels |
| Magic numbers | WARNING | 2+ occurrences |

## Summary

**Priority order**: Correctness, Security, Performance, Maintainability, Design, Testing
**CRITICAL**: Security, crashes, data loss
**WARNING**: Performance, quality, tests, design
