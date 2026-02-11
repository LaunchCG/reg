# list-link-types.ps1 - List all available issue link types
# Usage: .\list-link-types.ps1 [-Output link-types.json]

<#
.SYNOPSIS
    List all available issue link types for your Jira instance.

.DESCRIPTION
    Retrieves all available issue link types configured in your Jira instance.
    Automatically checks authentication before executing.

.PARAMETER Output
    Optional file path to save JSON output.

.PARAMETER Verbose
    Show detailed execution information.

.EXAMPLE
    .\list-link-types.ps1

.EXAMPLE
    .\list-link-types.ps1 -Output link-types.json

.EXAMPLE
    .\list-link-types.ps1 -Verbose
#>

[CmdletBinding()]
param(
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
$cmd = "acli jira workitem link type --json"

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
