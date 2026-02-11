# Language Detection

Quick reference for detecting languages and mapping to skills.

## Detection Priority

1. File extension (95% reliable)
2. Shebang line (scripts)
3. Syntax patterns (fallback)

## Extension Map

| Extension | Language | Skill |
|-----------|----------|-------|
| `.ts`, `.tsx` | TypeScript | typescript-review |
| `.js`, `.jsx` | JavaScript | javascript-review |
| `.py` | Python | python-review |
| `.go` | Go | go-review |
| `.java` | Java | java-review |
| `.rs` | Rust | rust-review |
| `.c`, `.cpp`, `.h` | C/C++ | c-review, cpp-review |
| `.rb` | Ruby | ruby-review |
| `.php` | PHP | php-review |
| `.sh` | Shell | shell-review |

## Syntax Detection

Use when extension unavailable:

**TypeScript**: `: type`, `interface`, `<T>`
```typescript
const name: string = "value";
interface User { }
```

**JavaScript**: No types, `const/let`, `=>`
```javascript
const name = "value";
const fn = () => {};
```

**Python**: `def`, indentation blocks, `self`
```python
def function_name(param):
    pass
```

**Go**: `package`, `func`, `:=`
```go
package main
func name() { }
```

**Rust**: `fn`, `let mut`, `impl`
```rust
fn name() -> i32 { 42 }
```

**Java**: `public class`, `@Override`
```java
public class Name { }
```

## Framework Detection

Add framework-specific skills when detected:

**React**: `import React`, `useState` → add `react-review`
```typescript
import React, { useState } from 'react';
```

**Vue**: `defineComponent` → add `vue-review`
```typescript
import { defineComponent } from 'vue';
```

**Angular**: `@Component`, `@NgModule` → add `angular-review`
```typescript
import { Component } from '@angular/core';
@Component({ selector: 'app-root' })
```

**Express**: `express()`, `app.get` → add `express-review`
```typescript
import express from 'express';
const app = express();
app.get('/route', (req, res) => {});
```

**Django**: `from django` → add `django-review`
```python
from django.db import models
from django.views import View
```

**Flask**: `from flask` → add `flask-review`
```python
from flask import Flask, request
app = Flask(__name__)
@app.route('/')
```

**FastAPI**: `from fastapi` → add `fastapi-review`
```python
from fastapi import FastAPI
app = FastAPI()
@app.get("/")
```

**Spring**: `@SpringBootApplication` → add `spring-review`
```java
@SpringBootApplication
@RestController
```

## Domain Skills

Add based on code content:

**Security**: Keywords like `authenticate`, `encrypt`, `password` → add `security-review`
**Database**: `SELECT`, `db.query` → add `database-review`
**API**: `@route`, `/api/`, REST methods → add `api-review`
**Concurrency**: `go func()`, `async def`, `chan` → add `concurrency-review`

## Skill Mapping Examples

### TypeScript + React
```typescript
import React, { useState } from 'react';
export function Component() {
  const [user, setUser] = useState(null);
  return <div>{user?.name}</div>;
}
```
**Skills**: `typescript-review`, `react-review`

### Python + Django + Security
```python
from django.db import models
class User(models.Model):
    def authenticate(self, password):
        pass
```
**Skills**: `python-review`, `django-review`, `security-review`

### Go + Concurrency
```go
func worker(ctx context.Context, ch chan int) {
    select {
    case <-ctx.Done():
        return
    }
}
```
**Skills**: `go-review`, `concurrency-review`

## Edge Cases

**.h files**: Default to C++ (check for `class`, `namespace`)
**TS vs JS**: Type annotations → TS, otherwise JS
**Python 2/3**: Default to Python 3
**Generated code**: Flag with `// Generated` → lighter review

## Detection Algorithm

```
1. Check extension → Use map
2. Check shebang → Use shebang language
3. Count keywords → Highest match wins
4. Scan imports → Detect frameworks
5. Search keywords → Detect domains
6. Return: language + frameworks + domains
```

## Quick Syntax Reference

| Language | Unique Pattern |
|----------|----------------|
| TypeScript | `: type`, `interface` |
| JavaScript | No types, `=>` |
| Python | `def`, indentation |
| Go | `func`, `:=` |
| Java | `public class` |
| Rust | `fn`, `let mut` |

## Summary

**Primary**: File extension
**Fallback**: Syntax keywords
**Enhancement**: Framework + domain detection
**Output**: Base language + frameworks + domains
