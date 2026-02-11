# Module Organization

When and how to split large modules.

## When to Split

- File >300-500 lines
- Multiple unrelated responsibilities
- Testing difficulty
- Frequent merge conflicts

## Pattern 1: God Class → Responsibilities

```typescript
// BEFORE: One class, many jobs
class UserManager {
  save(user: User) { /* DB */ }
  validateEmail(email: string) { /* Validation */ }
  sendWelcomeEmail(user: User) { /* Email */ }
}

// AFTER: Split by responsibility
class UserRepository { save(user: User) {} }
class UserValidator { validateEmail(email: string) {} }
class EmailService { sendWelcomeEmail(user: User) {} }
```

## Pattern 2: Feature-Based Split

```python
# BEFORE: All routes in one file
@app.route('/users')
def get_users(): pass
@app.route('/products')
def get_products(): pass

# AFTER: Split by feature
# routes/users.py
user_blueprint = Blueprint('users', __name__)
@user_blueprint.route('/')
def get_users(): pass
```

## Pattern 3: Layer-Based Split

```go
// BEFORE: Everything mixed
func handleGetUsers(w http.ResponseWriter, r *http.Request) {
    rows, _ := db.Query("SELECT * FROM users")
    json.NewEncoder(w).Encode(users)
}

// AFTER: Layered
// repositories/user_repository.go
type UserRepository struct { db *sql.DB }
func (r *UserRepository) FindAll() ([]User, error) {}

// handlers/user_handler.go
type UserHandler struct { service *UserService }
func (h *UserHandler) GetUsers(w http.ResponseWriter, r *http.Request) {}
```

## Pattern 4: Extract Utilities

```java
// BEFORE: Utils in main class
public class OrderProcessor {
    private String formatDate(Date d) {}
    private boolean validateEmail(String e) {}
}

// AFTER: Extract utils
public class DateUtils { public static String formatDate(Date d) {} }
public class ValidationUtils { public static boolean validateEmail(String e) {} }
```

## Pattern 5: Configuration Separation

```typescript
// BEFORE: Config scattered
class Application {
  private dbUrl = 'postgresql://localhost:5432/db';
  private redisHost = 'localhost';
}

// AFTER: Centralized
// config/database.config.ts
export const databaseConfig = {
  url: process.env.DATABASE_URL || 'postgresql://localhost:5432/db'
};
```

## Decision Criteria

| Indicator | Action |
|-----------|--------|
| File >500 lines | Consider splitting |
| >3 responsibilities | Extract classes |
| Utilities used >3 times | Extract module |
| Config in >3 places | Centralize |

## When NOT to Split

- Module <200 lines and focused
- Only 1-2 uses
- Would create tight coupling
