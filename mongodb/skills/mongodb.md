---
name: mongodb
description: Expert in MongoDB and Mongoose ODM for Node.js
---

# MongoDB & Mongoose Skill

Expert guidance for MongoDB database operations using Mongoose ODM.

## Core Principles

1. **Schema-Based Modeling** - Define structure with schemas for type safety
2. **Middleware Support** - Pre/post hooks for business logic
3. **Type Safety** - TypeScript-first with strong type inference
4. **Validation** - Built-in and custom validators at schema level
5. **Query Building** - Chainable query API for expressive operations

## Common Patterns

### Model Definition

```typescript
import mongoose, { Document, Schema } from 'mongoose';

interface IUser extends Document {
  email: string;
  name: string;
  createdAt: Date;
}

const UserSchema = new Schema<IUser>({
  email: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  createdAt: { type: Date, default: Date.now }
});

// Prevent model recompilation in development
export default mongoose.models.User || mongoose.model<IUser>('User', UserSchema);
```

### Connection Management

```typescript
import mongoose from 'mongoose';

let cached = global.mongoose;

if (!cached) {
  cached = global.mongoose = { conn: null, promise: null };
}

async function connectDB() {
  if (cached.conn) return cached.conn;

  if (!cached.promise) {
    cached.promise = mongoose.connect(process.env.MONGODB_URI);
  }

  cached.conn = await cached.promise;
  return cached.conn;
}
```

### CRUD Operations

```typescript
// Create
const user = await User.create({ email, name });

// Read
const user = await User.findById(id);
const users = await User.find({ active: true }).lean();

// Update
await User.findByIdAndUpdate(id, { name: 'New Name' });

// Delete
await User.findByIdAndDelete(id);
```

### Transactions

```typescript
const session = await mongoose.startSession();
await session.withTransaction(async () => {
  await User.create([{ email, name }], { session });
  await Profile.create([{ userId }], { session });
});
session.endSession();
```

## Best Practices

- Use `.lean()` for read-only queries (returns plain objects)
- Always filter by userId for user-scoped queries
- Use transactions for related operations
- Index frequently queried fields
- Validate at schema level
- Cache connections in serverless environments

## Anti-Patterns to Avoid

❌ Not handling connection errors
❌ Not using transactions for related operations
❌ Querying in loops (N+1 problem)
❌ Not filtering by user (security risk)
❌ Exposing Mongoose documents to client (use .lean())

<!-- To be populated from /Users/jim/Projects/draftbox/.claude/skills/mongodb/SKILL.md -->
<!-- 3 additional resource files available in draftbox:
- resources/schema-validation.md
- resources/crud-queries.md
- resources/transactions-performance.md
-->
