# Technical Story Template

## Variables

- `{{TECH_TITLE}}` - Description of technical work
- `{{STORY_ID}}` - Jira key (e.g., PROJ-123) or TBD
- `{{CATEGORY}}` - Refactoring | Infrastructure | Tech Debt | Spike
- `{{STAKEHOLDER}}` - development team | system | operations team
- `{{IMPROVEMENT}}` - Technical improvement needed
- `{{TECH_BENEFIT}}` - Technical benefit or business value
- `{{TECH_CONTEXT}}` - Why this work is needed
- `{{IMPLEMENTATION_PLAN}}` - Detailed implementation approach
- `{{AC_1_TITLE}}` - First acceptance criterion title
- `{{AC_1_CRITERIA}}` - First validation criteria
- `{{AC_2_TITLE}}` - Second acceptance criterion title
- `{{AC_2_CRITERIA}}` - Second validation criteria
- `{{SUCCESS_METRICS}}` - How we measure success
- `{{TIMESTAMP}}` - Creation timestamp

---

## Technical Story Template

```markdown
# Technical Story: {{TECH_TITLE}}

**ID:** {{STORY_ID}}
**Type:** Technical
**Category:** {{CATEGORY}}
**Status:** Draft

---

## Story

**As a** {{STAKEHOLDER}}
**I want** {{IMPROVEMENT}}
**So that** {{TECH_BENEFIT}}

---

## Technical Context

{{TECH_CONTEXT}}

---

## Technical Approach

{{IMPLEMENTATION_PLAN}}

---

## Acceptance Criteria

### {{AC_1_TITLE}}
{{AC_1_CRITERIA}}

### {{AC_2_TITLE}}
{{AC_2_CRITERIA}}

---

## Success Metrics

{{SUCCESS_METRICS}}

---

## Definition of Ready Checklist

- [ ] Technical context is clear
- [ ] Approach is documented
- [ ] Success metrics defined
- [ ] Dependencies identified
- [ ] Rollback plan considered
- [ ] Testing approach defined

---

**Created:** {{TIMESTAMP}}
**Version:** 1.0
**Ready for Development:** {{READY_STATUS}}
```

---

## Category Guidelines

| Category | Description | Examples |
|----------|-------------|----------|
| Refactoring | Improving code structure without changing behavior | Extract service, rename components, reduce complexity |
| Infrastructure | Changes to deployment, CI/CD, or hosting | Add caching layer, upgrade database, set up monitoring |
| Tech Debt | Fixing shortcuts or outdated patterns | Update deprecated APIs, fix security vulnerabilities |
| Spike | Research or proof of concept | Evaluate new framework, prototype integration |

---

## Example Technical Story

```markdown
# Technical Story: Migrate authentication to OAuth 2.0

**ID:** PROJ-789
**Type:** Technical
**Category:** Infrastructure
**Status:** Draft

---

## Story

**As a** development team
**I want** to migrate our authentication system from session-based to OAuth 2.0
**So that** we can support SSO and improve security posture

---

## Technical Context

Our current session-based authentication:
- Doesn't support Single Sign-On (SSO) required by enterprise customers
- Stores sessions in memory, causing scaling issues
- Uses MD5 for password hashing (deprecated)

Migration to OAuth 2.0 will:
- Enable SSO integration with identity providers
- Remove session state from application servers
- Implement modern security standards (PKCE, token refresh)

---

## Technical Approach

1. **Phase 1: Infrastructure**
   - Set up OAuth 2.0 authorization server (Keycloak)
   - Configure identity provider connections
   - Set up token signing keys

2. **Phase 2: Application Changes**
   - Replace session middleware with JWT validation
   - Implement token refresh flow
   - Update API endpoints for token-based auth

3. **Phase 3: Migration**
   - Create user migration script
   - Run parallel auth systems during transition
   - Deprecate session-based endpoints

---

## Acceptance Criteria

### OAuth 2.0 Flow Works
- Authorization code flow with PKCE completes successfully
- Access tokens are issued with correct claims
- Refresh tokens extend session without re-authentication

### Backward Compatibility
- Existing API clients continue to work during migration period
- Session-based auth remains functional until cutoff date
- Migration script successfully transfers all user accounts

---

## Success Metrics

- **Security:** All passwords use bcrypt with cost factor 12
- **Performance:** Token validation < 10ms (95th percentile)
- **Reliability:** Zero authentication failures during migration
- **Adoption:** 100% of users migrated within 30 days
```

---

## Spike Story Format

For research or proof-of-concept work:

```markdown
# Technical Story: [Spike] Evaluate GraphQL for API Layer

**Type:** Technical
**Category:** Spike
**Time-boxed:** 2 days

---

## Story

**As a** development team
**I want** to evaluate GraphQL as a replacement for our REST API
**So that** we can make an informed decision about API architecture

---

## Questions to Answer

1. Can GraphQL handle our query patterns efficiently?
2. What is the learning curve for the team?
3. How does it integrate with our current authentication?
4. What are the performance implications?

---

## Deliverables

- [ ] Working proof-of-concept with 3 representative queries
- [ ] Performance comparison document (GraphQL vs REST)
- [ ] Team presentation with recommendation
- [ ] ADR documenting decision (proceed or not)

---

## Success Criteria

- Questions answered with evidence
- Team aligned on next steps
- Decision documented in ADR
```
