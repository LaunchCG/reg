# search-issues.ps1 - Search for Jira issues using JQL
# Usage: .\search-issues.ps1 -Jql "project=PROJ" [-Output issues.json]

<#
.SYNOPSIS
    Search for Jira issues using JQL (Jira Query Language).

.DESCRIPTION
    Searches for Jira issues using JQL and returns results in JSON format.
    Automatically checks authentication before executing the search.

.PARAMETER Jql
    JQL query string (required). Example: "project=PROJ AND status='In Progress'"

.PARAMETER Fields
    Comma-separated list of fields to return.
    WARNING: Only these fields are supported: key, summary, status, priority, assignee, issuetype
    Use "*all" for all available fields.

.PARAMETER Limit
    Maximum number of results to return (default: no limit).

.PARAMETER Output
    Optional file path to save JSON output.

.PARAMETER Verbose
    Show detailed execution information.

.EXAMPLE
    .\search-issues.ps1 -Jql "project=PROJ"

.EXAMPLE
    .\search-issues.ps1 -Jql "project=PROJ AND status='In Progress'" -Fields "key,summary,status"

.EXAMPLE
    .\search-issues.ps1 -Jql "assignee=currentUser()" -Output my-issues.json
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Jql,

    [Parameter(Mandatory=$false)]
    [string]$Fields,

    [Parameter(Mandatory=$false)]
    [int]$Limit,

    [Parameter(Mandatory=$false)]
    [string]$Output,

    [Parameter(Mandatory=$false)]
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if ($Verbose) {
    Write-Host "Checking authentication..." -ForegroundColor Cyan
}

# Check authentication
. "$ScriptDir\check-auth.ps1"

# Build command
$cmd = "acli jira workitem search --jql `"$Jql`" --json"

if ($Fields) {
    $cmd += " --fields `"$Fields`""
}

if ($Limit -gt 0) {
    $cmd += " --limit $Limit"
}

if ($Verbose) {
    Write-Host "Executing: $cmd" -ForegroundColor Cyan
}

# Execute command
if ($Output) {
    Invoke-Expression $cmd | Out-File -FilePath $Output -Encoding UTF8
    if ($Verbose) {
        Write-Host "Results saved to: $Output" -ForegroundColor Green
    }
} else {
    Invoke-Expression $cmd
}
