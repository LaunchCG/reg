# SOLID Principles

Five design principles for maintainable object-oriented code.

## Single Responsibility Principle (SRP)

**A class should have only one reason to change.**

```typescript
// BEFORE: Multiple responsibilities
class User {
  updateEmail(email: string) { this.email = email; }
  save() { database.execute('INSERT...'); }
  sendWelcomeEmail() { smtp.send(...); }
}

// AFTER: Separated concerns
class User {
  updateEmail(email: string) { this.email = email; }
}
class UserRepository {
  save(user: User) { database.execute(...); }
}
class UserEmailService {
  sendWelcomeEmail(user: User) { smtp.send(...); }
}
```

## Open/Closed Principle (OCP)

**Open for extension, closed for modification.**

```python
// BEFORE
class PaymentProcessor:
    def process(self, method, amount):
        if method == "credit_card": # ...
        elif method == "paypal": # ...

// AFTER: Extensible design
class PaymentMethod:
    def process(self, amount): pass

class CreditCardPayment(PaymentMethod):
    def process(self, amount): # ...

class PaymentProcessor:
    def __init__(self):
        self.methods = {}
    def register(self, name, method):
        self.methods[name] = method
```

## Liskov Substitution Principle (LSP)

**Subtypes must be substitutable for base types.**

```go
// BEFORE: Square breaks Rectangle
type Rectangle struct { width, height float64 }
type Square struct { Rectangle }
func (s *Square) SetWidth(w float64) {
    s.width = w
    s.height = w  // Violates LSP
}

// AFTER: Separate types
type Shape interface { Area() float64 }
type Rectangle struct { width, height float64 }
type Square struct { side float64 }
```

## Interface Segregation Principle (ISP)

**Clients shouldn't depend on methods they don't use.**

```java
// BEFORE: Fat interface
public interface Worker {
    void work();
    void eat();
    void sleep();
}
public class Robot implements Worker {
    public void eat() { throw new UnsupportedOperationException(); }
}

// AFTER: Segregated interfaces
public interface Workable { void work(); }
public interface Eatable { void eat(); }
public class Robot implements Workable { public void work() {} }
```

## Dependency Inversion Principle (DIP)

**Depend on abstractions, not concretions.**

```typescript
// BEFORE
class UserService {
  private db = new MySQLDatabase();  // Tightly coupled
}

// AFTER
interface Database { save(data: string): void; }
class UserService {
  constructor(private db: Database) {}  // Depends on abstraction
}
```

## Quick Reference

| Principle | Violation Sign |
|-----------|----------------|
| SRP | Class doing DB + validation + business logic |
| OCP | Long if/else chains for types |
| LSP | Child throws unexpected errors |
| ISP | Empty/error-throwing implementations |
| DIP | Direct instantiation of concrete classes |
