# Feedback Patterns

Templates for effective code review feedback.

## Principles

**The 4 C's**:
1. **Clear**: Specific location and issue
2. **Constructive**: Explain why and how to fix
3. **Courteous**: Respectful, assume good intent
4. **Complete**: Context and examples

**Tone**: Use "we" not "you", ask questions, explain reasoning.

## Standard Template

```
[SEVERITY] Brief description

Location: file.ts:42

Problem: What's wrong and why it matters
Fix: How to resolve it
Example: Code showing the fix
```

## Templates by Severity

### CRITICAL
```
[CRITICAL] Security/Crash: <issue>

Location: file:line

Problem: <vulnerability/crash>
Impact: <data loss/security breach>
Fix: <secure approach>

Example:
// Bad: <vulnerable code>
// Fix: <secure code>
```

### WARNING
```
[WARNING] Performance/Quality: <issue>

Location: file:line

Problem: <inefficiency>
Impact: <scale impact>
Fix: <better approach>

Example: <improved code>
```

### SUGGESTION
```
[SUGGESTION] Consider <alternative>

Location: file:line

Alternative: <benefit>
Example: <alternative code>

Note: Optional.
```

## Language Examples

### TypeScript - Security
```
[CRITICAL] XSS via innerHTML

Location: display.ts:23

Problem: innerHTML with user input allows XSS
Fix: Use textContent

Example:
// Bad: element.innerHTML = userMessage;
// Fix: element.textContent = userMessage;
```

### Python - Correctness
```
[WARNING] Mutable default argument

Location: utils.py:34

Problem: Default list shared across calls
Fix: Use None, create list inside

Example:
# Bad:
def add(item, items=[]):
    items.append(item)

# Fix:
def add(item, items=None):
    if items is None:
        items = []
    items.append(item)
```

### Go - Error Handling
```
[WARNING] Ignored error

Location: save.go:67

Problem: WriteFile error ignored
Fix: Check and return error

Example:
// Bad:
os.WriteFile(path, data, 0644)

// Fix:
if err := os.WriteFile(path, data, 0644); err != nil {
    return fmt.Errorf("save failed: %w", err)
}
```

### Java - Resource Leak
```
[WARNING] Resource not closed

Location: FileHandler.java:89

Problem: FileReader leaked on exception
Fix: Use try-with-resources

Example:
// Bad:
FileReader reader = new FileReader(path);
return readAll(reader);

// Fix:
try (FileReader reader = new FileReader(path)) {
    return readAll(reader);
}
```

### Rust - Panic
```
[WARNING] Unwrap panics

Location: user.rs:45

Problem: unwrap() crashes on error
Fix: Use ? operator or Result

Example:
// Bad:
fn get(id: &str) -> User {
    db.query(id).unwrap()
}

// Fix:
fn get(id: &str) -> Result<User, Error> {
    db.query(id)
}
```

## Anti-Patterns

### Vague
**Bad**: "This is wrong"
**Good**: "[WARNING] Off-by-one: Loop skips last element. Fix: Change `i < len-1` to `i < len`"

### No Context
**Bad**: "Use const"
**Good**: "[SUGGESTION] Use const for taxRate since it's never reassigned"

### Personal
**Bad**: "You don't understand async"
**Good**: "[WARNING] Promise not awaited. Add: await saveUser(user)"

### Nitpicking
**Bad**: "[CRITICAL] Prefer tabs"
**Good**: Use linter for style

### No Solution
**Bad**: "Won't work"
**Good**: "[WARNING] Loads all into memory. Fix: Use streaming"

## Checklist

Before posting:
- [ ] Appropriate severity
- [ ] Specific location
- [ ] Problem explained
- [ ] Solution provided
- [ ] Example included
- [ ] Respectful tone

## Summary

Good feedback: specific, explains why, shows fix, respectful tone.
Goal: Improve code AND help developers grow.
