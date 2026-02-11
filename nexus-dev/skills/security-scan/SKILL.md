---
name: security-scan
description: Scans for security vulnerabilities in code changes and dependencies before deployment
allowed-tools: mcp__github__*
mcpServers:
  - github
---

# Security Scan Skill

This skill scans for security vulnerabilities in code changes and dependencies to ensure secure deployments and protect against common security threats.

## When This Skill is Invoked

This skill will be used when you mention:
- \"security scan\"
- \"security vulnerabilities\"
- \"security review\"
- \"vulnerability check\"
- \"security issues\"

## Security Check Categories

### 1. Secrets and Credentials 🔐
**What We Check:**
- Hardcoded API keys
- Database passwords
- Private keys
- OAuth tokens
- Configuration secrets

**Common Patterns Detected:**
```javascript
// ❌ Hardcoded secrets
const API_KEY = \"sk_live_abc123xyz\";
const DB_PASSWORD = \"mypassword123\";

// ✅ Environment variables
const API_KEY = process.env.STRIPE_API_KEY;
const DB_PASSWORD = process.env.DATABASE_PASSWORD;
```

### 2. Injection Vulnerabilities 💉
**What We Check:**
- SQL injection
- Command injection
- LDAP injection
- NoSQL injection
- XSS vulnerabilities

**Common Patterns:**
```javascript
// ❌ SQL injection risk
const query = `SELECT * FROM users WHERE id = ${userId}`;

// ✅ Parameterized queries
const query = 'SELECT * FROM users WHERE id = $1';
db.query(query, [userId]);
```

### 3. Authentication & Authorization 🔒
**What We Check:**
- Missing authentication
- Weak authentication
- Authorization bypass
- Insecure session handling
- JWT vulnerabilities

**Common Issues:**
```javascript
// ❌ Missing auth check
app.get('/admin/users', (req, res) => {
  // No authentication check
  return getAllUsers();
});

// ✅ Proper auth check
app.get('/admin/users', requireAuth, requireRole('admin'), (req, res) => {
  return getAllUsers();
});
```

### 4. Data Validation & Sanitization 🧹
**What We Check:**
- Missing input validation
- Insufficient sanitization
- Type confusion
- Buffer overflows
- Path traversal

**Common Patterns:**
```javascript
// ❌ No input validation
app.post('/upload', (req, res) => {
  const filename = req.body.filename;
  fs.writeFile(`./uploads/${filename}`, data);
});

// ✅ Input validation
app.post('/upload', (req, res) => {
  const filename = validator.sanitizeFilename(req.body.filename);
  if (!validator.isValidFilename(filename)) {
    return res.status(400).json({error: 'Invalid filename'});
  }
  fs.writeFile(`./uploads/${filename}`, data);
});
```

### 5. Dependency Vulnerabilities 📦
**What We Check:**
- Outdated packages with known CVEs
- Malicious packages
- License compliance issues
- Dependency confusion attacks

### 6. Configuration Security ⚙️
**What We Check:**
- Debug mode in production
- Insecure defaults
- Missing security headers
- Weak encryption settings

## How to Use This Skill

**Step 1: Analyze Code Changes**
```python
# Get PR file changes
pr = github_get_pull_request(owner, repo, pr_number)
files_changed = github_get_pull_request_files(owner, repo, pr_number)

# Get dependency files
package_files = get_dependency_files(files_changed)
```

**Step 2: Run Security Scans**
```python
import sys
sys.path.append('/path/to/skills/security-scan')
from scanner import SecurityScanner

scanner = SecurityScanner()

# Scan for secrets
secrets_scan = scanner.scan_for_secrets(files_changed)

# Check for injection vulnerabilities
injection_scan = scanner.scan_for_injections(files_changed)

# Validate authentication patterns
auth_scan = scanner.scan_authentication(files_changed)

# Check input validation
validation_scan = scanner.scan_input_validation(files_changed)

# Scan dependencies
dependency_scan = scanner.scan_dependencies(package_files)

# Overall security assessment
security_report = scanner.generate_report([
    secrets_scan, injection_scan, auth_scan,
    validation_scan, dependency_scan
])
```

## Security Assessment Examples

### 🔴 HIGH RISK Example

**PR #205: User Profile API**

**Security Assessment: 🔴 HIGH RISK**

**CRITICAL Issues Found: 3**

**🔐 Secret Exposure (CRITICAL)**
```javascript
// File: config/database.js, Line 12
const DATABASE_URL = \"postgresql://user:mypassword@localhost:5432/mydb\";
```
**Risk:** Database credentials exposed in source code
**Action:** Move to environment variables immediately

**💉 SQL Injection (CRITICAL)**
```javascript
// File: routes/profile.js, Line 28
const query = `SELECT * FROM profiles WHERE user_id = ${req.params.id}`;
```
**Risk:** User input directly concatenated into SQL query
**Action:** Use parameterized queries

**🔒 Missing Authorization (CRITICAL)**
```javascript
// File: routes/profile.js, Line 15
app.get('/api/profile/:id', (req, res) => {
  // No check if user can access this profile
})
```
**Risk:** Users can access any profile by changing ID
**Action:** Add authorization check

**❌ BLOCKED - Cannot merge until critical issues resolved**

### ⚠️ MEDIUM RISK Example

**PR #206: File Upload Feature**

**Security Assessment: ⚠️ MEDIUM RISK**

**Issues Found: 2 medium, 1 low**

**🧹 Input Validation (MEDIUM)**
```javascript
// File: upload.js, Line 45
const filename = req.body.filename;
fs.writeFile(`./uploads/${filename}`, fileData);
```
**Risk:** Path traversal vulnerability (../../../etc/passwd)
**Action:** Sanitize filename and validate path

**🔒 Missing File Type Validation (MEDIUM)**
```javascript
// File: upload.js, Line 52
// No file type checking
multer().single('file')
```
**Risk:** Malicious file uploads (scripts, executables)
**Action:** Whitelist allowed file types

**⚙️ Missing Security Headers (LOW)**
```javascript
// File: app.js
// Missing: X-Content-Type-Options, X-Frame-Options
```
**Risk:** Clickjacking and MIME type sniffing
**Action:** Add security middleware

**🔄 REQUIRES FIXES - Address medium risk issues before merge**

### ✅ LOW RISK Example

**PR #207: UI Component Updates**

**Security Assessment: ✅ LOW RISK**

**Issues Found: 1 informational**

**📦 Dependency Update Available (INFO)**
```json
// package.json
\"lodash\": \"4.17.20\"
```
**Info:** Lodash 4.17.21 available with security fixes
**Action:** Update in next maintenance cycle

**🧹 Minor Validation Enhancement (INFO)**
```javascript
// File: components/SearchBox.js, Line 23
// Consider adding length limit for search queries
```
**Info:** Very long search queries could impact performance
**Action:** Optional - add reasonable length limit

**✅ APPROVED - Low risk issues can be addressed later**

## Security Scanning Checklist

### Code Review Checklist
```markdown
## Security Review Checklist

### Secrets & Credentials
- [ ] No hardcoded API keys
- [ ] No database passwords in code
- [ ] No private keys committed
- [ ] All secrets use environment variables
- [ ] .env files in .gitignore

### Input Validation
- [ ] All user inputs validated
- [ ] SQL queries use parameters
- [ ] File uploads type-checked
- [ ] Path traversal prevention
- [ ] XSS prevention measures

### Authentication & Authorization
- [ ] Auth required for protected routes
- [ ] Authorization levels checked
- [ ] Session handling secure
- [ ] JWT properly validated
- [ ] Password policies enforced

### Dependencies
- [ ] No known vulnerable packages
- [ ] Dependencies up to date
- [ ] No suspicious new packages
- [ ] License compliance checked

### Configuration
- [ ] Debug mode disabled in prod
- [ ] Security headers configured
- [ ] HTTPS enforced
- [ ] CORS properly configured
- [ ] Rate limiting implemented
```

### Automated Security Tools

**Static Analysis:**
- ESLint security rules
- Bandit (Python)
- Brakeman (Ruby)
- SonarQube

**Dependency Scanning:**
- npm audit
- Snyk
- OWASP Dependency Check
- GitHub Dependabot

**Dynamic Testing:**
- OWASP ZAP
- Burp Suite
- Security headers check
- SSL/TLS configuration test

## Risk Levels and Actions

### 🔴 CRITICAL (Block Merge)
- Hardcoded secrets
- SQL injection vulnerabilities
- Authentication bypass
- Remote code execution risks

### ⚠️ HIGH (Fix Before Merge)
- Missing authorization
- XSS vulnerabilities
- Weak authentication
- Data exposure risks

### 🟡 MEDIUM (Fix Soon)
- Input validation issues
- Insecure configurations
- Missing security headers
- Vulnerable dependencies

### 🔵 LOW (Informational)
- Minor configuration improvements
- Dependency updates available
- Code quality enhancements
- Best practice recommendations

## Integration with CI/CD

### Pre-Commit Hooks
- Secret detection
- Basic static analysis
- Dependency vulnerability check

### Pull Request Checks
- Comprehensive security scan
- Dependency audit
- Configuration review
- Manual security review (for high-risk changes)

### Pre-Deployment
- Final security validation
- Infrastructure security check
- Environment configuration review

## False Positive Handling

**Common False Positives:**
- Test data that looks like secrets
- Commented-out code examples
- Mock API keys in tests
- Development configuration

**Mitigation:**
- Use `// security-ignore` comments for exceptions
- Maintain allow-list for test patterns
- Regular review of ignored items

## Security Training Integration

**Developer Education:**
- Secure coding guidelines
- Common vulnerability patterns
- Security testing practices
- Incident response procedures

**Resources:**
- OWASP Top 10 training
- Secure code review checklists
- Security testing examples
- Vulnerability databases

---

This skill ensures code changes meet security standards and protects against common vulnerabilities before deployment.