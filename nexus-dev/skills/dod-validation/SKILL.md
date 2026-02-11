---
name: dod-validation
description: Validates work meets Definition of Done before merge to ensure quality and completeness
allowed-tools: mcp__github__*, mcp__atlassian__*
mcpServers:
  - github
  - atlassian
---

# Definition of Done Validation Skill

This skill validates that completed work meets Definition of Done (DoD) criteria before merge. It ensures consistent quality standards and completeness across all deliverables.

## When This Skill is Invoked

This skill will be used when you mention:
- \"definition of done\"
- \"DoD validation\"
- \"ready for merge\"
- \"PR review checklist\"
- \"quality gates\"

## Definition of Done Criteria

Work is **complete** and ready for merge when ALL criteria are met:

### 1. Code Quality ✅
- [ ] Code follows team standards and conventions
- [ ] No linting errors or warnings
- [ ] Code is readable and well-documented
- [ ] No debug code or console.log statements
- [ ] Complexity is manageable (functions <50 lines)

### 2. Testing ✅
- [ ] Unit tests written for all new functions
- [ ] Integration tests for component interactions
- [ ] All tests pass (100% pass rate)
- [ ] Test coverage meets minimum threshold (>80%)
- [ ] Edge cases and error scenarios tested

### 3. Security ✅
- [ ] No hardcoded secrets or credentials
- [ ] Input validation implemented
- [ ] Authentication checks in place
- [ ] Authorization verified where needed
- [ ] No SQL injection vulnerabilities

### 4. Documentation ✅
- [ ] Code comments for complex logic
- [ ] README updated if needed
- [ ] API documentation updated
- [ ] User documentation for new features
- [ ] Migration guides for breaking changes

### 5. Acceptance Criteria ✅
- [ ] All acceptance criteria implemented
- [ ] Feature works as specified
- [ ] User story objectives achieved
- [ ] Demo-ready for stakeholders

### 6. Version Control ✅
- [ ] Commits have Jira ticket keys
- [ ] Commit messages are descriptive
- [ ] Branch follows naming convention
- [ ] No merge conflicts
- [ ] Clean git history (squash if needed)

## How to Use This Skill

**Step 1: Fetch PR and Story Data**
```python
# Get pull request details
pr = github_get_pull_request(owner, repo, pr_number)
files_changed = github_get_pull_request_files(owner, repo, pr_number)

# Get associated Jira story
story_key = extract_jira_key_from_pr(pr)
story = atlassian_jira_get_issue(story_key) if story_key else None
```

**Step 2: Validate DoD Criteria**
```python
import sys
sys.path.append('/path/to/skills/dod-validation')
from validator import DoDValidator

validator = DoDValidator()

# Check each DoD criterion
code_quality = validator.validate_code_quality(files_changed)
testing = validator.validate_testing(pr, files_changed)
security = validator.validate_security(files_changed)
documentation = validator.validate_documentation(pr, files_changed)
acceptance = validator.validate_acceptance_criteria(story, pr)
version_control = validator.validate_version_control(pr)

# Overall assessment
dod_result = validator.overall_assessment([
    code_quality, testing, security,
    documentation, acceptance, version_control
])
```

## Validation Examples

### ✅ COMPLETE Example

**PR #142: PROJ-123 Export Customer Health Scores**

**DoD Assessment: ✅ COMPLETE**

**Code Quality: ✅ PASS**
- ✅ ESLint passes with no warnings
- ✅ Functions average 23 lines (under 50 line limit)
- ✅ Clear variable names and structure
- ✅ No console.log or debug code found

**Testing: ✅ PASS**
- ✅ 12 unit tests added for export functionality
- ✅ 3 integration tests for file download
- ✅ All 47 tests passing (100% pass rate)
- ✅ Coverage: 94% (exceeds 80% threshold)

**Security: ✅ PASS**
- ✅ No hardcoded API keys detected
- ✅ Input validation on file format parameters
- ✅ User authentication required for export
- ✅ Data filtering by user permissions

**Documentation: ✅ PASS**
- ✅ API endpoint documented in swagger.yml
- ✅ User guide updated with export instructions
- ✅ Complex CSV parsing logic commented

**Acceptance Criteria: ✅ PASS**
- ✅ CSV export button working as specified
- ✅ Correct data format (customer_id, name, health_score, date)
- ✅ Error handling for empty data and service failures
- ✅ All 3 acceptance criteria implemented and tested

**Version Control: ✅ PASS**
- ✅ All 4 commits include \"PROJ-123\" key
- ✅ Descriptive commit messages
- ✅ Feature branch name follows convention (feature/PROJ-123-export)
- ✅ No merge conflicts

**✅ READY FOR MERGE**

### ❌ INCOMPLETE Example

**PR #143: PROJ-124 User Dashboard Improvements**

**DoD Assessment: ❌ INCOMPLETE**

**Code Quality: ⚠️ CONDITIONAL PASS**
- ✅ No linting errors
- ❌ Function `updateDashboard()` is 87 lines (exceeds 50 line limit)
- ⚠️ Some variable names unclear (`temp`, `data2`)

**Testing: ❌ FAIL**
- ❌ No unit tests for new dashboard components
- ❌ Integration tests failing (2/5 pass)
- ❌ Coverage dropped from 84% to 73%
- ❌ Edge case for empty data not tested

**Security: ✅ PASS**
- ✅ No security issues detected
- ✅ Proper authentication checks

**Documentation: ❌ FAIL**
- ❌ No user documentation for new dashboard features
- ❌ Complex dashboard logic not commented
- ⚠️ API changes not reflected in documentation

**Acceptance Criteria: ⚠️ PARTIAL**
- ✅ Dashboard loads faster (AC #1 complete)
- ❌ Filter functionality not working (AC #2 incomplete)
- ❌ Mobile responsive layout issues (AC #3 incomplete)

**Version Control: ❌ FAIL**
- ❌ 2 commits missing PROJ-124 key
- ❌ Generic commit message: \"fix stuff\"
- ✅ Branch name follows convention

**❌ BLOCKED - Cannot merge until issues resolved**

**Required Actions:**
1. **CRITICAL:** Fix failing integration tests
2. **CRITICAL:** Implement remaining acceptance criteria (filter, mobile)
3. **HIGH:** Add unit tests (target >80% coverage)
4. **HIGH:** Break down 87-line function into smaller pieces
5. **MEDIUM:** Update user documentation
6. **MEDIUM:** Fix commit messages and add Jira keys

### 🔄 NEEDS REVIEW Example

**PR #144: PROJ-125 Password Reset Enhancement**

**DoD Assessment: 🔄 NEEDS REVIEW**

**Auto-Validation Results:**
- ✅ Code Quality: Pass
- ✅ Testing: Pass (89% coverage)
- ✅ Security: Pass
- ✅ Version Control: Pass
- ⚠️ Documentation: Partial (API docs updated, user guide missing)
- ❓ Acceptance Criteria: Manual verification required

**Manual Review Required:**
1. **Product Owner:** Verify acceptance criteria implementation
2. **Security:** Review password reset flow for vulnerabilities
3. **UX:** Approve new password strength indicators

**Estimated Review Time:** 2 hours

**If Approved:** Ready for merge
**If Issues Found:** Return to development

## Batch Validation

For multiple PRs (e.g., sprint review):

```
Sprint 45 DoD Validation Summary (6 PRs)

✅ COMPLETE & MERGED: 4 PRs (67%)
❌ INCOMPLETE: 2 PRs (33%)

Status Breakdown:
✅ PR #140: PROJ-120 Bug fixes (merged)
✅ PR #141: PROJ-121 API optimization (merged)  
✅ PR #142: PROJ-123 Export feature (merged)
✅ PR #145: PROJ-127 Navigation fix (merged)
❌ PR #143: PROJ-124 Dashboard (blocked - testing issues)
❌ PR #146: PROJ-128 Social login (blocked - missing docs)

Quality Metrics:
- Average test coverage: 87%
- Security issues found: 0
- Documentation compliance: 83%

Sprint Success Rate: 67% (target >85%)

Improvement Actions:
1. Reinforce DoD training for testing requirements
2. Update PR template with DoD checklist
3. Implement automated DoD checks in CI/CD
```

## Integration with CI/CD

### Automated Checks
- Linting and code style
- Test execution and coverage
- Security scans
- Documentation generation

### Manual Gates
- Code review approval
- Product owner acceptance
- Security review (for sensitive changes)
- Architecture review (for major changes)

## DoD Checklist Template

Use this in PR descriptions:

```markdown
## Definition of Done Checklist

### Code Quality
- [ ] No linting errors or warnings
- [ ] Functions under 50 lines
- [ ] Clear variable and function names
- [ ] No debug code or console statements

### Testing  
- [ ] Unit tests for all new functions
- [ ] Integration tests for interactions
- [ ] All tests pass (green CI)
- [ ] Coverage >80%
- [ ] Edge cases tested

### Security
- [ ] No hardcoded secrets
- [ ] Input validation implemented
- [ ] Authentication/authorization verified
- [ ] No injection vulnerabilities

### Documentation
- [ ] Code commented where complex
- [ ] README updated if needed
- [ ] API docs updated
- [ ] User docs for new features

### Acceptance Criteria
- [ ] All ACs implemented
- [ ] Feature works as specified  
- [ ] Demo ready

### Version Control
- [ ] Commits have Jira keys
- [ ] Descriptive commit messages
- [ ] Clean git history
- [ ] No merge conflicts

**Overall: [ ] READY FOR MERGE**
```

## Error Handling

- **PR Not Found:** Verify repository and PR number
- **Jira Integration:** May not have associated story (note in assessment)
- **Test Failures:** Cannot merge until all tests pass
- **Security Issues:** Automatic block until resolved
- **Missing Documentation:** May allow merge with follow-up ticket

---

This skill ensures consistent quality standards and reduces post-merge defects through comprehensive validation.