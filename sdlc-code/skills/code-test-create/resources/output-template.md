# Test Suite Generated for {{STORY_KEY}}

## Summary
- **Total Tests:** {{TOTAL_TESTS}}
- **Unit Tests:** {{UNIT_TESTS_COUNT}}
- **Integration Tests:** {{INTEGRATION_TESTS_COUNT}}
- **E2E Tests:** {{E2E_TESTS_COUNT}}
- **Test Files Created:** {{TEST_FILES_COUNT}}

---

## Generated Test Files

### 1. `{{TEST_FILE_1}}`
```{{LANGUAGE}}
{{TEST_CODE_1}}
```

### 2. `{{TEST_FILE_2}}`
```{{LANGUAGE}}
{{TEST_CODE_2}}
```

{{ADDITIONAL_TEST_FILES}}

---

## Running the Tests (RED Phase)

```bash
{{TEST_COMMAND}}

# Expected: ALL tests should FAIL
# This confirms we're in RED phase
```

**Expected Failures:**
- [ ] Test 1: {{EXPECTED_FAILURE_1}}
- [ ] Test 2: {{EXPECTED_FAILURE_2}}
- [ ] Test 3: {{EXPECTED_FAILURE_3}}

---

## Next Steps

1. **Verify RED:** Run tests and confirm all fail
2. **Review Failures:** Check failure messages are clear
3. **Proceed to GREEN:** Move to implementation phase
4. **Use `/code-build`:** Generate implementation to pass these tests

---

**Tests Generated:** {{TIMESTAMP}}
**TDD Phase:** RED (tests should fail)
**Ready for Implementation:** Yes
