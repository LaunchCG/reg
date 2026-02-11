#!/bin/bash
# view-issue.sh - Get detailed information for a single Jira issue
# Usage: ./view-issue.sh PROJ-123 [--fields "*all"] [--output issue.json]

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
ISSUE_KEY=""
FIELDS=""
OUTPUT=""
VERBOSE=0

# Error handling function
handle_error() {
  local exit_code=$1
  local operation=$2
  local details=$3

  echo "=============================================="  >&2
  echo "ERROR: Jira View Issue Operation Failed" >&2
  echo "=============================================="  >&2
  echo "" >&2
  echo "Operation: $operation" >&2
  echo "Issue Key: ${ISSUE_KEY:-N/A}" >&2
  echo "Exit Code: $exit_code" >&2
  echo "" >&2
  echo "Details:" >&2
  echo "$details" >&2
  echo "" >&2
  echo "Possible causes:" >&2
  echo "  - Issue key does not exist or is invalid" >&2
  echo "  - Insufficient permissions to view issue" >&2
  echo "  - Network connectivity issues" >&2
  echo "  - Authentication expired or invalid" >&2
  echo "  - Invalid field names specified" >&2
  echo "" >&2
  echo "Troubleshooting:" >&2
  echo "  1. Verify issue key format (e.g., PROJ-123)" >&2
  echo "  2. Check authentication: acli jira auth status" >&2
  echo "  3. Re-authenticate if needed: source check-auth.sh" >&2
  echo "  4. Try with --verbose flag for more details" >&2
  echo "=============================================="  >&2
  exit $exit_code
}

# Help text
show_help() {
  cat << EOF
Usage: $(basename "$0") ISSUE_KEY [OPTIONS]

Get detailed information for a single Jira issue.

Required:
  ISSUE_KEY              Issue key (e.g., PROJ-123)

Options:
  --fields FIELDS        Comma-separated field list or "*all"
  --output FILE          Save JSON output to file
  --verbose              Show detailed execution
  --help                 Show this help message

Examples:
  $0 PROJ-123
  $0 PROJ-123 --fields "*all"
  $0 PROJ-123 --fields "summary,description,status,assignee"
  $0 PROJ-123 --output issue.json

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --fields)
      FIELDS="$2"
      shift 2
      ;;
    --output)
      OUTPUT="$2"
      shift 2
      ;;
    --verbose)
      VERBOSE=1
      shift
      ;;
    --help)
      show_help
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      show_help
      exit 1
      ;;
    *)
      if [ -z "$ISSUE_KEY" ]; then
        ISSUE_KEY="$1"
      else
        echo "Unexpected argument: $1" >&2
        show_help
        exit 1
      fi
      shift
      ;;
  esac
done

# Validate required arguments
if [ -z "$ISSUE_KEY" ]; then
  echo "ERROR: ISSUE_KEY is required" >&2
  show_help
  exit 1
fi

# Check authentication
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
CMD="acli jira workitem view $ISSUE_KEY --json"

if [ -n "$FIELDS" ]; then
  CMD="$CMD --fields \"$FIELDS\""
fi

# Execute command
[[ $VERBOSE -eq 1 ]] && echo "Executing: $CMD" >&2

# Execute command and capture output and exit code
set +e
if [ -n "$OUTPUT" ]; then
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "View issue $ISSUE_KEY" "$RESULT"
  fi

  # Validate JSON output
  if ! echo "$RESULT" | jq empty 2>/dev/null; then
    handle_error 1 "View issue $ISSUE_KEY" "Invalid JSON response from acli command:
$RESULT"
  fi

  echo "$RESULT" > "$OUTPUT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Issue retrieved successfully" >&2
  [[ $VERBOSE -eq 1 ]] && echo "Results saved to: $OUTPUT" >&2
else
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "View issue $ISSUE_KEY" "$RESULT"
  fi

  # Validate JSON output
  if ! echo "$RESULT" | jq empty 2>/dev/null; then
    handle_error 1 "View issue $ISSUE_KEY" "Invalid JSON response from acli command:
$RESULT"
  fi

  echo "$RESULT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Issue retrieved successfully" >&2
fi
set -e
