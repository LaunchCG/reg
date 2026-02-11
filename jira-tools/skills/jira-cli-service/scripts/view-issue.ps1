# view-issue.ps1 - Get details of a single Jira issue
# Usage: .\view-issue.ps1 -Key PROJ-123 [-Fields "*all"] [-Output issue.json]

<#
.SYNOPSIS
    Get details of a single Jira issue.

.DESCRIPTION
    Retrieves complete details of a Jira issue by its key.
    Automatically checks authentication before executing.

.PARAMETER Key
    Issue key (required). Example: PROJ-123

.PARAMETER Fields
    Comma-separated list of fields to return.
    Use "*all" for all fields (recommended).
    Default: Returns standard fields only.

.PARAMETER Output
    Optional file path to save JSON output.

.PARAMETER Verbose
    Show detailed execution information.

.EXAMPLE
    .\view-issue.ps1 -Key PROJ-123

.EXAMPLE
    .\view-issue.ps1 -Key PROJ-123 -Fields "*all"

.EXAMPLE
    .\view-issue.ps1 -Key PROJ-123 -Output issue.json
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Key,

    [Parameter(Mandatory=$false)]
    [string]$Fields,

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
$cmd = "acli jira workitem view `"$Key`" --json"

if ($Fields) {
    $cmd += " --fields `"$Fields`""
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
