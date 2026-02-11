# edit-issue.ps1 - Update fields on an existing Jira issue
# Usage: .\edit-issue.ps1 -Key PROJ-123 -Summary "New title" [-Assignee email] [-Priority High]

<#
.SYNOPSIS
    Update fields on an existing Jira issue.

.DESCRIPTION
    Updates one or more fields on an existing Jira issue.
    Automatically checks authentication before executing.

.PARAMETER Key
    Issue key (required). Example: PROJ-123

.PARAMETER Summary
    New summary/title (optional).

.PARAMETER Description
    New description (optional).

.PARAMETER Assignee
    New assignee email address (optional).

.PARAMETER Priority
    New priority (optional). Example: High, Medium, Low

.PARAMETER Labels
    Comma-separated labels - replaces existing labels (optional).

.PARAMETER Output
    Optional file path to save JSON output.

.PARAMETER Verbose
    Show detailed execution information.

.EXAMPLE
    .\edit-issue.ps1 -Key PROJ-123 -Summary "Updated title"

.EXAMPLE
    .\edit-issue.ps1 -Key PROJ-123 -Assignee "user@example.com" -Priority High

.EXAMPLE
    .\edit-issue.ps1 -Key PROJ-123 -Labels "backend,security,authentication"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Key,

    [Parameter(Mandatory=$false)]
    [string]$Summary,

    [Parameter(Mandatory=$false)]
    [string]$Description,

    [Parameter(Mandatory=$false)]
    [string]$Assignee,

    [Parameter(Mandatory=$false)]
    [string]$Priority,

    [Parameter(Mandatory=$false)]
    [string]$Labels,

    [Parameter(Mandatory=$false)]
    [string]$Output,

    [Parameter(Mandatory=$false)]
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Validate at least one field is provided
if (-not $Summary -and -not $Description -and -not $Assignee -and -not $Priority -and -not $Labels) {
    Write-Host "ERROR: At least one field to update is required" -ForegroundColor Red
    exit 1
}

if ($Verbose) {
    Write-Host "Checking authentication..." -ForegroundColor Cyan
}

# Check authentication
. "$ScriptDir\check-auth.ps1"

# Build command
$cmd = "acli jira workitem edit --key `"$Key`""

if ($Summary) {
    $cmd += " --summary `"$Summary`""
}

if ($Description) {
    $cmd += " --description `"$Description`""
}

if ($Assignee) {
    $cmd += " --assignee `"$Assignee`""
}

if ($Priority) {
    $cmd += " --priority `"$Priority`""
}

if ($Labels) {
    $cmd += " --labels `"$Labels`""
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
