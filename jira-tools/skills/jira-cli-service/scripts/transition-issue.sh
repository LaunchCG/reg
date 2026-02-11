#!/bin/bash
# transition-issue.sh - Change the status/workflow state of a Jira issue
# Usage: ./transition-issue.sh --key PROJ-123 --status "In Progress"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

KEY=""
STATUS=""
OUTPUT=""
VERBOSE=0

# Error handling function
handle_error() {
  local exit_code=$1
  local operation=$2
  local details=$3

  echo "=============================================="  >&2
  echo "ERROR: Jira Transition Issue Operation Failed" >&2
  echo "=============================================="  >&2
  echo "" >&2
  echo "Operation: $operation" >&2
  echo "Issue Key: ${KEY:-N/A}" >&2
  echo "Target Status: ${STATUS:-N/A}" >&2
  echo "Exit Code: $exit_code" >&2
  echo "" >&2
  echo "Details:" >&2
  echo "$details" >&2
  echo "" >&2
  echo "Possible causes:" >&2
  echo "  - Issue key does not exist or is invalid" >&2
  echo "  - Target status not available for current workflow state" >&2
  echo "  - Transition not allowed from current status" >&2
  echo "  - Insufficient permissions to transition issue" >&2
  echo "  - Network connectivity issues" >&2
  echo "  - Authentication expired or invalid" >&2
  echo "  - Required fields missing for transition" >&2
  echo "" >&2
  echo "Troubleshooting:" >&2
  echo "  1. Verify issue key exists: acli jira workitem view $KEY" >&2
  echo "  2. Check current status and available transitions" >&2
  echo "  3. Verify status name matches exactly (case-sensitive)" >&2
  echo "  4. Check authentication: acli jira auth status" >&2
  echo "  5. Re-authenticate if needed: source check-auth.sh" >&2
  echo "  6. Try with --verbose flag for more details" >&2
  echo "=============================================="  >&2
  exit $exit_code
}

show_help() {
  cat << EOF
Usage: $(basename "$0") --key ISSUE_KEY --status STATUS [OPTIONS]

Change the status/workflow state of a Jira issue.

Required:
  --key ISSUE_KEY        Issue key (e.g., PROJ-123)
  --status STATUS        Target status (e.g., "In Progress", "Done")

Options:
  --output FILE          Save JSON output to file
  --verbose              Show detailed execution
  --help                 Show this help message

Examples:
  $0 --key PROJ-123 --status "In Progress"
  $0 --key PROJ-123 --status "Done"
  $0 --key PROJ-123 --status "In Review" --output result.json

Common statuses: "To Do", "In Progress", "In Review", "Done"

EOF
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --key) KEY="$2"; shift 2 ;;
    --status) STATUS="$2"; shift 2 ;;
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

if [ -z "$STATUS" ]; then
  echo "ERROR: --status is required" >&2
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

CMD="acli jira workitem transition --key \"$KEY\" --status \"$STATUS\""

[[ $VERBOSE -eq 1 ]] && echo "Executing: $CMD" >&2

# Execute command and capture output and exit code
set +e
if [ -n "$OUTPUT" ]; then
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "Transition issue $KEY to status '$STATUS'" "$RESULT"
  fi

  echo "$RESULT" > "$OUTPUT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Issue transitioned successfully to '$STATUS'" >&2
  [[ $VERBOSE -eq 1 ]] && echo "Results saved to: $OUTPUT" >&2
else
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "Transition issue $KEY to status '$STATUS'" "$RESULT"
  fi

  echo "$RESULT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Issue transitioned successfully to '$STATUS'" >&2
fi
set -e
