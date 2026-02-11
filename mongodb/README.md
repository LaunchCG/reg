# mongodb

MongoDB and Mongoose ODM expertise for Node.js applications.

## Overview

Comprehensive MongoDB guidance including:
- Schema design patterns
- CRUD operations
- Transactions
- Performance optimization
- Type safety with TypeScript

## Contents

### Skills
- **mongodb** - Expert guidance for MongoDB and Mongoose ODM

## Dependencies

- `typescript@^0.2.0` - For TypeScript support

## Installation

Add to your `dex.hcl`:

```hcl
plugin "mongodb" {
  registry = "dex-dev-registry"
  version  = "^0.1.0"
}
```

## Usage

The mongodb skill provides expert guidance on:
- Defining Mongoose schemas with TypeScript
- Connection management in serverless environments
- CRUD operations with proper patterns
- Transaction handling for atomic operations
- Query optimization and indexing
- Validation at schema level

## Best Practices

### Schema Definition
```typescript
interface IUser extends Document {
  email: string;
  name: string;
}

const UserSchema = new Schema<IUser>({
  email: { type: String, required: true, unique: true },
  name: { type: String, required: true }
});
```

### Connection Caching
```typescript
// Cache connection in serverless environments
let cached = global.mongoose;
```

### Use .lean() for Read Operations
```typescript
// Returns plain objects, better performance
const users = await User.find().lean();
```

### Transactions for Related Operations
```typescript
const session = await mongoose.startSession();
await session.withTransaction(async () => {
  // All operations succeed or all fail
});
```

## Version History

### 0.1.0 (Initial Release)
- MongoDB/Mongoose skill with TypeScript patterns
- Schema design guidance
- CRUD operation patterns
- Transaction handling

## Note

This package contains placeholder content. Full content should be populated from:
- `/Users/jim/Projects/draftbox/.claude/skills/mongodb/SKILL.md`
- `/Users/jim/Projects/draftbox/.claude/skills/mongodb/resources/schema-validation.md`
- `/Users/jim/Projects/draftbox/.claude/skills/mongodb/resources/crud-queries.md`
- `/Users/jim/Projects/draftbox/.claude/skills/mongodb/resources/transactions-performance.md`
