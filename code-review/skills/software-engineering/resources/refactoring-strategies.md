# Refactoring Strategies

Safe techniques for improving code structure.

## Safety First

- ✅ Tests exist and pass
- ✅ One change at a time
- ✅ Run tests after each step

## Extract Method

**When**: Function >20 lines, multiple concerns

```typescript
// BEFORE
function processOrder(order: Order): void {
  if (!order.items) throw new Error('No items');
  let total = 0;
  for (const item of order.items) {
    total += item.price * item.quantity;
  }
  database.save(order);
  emailService.send(order.customer.email, 'Confirmed');
}

// AFTER
function processOrder(order: Order): void {
  validateOrder(order);
  order.total = calculateTotal(order);
  database.save(order);
  notifyCustomer(order);
}
```

## Extract Variable

**When**: Complex expressions

```go
// BEFORE
if order.Weight > 50 && (order.Country != "US" || order.State == "AK") {
    return order.Weight * 2.5 + (order.Total * 0.08)
}

// AFTER
isHeavy := order.Weight > 50
isRemote := order.Country != "US" || order.State == "AK"
if isHeavy && isRemote {
    return order.Weight * 2.5 + order.Total * 0.08
}
```

## Replace Conditional with Polymorphism

**When**: Type checking with if/switch

```python
# BEFORE
class Employee:
    def calculate_pay(self):
        if self.type == "full_time":
            return 40 * self.rate + overtime
        elif self.type == "part_time":
            return self.hours * self.rate

# AFTER
class FullTimeEmployee:
    def calculate_pay(self):
        return 40 * self.rate + self.overtime()

class PartTimeEmployee:
    def calculate_pay(self):
        return self.hours * self.rate
```

## Guard Clauses

**When**: Deep nesting (>3 levels)

```typescript
// BEFORE
function calculateBonus(employee: Employee): number {
  if (employee) {
    if (employee.isActive) {
      if (employee.years > 5) {
        return employee.salary * 0.1;
      }
    }
  }
  return 0;
}

// AFTER
function calculateBonus(employee: Employee): number {
  if (!employee || !employee.isActive) return 0;
  if (employee.years <= 5) return 0;
  return employee.salary * 0.1;
}
```

## Replace Magic Numbers

```rust
// BEFORE
fn calculate_discount(price: f64, type: i32) -> f64 {
    if type == 1 { price * 0.1 }
    else if type == 2 { price * 0.15 }
    else { 0.0 }
}

// AFTER
const REGULAR: i32 = 1;
const PREMIUM: i32 = 2;
const DISCOUNT_REGULAR: f64 = 0.1;
const DISCOUNT_PREMIUM: f64 = 0.15;

fn calculate_discount(price: f64, type: i32) -> f64 {
    match type {
        REGULAR => price * DISCOUNT_REGULAR,
        PREMIUM => price * DISCOUNT_PREMIUM,
        _ => 0.0,
    }
}
```

## Code Smells

| Smell | Fix | Threshold |
|-------|-----|-----------|
| Long Method | Extract Method | >20 lines |
| Large Class | Extract Class | >200 lines |
| Long Parameter List | Parameter Object | >3 params |
| Deep Nesting | Guard Clauses | >3 levels |
| Magic Numbers | Named Constants | Any literal |
