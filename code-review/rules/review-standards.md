---
name: review-standards
description: Standards for conducting effective and thorough code reviews. Focus on critical issues, provide actionable feedback, and maintain high quality standards.
---

# Code Review Standards

## Core Principle

**Code reviews MUST focus on critical issues that affect correctness, security, performance, and maintainability.**

Reviews should be thorough, specific, and actionable. The goal is to catch real problems and improve code quality, not to nitpick style preferences.

## Required Behaviors

### MUST Be Critical

Code reviews MUST identify substantive issues:

**Security vulnerabilities:**
- Authentication/authorization bypasses
- Injection vulnerabilities (SQL, XSS, command injection)
- Insecure data handling (secrets, weak encryption)
- Missing input validation at trust boundaries

**Correctness issues:**
- Logic errors that produce wrong results
- Off-by-one errors, race conditions
- Incorrect error handling
- Unhandled edge cases

**Performance problems:**
- N+1 queries
- Inefficient algorithms (O(n²) where O(n) is possible)
- Memory leaks
- Missing database indexes

**Maintainability issues:**
- Unclear or misleading code
- Missing error handling
- Tight coupling that prevents testing

### MUST Prioritize DRY (Don't Repeat Yourself)

Code reviews MUST identify and eliminate duplication:

**What counts as duplication:**
- Identical or nearly-identical code blocks
- Similar business logic implemented multiple times
- Duplicated validation, error handling, or formatting logic

**How to address:**
- Extract shared logic into reusable functions
- Create utility modules for common operations
- Use abstraction to handle variations

**Example:**
```python
# Bad - Duplicated validation in multiple files
def validate_email(email):
    if not email or '@' not in email:
        raise ValueError("Invalid email")
    return email.lower().strip()

# Good - Single shared validator
# In validators.py
def validate_email(email):
    if not email or '@' not in email:
        raise ValueError("Invalid email")
    return email.lower().strip()
```

### MUST Classify Severity

Every review comment MUST indicate severity level:

**CRITICAL - Must fix before merging:**
- Security vulnerabilities
- Data corruption risks
- Logic errors causing incorrect behavior

**HIGH - Should fix before merging:**
- Performance problems in common paths
- Missing error handling for likely failures
- Significant duplication

**MEDIUM - Should address soon:**
- Minor performance inefficiencies
- Unclear variable names in complex code

**LOW - Nice to have:**
- Style inconsistencies (if not caught by linter)
- Minor refactoring opportunities

**Format:**
```
[CRITICAL] SQL injection: user input concatenated directly into query
[HIGH] N+1 query: this will make 100+ database calls for large lists
[MEDIUM] Variable name 'data' is unclear - consider 'validatedUserInput'
```

### MUST Include Examples

When suggesting changes, provide concrete examples:

```
[HIGH] Missing error handling for network failures.

Current:
const data = await fetch('/api/users');
setUsers(data.json());

Fix:
try {
  const response = await fetch('/api/users');
  if (!response.ok) {
    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
  }
  setUsers(await response.json());
} catch (error) {
  setError('Unable to load users. Please try again.');
}
```

### MUST Be Specific

Reviews MUST identify exact locations and provide precise feedback:

**Vague:**
```
The authentication logic needs work.
```

**Specific:**
```
[CRITICAL] auth.py:45 - JWT tokens not validated:

def verify_token(token):
    return jwt.decode(token, options={"verify_signature": False})

This allows attackers to forge tokens. Change to:
    return jwt.decode(token, settings.JWT_SECRET, algorithms=["HS256"])
```

## What Makes Good Reviews

### Specific and Actionable

Tell the author exactly what to change and why:

```
[CRITICAL] routes.py:78 - SQL injection vulnerability:
query = f"SELECT * FROM users WHERE id = {user_id}"

Change to parameterized query:
query = "SELECT * FROM users WHERE id = ?"
cursor.execute(query, (user_id,))

Why: Attackers can inject SQL by passing "1 OR 1=1" as user_id
```

### Impactful

Focus on changes that matter:

**High impact:**
- Security vulnerabilities
- Bugs causing data loss
- Performance problems affecting UX
- Code making future changes difficult

**Lower priority:**
- Formatting (handled by linters)
- Personal style preferences
- Premature optimization

### Critical Thinking

Question assumptions and identify edge cases:

```
[HIGH] payment.py:89 - Assumes payment_method is always present:
charge_amount = payment_method.process(total)

But payment_method can be None for free trials. Add check:
if payment_method is None:
    if total > 0:
        raise ValueError("Payment method required")
    return create_free_order()
```

### Thorough

Check all aspects:
- Modified code paths and test coverage
- Documentation and database migrations
- API contracts and dependencies
- Error handling and security

**Example - Comprehensive review:**
```
Reviewing PR #123: Add user export feature

Code quality:
[CRITICAL] export.py:45 - Missing authorization check.
Any user can export any other user's data. Add:
if current_user.id != user_id and not current_user.is_admin:
    raise PermissionError("Cannot export other users' data")

[HIGH] export.py:67 - Loads all user data into memory.
For users with large datasets, this will cause OOM. Use streaming:
def stream_export():
    for chunk in query.yield_per(1000):
        yield format_chunk(chunk)

Testing:
[HIGH] Missing test for unauthorized access attempt
[MEDIUM] No test for users with >10k records

Documentation:
[MEDIUM] API docs don't mention rate limiting on export endpoint
[LOW] Add example curl command to README

Performance:
[HIGH] Export query missing index on created_at column. Add migration:
CREATE INDEX idx_records_created_at ON records(created_at);
```

## What to Avoid

### Vague Feedback

**Bad:**
```
This could be better.
Consider refactoring this.
```

**Good:**
```
[HIGH] This function does too much. Split into:
- validateOrderData() - validates and normalizes
- calculateOrderTotal() - computes pricing
- persistOrder() - saves to database
```

### Style-Only Focus

Don't review formatting that should be automated:
- Indentation, whitespace, semicolons
- Quote style, line length, import ordering

**Instead:**
```
[LOW] Run the project linter before committing.
```

### Issues Without Explanations

**Bad:**
```
Don't use var here.
```

**Good:**
```
[MEDIUM] Use 'const' instead of 'var':
var config = loadConfig();

Why: 'var' has function scope and can be accidentally redeclared.
'const' prevents reassignment bugs.
```

### Bikeshedding

Don't debate trivial preferences unless there's a documented standard:
- Personal language feature preferences
- Equivalent implementations with same performance
- Minor naming variations that are equally clear

### Premature Optimization

**Bad:**
```
This loop could be slow. Consider caching.
```

**Good:**
```
[HIGH] Performance test shows 3.2s for 10k records.

Bottleneck is nested loop (lines 45-52):
for item in items:
    for tag in all_tags:
        if tag in item.tags:
            matches.append((item, tag))

Change to hash-based lookup:
tag_set = set(all_tags)
matches = [(item, tag) for item in items
           for tag in item.tags if tag in tag_set]

This reduces time from 3.2s to 0.14s in testing.
```

### Requesting Unnecessary Changes

**Unnecessary:**
```
Could extract this 3-line function into a helper.
```

**Necessary:**
```
[HIGH] This validation block is duplicated in 8 files.
Extract into shared validator for consistency.
```

### Inconsistent Standards

- Apply severity levels consistently
- Flag similar issues everywhere they appear
- Review all code with equal depth

## Balancing Act

**Be thorough, but not pedantic** - Catch real issues, not trivial preferences

**Be critical, but constructive** - Point out problems and suggest solutions

**Be strict, but pragmatic** - Maintain standards but understand tradeoffs

**Be specific, but efficient** - Detail on important issues, brief on minor ones

The goal is shipping high-quality code that's secure, correct, performant, and maintainable.
