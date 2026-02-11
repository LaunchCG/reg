#!/bin/bash
# check-auth.sh - Check acli authentication and login if needed
# Usage: source scripts/check-auth.sh
# Requires: ATLASSIAN_EMAIL, ATLASSIAN_SITE, ATLASSIAN_TOKEN environment variables

set -e

# Check if acli is installed
if ! command -v acli &> /dev/null; then
  echo "ERROR: acli is not installed" >&2
  echo "" >&2
  echo "Install with: npm install -g @atlassian/acli" >&2
  echo "See REFERENCE.md for detailed instructions." >&2
  return 1 2>/dev/null || exit 1
fi

# Check authentication status
AUTH_STATUS=$(acli jira auth status 2>&1)

if echo "$AUTH_STATUS" | grep -qi "not authenticated\|No credentials found\|unauthorized"; then
  echo "Not authenticated. Attempting automatic login..." >&2

  # Check for required environment variables
  if [ -z "$ATLASSIAN_EMAIL" ] || [ -z "$ATLASSIAN_SITE" ] || [ -z "$ATLASSIAN_TOKEN" ]; then
    echo "=============================================="  >&2
    echo "ERROR: Atlassian CLI Authentication Required" >&2
    echo "=============================================="  >&2
    echo "" >&2
    echo "The Atlassian CLI (acli) is not authenticated and required" >&2
    echo "environment variables are not set." >&2
    echo "" >&2
    echo "Please set these environment variables and try again:" >&2
    echo "" >&2
    echo "  export ATLASSIAN_EMAIL=\"your-email@company.com\"" >&2
    echo "  export ATLASSIAN_SITE=\"your-domain.atlassian.net\"" >&2
    echo "  export ATLASSIAN_TOKEN=\"your-api-token\"" >&2
    echo "" >&2
    echo "To generate an API token:" >&2
    echo "  1. Go to https://id.atlassian.com/manage-profile/security/api-tokens" >&2
    echo "  2. Click 'Create API token'" >&2
    echo "  3. Copy the token and set it as ATLASSIAN_TOKEN" >&2
    echo "" >&2
    echo "For GitHub Actions, add these as repository secrets:" >&2
    echo "  Settings → Secrets and variables → Actions → New repository secret" >&2
    echo "" >&2
    echo "After setting these variables, run the command again." >&2
    echo "=============================================="  >&2
    return 1 2>/dev/null || exit 1
  fi

  # Perform non-interactive login using environment variables
  echo "$ATLASSIAN_TOKEN" | acli jira auth login \
    --email "$ATLASSIAN_EMAIL" \
    --site "$ATLASSIAN_SITE" \
    --token \
    2>&1 | grep -v "Enter" || true

  # Verify login succeeded
  if acli jira auth status 2>&1 | grep -q "authenticated"; then
    echo "✓ Authentication successful" >&2
    return 0 2>/dev/null || exit 0
  else
    echo "✗ Authentication failed" >&2
    echo "" >&2
    echo "Possible causes:" >&2
    echo "  - API token expired or revoked" >&2
    echo "  - Invalid email or site domain" >&2
    echo "  - Insufficient account permissions" >&2
    echo "" >&2
    echo "Generate new token: https://id.atlassian.com/manage-profile/security/api-tokens" >&2
    return 1 2>/dev/null || exit 1
  fi
else
  echo "✓ Already authenticated" >&2
  return 0 2>/dev/null || exit 0
fi
