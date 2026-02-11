#!/bin/bash
# edit-issue.sh - Update fields on an existing Jira issue
# Usage: ./edit-issue.sh --key PROJ-123 --summary "New title" [--assignee email] [--priority High]

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

KEY=""
SUMMARY=""
DESCRIPTION=""
ASSIGNEE=""
PRIORITY=""
LABELS=""
OUTPUT=""
VERBOSE=0

# Error handling function
handle_error() {
  local exit_code=$1
  local operation=$2
  local details=$3

  echo "=============================================="  >&2
  echo "ERROR: Jira Edit Issue Operation Failed" >&2
  echo "=============================================="  >&2
  echo "" >&2
  echo "Operation: $operation" >&2
  echo "Issue Key: ${KEY:-N/A}" >&2
  echo "Exit Code: $exit_code" >&2
  echo "" >&2
  echo "Details:" >&2
  echo "$details" >&2
  echo "" >&2
  echo "Possible causes:" >&2
  echo "  - Issue key does not exist or is invalid" >&2
  echo "  - Insufficient permissions to edit issue" >&2
  echo "  - Network connectivity issues" >&2
  echo "  - Authentication expired or invalid" >&2
  echo "  - Invalid field values provided" >&2
  echo "  - Required fields missing for issue type" >&2
  echo "" >&2
  echo "Troubleshooting:" >&2
  echo "  1. Verify issue key exists: acli jira workitem view $KEY" >&2
  echo "  2. Check authentication: acli jira auth status" >&2
  echo "  3. Re-authenticate if needed: source check-auth.sh" >&2
  echo "  4. Verify field values are valid for this issue type" >&2
  echo "  5. Try with --verbose flag for more details" >&2
  echo "=============================================="  >&2
  exit $exit_code
}

show_help() {
  cat << EOF
Usage: $(basename "$0") --key ISSUE_KEY [OPTIONS]

Update fields on an existing Jira issue.

Required:
  --key ISSUE_KEY        Issue key (e.g., PROJ-123)

Options (at least one required):
  --summary TEXT         New summary/title
  --description TEXT     New description
  --assignee EMAIL       New assignee email address
  --priority PRIORITY    New priority (High, Medium, Low)
  --labels LABELS        Comma-separated labels (replaces existing)
  --output FILE          Save JSON output to file
  --verbose              Show detailed execution
  --help                 Show this help message

Examples:
  $0 --key PROJ-123 --summary "Updated title"
  $0 --key PROJ-123 --assignee "user@example.com" --priority "High"
  $0 --key PROJ-123 --labels "backend,security,authentication"

EOF
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --key) KEY="$2"; shift 2 ;;
    --summary) SUMMARY="$2"; shift 2 ;;
    --description) DESCRIPTION="$2"; shift 2 ;;
    --assignee) ASSIGNEE="$2"; shift 2 ;;
    --priority) PRIORITY="$2"; shift 2 ;;
    --labels) LABELS="$2"; shift 2 ;;
    --output) OUTPUT="$2"; shift 2 ;;
    --verbose) VERBOSE=1; shift ;;
    --help) show_help; exit 0 ;;
    *) echo "Unknown option: $1" >&2; show_help; exit 1 ;;
  esac
done

if [ -z "$KEY" ]; then
  echo "ERROR: --key is required" >&2
  show_help
  exit 1
fi

if [ -z "$SUMMARY" ] && [ -z "$DESCRIPTION" ] && [ -z "$ASSIGNEE" ] && [ -z "$PRIORITY" ] && [ -z "$LABELS" ]; then
  echo "ERROR: At least one field to update is required" >&2
  show_help
  exit 1
fi

[[ $VERBOSE -eq 1 ]] && echo "Checking authentication..." >&2

# Check authentication (disable exit on error temporarily)
set +e
source "$SCRIPT_DIR/check-auth.sh"
AUTH_STATUS=$?
set -e

if [ $AUTH_STATUS -ne 0 ]; then
  handle_error $AUTH_STATUS "Authentication check" "Failed to authenticate with Atlassian CLI. See error messages above."
fi

CMD="acli jira workitem edit --key \"$KEY\""
[ -n "$SUMMARY" ] && CMD="$CMD --summary \"$SUMMARY\""
[ -n "$DESCRIPTION" ] && CMD="$CMD --description \"$DESCRIPTION\""
[ -n "$ASSIGNEE" ] && CMD="$CMD --assignee \"$ASSIGNEE\""
[ -n "$PRIORITY" ] && CMD="$CMD --priority \"$PRIORITY\""
[ -n "$LABELS" ] && CMD="$CMD --labels \"$LABELS\""

[[ $VERBOSE -eq 1 ]] && echo "Executing: $CMD" >&2

# Execute command and capture output and exit code
set +e
if [ -n "$OUTPUT" ]; then
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "Edit issue $KEY" "$RESULT"
  fi

  echo "$RESULT" > "$OUTPUT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Issue updated successfully" >&2
  [[ $VERBOSE -eq 1 ]] && echo "Results saved to: $OUTPUT" >&2
else
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "Edit issue $KEY" "$RESULT"
  fi

  echo "$RESULT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Issue updated successfully" >&2
fi
set -e
