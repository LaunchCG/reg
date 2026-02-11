# Abstraction Patterns

Finding the right level: not too little, not too much.

## Core Principle

- **Too little**: Duplication
- **Too much**: Complexity
- **Just right**: Clear, maintainable

## Anti-Pattern: Over-Abstraction

```typescript
// WRONG: Enterprise FizzBuzz
interface INumberProcessor { process(n: number): string; }
class DivisibilityRule { /* 50 lines */ }
class RuleEngine { /* 50 lines */ }
// 100+ lines for FizzBuzz

// RIGHT: Simple and direct
function fizzBuzz(n: number): string {
  if (n % 15 === 0) return 'FizzBuzz';
  if (n % 3 === 0) return 'Fizz';
  if (n % 5 === 0) return 'Buzz';
  return n.toString();
}
```

## Anti-Pattern: Under-Abstraction

```python
# WRONG: Repeated validation
def process_user(data):
    if not data.get('email') or '@' not in data['email']:
        return {'error': 'Invalid'}
    # ...

def process_admin(data):
    if not data.get('email') or '@' not in data['email']:
        return {'error': 'Invalid'}
    # ...

# RIGHT: Extract common pattern
def validate_email(data):
    if not data.get('email') or '@' not in data['email']:
        return 'Invalid'
    return None
```

## Right-Sized Abstraction

```go
// Simple, practical HTTP client
type Client struct {
    httpClient *http.Client
    baseURL    string
}

func (c *Client) Get(path string) ([]byte, error) {
    return c.request("GET", path, nil)
}

func (c *Client) request(method, path string, body []byte) ([]byte, error) {
    req, _ := http.NewRequest(method, c.baseURL+path, bytes.NewReader(body))
    resp, err := c.httpClient.Do(req)
    if err != nil { return nil, err }
    defer resp.Body.Close()
    return io.ReadAll(resp.Body)
}
```

## Red Flags

**Over-Abstraction:**
- More interfaces than implementations
- Deep inheritance (>3 levels)
- Single-use abstractions

**Under-Abstraction:**
- Copy-pasted code blocks
- Repeated validation
- Giant switch statements

## Decision Rules

1. **Rule of Three**: Abstract on third occurrence
2. **YAGNI**: Don't predict future needs
3. **Start concrete**: Generalize when patterns emerge
