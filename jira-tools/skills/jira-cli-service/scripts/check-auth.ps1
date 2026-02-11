# check-auth.ps1 - Check acli authentication and login if needed
# Usage: . .\scripts\check-auth.ps1
# Requires: $env:ATLASSIAN_EMAIL, $env:ATLASSIAN_SITE, $env:ATLASSIAN_TOKEN

$ErrorActionPreference = "Stop"

# Check if acli is installed
if (-not (Get-Command acli -ErrorAction SilentlyContinue)) {
    Write-Error "ERROR: acli is not installed"
    Write-Host "Please install acli first. See REFERENCE.md for instructions." -ForegroundColor Red
    exit 1
}

# Check authentication status
$authStatus = acli jira auth status 2>&1 | Out-String

if ($authStatus -match "not authenticated|No credentials found|unauthorized") {
    Write-Host "Not authenticated. Attempting automatic login..." -ForegroundColor Yellow

    # Check for required environment variables
    if (-not $env:ATLASSIAN_EMAIL -or -not $env:ATLASSIAN_SITE -or -not $env:ATLASSIAN_TOKEN) {
        Write-Host "=============================================="  -ForegroundColor Red
        Write-Host "ERROR: Atlassian CLI Authentication Required" -ForegroundColor Red
        Write-Host "=============================================="  -ForegroundColor Red
        Write-Host ""
        Write-Host "The Atlassian CLI (acli) is not authenticated and required"
        Write-Host "environment variables are not set."
        Write-Host ""
        Write-Host "Please set these environment variables and try again:"
        Write-Host ""
        Write-Host '  $env:ATLASSIAN_EMAIL="your-email@company.com"'
        Write-Host '  $env:ATLASSIAN_SITE="your-domain.atlassian.net"'
        Write-Host '  $env:ATLASSIAN_TOKEN="your-api-token"'
        Write-Host ""
        Write-Host "To generate an API token:"
        Write-Host "  1. Go to https://id.atlassian.com/manage-profile/security/api-tokens"
        Write-Host "  2. Click 'Create API token'"
        Write-Host "  3. Copy the token and set it as ATLASSIAN_TOKEN"
        Write-Host ""
        Write-Host "After setting these variables, run the command again."
        Write-Host "=============================================="  -ForegroundColor Red
        exit 1
    }

    # Perform non-interactive login using environment variables
    $env:ATLASSIAN_TOKEN | acli jira auth login `
        --email $env:ATLASSIAN_EMAIL `
        --site $env:ATLASSIAN_SITE `
        --token `
        2>&1 | Out-Null

    # Verify login succeeded
    $authCheck = acli jira auth status 2>&1 | Out-String
    if ($authCheck -match "authenticated") {
        Write-Host "✓ Authentication successful" -ForegroundColor Green
        exit 0
    } else {
        Write-Error "✗ Authentication failed"
        exit 1
    }
} else {
    Write-Host "✓ Already authenticated" -ForegroundColor Green
    exit 0
}
