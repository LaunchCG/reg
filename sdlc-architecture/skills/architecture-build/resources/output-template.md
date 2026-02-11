# Architecture Build Output Template

## Variables

- `{{PROJECT_NAME}}` - Repository/project name
- `{{ASSESSMENT_DATE}}` - Date of assessment
- `{{README_SCORE}}` - README quality score (0-5)
- `{{ARCHITECTURE_SCORE}}` - Architecture docs score (0-5)
- `{{API_SCORE}}` - API documentation score (0-5)
- `{{TESTING_SCORE}}` - Testing docs score (0-5)
- `{{CICD_SCORE}}` - CI/CD docs score (0-5)
- `{{OPERATIONS_SCORE}}` - Operations docs score (0-5)
- `{{TECH_STACK}}` - Detected technology stack
- `{{FRAMEWORK}}` - Detected framework
- `{{DATABASE}}` - Detected database
- `{{EXTERNAL_SERVICES}}` - List of detected external services
- `{{STRENGTHS_LIST}}` - List of documentation strengths
- `{{GAPS_LIST}}` - List of documentation gaps
- `{{CRITICAL_QUESTIONS}}` - Questions needing team answers
- `{{GENERATED_DRAFTS}}` - List of generated draft documents
- `{{ROADMAP}}` - Recommended improvement roadmap

---

## Output Template

```markdown
# Repository Documentation Assessment

**Project:** {{PROJECT_NAME}}
**Assessment Date:** {{ASSESSMENT_DATE}}

---

## Summary

| Dimension | Score | Status |
|-----------|-------|--------|
| README Quality | {{README_SCORE}}/5 | {{README_STATUS}} |
| Architecture Docs | {{ARCHITECTURE_SCORE}}/5 | {{ARCHITECTURE_STATUS}} |
| API Contracts | {{API_SCORE}}/5 | {{API_STATUS}} |
| Testing Standards | {{TESTING_SCORE}}/5 | {{TESTING_STATUS}} |
| CI/CD Documentation | {{CICD_SCORE}}/5 | {{CICD_STATUS}} |
| Operational Readiness | {{OPERATIONS_SCORE}}/5 | {{OPERATIONS_STATUS}} |

**Overall Assessment:** {{OVERALL_ASSESSMENT}}

---

## Technology Detection

| Aspect | Detected | Confidence |
|--------|----------|------------|
| Language | {{LANGUAGE}} | {{LANGUAGE_CONFIDENCE}} |
| Framework | {{FRAMEWORK}} | {{FRAMEWORK_CONFIDENCE}} |
| Database | {{DATABASE}} | {{DATABASE_CONFIDENCE}} |
| External Services | {{EXTERNAL_SERVICES}} | {{SERVICES_CONFIDENCE}} |
| Infrastructure | {{INFRASTRUCTURE}} | {{INFRA_CONFIDENCE}} |

---

## Strengths

{{STRENGTHS_LIST}}

---

## Areas for Improvement

{{GAPS_LIST}}

---

## Critical Questions

> These questions need answers from the engineering team to complete documentation.

{{CRITICAL_QUESTIONS}}

---

## Generated Drafts

> **Note to Engineering Team:** The following drafts are generated based on
> codebase analysis. They represent a good-faith effort to document what
> I observed. Please review, correct, and expand these documents.
>
> I anticipate you'll be editing these locally.

{{GENERATED_DRAFTS}}

---

## Recommended Roadmap

{{ROADMAP}}

---

**Assessment Complete:** {{ASSESSMENT_DATE}}
**Re-run Command:** `/architecture build` after making updates
```

---

## Status Indicators

| Score | Status Text | Emoji |
|-------|-------------|-------|
| 5 | Excellent | ✅ |
| 4 | Good | ✅ |
| 3 | Needs Work | ⚠️ |
| 2 | Poor | ⚠️ |
| 1 | Minimal | ❌ |
| 0 | Missing | ❌ |

---

## Confidence Levels

| Level | Description |
|-------|-------------|
| HIGH | Direct evidence found (config file, explicit import) |
| MEDIUM | Inferred from patterns (directory structure, naming) |
| LOW | Uncertain, needs verification |

---

## Example Populated Output

```markdown
# Repository Documentation Assessment

**Project:** payment-service
**Assessment Date:** 2025-11-30

---

## Summary

| Dimension | Score | Status |
|-----------|-------|--------|
| README Quality | 4/5 | ✅ Good |
| Architecture Docs | 2/5 | ⚠️ Needs Work |
| API Contracts | 3/5 | ⚠️ Needs Work |
| Testing Standards | 1/5 | ❌ Minimal |
| CI/CD Documentation | 4/5 | ✅ Good |
| Operational Readiness | 2/5 | ⚠️ Needs Work |

**Overall Assessment:** This repository has a solid foundation but needs investment in architecture documentation and testing standards.

---

## Technology Detection

| Aspect | Detected | Confidence |
|--------|----------|------------|
| Language | TypeScript | HIGH |
| Framework | Express.js | HIGH |
| Database | PostgreSQL | HIGH |
| External Services | Stripe, SendGrid | HIGH |
| Infrastructure | Docker, GitHub Actions | HIGH |

---

## Strengths

✅ **README Quality (4/5)**
- Clear project description explaining payment processing
- Quick start guide with working commands
- Team ownership documented (payments-team, #payments-support)
- Missing: Deployment link (points to outdated wiki)

✅ **CI/CD Documentation (4/5)**
- Well-structured GitHub Actions workflows
- Clear separation of CI and deploy pipelines
- Rollback procedure documented in deploy workflow
- Missing: Detailed troubleshooting for failed deploys

---

## Areas for Improvement

### Architecture Documentation (2/5)

**What Exists:**
- Basic ARCHITECTURE.md with system overview

**What's Missing:**
- Data flow diagrams
- Integration point documentation
- ADRs for key decisions
- Failure mode documentation

### Testing Standards (1/5)

**What Exists:**
- Jest test files in `__tests__/`
- Some integration tests

**What's Missing:**
- Test layer documentation
- Coverage expectations
- Pre-PR requirements
- Flaky test policy

---

## Critical Questions

### About Architecture
1. Why was PostgreSQL chosen for payment data over a specialized financial database?
2. What is the exact flow of a payment from API request to Stripe completion?
3. How are failed Stripe webhooks handled and retried?
4. What happens to in-flight payments during deployment?

### About Operations
1. What PagerDuty escalation policy applies to this service?
2. What Datadog dashboards should be monitored?
3. What constitutes a "healthy" deployment vs. rollback trigger?

### About Testing
1. What coverage percentage is expected for new code?
2. Are integration tests required for all PRs?
3. How should tests handle Stripe sandbox timeouts?

---

## Generated Drafts

### docs/architecture/data-flow.md (Draft)

```markdown
# Payment Data Flow

## Payment Creation Flow

\`\`\`mermaid
sequenceDiagram
    participant C as Client
    participant A as Payment API
    participant D as PostgreSQL
    participant S as Stripe

    C->>A: POST /payments
    A->>D: Create pending payment
    A->>S: Create PaymentIntent
    S-->>A: PaymentIntent ID
    A->>D: Update with Stripe ID
    A-->>C: Payment pending

    Note over S: Customer completes payment

    S->>A: Webhook: payment_succeeded
    A->>D: Update status to completed
\`\`\`

> **Note:** This diagram is inferred from code analysis. Please verify accuracy.
```

### docs/architecture/decisions/001-postgresql-payments.md (Draft)

```markdown
# ADR-001: PostgreSQL for Payment Data

## Status
Accepted (inferred from codebase - please verify)

## Context
> **Note:** This context is inferred. Please expand with actual decision history.

The payment service requires persistent storage for payment records, customer data,
and transaction history. ACID compliance is critical for financial data integrity.

## Decision
Use PostgreSQL as the primary database for payment data.

**Evidence from codebase:**
- `DATABASE_URL` references PostgreSQL
- Prisma configured with PostgreSQL provider
- Migration files use PostgreSQL-specific syntax

## Consequences

**Positive (assumed):**
- Strong ACID compliance for financial transactions
- Rich query capabilities for reporting
- Well-understood operational model

**Negative (assumed):**
- Requires careful connection pool management
- Horizontal scaling requires additional tooling

## Date
2024-03-15 (earliest database migration)

---
> **Team Action Required:** Please verify this ADR and add actual decision context.
```

---

## Recommended Roadmap

### Week 1: Foundation
- [ ] Answer critical architecture questions
- [ ] Review and finalize generated ADR drafts
- [ ] Add missing README deployment link

### Week 2: Architecture
- [ ] Complete data-flow.md with accurate diagrams
- [ ] Document Stripe integration failure modes
- [ ] Create ADR for webhook retry strategy

### Week 3: Operations
- [ ] Create runbook for payment failures
- [ ] Document Datadog dashboards and alerts
- [ ] Define deployment health checks

---

**Assessment Complete:** 2025-11-30
**Re-run Command:** `/architecture build` after making updates
```
