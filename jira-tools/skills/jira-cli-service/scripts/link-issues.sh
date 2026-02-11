#!/bin/bash
# link-issues.sh - Create a link between two Jira issues
# Usage: ./link-issues.sh --out PROJ-123 --in PROJ-456 --type "Blocks"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OUT=""
IN=""
TYPE=""
OUTPUT=""
VERBOSE=0

# Error handling function
handle_error() {
  local exit_code=$1
  local operation=$2
  local details=$3

  echo "=============================================="  >&2
  echo "ERROR: Jira Link Issues Operation Failed" >&2
  echo "=============================================="  >&2
  echo "" >&2
  echo "Operation: $operation" >&2
  echo "Outward Issue: ${OUT:-N/A}" >&2
  echo "Inward Issue: ${IN:-N/A}" >&2
  echo "Link Type: ${TYPE:-N/A}" >&2
  echo "Exit Code: $exit_code" >&2
  echo "" >&2
  echo "Details:" >&2
  echo "$details" >&2
  echo "" >&2
  echo "Possible causes:" >&2
  echo "  - One or both issue keys do not exist" >&2
  echo "  - Invalid link type specified" >&2
  echo "  - Link already exists between these issues" >&2
  echo "  - Insufficient permissions to link issues" >&2
  echo "  - Network connectivity issues" >&2
  echo "  - Authentication expired or invalid" >&2
  echo "" >&2
  echo "Troubleshooting:" >&2
  echo "  1. Verify both issue keys exist" >&2
  echo "  2. List available link types: ./list-link-types.sh" >&2
  echo "  3. Check authentication: acli jira auth status" >&2
  echo "  4. Re-authenticate if needed: source check-auth.sh" >&2
  echo "  5. Try with --verbose flag for more details" >&2
  echo "=============================================="  >&2
  exit $exit_code
}

show_help() {
  cat << EOF
Usage: $(basename "$0") --out ISSUE_KEY --in ISSUE_KEY --type LINK_TYPE [OPTIONS]

Create a link between two Jira issues.

Required:
  --out ISSUE_KEY        Outward issue key (e.g., PROJ-123)
  --in ISSUE_KEY         Inward issue key (e.g., PROJ-456)
  --type LINK_TYPE       Link type (Blocks, Relates, Duplicate, Causes, etc.)

Options:
  --output FILE          Save JSON output to file
  --verbose              Show detailed execution
  --help                 Show this help message

Common Link Types:
  Blocks      - Outward issue blocks inward issue
  Relates     - General relationship
  Duplicate   - Mark as duplicate
  Causes      - Issue causes another issue (for bugs)

Examples:
  $0 --out PROJ-123 --in PROJ-456 --type "Blocks"
  $0 --out PROJ-100 --in PROJ-123 --type "Relates"
  $0 --out PROJ-123 --in PROJ-124 --type "Duplicate" --output result.json

To see all available link types, use: ./list-link-types.sh

EOF
}

while [[ $# -gt 0 ]]; do
  case $1 in
    --out) OUT="$2"; shift 2 ;;
    --in) IN="$2"; shift 2 ;;
    --type) TYPE="$2"; shift 2 ;;
    --output) OUTPUT="$2"; shift 2 ;;
    --verbose) VERBOSE=1; shift ;;
    --help) show_help; exit 0 ;;
    *) echo "Unknown option: $1" >&2; show_help; exit 1 ;;
  esac
done

if [ -z "$OUT" ]; then
  echo "ERROR: --out is required" >&2
  show_help
  exit 1
fi

if [ -z "$IN" ]; then
  echo "ERROR: --in is required" >&2
  show_help
  exit 1
fi

if [ -z "$TYPE" ]; then
  echo "ERROR: --type is required" >&2
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

CMD="acli jira workitem link create --out \"$OUT\" --in \"$IN\" --type \"$TYPE\""

[[ $VERBOSE -eq 1 ]] && echo "Executing: $CMD" >&2

# Execute command and capture output and exit code
set +e
if [ -n "$OUTPUT" ]; then
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "Link issue $OUT to $IN with type '$TYPE'" "$RESULT"
  fi

  echo "$RESULT" > "$OUTPUT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Issues linked successfully" >&2
  [[ $VERBOSE -eq 1 ]] && echo "Results saved to: $OUTPUT" >&2
else
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "Link issue $OUT to $IN with type '$TYPE'" "$RESULT"
  fi

  echo "$RESULT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Issues linked successfully" >&2
fi
set -e
