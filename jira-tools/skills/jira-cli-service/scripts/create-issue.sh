#!/bin/bash
# create-issue.sh - Create a new Jira issue
# Usage: ./create-issue.sh --project PROJ --type Story --summary "Title" [OPTIONS]

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
PROJECT=""
TYPE=""
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
  echo "ERROR: Jira Create Issue Operation Failed" >&2
  echo "=============================================="  >&2
  echo "" >&2
  echo "Operation: $operation" >&2
  echo "Project: ${PROJECT:-N/A}" >&2
  echo "Type: ${TYPE:-N/A}" >&2
  echo "Exit Code: $exit_code" >&2
  echo "" >&2
  echo "Details:" >&2
  echo "$details" >&2
  echo "" >&2
  echo "Possible causes:" >&2
  echo "  - Project key does not exist or is invalid" >&2
  echo "  - Issue type not available in project" >&2
  echo "  - Required fields missing for issue type" >&2
  echo "  - Insufficient permissions to create issues" >&2
  echo "  - Network connectivity issues" >&2
  echo "  - Authentication expired or invalid" >&2
  echo "  - Invalid assignee email address" >&2
  echo "" >&2
  echo "Troubleshooting:" >&2
  echo "  1. Verify project key exists in Jira" >&2
  echo "  2. Check issue type is available in project settings" >&2
  echo "  3. Check authentication: acli jira auth status" >&2
  echo "  4. Re-authenticate if needed: source check-auth.sh" >&2
  echo "  5. Verify assignee email is valid Jira user" >&2
  echo "  6. Try with --verbose flag for more details" >&2
  echo "=============================================="  >&2
  exit $exit_code
}

# Help text
show_help() {
  cat << EOF
Usage: $(basename "$0") --project PROJECT --type TYPE --summary "SUMMARY" [OPTIONS]

Create a new Jira issue.

Required:
  --project PROJECT      Project key (e.g., PROJ)
  --type TYPE            Issue type (Story, Bug, Task, etc.)
  --summary SUMMARY      Issue summary/title

Options:
  --description TEXT     Issue description
  --assignee EMAIL       Assignee email address
  --priority PRIORITY    Priority (High, Medium, Low)
  --labels LABELS        Comma-separated labels
  --output FILE          Save JSON output to file
  --verbose              Show detailed execution
  --help                 Show this help message

Examples:
  $0 --project PROJ --type Story --summary "New feature"
  $0 --project PROJ --type Bug --summary "Fix login" --assignee "user@example.com"
  $0 --project PROJ --type Story --summary "Add API" --description "REST API" --labels "backend,api"
  $0 --project PROJ --type Task --summary "Update docs" --output created.json

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --project)
      PROJECT="$2"
      shift 2
      ;;
    --type)
      TYPE="$2"
      shift 2
      ;;
    --summary)
      SUMMARY="$2"
      shift 2
      ;;
    --description)
      DESCRIPTION="$2"
      shift 2
      ;;
    --assignee)
      ASSIGNEE="$2"
      shift 2
      ;;
    --priority)
      PRIORITY="$2"
      shift 2
      ;;
    --labels)
      LABELS="$2"
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
if [ -z "$PROJECT" ]; then
  echo "ERROR: --project is required" >&2
  show_help
  exit 1
fi

if [ -z "$TYPE" ]; then
  echo "ERROR: --type is required" >&2
  show_help
  exit 1
fi

if [ -z "$SUMMARY" ]; then
  echo "ERROR: --summary is required" >&2
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
CMD="acli jira workitem create --project \"$PROJECT\" --type \"$TYPE\" --summary \"$SUMMARY\" --json"

if [ -n "$DESCRIPTION" ]; then
  CMD="$CMD --description \"$DESCRIPTION\""
fi

if [ -n "$ASSIGNEE" ]; then
  CMD="$CMD --assignee \"$ASSIGNEE\""
fi

if [ -n "$PRIORITY" ]; then
  CMD="$CMD --priority \"$PRIORITY\""
fi

if [ -n "$LABELS" ]; then
  # Split labels and add each one
  IFS=',' read -ra LABEL_ARRAY <<< "$LABELS"
  for label in "${LABEL_ARRAY[@]}"; do
    CMD="$CMD --label \"$label\""
  done
fi

# Execute command
[[ $VERBOSE -eq 1 ]] && echo "Executing: $CMD" >&2

# Execute command and capture output and exit code
set +e
if [ -n "$OUTPUT" ]; then
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "Create issue in project $PROJECT" "$RESULT"
  fi

  # Validate JSON output
  if ! echo "$RESULT" | jq empty 2>/dev/null; then
    handle_error 1 "Create issue in project $PROJECT" "Invalid JSON response from acli command:
$RESULT"
  fi

  echo "$RESULT" > "$OUTPUT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Issue created successfully" >&2
  [[ $VERBOSE -eq 1 ]] && echo "Results saved to: $OUTPUT" >&2
  # Also print the created issue key
  ISSUE_KEY=$(cat "$OUTPUT" | jq -r '.key' 2>/dev/null || echo "")
  if [ -n "$ISSUE_KEY" ]; then
    echo "Created: $ISSUE_KEY" >&2
  fi
else
  RESULT=$(eval "$CMD" 2>&1)
  CMD_EXIT_CODE=$?

  if [ $CMD_EXIT_CODE -ne 0 ]; then
    handle_error $CMD_EXIT_CODE "Create issue in project $PROJECT" "$RESULT"
  fi

  # Validate JSON output
  if ! echo "$RESULT" | jq empty 2>/dev/null; then
    handle_error 1 "Create issue in project $PROJECT" "Invalid JSON response from acli command:
$RESULT"
  fi

  echo "$RESULT"
  [[ $VERBOSE -eq 1 ]] && echo "✓ Issue created successfully" >&2
  # Also print the created issue key for easy reference
  ISSUE_KEY=$(echo "$RESULT" | jq -r '.key' 2>/dev/null || echo "")
  if [ -n "$ISSUE_KEY" ]; then
    echo "Created: $ISSUE_KEY" >&2
  fi
fi
set -e
