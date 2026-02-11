#!/bin/bash
# search-issues.sh - Search for Jira issues using JQL
# Usage: ./search-issues.sh --jql "project=PROJ" [--fields key,summary] [--limit 50] [--output file.json]

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
JQL=""
FIELDS=""
LIMIT=""
OUTPUT=""
VERBOSE=0

# Error handling function
handle_error() {
  local exit_code=$1
  local operation=$2
  local details=$3

  echo "=============================================="  >&2
  echo "ERROR: Jira Search Issues Operation Failed" >&2
  echo "=============================================="  >&2
  echo "" >&2
  echo "Operation: $operation" >&2
  echo "JQL Query: ${JQL:-N/A}" >&2
  echo "Exit Code: $exit_code" >&2
  echo "" >&2
  echo "Details:" >&2
  echo "$details" >&2
  echo "" >&2
  echo "Possible causes:" >&2
  echo "  - Invalid JQL syntax" >&2
  echo "  - Disallowed field names in --fields parameter" >&2
  echo "  - Insufficient permissions to search project" >&2
  echo "  - Network connectivity issues" >&2
  echo "  - Authentication expired or invalid" >&2
  echo "" >&2
  echo "Allowed fields:" >&2
  echo "  key, summary, status, priority, assignee, issuetype" >&2
  echo "" >&2
  echo "Troubleshooting:" >&2
  echo "  1. Validate JQL syntax at your Jira instance" >&2
  echo "  2. Check authentication: acli jira auth status" >&2
  echo "  3. Re-authenticate if needed: source check-auth.sh" >&2
  echo "  4. Verify field names are allowed (see above)" >&2
  echo "  5. Try with --verbose flag for more details" >&2
  echo "=============================================="  >&2
  exit $exit_code
}

# Help text
show_help() {
  cat << EOF
Usage: $(basename "$0") --jql "JQL_QUERY" [OPTIONS]

Search for Jira issues using JQL.

Required:
  --jql JQL_QUERY        JQL query string

Options:
  --fields FIELDS        Comma-separated field list (restricted, see below)
  --limit NUMBER         Maximum number of results
  --output FILE          Save JSON output to file
  --verbose              Show detailed execution
  --help                 Show this help message

Field Restrictions:
  Allowed: key, summary, status, priority, assignee, issuetype
  NOT allowed: updated, created, description, labels, components, custom fields
  Workaround: Use view-issue.sh for full field access on single issues

Examples:
  $0 --jql "project=PROJ AND status='In Progress'"
  $0 --jql "assignee=currentUser()" --fields "key,summary,status"
  $0 --jql "project=PROJ" --limit 50 --output issues.json

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --jql)
      JQL="$2"
      shift 2
      ;;
    --fields)
      FIELDS="$2"
      shift 2
      ;;
    --limit)
      LIMIT="$2"
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
    *)
      echo "Unknown option: $1" >&2
      show_help
      exit 1
      ;;
  esac
done

# Validate required arguments
if [ -z "$JQL" ]; then
  echo "ERROR: --jql is required" >&2
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
CMD="acli jira workitem search --jql \"$JQL\" --json"

if [ -n "$FIELDS" ]; then
  CMD="$CMD --fields \"$FIELDS\""
fi

if [ -n "$LIMIT" ]; then
  CMD="$CMD --limit $LIMIT"
fi

# Execute command
[[ $VERBOSE -eq 1 ]] && echo "Executing: $CMD" >&2

# Execute command and capture output and exit code
set +e
if [ -n "$OUTPUT" ]; then
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "Search issues with JQL: $JQL" "$RESULT"
  fi

  # Validate JSON output
  if ! echo "$RESULT" | jq empty 2>/dev/null; then
    handle_error 1 "Search issues with JQL: $JQL" "Invalid JSON response from acli command:
$RESULT"
  fi

  echo "$RESULT" > "$OUTPUT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Search completed successfully" >&2
  [[ $VERBOSE -eq 1 ]] && echo "Results saved to: $OUTPUT" >&2
else
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "Search issues with JQL: $JQL" "$RESULT"
  fi

  # Validate JSON output
  if ! echo "$RESULT" | jq empty 2>/dev/null; then
    handle_error 1 "Search issues with JQL: $JQL" "Invalid JSON response from acli command:
$RESULT"
  fi

  echo "$RESULT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Search completed successfully" >&2
fi
set -e
