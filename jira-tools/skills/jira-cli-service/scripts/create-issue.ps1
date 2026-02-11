# create-issue.ps1 - Create a new Jira issue
# Usage: .\create-issue.ps1 -Project PROJ -Type Story -Summary "Title" [-Description "Body"]

<#
.SYNOPSIS
    Create a new Jira issue.

.DESCRIPTION
    Creates a new Jira issue with the specified fields.
    Automatically checks authentication before creating the issue.

.PARAMETER Project
    Project key (required). Example: PROJ

.PARAMETER Type
    Issue type (required). Common types: Story, Task, Bug, Epic

.PARAMETER Summary
    Issue title/summary (required).

.PARAMETER Description
    Issue description (optional).

.PARAMETER Assignee
    Assignee email address (optional).

.PARAMETER Priority
    Priority level (optional). Example: High, Medium, Low

.PARAMETER Labels
    Comma-separated labels (optional). Example: "backend,security,authentication"

.PARAMETER Output
    Optional file path to save JSON output.

.PARAMETER Verbose
    Show detailed execution information.

.EXAMPLE
    .\create-issue.ps1 -Project PROJ -Type Story -Summary "Implement feature"

.EXAMPLE
    .\create-issue.ps1 -Project PROJ -Type Bug -Summary "Fix login" -Description "Users cannot login" -Priority High

.EXAMPLE
    .\create-issue.ps1 -Project PROJ -Type Task -Summary "Update docs" -Assignee "user@example.com" -Labels "documentation,onboarding"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Project,

    [Parameter(Mandatory=$true)]
    [string]$Type,

    [Parameter(Mandatory=$true)]
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

if ($Verbose) {
    Write-Host "Checking authentication..." -ForegroundColor Cyan
}

# Check authentication
. "$ScriptDir\check-auth.ps1"

# Build command
$cmd = "acli jira workitem create --project `"$Project`" --type `"$Type`" --summary `"$Summary`" --json"

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
    $labelArray = $Labels -split ','
    foreach ($label in $labelArray) {
        $trimmedLabel = $label.Trim()
        $cmd += " --label `"$trimmedLabel`""
    }
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
