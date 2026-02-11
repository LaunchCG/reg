#!/bin/bash
# list-link-types.sh - List all available issue link types
# Usage: ./list-link-types.sh [--output link-types.json]

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OUTPUT=""
VERBOSE=0

# Error handling function
handle_error() {
  local exit_code=$1
  local operation=$2
  local details=$3

  echo "=============================================="  >&2
  echo "ERROR: Jira List Link Types Operation Failed" >&2
  echo "=============================================="  >&2
  echo "" >&2
  echo "Operation: $operation" >&2
  echo "Exit Code: $exit_code" >&2
  echo "" >&2
  echo "Details:" >&2
  echo "$details" >&2
  echo "" >&2
  echo "Possible causes:" >&2
  echo "  - Insufficient permissions to view link types" >&2
  echo "  - Network connectivity issues" >&2
  echo "  - Authentication expired or invalid" >&2
  echo "  - Jira instance configuration issues" >&2
  echo "" >&2
  echo "Troubleshooting:" >&2
  echo "  1. Check authentication: acli jira auth status" >&2
  echo "  2. Re-authenticate if needed: source check-auth.sh" >&2
  echo "  3. Verify you have access to Jira instance" >&2
  echo "  4. Try with --verbose flag for more details" >&2
  echo "=============================================="  >&2
  exit $exit_code
}

show_help() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS]

List all available issue link types for your Jira instance.

Options:
  --output FILE          Save JSON output to file
  --verbose              Show detailed execution
  --help                 Show this help message

Examples:
  $0
  $0 --output link-types.json
  $0 --verbose

EOF
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --output) OUTPUT="$2"; shift 2 ;;
    --verbose) VERBOSE=1; shift ;;
    --help) show_help; exit 0 ;;
    *) echo "Unknown option: $1" >&2; show_help; exit 1 ;;
  esac
done

[[ $VERBOSE -eq 1 ]] && echo "Checking authentication..." >&2

# Check authentication (disable exit on error temporarily)
set +e
source "$SCRIPT_DIR/check-auth.sh"
AUTH_STATUS=$?
set -e

if [ $AUTH_STATUS -ne 0 ]; then
  handle_error $AUTH_STATUS "Authentication check" "Failed to authenticate with Atlassian CLI. See error messages above."
fi

CMD="acli jira workitem link type --json"

[[ $VERBOSE -eq 1 ]] && echo "Executing: $CMD" >&2

# Execute command and capture output and exit code
set +e
if [ -n "$OUTPUT" ]; then
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "List link types" "$RESULT"
  fi

  # Validate JSON output
  if ! echo "$RESULT" | jq empty 2>/dev/null; then
    handle_error 1 "List link types" "Invalid JSON response from acli command:
$RESULT"
  fi

  echo "$RESULT" > "$OUTPUT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Link types retrieved successfully" >&2
  [[ $VERBOSE -eq 1 ]] && echo "Results saved to: $OUTPUT" >&2
else
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "List link types" "$RESULT"
  fi

  # Validate JSON output
  if ! echo "$RESULT" | jq empty 2>/dev/null; then
    handle_error 1 "List link types" "Invalid JSON response from acli command:
$RESULT"
  fi

  echo "$RESULT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Link types retrieved successfully" >&2
fi
set -e
