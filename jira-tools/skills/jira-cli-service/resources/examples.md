# Jira CLI Service - Complete Examples

This document provides comprehensive examples for Jira operations using both the wrapper scripts and direct acli commands.

## Table of Contents

1. [Using Wrapper Scripts](#using-wrapper-scripts)
2. [Reading Issues](#reading-issues)
3. [Creating Issues](#creating-issues)
4. [Updating Issues](#updating-issues)
5. [Managing Comments](#managing-comments)
6. [Linking Issues](#linking-issues)
7. [Test Case Operations](#test-case-operations)
8. [Field Restrictions and Workarounds](#field-restrictions-and-workarounds)
9. [Error Handling Patterns](#error-handling-patterns)
10. [JSON Parsing with jq](#json-parsing-with-jq)
11. [Common Workflows](#common-workflows)

---

## Using Wrapper Scripts

The jira-cli-service skill provides wrapper scripts that handle authentication and error handling automatically.

### Script Basics

**Unix/macOS:**
```bash
cd plugins/ai-sdlc-enablement/skills/jira-cli-service/scripts

# Check authentication (required first)
source ./check-auth.sh

# Run any operation script
./search-issues.sh --jql "project=PROJ" --output results.json
```

**Windows PowerShell:**
```powershell
cd plugins\ai-sdlc-enablement\skills\jira-cli-service\scripts

# Check authentication (required first)
. .\check-auth.ps1

# Run any operation script
.\search-issues.ps1 -Jql "project=PROJ" -Output results.json
```

### Script Examples

#### Search Issues with Script

```bash
# Basic search
./search-issues.sh --jql "project=PROJ AND status='In Progress'"

# With specific fields
./search-issues.sh \
  --jql "project=PROJ" \
  --fields "key,summary,status" \
  --limit 50 \
  --output results.json

# Verbose mode
./search-issues.sh --jql "project=PROJ" --verbose
```

#### View Single Issue with Script

```bash
# Get issue details
./view-issue.sh PROJ-123

# Get all fields
./view-issue.sh PROJ-123 --fields "*all" --output issue.json

# Verbose mode
./view-issue.sh PROJ-123 --verbose
```

#### Create Issue with Script

```bash
# Basic story
./create-issue.sh \
  --project PROJ \
  --type Story \
  --summary "Implement user authentication" \
  --description "Add JWT-based authentication"

# Story with all fields
./create-issue.sh \
  --project PROJ \
  --type Story \
  --summary "Password reset feature" \
  --description "Add password reset via email" \
  --assignee "john.doe@company.com" \
  --priority High \
  --labels "backend,security,authentication" \
  --output new-issue.json
```

#### Manage Comments with Scripts

```bash
# List comments
./list-comments.sh --key PROJ-123

# Add comment
./add-comment.sh --key PROJ-123 --body "Ready for review"

# Add comment from file
echo "Implementation complete" > comment.txt
./add-comment.sh --key PROJ-123 --body-file comment.txt
```

#### Update Issue with Script

```bash
# Update summary
./edit-issue.sh --key PROJ-123 --summary "Updated title"

# Update multiple fields
./edit-issue.sh \
  --key PROJ-123 \
  --summary "New title" \
  --assignee "jane.smith@company.com" \
  --priority High
```

#### Transition Issue with Script

```bash
# Start work
./transition-issue.sh --key PROJ-123 --status "In Progress"

# Complete work
./transition-issue.sh --key PROJ-123 --status "Done"
```

#### Link Issues with Script

```bash
# List available link types first
./list-link-types.sh

# Create a blocker link
./link-issues.sh \
  --out PROJ-456 \
  --in PROJ-123 \
  --type "Blocks"

# Create a relates link
./link-issues.sh \
  --out PROJ-123 \
  --in PROJ-124 \
  --type "Relates"
```

---

## Reading Issues

### Get Single Issue with Full Details

**Using script:**
```bash
./view-issue.sh PROJ-123 --fields "*all"
```

**Using acli directly:**
```bash
acli jira workitem view PROJ-123 --json
```

**Output:**
```json
{
  "key": "PROJ-123",
  "fields": {
    "summary": "Implement user authentication",
    "description": "As a user, I want to log in securely so that I can access my account...",
    "status": {"name": "In Progress"},
    "priority": {"name": "High"},
    "assignee": {
      "displayName": "John Doe",
      "emailAddress": "john.doe@company.com"
    },
    "reporter": {
      "displayName": "Jane Smith",
      "emailAddress": "jane.smith@company.com"
    },
    "created": "2025-12-01T10:00:00.000Z",
    "updated": "2025-12-15T14:30:00.000Z",
    "labels": ["backend", "security"],
    "components": [{"name": "Authentication"}]
  }
}
```

### Get Multiple Issues by Keys

```bash
# Using script
./search-issues.sh --jql "key in (PROJ-123, PROJ-124, PROJ-125)"

# Using acli directly
acli jira workitem search \
  --jql "key in (PROJ-123, PROJ-124, PROJ-125)" \
  --json
```

### Get Issue Description

```bash
# Extract just the description field
acli jira workitem view PROJ-123 \
  --fields "description" \
  --json \
  | jq -r '.fields.description'
```

### Search Issues by JQL

```bash
# Get issues assigned to specific user
./search-issues.sh \
  --jql "assignee='john.doe@company.com' AND status!='Done'"

# Get issues by label
./search-issues.sh \
  --jql "project=PROJ AND labels='backend'"

# Get recent issues
./search-issues.sh \
  --jql "project=PROJ AND created >= -7d"
```

**Common JQL Patterns:**

```bash
# Recently updated issues
./search-issues.sh --jql "project=PROJ AND updated >= -7d"

# Issues without assignee
./search-issues.sh --jql "project=PROJ AND assignee IS EMPTY"

# High priority open issues
./search-issues.sh --jql "project=PROJ AND priority=High AND status!='Done'"

# Issues by sprint
./search-issues.sh --jql "sprint='Sprint 23' AND project=PROJ"

# Issues with specific labels
./search-issues.sh --jql "project=PROJ AND labels IN ('technical-debt', 'bug')"
```

---

## Creating Issues

### Create Basic Story

```bash
# Using script
./create-issue.sh \
  --project "PROJ" \
  --type "Story" \
  --summary "Implement password reset feature" \
  --description "As a user, I want to reset my password via email so that I can regain access to my account if I forget my password."
```

**Output:**
```json
{
  "key": "PROJ-789",
  "id": "10789",
  "self": "https://your-domain.atlassian.net/rest/api/3/issue/10789"
}
```

### Create Story with Full Details

```bash
# Using script with all optional parameters
./create-issue.sh \
  --project "PROJ" \
  --type "Story" \
  --summary "Add user profile editing" \
  --description "As a user, I want to edit my profile information so that I can keep my details up to date.

Acceptance Criteria:
- User can edit name, email, phone
- Changes are validated before saving
- User receives confirmation message
- Profile updates are logged" \
  --assignee "john.doe@company.com" \
  --priority "High" \
  --labels "frontend,user-management" \
  --output new-story.json
```

### Create Bug

```bash
# Using script
./create-issue.sh \
  --project "PROJ" \
  --type "Bug" \
  --summary "Login fails with special characters in password" \
  --description "Reproduction Steps:
1. Navigate to login page
2. Enter username: test@company.com
3. Enter password with special chars: P@ssw0rd!
4. Click Login button

Expected: User logs in successfully
Actual: Error message 'Invalid credentials'

Environment: Chrome 120, Windows 11" \
  --labels "bug,login" \
  --priority "High"
```

### Create Task

```bash
# Using script
./create-issue.sh \
  --project "PROJ" \
  --type "Task" \
  --summary "Update API documentation for auth endpoints" \
  --description "Update Swagger documentation to reflect new authentication flow:
- POST /auth/login
- POST /auth/logout
- POST /auth/refresh
- GET /auth/verify" \
  --assignee "jane.smith@company.com"
```

---

## Updating Issues

### Update Issue Summary

```bash
# Using script
./edit-issue.sh \
  --key "PROJ-123" \
  --summary "Implement secure user authentication with 2FA"
```

### Update Issue Description

```bash
# Using script
./edit-issue.sh \
  --key "PROJ-123" \
  --description "As a user, I want to log in securely with two-factor authentication so that my account is protected from unauthorized access.

Acceptance Criteria:
- User can enable/disable 2FA in settings
- 2FA supports authenticator apps (Google Authenticator, Authy)
- Backup codes provided for account recovery
- User is prompted for 2FA code after password entry
- Failed 2FA attempts are logged"
```

### Update Assignee

```bash
# Using script
./edit-issue.sh --key "PROJ-123" --assignee "jane.smith@company.com"

# Using acli directly
acli jira workitem edit --key "PROJ-123" --assignee "@me"
acli jira workitem edit --key "PROJ-123" --remove-assignee
```

### Update Labels

```bash
# Using script (replaces existing labels)
./edit-issue.sh \
  --key "PROJ-123" \
  --labels "backend,security,authentication,2fa"

# Using acli directly to remove labels
acli jira workitem edit \
  --key "PROJ-123" \
  --remove-labels "old-label,deprecated"
```

### Update Multiple Fields

```bash
# Using script
./edit-issue.sh \
  --key "PROJ-123" \
  --summary "Updated summary" \
  --assignee "john.doe@company.com" \
  --priority "High" \
  --labels "backend,api"
```

---

## Managing Comments

### Get All Comments

```bash
# Using script
./list-comments.sh --key PROJ-123

# With pagination
./list-comments.sh --key PROJ-123 --paginate

# With limit
./list-comments.sh --key PROJ-123 --limit 20
```

**Output:**
```json
{
  "comments": [
    {
      "id": "10001",
      "author": {
        "displayName": "John Doe",
        "emailAddress": "john.doe@company.com"
      },
      "body": {
        "content": [
          {
            "type": "paragraph",
            "content": [{"type": "text", "text": "Working on the authentication flow implementation"}]
          }
        ]
      },
      "created": "2025-12-10T09:00:00.000Z"
    }
  ]
}
```

### Add Simple Comment

```bash
# Using script
./add-comment.sh \
  --key "PROJ-123" \
  --body "Implementation completed. Ready for code review."
```

### Add Comment with Details

```bash
# Using script with multi-line comment
./add-comment.sh \
  --key "PROJ-123" \
  --body "Authentication implementation complete:
- JWT token generation and validation
- Password hashing with bcrypt
- Session management
- Rate limiting on login attempts

Next steps:
- Add unit tests
- Update API documentation
- Deploy to staging environment"
```

### Add Comment from File

```bash
# Create comment file
cat > comment.txt <<'EOF'
Code review feedback addressed:
- Fixed password validation logic
- Added input sanitization
- Improved error messages
- Added logging for security events
EOF

# Using script
./add-comment.sh --key "PROJ-123" --body-file comment.txt
```

### Get Latest Comment

```bash
# Using acli with jq
acli jira workitem comment list --key PROJ-123 --json \
  | jq -r '.comments | sort_by(.created) | last | .body.content[0].content[0].text'
```

---

## Linking Issues

### Link Story to Epic

```bash
# First, list available link types
./list-link-types.sh

# Using script to create epic link
./link-issues.sh \
  --out "PROJ-100" \
  --in "PROJ-123" \
  --type "Epic-Story Link"
```

### Create Blocker Link

```bash
# Using script: PROJ-456 blocks PROJ-123
./link-issues.sh \
  --out "PROJ-456" \
  --in "PROJ-123" \
  --type "Blocks"
```

### Create Related Link

```bash
# Using script
./link-issues.sh \
  --out "PROJ-123" \
  --in "PROJ-124" \
  --type "Relates"
```

### Create Duplicate Link

```bash
# Using script
./link-issues.sh \
  --out "PROJ-789" \
  --in "PROJ-123" \
  --type "Duplicate"
```

### Get Issue Links

```bash
# Using acli directly
acli jira workitem link list --key "PROJ-123" --json
```

**Output:**
```json
{
  "issueLinks": [
    {
      "id": "10001",
      "type": {
        "name": "Epic-Story Link",
        "inward": "is child of",
        "outward": "has child"
      },
      "outwardIssue": {
        "key": "PROJ-100",
        "fields": {
          "summary": "User Authentication Epic",
          "status": {"name": "In Progress"}
        }
      }
    }
  ]
}
```

### Get Blocked By Issues

```bash
# Using acli with jq
acli jira workitem link list --key "PROJ-123" --json \
  | jq -r '.issueLinks[] | select(.type.inward == "is blocked by") | .inwardIssue | {key, summary: .fields.summary}'
```

---

## Test Case Operations

### Create Test Case

```bash
# Using script
./create-issue.sh \
  --project "PROJ" \
  --type "Test" \
  --summary "Test: User can log in with valid credentials" \
  --description "Test Steps:
1. Navigate to login page (https://app.company.com/login)
2. Enter valid username: test@company.com
3. Enter valid password: TestPass123!
4. Click 'Login' button

Expected Result:
- User is redirected to dashboard
- User's name appears in header
- Session cookie is set

Test Data:
- Username: test@company.com
- Password: TestPass123!"
```

### Link Test to Story

```bash
# Using script
./link-issues.sh \
  --out "PROJ-TEST-456" \
  --in "PROJ-123" \
  --type "Tests"
```

### Get Test Cases for Story

```bash
# Using acli with jq
acli jira workitem link list --key "PROJ-123" --json \
  | jq -r '.issueLinks[] | select(.type.name == "Test") | .outwardIssue | {key, summary: .fields.summary, status: .fields.status.name}'
```

**Output:**
```json
{
  "key": "PROJ-TEST-456",
  "summary": "Test: User can log in with valid credentials",
  "status": "Pass"
}
```

### Update Test Case Status

```bash
# Using script
./transition-issue.sh --key "PROJ-TEST-456" --status "Pass"

# Or mark as failed
./transition-issue.sh --key "PROJ-TEST-456" --status "Fail"
```

### Add Test Execution Comment

```bash
# Using script
./add-comment.sh \
  --key "PROJ-TEST-456" \
  --body "Test Execution: PASSED

Date: 2025-12-15
Environment: Staging
Browser: Chrome 120
Tester: John Doe

Notes:
- All steps completed successfully
- Login time: 1.2 seconds
- No errors in console
- Session persists correctly"
```

---

## Field Restrictions and Workarounds

### Understanding Field Restrictions

The `search-issues.sh --fields` parameter (and `acli jira workitem search --fields`) has a **restricted whitelist**:

**✅ Allowed fields:**
- `key`
- `summary`
- `status`
- `priority`
- `assignee`
- `issuetype`

**❌ NOT allowed (will cause error):**
- `updated`
- `created`
- `description`
- `labels`
- `components`
- Custom fields
- `*all` or `*navigable`

### Workaround 1: Use view-issue for Single Issues

```bash
# ❌ This will fail
./search-issues.sh --jql "project=PROJ" --fields "key,summary,updated"

# ✅ Use view-issue for full field access
./view-issue.sh PROJ-123 --fields "*all"
```

### Workaround 2: Search for Keys, Then View Each

```bash
# Step 1: Search for issue keys
./search-issues.sh --jql "project=PROJ" --fields "key" --output keys.json

# Step 2: View each issue for full details
cat keys.json | jq -r '.[].key' | while read key; do
  ./view-issue.sh "$key" --fields "updated,created,description" --output "${key}.json"
done
```

### Workaround 3: Use JQL for Filtering, Extract Fields with jq

```bash
# Search returns default fields, extract with jq
./search-issues.sh --jql "project=PROJ AND updated >= -7d" \
  | jq -r '.[] | {key, summary: .fields.summary, status: .fields.status.name}'
```

### Workaround 4: Use CSV Output

```bash
# acli supports CSV output without field restrictions
acli jira workitem search --jql "project=PROJ" --csv > issues.csv
```

---

## Error Handling Patterns

### Pattern 1: Check for Errors in JSON Response

```bash
# Using acli directly with error checking
RESULT=$(acli jira workitem view PROJ-123 --json 2>&1)

if echo "$RESULT" | jq -e '.errorMessages' > /dev/null 2>&1; then
  echo "Error: $(echo "$RESULT" | jq -r '.errorMessages[]')"
  exit 1
fi

# Process successful result
echo "$RESULT" | jq '.'
```

### Pattern 2: Validate Issue Exists Before Operations

```bash
# Function to check if issue exists
check_issue_exists() {
  local issue_key="$1"

  RESULT=$(acli jira workitem view "$issue_key" --json 2>&1)

  if echo "$RESULT" | jq -e '.errorMessages' > /dev/null 2>&1; then
    echo "Issue $issue_key not found"
    return 1
  fi

  return 0
}

# Usage
if check_issue_exists "PROJ-123"; then
  ./add-comment.sh --key PROJ-123 --body "Issue verified"
else
  echo "Skipping non-existent issue"
fi
```

### Pattern 3: Retry on Transient Errors

```bash
# Function with retry logic
retry_command() {
  local max_attempts=3
  local attempt=1
  local delay=2

  while [ $attempt -le $max_attempts ]; do
    echo "Attempt $attempt of $max_attempts..."

    if ./search-issues.sh --jql "project=PROJ" --output results.json; then
      echo "Success!"
      return 0
    fi

    echo "Failed, retrying in ${delay}s..."
    sleep $delay
    delay=$((delay * 2))
    attempt=$((attempt + 1))
  done

  echo "All attempts failed"
  return 1
}

# Usage
retry_command
```

### Pattern 4: Validate Required Environment Variables

```bash
# Check authentication prerequisites
check_auth_vars() {
  if [ -z "$ATLASSIAN_EMAIL" ] || [ -z "$ATLASSIAN_SITE" ] || [ -z "$ATLASSIAN_TOKEN" ]; then
    echo "ERROR: Missing required environment variables"
    echo ""
    echo "Please set:"
    echo "  export ATLASSIAN_EMAIL='your-email@company.com'"
    echo "  export ATLASSIAN_SITE='your-domain.atlassian.net'"
    echo "  export ATLASSIAN_TOKEN='your-api-token'"
    return 1
  fi
  return 0
}

# Usage
if ! check_auth_vars; then
  exit 1
fi

source ./scripts/check-auth.sh
```

### Pattern 5: Log Operations to File

```bash
# Logging wrapper
log_operation() {
  local log_file="jira-operations.log"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

  echo "[$timestamp] $@" >> "$log_file"

  # Execute command and capture result
  "$@" 2>&1 | tee -a "$log_file"

  local exit_code=${PIPESTATUS[0]}
  echo "[$timestamp] Exit code: $exit_code" >> "$log_file"

  return $exit_code
}

# Usage
log_operation ./create-issue.sh --project PROJ --type Story --summary "Test"
```

---

## JSON Parsing with jq

### Extract Specific Fields

```bash
# Get just issue keys
./search-issues.sh --jql "project=PROJ" \
  | jq -r '.[].key'

# Get key and summary
./search-issues.sh --jql "project=PROJ" \
  | jq -r '.[] | {key, summary: .fields.summary}'

# Get key, summary, and status
./search-issues.sh --jql "project=PROJ" \
  | jq -r '.[] | {key, summary: .fields.summary, status: .fields.status.name}'
```

### Format as CSV

```bash
# Convert to CSV format
./search-issues.sh --jql "project=PROJ" \
  | jq -r '.[] | [.key, .fields.summary] | @csv'

# With headers
echo "Key,Summary" > issues.csv
./search-issues.sh --jql "project=PROJ" \
  | jq -r '.[] | [.key, .fields.summary] | @csv' >> issues.csv
```

### Count and Group Data

```bash
# Count issues by status
./search-issues.sh --jql "project=PROJ" \
  | jq -r '.[] | .fields.status.name' | sort | uniq -c

# Group by assignee
./search-issues.sh --jql "project=PROJ" \
  | jq -r 'group_by(.fields.assignee.emailAddress) | map({assignee: .[0].fields.assignee.emailAddress, count: length})'
```

### Filter Results

```bash
# Filter high priority issues
./search-issues.sh --jql "project=PROJ" \
  | jq '.[] | select(.fields.priority.name == "High")'

# Filter issues with specific label
./search-issues.sh --jql "project=PROJ" \
  | jq '.[] | select(.fields.labels | contains(["backend"]))'

# Filter by date
./search-issues.sh --jql "project=PROJ" \
  | jq '.[] | select(.fields.created >= "2025-12-01")'
```

### Pretty Print

```bash
# Pretty print JSON
./view-issue.sh PROJ-123 | jq '.'

# Compact output
./view-issue.sh PROJ-123 | jq -c '.'

# Colored output
./view-issue.sh PROJ-123 | jq -C '.'
```

### Extract Nested Fields

```bash
# Get assignee email
./view-issue.sh PROJ-123 \
  | jq -r '.fields.assignee.emailAddress'

# Get all labels
./view-issue.sh PROJ-123 \
  | jq -r '.fields.labels[]'

# Get comment text
./list-comments.sh --key PROJ-123 \
  | jq -r '.comments[].body.content[0].content[0].text'
```

---

## Common Workflows

### Workflow: Create Story with Tests (Using Scripts)

```bash
#!/bin/bash
# Complete workflow using wrapper scripts

cd plugins/ai-sdlc-enablement/skills/jira-cli-service/scripts

# 1. Check authentication
source ./check-auth.sh

# 2. Create the story
STORY=$(./create-issue.sh \
  --project "PROJ" \
  --type "Story" \
  --summary "User can update profile picture" \
  --description "As a user, I want to upload a profile picture so that others can recognize me." \
  --output story.json \
  | jq -r '.key')

echo "Created story: ${STORY}"

# 3. Create test case
TEST=$(./create-issue.sh \
  --project "PROJ" \
  --type "Test" \
  --summary "Test: User can upload profile picture" \
  --description "Test steps for profile picture upload" \
  --output test.json \
  | jq -r '.key')

echo "Created test: ${TEST}"

# 4. Link test to story
./link-issues.sh \
  --out "${TEST}" \
  --in "${STORY}" \
  --type "Tests"

echo "Linked ${TEST} to ${STORY}"
```

### Workflow: Clone Issue with Comments

```bash
#!/bin/bash
# Clone issue and copy comments

SOURCE_ISSUE="PROJ-123"

# 1. Get source issue
SOURCE=$(./view-issue.sh "${SOURCE_ISSUE}" --fields "*all")

# 2. Create new issue with same content
NEW_ISSUE=$(./create-issue.sh \
  --project "PROJ" \
  --type "Story" \
  --summary "$(echo "$SOURCE" | jq -r '.fields.summary')" \
  --description "$(echo "$SOURCE" | jq -r '.fields.description')" \
  | jq -r '.key')

echo "Cloned ${SOURCE_ISSUE} to ${NEW_ISSUE}"

# 3. Copy comments
./list-comments.sh --key "${SOURCE_ISSUE}" \
  | jq -r '.comments[].body.content[0].content[0].text' \
  | while read -r comment; do
      ./add-comment.sh \
        --key "${NEW_ISSUE}" \
        --body "[Copied from ${SOURCE_ISSUE}] ${comment}"
    done

echo "Copied comments to ${NEW_ISSUE}"
```

### Workflow: Create Epic with Stories

```bash
#!/bin/bash
# Create epic and add stories using scripts

# 1. Create epic
EPIC=$(./create-issue.sh \
  --project "PROJ" \
  --type "Epic" \
  --summary "User Profile Management" \
  --description "Complete user profile management functionality" \
  | jq -r '.key')

echo "Created epic: ${EPIC}"

# 2. Create stories and link to epic
STORIES=(
  "User can view profile"
  "User can edit profile"
  "User can upload profile picture"
  "User can change password"
)

for story_summary in "${STORIES[@]}"; do
  STORY=$(./create-issue.sh \
    --project "PROJ" \
    --type "Story" \
    --summary "${story_summary}" \
    --description "Story description..." \
    | jq -r '.key')

  ./link-issues.sh \
    --out "${EPIC}" \
    --in "${STORY}" \
    --type "Epic-Story Link"

  echo "Created and linked: ${STORY}"
done
```

### Workflow: Bulk Transition Issues

```bash
#!/bin/bash
# Move all issues in "In Review" to "Done"

# Get issues to transition
./search-issues.sh \
  --jql "project=PROJ AND status='In Review'" \
  | jq -r '.[].key' \
  | while read -r issue; do
      echo "Transitioning ${issue} to Done..."
      ./transition-issue.sh --key "$issue" --status "Done"
    done

echo "All issues transitioned"
```

### Workflow: Add Comment to Sprint Issues

```bash
#!/bin/bash
# Add comment to all issues in active sprint

COMMENT="Sprint review scheduled for Friday 2pm"

./search-issues.sh \
  --jql "sprint in openSprints() AND project=PROJ" \
  | jq -r '.[].key' \
  | while read -r issue; do
      ./add-comment.sh --key "$issue" --body "$COMMENT"
      echo "Added comment to ${issue}"
    done
```

### Workflow: Daily Status Report

```bash
#!/bin/bash
# Generate daily status report

REPORT_DATE=$(date '+%Y-%m-%d')
REPORT_FILE="status-report-${REPORT_DATE}.md"

cat > "$REPORT_FILE" <<EOF
# Jira Status Report - ${REPORT_DATE}

## In Progress Issues
EOF

./search-issues.sh --jql "project=PROJ AND status='In Progress'" \
  | jq -r '.[] | "- \(.key): \(.fields.summary) (Assignee: \(.fields.assignee.displayName))"' \
  >> "$REPORT_FILE"

cat >> "$REPORT_FILE" <<EOF

## Completed Today
EOF

./search-issues.sh --jql "project=PROJ AND status='Done' AND updated >= -1d" \
  | jq -r '.[] | "- \(.key): \(.fields.summary)"' \
  >> "$REPORT_FILE"

echo "Report generated: ${REPORT_FILE}"
```

---

## Additional Tips

### Using JQL Effectively

```bash
# Complex JQL queries
./search-issues.sh \
  --jql "project=PROJ AND status='In Progress' AND assignee='@me' AND labels='high-priority'"

# Date range queries
./search-issues.sh \
  --jql "project=PROJ AND created >= '2025-12-01' AND created <= '2025-12-31'"

# NULL checks
./search-issues.sh \
  --jql "project=PROJ AND assignee IS EMPTY"

# Sprint queries
./search-issues.sh \
  --jql "sprint in openSprints() AND project=PROJ"

# Text search
./search-issues.sh \
  --jql "project=PROJ AND text ~ 'authentication'"
```

### Performance Tips

```bash
# Limit results for faster queries
./search-issues.sh --jql "project=PROJ" --limit 50

# Select only needed fields (within whitelist)
./search-issues.sh \
  --jql "project=PROJ" \
  --fields "key,summary,status"

# Use pagination for large result sets
./search-issues.sh --jql "project=PROJ" --paginate
```

### Debugging Scripts

```bash
# Use verbose mode
./search-issues.sh --jql "project=PROJ" --verbose

# Check authentication status
source ./check-auth.sh

# View script help
./search-issues.sh --help
./create-issue.sh --help
./edit-issue.sh --help
```

---

For more information, see:
- **[SKILL.md](SKILL.md)** - Quick reference and execution workflow
- **[scripts/README.md](scripts/README.md)** - Detailed script documentation
- **[REFERENCE.md](REFERENCE.md)** - Installation, setup, and troubleshooting
