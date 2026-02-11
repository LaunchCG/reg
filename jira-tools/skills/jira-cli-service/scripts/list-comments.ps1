# list-comments.ps1 - List comments on a Jira issue
# Usage: .\list-comments.ps1 -Key PROJ-123 [-Limit 10] [-Output comments.json]

<#
.SYNOPSIS
    List comments on a Jira issue.

.DESCRIPTION
    Retrieves all comments for a specified Jira issue.
    Automatically checks authentication before executing.

.PARAMETER Key
    Issue key (required). Example: PROJ-123

.PARAMETER Limit
    Maximum number of comments to return (optional).

.PARAMETER Paginate
    Enable pagination for large comment lists.

.PARAMETER Output
    Optional file path to save JSON output.

.PARAMETER Verbose
    Show detailed execution information.

.EXAMPLE
    .\list-comments.ps1 -Key PROJ-123

.EXAMPLE
    .\list-comments.ps1 -Key PROJ-123 -Limit 10

.EXAMPLE
    .\list-comments.ps1 -Key PROJ-123 -Paginate -Output comments.json
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Key,

    [Parameter(Mandatory=$false)]
    [int]$Limit,

    [Parameter(Mandatory=$false)]
    [switch]$Paginate,

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
$cmd = "acli jira workitem comment list --key `"$Key`" --json"

if ($Limit -gt 0) {
    $cmd += " --limit $Limit"
}

if ($Paginate) {
    $cmd += " --paginate"
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
