# DRY Principle (Don't Repeat Yourself)

Every piece of knowledge must have a single, unambiguous representation.

## When to Apply

- Third occurrence of similar code (Rule of Three)
- Identical logic in multiple places
- Repeated validation or business rules

## Pattern 1: Duplicate Logic

```typescript
// BEFORE
function getUserEmail(user: User | null): string {
  if (!user) return 'unknown@example.com';
  return user.email;
}
function getUserName(user: User | null): string {
  if (!user) return 'Unknown';
  return user.name;
}

// AFTER
function withDefault<T, R>(value: T | null, accessor: (v: T) => R, defaultValue: R): R {
  return value ? accessor(value) : defaultValue;
}
const email = withDefault(user, u => u.email, 'unknown@example.com');
const name = withDefault(user, u => u.name, 'Unknown');
```

## Pattern 2: Repeated Validation

```python
# BEFORE
def create_user(email, name):
    if not email or '@' not in email:
        raise ValueError("Invalid email")
    # create...

def update_user(id, email, name):
    if not email or '@' not in email:
        raise ValueError("Invalid email")
    # update...

# AFTER
class UserData:
    def validate(self):
        if not self.email or '@' not in self.email:
            raise ValueError("Invalid email")

def create_user(data: UserData):
    data.validate()
    # create...
```

## Pattern 3: Repeated Error Handling

```go
// BEFORE
func GetUser(id string) (*User, error) {
    resp, err := http.Get(baseURL + "/users/" + id)
    if err != nil { return nil, err }
    defer resp.Body.Close()
    var user User
    json.NewDecoder(resp.Body).Decode(&user)
    return &user, nil
}

// AFTER: Generic function
func fetchEntity[T any](endpoint, id string) (*T, error) {
    resp, err := http.Get(baseURL + "/" + endpoint + "/" + id)
    if err != nil { return nil, err }
    defer resp.Body.Close()
    var entity T
    json.NewDecoder(resp.Body).Decode(&entity)
    return &entity, nil
}
func GetUser(id string) (*User, error) {
    return fetchEntity[User]("users", id)
}
```

## Pattern 4: Duplicate Configuration

```java
// BEFORE
public class UserService {
    private int timeout = 30;
    private String baseUrl = "https://api.example.com";
}

// AFTER
public class ApiConfig {
    public static final int TIMEOUT = 30;
    public static final String BASE_URL = "https://api.example.com";
}
```

## Pattern 5: Database Queries

```typescript
// BEFORE
async function getActiveUsers() {
  const conn = await getConnection();
  return conn.query("SELECT * FROM users WHERE status = 'active'");
}

// AFTER
async function getActiveEntities(table: string) {
  const conn = await getConnection();
  return conn.query(`SELECT * FROM ${table} WHERE status = 'active'`);
}
```

## When NOT to Apply

- **Accidental similarity**: Different concepts that look alike
- **Different change rates**: Code changing for different reasons
- **Before third occurrence**: Wait for pattern to emerge
- **Over-engineering**: Don't create complex abstractions for simple duplication

## Key Principle

Wait for third occurrence before extracting. Sometimes duplication is better than wrong abstraction.
