#!/bin/bash
# add-comment.sh - Add a comment to a Jira issue
# Usage: ./add-comment.sh --key PROJ-123 --body "Comment text" OR --body-file comment.txt

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

KEY=""
BODY=""
BODY_FILE=""
OUTPUT=""
VERBOSE=0

# Error handling function
handle_error() {
  local exit_code=$1
  local operation=$2
  local details=$3

  echo "=============================================="  >&2
  echo "ERROR: Jira Comment Operation Failed" >&2
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
  echo "  - Insufficient permissions to add comments" >&2
  echo "  - Network connectivity issues" >&2
  echo "  - Authentication expired or invalid" >&2
  echo "  - Comment body contains invalid characters" >&2
  echo "" >&2
  echo "Troubleshooting:" >&2
  echo "  1. Verify issue key exists: acli jira workitem view $KEY" >&2
  echo "  2. Check authentication: acli jira auth status" >&2
  echo "  3. Re-authenticate if needed: source check-auth.sh" >&2
  echo "  4. Try with --verbose flag for more details" >&2
  echo "=============================================="  >&2
  exit $exit_code
}

show_help() {
  cat << EOF
Usage: $(basename "$0") --key ISSUE_KEY (--body TEXT | --body-file FILE) [OPTIONS]

Add a comment to a Jira issue.

Required:
  --key ISSUE_KEY        Issue key (e.g., PROJ-123)
  --body TEXT            Comment text (required if no --body-file)
  --body-file FILE       File containing comment text (required if no --body)

Options:
  --output FILE          Save JSON output to file
  --verbose              Show detailed execution
  --help                 Show this help message

Examples:
  $0 --key PROJ-123 --body "Ready for review"
  $0 --key PROJ-123 --body-file comment.txt
  $0 --key PROJ-123 --body "Looks good" --output result.json

EOF
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --key) KEY="$2"; shift 2 ;;
    --body) BODY="$2"; shift 2 ;;
    --body-file) BODY_FILE="$2"; shift 2 ;;
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

if [ -z "$BODY" ] && [ -z "$BODY_FILE" ]; then
  echo "ERROR: Either --body or --body-file is required" >&2
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

# Build command
if [ -n "$BODY" ]; then
  CMD="acli jira workitem comment create --key \"$KEY\" --body \"$BODY\" --json"
else
  CMD="acli jira workitem comment create --key \"$KEY\" --body-file \"$BODY_FILE\" --json"
fi

[[ $VERBOSE -eq 1 ]] && echo "Executing: $CMD" >&2

# Execute command and capture output and exit code
set +e
if [ -n "$OUTPUT" ]; then
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "Add comment to issue $KEY" "$RESULT"
  fi

  # Validate JSON output
  if ! echo "$RESULT" | jq empty 2>/dev/null; then
    handle_error 1 "Add comment to issue $KEY" "Invalid JSON response from acli command:
$RESULT"
  fi

  echo "$RESULT" > "$OUTPUT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Comment added successfully" >&2
  [[ $VERBOSE -eq 1 ]] && echo "Results saved to: $OUTPUT" >&2
else
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "Add comment to issue $KEY" "$RESULT"
  fi

  # Validate JSON output
  if ! echo "$RESULT" | jq empty 2>/dev/null; then
    handle_error 1 "Add comment to issue $KEY" "Invalid JSON response from acli command:
$RESULT"
  fi

  echo "$RESULT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Comment added successfully" >&2
fi
set -e
