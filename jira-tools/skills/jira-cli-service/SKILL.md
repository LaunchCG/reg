---
name: jira-cli-service
description: Jira service layer using Atlassian CLI (acli) wrapper scripts for reliable local execution
allowed-tools: Bash
---

# Jira CLI Service Skill

Wrapper scripts for Atlassian CLI (acli) operations with automatic authentication and error handling.

## When This Skill is Invoked

**PRIMARY JIRA SERVICE:** This is the default and recommended Jira integration skill.

Claude will use this skill when:
- **ANY Jira operation is needed** (search issues, create stories, add comments, etc.)
- Other skills need Jira access (velocity-tracker, story-build, dora-metrics-calculator, etc.)
- "use acli" or "atlassian cli" is explicitly mentioned
- "fetch jira issues", "search jira", "create jira issue"
- Reliable local execution without MCP dependency is required

---

## 🎯 SKILL INVOCATION FORMAT

**When invoked using the Skill tool with args parameter:**

### Args Format
```
args="<operation> <parameters>"
```

### Supported Operations

| Args Pattern | Executes | Returns |
|--------------|----------|---------|
| `view <key>` | `./view-issue.sh <key>` | Full issue JSON |
| `search <jql>` | `./search-issues.sh --jql "<jql>"` | Array of issues |
| `create <params>` | `./create-issue.sh <params>` | New issue JSON |
| `comment <key> <text>` | `./add-comment.sh --key <key> --body "<text>"` | Comment JSON |
| `update <key> <params>` | `./edit-issue.sh --key <key> <params>` | Updated issue JSON |
| `transition <key> <status>` | `./transition-issue.sh --key <key> --status "<status>"` | Status JSON |

### Examples

**Fetch single issue:**
```
Skill tool:
  skill: "jira-cli-service"
  args: "view HUN-155"

Executes: ./view-issue.sh HUN-155
Returns: Full issue JSON with all fields
```

**Search issues:**
```
Skill tool:
  skill: "jira-cli-service"
  args: "search project=PROJ AND status=Open"

Executes: ./search-issues.sh --jql "project=PROJ AND status=Open"
Returns: Array of matching issues
```

**Add comment:**
```
Skill tool:
  skill: "jira-cli-service"
  args: "comment HUN-155 Story validation complete"

Executes: ./add-comment.sh --key HUN-155 --body "Story validation complete"
Returns: Comment JSON
```

---

## 🚨 EXECUTION WORKFLOW

**When invoked with args parameter:**

### Parse Args and Execute Script

1. **Parse the args** to determine operation and parameters
2. **Map to bash script** using the table above
3. **Execute the script** using Bash tool
4. **Return the JSON output** directly

**Example for `args="view HUN-155"`:**
```bash
# Navigate to script directory
cd plugins/ai-sdlc/skills/jira-cli-service/scripts

# Execute view-issue.sh (check-auth runs automatically inside the script)
./view-issue.sh HUN-155
```

**Example for `args="comment HUN-155 Story looks good"`:**
```bash
cd plugins/ai-sdlc/skills/jira-cli-service/scripts
./add-comment.sh --key HUN-155 --body "Story looks good"
```

### Important Notes

- **Authentication is automatic**: All scripts source `check-auth.sh` internally
- **Output is JSON**: Scripts return JSON directly, ready to parse
- **Errors are handled**: Scripts show clear error messages if something fails
- **No need to check auth first**: Scripts do it themselves

### Step-by-Step Flow

1. Skill receives args (e.g., "view HUN-155")
2. Parse operation ("view") and parameters ("HUN-155")
3. Use Bash tool to execute: `./view-issue.sh HUN-155`
4. Script checks authentication automatically
5. Script queries Jira via acli
6. Script returns JSON or error message
7. Return result (success or error) to invoker

### Error Handling

**CRITICAL: Always check bash command exit status and return errors to the agent.**

When a script fails (authentication, network, invalid key, etc.), the Bash tool will return:
- **Exit code**: Non-zero (usually 1)
- **stderr output**: Error message with troubleshooting steps

**You MUST return the error message to the invoking agent/command so the user can be notified.**

**Example - Missing Environment Variables:**
```bash
cd plugins/ai-sdlc/skills/jira-cli-service/scripts
./view-issue.sh HUN-155

# Returns to stderr:
==============================================
ERROR: Atlassian CLI Authentication Required
==============================================

The Atlassian CLI (acli) is not authenticated and required
environment variables are not set.

Please set these environment variables and try again:

  export ATLASSIAN_EMAIL="your-email@company.com"
  export ATLASSIAN_SITE="your-domain.atlassian.net"
  export ATLASSIAN_TOKEN="your-api-token"

To generate an API token:
  1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
  2. Click 'Create API token'
  3. Copy the token and set it as ATLASSIAN_TOKEN

For GitHub Actions, add these as repository secrets:
  Settings → Secrets and variables → Actions → New repository secret

After setting these variables, run the command again.
==============================================

# Exit code: 1
```

**Your response to agent:**
```
ERROR: Unable to fetch HUN-155 from Jira.

The jira-cli-service skill failed with the following error:

[paste the error message above]

Please ensure the required environment variables are set:
- ATLASSIAN_EMAIL
- ATLASSIAN_SITE
- ATLASSIAN_TOKEN

The user needs to configure these before trying again.
```

**Example - Invalid Issue Key:**
```bash
./view-issue.sh INVALID-999

# Returns:
ERROR: Issue INVALID-999 not found
# Exit code: 1
```

**Your response to agent:**
```
ERROR: Story INVALID-999 not found in Jira.

Please verify the issue key is correct and try again.
```

**Common Error Scenarios:**
1. **Missing environment variables** → Clear setup instructions (shown above)
2. **Invalid issue key** → Notify user to verify the key
3. **Network errors** → Suggest checking connectivity
4. **Permission errors** → Verify API token has correct permissions
5. **acli not installed** → Provide installation command

**DO NOT:**
- Silently fail and continue without data
- Attempt to fetch data another way
- Make up placeholder data

**DO:**
- Return the full error message to the agent
- Let the agent communicate the error to the user
- Include actionable troubleshooting steps

---

## 📜 SCRIPTS REFERENCE

All scripts are in `scripts/` directory with bash (.sh) and PowerShell (.ps1) versions.

| Script | Usage | Description |
|--------|-------|-------------|
| `check-auth` | `source check-auth.sh` | Check/login authentication |
| `search-issues` | `./search-issues.sh --jql "project=PROJ"` | Search issues with JQL |
| `view-issue` | `./view-issue.sh PROJ-123` | Get single issue details |
| `list-comments` | `./list-comments.sh --key PROJ-123` | List issue comments |
| `add-comment` | `./add-comment.sh --key PROJ-123 --body "text"` | Add comment to issue |
| `create-issue` | `./create-issue.sh --project PROJ --type Story --summary "..."` | Create new issue |
| `edit-issue` | `./edit-issue.sh --key PROJ-123 --summary "..."` | Update issue fields |
| `transition-issue` | `./transition-issue.sh --key PROJ-123 --status "Done"` | Change issue status |
| `link-issues` | `./link-issues.sh --out PROJ-123 --in PROJ-456 --type "Blocks"` | Link two issues |
| `list-link-types` | `./list-link-types.sh` | List available link types |

**Common Flags (all scripts):**
- `--help` - Show usage and examples
- `--output FILE` - Save JSON to file
- `--verbose` - Show detailed execution

**Script Location:**
- Bash: `plugins/ai-sdlc-enablement/skills/jira-cli-service/scripts/*.sh`
- PowerShell: `plugins/ai-sdlc-enablement/skills/jira-cli-service/scripts/*.ps1`

**See [scripts/README.md](scripts/README.md) for detailed usage and parameter documentation.**

---

## ⚠️ CRITICAL: Field Restrictions

When using `search-issues.sh --fields`, **only these fields are allowed**:

**✅ Allowed fields:**
- `key`
- `summary`
- `status`
- `priority`
- `assignee`
- `issuetype`

**❌ NOT allowed (will cause error):**
- `updated`, `created`, `description`, `labels`, `components`
- Custom fields
- `*all` or `*navigable`

**Workaround:** Use `view-issue.sh` for full field access on single issues.

**Example:**
```bash
# ❌ This will fail
./search-issues.sh --jql "project=PROJ" --fields "key,summary,updated"

# ✅ Use this instead
./search-issues.sh --jql "project=PROJ" --fields "key,summary"

# ✅ Or for full fields on one issue
./view-issue.sh PROJ-123 --fields "*all"
```

---

## Prerequisites

**CRITICAL: acli must be installed before using this skill.**

**Quick Check:**
```bash
acli --version
# Expected: acli version 1.3.8 or higher
```

**If not installed:** See [REFERENCE.md](REFERENCE.md) for installation instructions.

---

## Environment Variables

**Required for auto-authentication:**

**Unix/macOS:**
```bash
export ATLASSIAN_EMAIL="your-email@company.com"
export ATLASSIAN_SITE="your-domain.atlassian.net"
export ATLASSIAN_TOKEN="your-api-token"
```

**Windows PowerShell:**
```powershell
$env:ATLASSIAN_EMAIL="your-email@company.com"
$env:ATLASSIAN_SITE="your-domain.atlassian.net"
$env:ATLASSIAN_TOKEN="your-api-token"
```

**Generate API token:**
1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Click "Create API token"
3. Copy the token and set as `ATLASSIAN_TOKEN`

**See [REFERENCE.md](REFERENCE.md) for persistent setup.**

---

## Data Quality Tracking

Always report data quality metrics when using this skill:

```markdown
### Data Quality
- **Backend:** Atlassian CLI (acli)
- **Script Used:** search-issues.sh
- **Issues Retrieved:** 15
- **Query:** project=PROJ AND status='In Progress'
- **Completeness:** 100%
- **Confidence:** HIGH
```

---

## Integration with Other Skills

This skill can be invoked by:
- `story-build` - For creating/updating stories
- `velocity-tracker` - For fetching sprint data
- `jira-story-analyzer` - For analyzing story quality
- `dora-metrics-calculator` - For deployment tracking

---

## 📚 Additional Resources

- **[scripts/README.md](scripts/README.md)** - Detailed script usage, parameters, and examples
- **[EXAMPLES.md](EXAMPLES.md)** - Complete workflows, JQL patterns, error handling
- **[REFERENCE.md](REFERENCE.md)** - Installation, setup, troubleshooting, best practices
- **[Atlassian CLI Docs](https://developer.atlassian.com/cloud/acli/)** - Official acli documentation

---

This skill provides wrapper scripts for reliable Jira operations via acli with automatic authentication and error handling.
