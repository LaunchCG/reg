# transition-issue.ps1 - Change the status/workflow state of a Jira issue
# Usage: .\transition-issue.ps1 -Key PROJ-123 -Status "In Progress"

<#
.SYNOPSIS
    Change the status/workflow state of a Jira issue.

.DESCRIPTION
    Transitions a Jira issue to a new workflow state/status.
    Automatically checks authentication before executing.

.PARAMETER Key
    Issue key (required). Example: PROJ-123

.PARAMETER Status
    Target status (required). Example: "In Progress", "Done", "In Review"

.PARAMETER Output
    Optional file path to save JSON output.

.PARAMETER Verbose
    Show detailed execution information.

.EXAMPLE
    .\transition-issue.ps1 -Key PROJ-123 -Status "In Progress"

.EXAMPLE
    .\transition-issue.ps1 -Key PROJ-123 -Status "Done"

.EXAMPLE
    .\transition-issue.ps1 -Key PROJ-123 -Status "In Review" -Output result.json

.NOTES
    Common statuses: "To Do", "In Progress", "In Review", "Done"
    Available transitions depend on your Jira workflow configuration.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Key,

    [Parameter(Mandatory=$true)]
    [string]$Status,

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
$cmd = "acli jira workitem transition --key `"$Key`" --status `"$Status`""

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
