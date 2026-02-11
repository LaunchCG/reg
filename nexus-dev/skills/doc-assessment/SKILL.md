---
name: doc-assessment
description: Assesses documentation completeness and quality for code changes and features
allowed-tools: mcp__github__*
mcpServers:
  - github
---

# Documentation Assessment Skill

This skill assesses documentation completeness and quality for code changes and features to ensure maintainability and knowledge sharing.

## When This Skill is Invoked

This skill will be used when you mention:
- \"documentation review\"
- \"docs assessment\"
- \"documentation quality\"
- \"missing documentation\"
- \"doc completeness\"

## Documentation Requirements by Change Type

### New Feature
**Required Documentation:**
- [ ] User-facing feature documentation
- [ ] API documentation (if adding endpoints)
- [ ] Configuration documentation (if adding settings)
- [ ] Integration guide (if external systems)

### Bug Fix
**Required Documentation:**
- [ ] Root cause analysis (for complex bugs)
- [ ] Prevention measures (if systemic)
- [ ] Usually NO user documentation needed

### API Changes
**Required Documentation:**
- [ ] Updated API specification
- [ ] Migration guide (breaking changes)
- [ ] Examples of new usage
- [ ] Deprecation notices (if applicable)

### Configuration Changes
**Required Documentation:**
- [ ] Updated configuration guide
- [ ] Environment variable documentation
- [ ] Deployment instructions
- [ ] Security implications

### Architecture Changes
**Required Documentation:**
- [ ] Updated architecture diagrams
- [ ] Decision records (ADRs)
- [ ] Migration instructions
- [ ] Performance implications

## How to Use This Skill

**Step 1: Analyze Code Changes**
```python
# Get PR file changes
pr = github_get_pull_request(owner, repo, pr_number)
files_changed = github_get_pull_request_files(owner, repo, pr_number)

# Identify change types
change_analysis = analyze_change_types(files_changed)
```

**Step 2: Assess Documentation Requirements**
```python
import sys
sys.path.append('/path/to/skills/doc-assessment')
from assessor import DocumentationAssessor

assessor = DocumentationAssessor()

# Determine required documentation
requirements = assessor.determine_requirements(change_analysis)

# Check existing documentation
docs_status = assessor.assess_documentation(files_changed, requirements)

# Overall assessment
assessment = assessor.overall_assessment(docs_status, requirements)
```

## Assessment Examples

### ✅ COMPLETE Documentation Example

**PR #156: Add OAuth2 Integration**

**Change Type Analysis:**
- New API endpoints (+3)
- New configuration options (+5)  
- External service integration
- Breaking change to auth flow

**Documentation Assessment: ✅ COMPLETE**

**Required Documentation:**
✅ API Documentation
- New OAuth endpoints documented in swagger.yml
- Request/response examples included
- Error codes and messages specified

✅ Configuration Guide
- New environment variables documented
- Default values specified
- Security considerations noted

✅ Integration Guide  
- Step-by-step setup instructions
- Provider-specific configuration examples
- Callback URL configuration

✅ Migration Guide
- Breaking changes clearly marked
- Migration steps for existing users
- Backward compatibility notes

✅ Security Documentation
- OAuth flow diagrams
- Security best practices
- Token handling guidelines

**Documentation Quality Score: 95/100**
- Clear and comprehensive
- Good examples provided
- Proper formatting and structure

### ❌ INCOMPLETE Documentation Example

**PR #157: Add Advanced Search Feature**

**Change Type Analysis:**
- New user-facing feature
- New API endpoints (+2)
- Complex query functionality
- Database schema changes

**Documentation Assessment: ❌ INCOMPLETE**

**Missing Documentation:**
❌ User Guide
- No documentation for end users
- Feature discovery will be poor

❌ API Documentation
- New search endpoints not documented
- Query parameter options missing

❌ Database Documentation  
- Schema changes not documented
- Migration scripts missing

**Existing Documentation:**
⚠️ Code Comments
- Some complex logic commented
- Missing comments on search algorithm

✅ Unit Test Documentation
- Test cases show expected behavior
- Good coverage of edge cases

**Documentation Quality Score: 25/100**

**Required Before Merge:**
1. **CRITICAL:** Add user guide for search feature
2. **CRITICAL:** Document API endpoints and parameters  
3. **HIGH:** Document database schema changes
4. **MEDIUM:** Add inline comments for search algorithm

### 🔄 PARTIAL Documentation Example

**PR #158: Optimize Database Queries**

**Change Type Analysis:**
- Performance optimization
- Internal code changes only
- No user-facing changes
- Database query modifications

**Documentation Assessment: 🔄 PARTIAL**

**Required Documentation:**
✅ Performance Benchmarks
- Before/after performance metrics
- Query execution time improvements
- Resource usage comparisons

⚠️ Code Comments
- Complex optimization logic partially commented
- Missing rationale for algorithm choices

❌ Operations Documentation
- Missing monitoring recommendations
- No alerting threshold updates

N/A User Documentation
- No user-facing changes (not required)

**Documentation Quality Score: 70/100**

**Recommendations:**
1. Add comments explaining optimization strategy
2. Update monitoring documentation
3. Consider adding troubleshooting guide

## Documentation Quality Criteria

### Content Quality
- **Clarity:** Easy to understand by target audience
- **Completeness:** Covers all necessary information
- **Accuracy:** Information is correct and up-to-date
- **Examples:** Practical examples provided
- **Structure:** Well-organized and logical flow

### Technical Quality  
- **Formatting:** Proper markdown/formatting
- **Links:** Working internal and external links
- **Images:** Relevant diagrams and screenshots
- **Code Blocks:** Properly formatted code examples
- **Versioning:** Appropriate for software version

### Maintenance Quality
- **Findability:** Easy to locate relevant documentation
- **Consistency:** Follows documentation standards
- **Currency:** Recently updated and relevant
- **Ownership:** Clear responsibility for maintenance

## Documentation Checklist by Type

### User Documentation
```markdown
## User Documentation Checklist

### Getting Started
- [ ] Prerequisites clearly stated
- [ ] Step-by-step setup instructions
- [ ] Common troubleshooting issues
- [ ] Expected outcomes described

### Feature Documentation  
- [ ] Feature purpose and benefits
- [ ] How to access the feature
- [ ] Step-by-step usage instructions
- [ ] Screenshots or examples
- [ ] Common use cases
- [ ] Limitations or constraints

### Integration Guide
- [ ] Required dependencies
- [ ] Configuration steps
- [ ] Code examples
- [ ] Error handling
- [ ] Testing instructions
```

### API Documentation
```markdown
## API Documentation Checklist

### Endpoint Documentation
- [ ] HTTP method and URL pattern
- [ ] Request parameters (query, path, body)
- [ ] Request examples
- [ ] Response format and examples
- [ ] Error responses and codes
- [ ] Authentication requirements

### Schema Documentation
- [ ] Data models defined
- [ ] Field types and constraints
- [ ] Required vs optional fields
- [ ] Validation rules
- [ ] Example data
```

### Technical Documentation
```markdown
## Technical Documentation Checklist

### Architecture
- [ ] System overview diagram
- [ ] Component relationships
- [ ] Data flow diagrams
- [ ] Technology stack
- [ ] Design decisions explained

### Configuration
- [ ] All configuration options listed
- [ ] Default values provided
- [ ] Environment-specific settings
- [ ] Security considerations
- [ ] Performance implications
```

## Integration with Code Review

### Automated Checks
- Documentation files modified when required
- Links are valid and working
- Markdown formatting is correct
- Required sections are present

### Manual Review
- Content accuracy and completeness
- Clarity for target audience
- Examples are correct and helpful
- Consistency with existing documentation

## Documentation Scoring Rubric

**Excellent (90-100 points):**
- Complete coverage of all requirements
- Clear, well-structured content
- Good examples and visuals
- Follows style guidelines

**Good (70-89 points):**
- Covers most requirements
- Generally clear content
- Some examples provided
- Minor style issues

**Acceptable (50-69 points):**
- Basic coverage of main topics
- Adequate clarity
- Limited examples
- Several style issues

**Poor (0-49 points):**
- Missing critical information
- Unclear or confusing content
- No examples provided
- Major style problems

## Error Handling

- **No Documentation Changes:** Assess if documentation should have been updated
- **Invalid Links:** Flag broken internal/external references
- **Missing Required Sections:** Identify specific gaps
- **Outdated Information:** Flag potentially stale content

---

This skill ensures documentation keeps pace with code changes, improving maintainability and team knowledge sharing.