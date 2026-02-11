# add-comment.ps1 - Add a comment to a Jira issue
# Usage: .\add-comment.ps1 -Key PROJ-123 -Body "Comment text" OR -BodyFile comment.txt

<#
.SYNOPSIS
    Add a comment to a Jira issue.

.DESCRIPTION
    Adds a new comment to the specified Jira issue.
    Automatically checks authentication before executing.

.PARAMETER Key
    Issue key (required). Example: PROJ-123

.PARAMETER Body
    Comment text (required if no -BodyFile).

.PARAMETER BodyFile
    File containing comment text (required if no -Body).

.PARAMETER Output
    Optional file path to save JSON output.

.PARAMETER Verbose
    Show detailed execution information.

.EXAMPLE
    .\add-comment.ps1 -Key PROJ-123 -Body "Ready for review"

.EXAMPLE
    .\add-comment.ps1 -Key PROJ-123 -BodyFile comment.txt

.EXAMPLE
    .\add-comment.ps1 -Key PROJ-123 -Body "Looks good" -Output result.json
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Key,

    [Parameter(Mandatory=$false)]
    [string]$Body,

    [Parameter(Mandatory=$false)]
    [string]$BodyFile,

    [Parameter(Mandatory=$false)]
    [string]$Output,

    [Parameter(Mandatory=$false)]
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Validate parameters
if (-not $Body -and -not $BodyFile) {
    Write-Host "ERROR: Either -Body or -BodyFile is required" -ForegroundColor Red
    exit 1
}

if ($Verbose) {
    Write-Host "Checking authentication..." -ForegroundColor Cyan
}

# Check authentication
. "$ScriptDir\check-auth.ps1"

# Build command
if ($Body) {
    $cmd = "acli jira workitem comment create --key `"$Key`" --body `"$Body`" --json"
} else {
    $cmd = "acli jira workitem comment create --key `"$Key`" --body-file `"$BodyFile`" --json"
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
