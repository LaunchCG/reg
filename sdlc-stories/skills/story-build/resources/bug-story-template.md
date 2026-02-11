# Bug Story Template

## Variables

- `{{BUG_TITLE}}` - Description of the bug
- `{{STORY_ID}}` - Jira key (e.g., PROJ-123) or TBD
- `{{SEVERITY}}` - Critical | High | Medium | Low
- `{{AFFECTED_USER}}` - User persona affected by the bug
- `{{CORRECT_BEHAVIOR}}` - What should happen
- `{{FIX_IMPACT}}` - Business impact of fixing the bug
- `{{BUG_DESCRIPTION}}` - What is broken
- `{{STEP_1}}` - First reproduction step
- `{{STEP_2}}` - Second reproduction step
- `{{STEP_3}}` - Third reproduction step
- `{{EXPECTED_BEHAVIOR}}` - What should happen
- `{{ACTUAL_BEHAVIOR}}` - What actually happens
- `{{FIX_GIVEN}}` - Initial state for fix verification
- `{{FIX_WHEN}}` - Reproduction steps
- `{{FIX_THEN}}` - Correct behavior
- `{{REGRESSION_GIVEN}}` - Related functionality context
- `{{REGRESSION_WHEN}}` - Related feature usage
- `{{REGRESSION_THEN}}` - No new issues
- `{{TIMESTAMP}}` - Creation timestamp

---

## Bug Story Template

```markdown
# Bug Story: {{BUG_TITLE}}

**ID:** {{STORY_ID}}
**Type:** Bug
**Severity:** {{SEVERITY}}
**Status:** Draft

---

## Story

**As a** {{AFFECTED_USER}}
**I want** {{CORRECT_BEHAVIOR}}
**So that** {{FIX_IMPACT}}

---

## Bug Description

{{BUG_DESCRIPTION}}

**Steps to Reproduce:**
1. {{STEP_1}}
2. {{STEP_2}}
3. {{STEP_3}}

**Expected Behavior:**
{{EXPECTED_BEHAVIOR}}

**Actual Behavior:**
{{ACTUAL_BEHAVIOR}}

---

## Acceptance Criteria

### Scenario 1: Bug is Fixed
**Given** {{FIX_GIVEN}}
**When** {{FIX_WHEN}}
**Then** {{FIX_THEN}}

### Scenario 2: Regression Check
**Given** {{REGRESSION_GIVEN}}
**When** {{REGRESSION_WHEN}}
**Then** {{REGRESSION_THEN}}

---

## Definition of Ready Checklist

- [ ] Bug is reproducible
- [ ] Steps to reproduce are clear
- [ ] Expected vs actual behavior documented
- [ ] Severity is assigned
- [ ] Fix acceptance criteria defined
- [ ] Regression check included

---

**Created:** {{TIMESTAMP}}
**Version:** 1.0
**Ready for Development:** {{READY_STATUS}}
```

---

## Severity Guidelines

| Severity | Description | Response |
|----------|-------------|----------|
| Critical | System down, data loss, security breach | Immediate fix required |
| High | Major feature broken, significant user impact | Fix in current sprint |
| Medium | Feature partially broken, workaround exists | Schedule for upcoming sprint |
| Low | Minor issue, cosmetic, rare edge case | Backlog for future sprint |

---

## Example Bug Story

```markdown
# Bug Story: Login fails with valid credentials after password reset

**ID:** PROJ-456
**Type:** Bug
**Severity:** High
**Status:** Draft

---

## Story

**As a** registered customer
**I want** to log in with my new password after resetting it
**So that** I can access my account without contacting support

---

## Bug Description

After completing password reset flow, users cannot log in with their new password. The system shows "Invalid credentials" error despite the password meeting all requirements and being confirmed via email.

**Steps to Reproduce:**
1. Go to login page and click "Forgot Password"
2. Complete password reset flow with valid new password
3. Receive confirmation email
4. Attempt to log in with new password

**Expected Behavior:**
User successfully logs in with new password

**Actual Behavior:**
System displays "Invalid credentials" error. User must contact support to unlock account.

---

## Acceptance Criteria

### Scenario 1: Bug is Fixed
**Given** I have completed the password reset flow
**When** I log in with my new password
**Then** I am successfully authenticated and redirected to dashboard

### Scenario 2: Regression Check
**Given** I am an existing user who has not reset my password
**When** I log in with my existing password
**Then** I am successfully authenticated as before
```
