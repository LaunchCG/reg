# Code Verification Results

## {{STATUS_ICON}} {{STATUS_MESSAGE}}

**Story:** {{STORY_KEY}} - {{STORY_TITLE}}
**Test Suite:** {{TOTAL_TESTS}} tests
**Status:** {{VERIFICATION_STATUS}}

---

## Test Results

| Test Type | Total | Passed | Failed | Coverage |
|-----------|-------|--------|--------|----------|
| Unit | {{UNIT_TOTAL}} | {{UNIT_PASSED}} | {{UNIT_FAILED}} | {{UNIT_COVERAGE}}% |
| Integration | {{INTEGRATION_TOTAL}} | {{INTEGRATION_PASSED}} | {{INTEGRATION_FAILED}} | {{INTEGRATION_COVERAGE}}% |
| E2E | {{E2E_TOTAL}} | {{E2E_PASSED}} | {{E2E_FAILED}} | {{E2E_COVERAGE}}% |
| **Total** | **{{TOTAL_TESTS}}** | **{{TOTAL_PASSED}}** | **{{TOTAL_FAILED}}** | **{{OVERALL_COVERAGE}}%** |

---

{{ACCEPTANCE_CRITERIA_SECTION}}

---

## Code Quality

### Coverage
- **Overall:** {{OVERALL_COVERAGE}}%
- **Status:** {{COVERAGE_STATUS}}

### Linting
- **Status:** {{LINTING_STATUS}}

### Security
- **Status:** {{SECURITY_STATUS}}

---

{{IMPLEMENTATION_OR_FIXES_SECTION}}

---

**Verification Complete:** {{TIMESTAMP}}
{{ADDITIONAL_STATUS_INFO}}
