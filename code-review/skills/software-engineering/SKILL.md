---
name: software-engineering
description: Expert in universal software engineering principles including DRY, SOLID, separation of concerns, and refactoring strategies
---

# Software Engineering Principles

Core principles for writing maintainable, scalable code across all languages.

## DRY Principle (Don't Repeat Yourself)

**HIGHEST PRIORITY**: Every piece of knowledge MUST have a single, unambiguous representation.

### Detection Criteria

**CRITICAL** - Flag immediately:
- ≥3 instances of identical code blocks (>5 lines)
- Same business logic in 2+ places
- Duplicated validation/error handling

**WARNING**:
- 2 instances of similar code (>10 lines)
- Repeated API patterns (>3 occurrences)

### When to Apply

**DO apply when:**
- ≥3 instances (Rule of Three)
- Changes to one require identical changes to others
- Abstraction improves readability

**DO NOT apply when:**
- Similar code represents different concepts
- Only 2 instances with unclear pattern
- Abstraction reduces readability

### Example

```typescript
// BAD: Duplicated validation
function createUser(email: string, password: string) {
  if (!email || !email.includes('@')) throw new Error('Invalid email');
  if (!password || password.length < 8) throw new Error('Password too short');
}

function updateUser(id: string, email: string, password: string) {
  if (!email || !email.includes('@')) throw new Error('Invalid email');
  if (!password || password.length < 8) throw new Error('Password too short');
}

// GOOD: Extracted validation
function validateEmail(email: string): void {
  if (!email || !email.includes('@')) throw new Error('Invalid email');
}

function validatePassword(password: string): void {
  if (!password || password.length < 8) throw new Error('Password too short');
}

function createUser(email: string, password: string) {
  validateEmail(email);
  validatePassword(password);
}

function updateUser(id: string, email: string, password: string) {
  validateEmail(email);
  validatePassword(password);
}
```

## SOLID Principles

### Single Responsibility Principle (SRP)

**Rule**: A class MUST have one reason to change.

**Detection:**
- CRITICAL: Class with 3+ different domains (data + logic + UI)
- WARNING: Class >300 lines or >10 dependencies

**Example:**

```typescript
// BAD: Multiple responsibilities
class UserManager {
  createUser(data: UserData): User {
    const user = new User(data);
    this.sendWelcomeEmail(user.email);  // Email responsibility
    this.database.save(user);            // Database responsibility
    this.logger.log(`Created ${user.id}`); // Logging responsibility
    return user;
  }
}

// GOOD: Separated responsibilities
class UserService {
  constructor(
    private repository: UserRepository,
    private emailService: EmailService,
    private logger: Logger
  ) {}

  createUser(data: UserData): User {
    const user = new User(data);
    this.repository.save(user);
    this.emailService.sendWelcomeEmail(user.email);
    this.logger.log(`Created ${user.id}`);
    return user;
  }
}
```

### Open/Closed Principle (OCP)

**Rule**: Open for extension, closed for modification.

**Detection:**
- CRITICAL: If/else or switch on type codes (≥3 branches)
- CRITICAL: New features require modifying existing code

**Example:**

```python
# BAD: Must modify for new types
class PaymentProcessor:
    def process(self, amount, method):
        if method == "credit_card":
            # process credit card
        elif method == "paypal":
            # process paypal
        # Adding bitcoin requires modifying this class

# GOOD: Extend without modification
from abc import ABC, abstractmethod

class PaymentMethod(ABC):
    @abstractmethod
    def process(self, amount): pass

class CreditCard(PaymentMethod):
    def process(self, amount): pass

class PayPal(PaymentMethod):
    def process(self, amount): pass

class PaymentProcessor:
    def process(self, amount, method: PaymentMethod):
        return method.process(amount)
```

### Liskov Substitution Principle (LSP)

**Rule**: Subclasses must be substitutable for their base classes.

**Detection:**
- CRITICAL: Subclass breaks parent contract
- CRITICAL: Subclass throws unexpected exceptions

### Interface Segregation Principle (ISP)

**Rule**: Don't force clients to depend on unused methods.

**Detection:**
- CRITICAL: Interface forces empty/stub implementations
- WARNING: Interface with >5 unrelated methods

### Dependency Inversion Principle (DIP)

**Rule**: Depend on abstractions, not concretions.

**Detection:**
- CRITICAL: High-level modules depend on concrete low-level classes
- WARNING: Direct instantiation of dependencies

**Example:**

```go
// BAD: Depends on concrete implementation
type UserService struct {
    database MySQLDatabase  // Coupled to MySQL
}

// GOOD: Depends on abstraction
type Database interface {
    Query(sql string) []string
}

type UserService struct {
    database Database  // Can be any implementation
}
```

## Module Organization

### Function Size

**Thresholds:**
- CRITICAL (MUST refactor): >100 lines
- WARNING (SHOULD refactor): 50-100 lines
- ACCEPTABLE: <50 lines
- IDEAL: 10-20 lines

**Split when:**
- >50 lines
- 3+ distinct sections
- 3+ levels of nesting
- >7 parameters

### File Size

**Thresholds:**
- CRITICAL (MUST split): >500 lines
- WARNING (SHOULD split): 300-500 lines
- ACCEPTABLE: <300 lines
- IDEAL: 100-200 lines

**Split when:**
- >400 lines
- >2 unrelated classes
- Only subset of functions change together

### Abstraction Levels

Functions should operate at one level of abstraction:

```python
# BAD: Mixed levels
def process_order(order_id):
    order = get_order(order_id)
    total = sum(item['price'] * item['qty'] for item in order['items'])  # Low-level
    apply_discount(order, total)  # High-level
    db.query('UPDATE orders SET total = ? WHERE id = ?', [total, order_id])  # Low-level

# GOOD: Consistent level
def process_order(order_id):
    order = get_order(order_id)
    total = calculate_total(order)
    discounted = apply_discount(order, total)
    save_order_total(order_id, discounted)

def calculate_total(order):
    return sum(item['price'] * item['qty'] for item in order['items'])

def save_order_total(order_id, total):
    db.query('UPDATE orders SET total = ? WHERE id = ?', [total, order_id])
```

## Separation of Concerns

Different concerns MUST be in different components.

**Layers:**
- **Presentation**: UI/HTTP concerns
- **Business Logic**: Domain rules
- **Data Access**: Database operations

**Example:**

```typescript
// Presentation Layer
class UserController {
  async createUser(req: Request, res: Response) {
    const user = await this.userService.createUser(req.body);
    res.json({ success: true, user });
  }
}

// Business Logic Layer
class UserService {
  async createUser(data: UserData): Promise<User> {
    this.validateBusinessRules(data);
    const user = await this.repository.create(data);
    await this.emailService.sendWelcome(user.email);
    return user;
  }
}

// Data Access Layer
class UserRepository {
  async create(data: UserData): Promise<User> {
    return db.query('INSERT INTO users...', data);
  }
}
```

## Refactoring Strategies

### Extract Method

**When**: Function >50 lines or has 3+ logical sections

```java
// BEFORE: Long method
public void processPayment(Payment payment) {
    // 20 lines of validation
    // 15 lines of fee calculation
    // 20 lines of payment processing
    // 15 lines of database updates
}

// AFTER: Extracted methods
public void processPayment(Payment payment) {
    validatePayment(payment);
    double total = calculateTotalWithFees(payment);
    Response response = chargePayment(payment, total);
    saveTransaction(payment, response);
}
```

### Replace Conditional with Polymorphism

**When**: Switch/if-else on type codes (≥3 branches)

```rust
// BEFORE
fn make_sound(animal_type: &str) -> String {
    match animal_type {
        "dog" => "Woof!".to_string(),
        "cat" => "Meow!".to_string(),
        _ => "".to_string(),
    }
}

// AFTER
trait Animal {
    fn make_sound(&self) -> String;
}

struct Dog;
impl Animal for Dog {
    fn make_sound(&self) -> String { "Woof!".to_string() }
}

struct Cat;
impl Animal for Cat {
    fn make_sound(&self) -> String { "Meow!".to_string() }
}
```

### Introduce Parameter Object

**When**: Functions with >3 parameters

```python
# BEFORE
def create_user(first, last, email, phone, street, city, state, zip):
    pass

# AFTER
from dataclasses import dataclass

@dataclass
class Address:
    street: str
    city: str
    state: str
    zip_code: str

@dataclass
class UserInfo:
    first_name: str
    last_name: str
    email: str
    phone: str
    address: Address

def create_user(user_info: UserInfo):
    pass
```

## Code Review Checklist

### Critical Issues
- [ ] ≥3 instances of identical code (DRY violation)
- [ ] Class with 3+ different domains (SRP violation)
- [ ] Switch/if-else on type codes ≥3 branches (OCP violation)
- [ ] Function >100 lines
- [ ] File >500 lines
- [ ] Business logic in presentation layer

### Warnings
- [ ] 2 instances of similar code
- [ ] Class >300 lines
- [ ] Function 50-100 lines
- [ ] File 300-500 lines
- [ ] >7 function parameters

## Quick Reference

| Metric | CRITICAL | WARNING | IDEAL |
|--------|----------|---------|-------|
| Function Lines | >100 | 50-100 | 10-20 |
| Function Params | >7 | 4-7 | 0-2 |
| File Lines | >500 | 300-500 | 100-200 |
| Class Responsibilities | ≥3 | 2 | 1 |
| Code Duplication | ≥3 instances | 2 instances | None |

## Language Integration

Apply these principles universally:

- **TypeScript/JavaScript**: Classes, interfaces, modules
- **Python**: Classes, ABC, dataclasses
- **Go**: Packages, interfaces, composition
- **Java**: Packages, interfaces, DI
- **Rust**: Modules, traits, type system

Principles remain constant; implementation details vary by language.
