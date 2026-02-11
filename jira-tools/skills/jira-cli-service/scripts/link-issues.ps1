# link-issues.ps1 - Create a link between two Jira issues
# Usage: .\link-issues.ps1 -Out PROJ-123 -In PROJ-456 -Type "Blocks"

<#
.SYNOPSIS
    Create a link between two Jira issues.

.DESCRIPTION
    Creates a directional link between two Jira issues.
    Automatically checks authentication before executing.

.PARAMETER Out
    Outward issue key (required). Example: PROJ-123

.PARAMETER In
    Inward issue key (required). Example: PROJ-456

.PARAMETER Type
    Link type (required). Example: "Blocks", "Relates", "Duplicate", "Causes"

.PARAMETER Output
    Optional file path to save JSON output.

.PARAMETER Verbose
    Show detailed execution information.

.EXAMPLE
    .\link-issues.ps1 -Out PROJ-123 -In PROJ-456 -Type "Blocks"

.EXAMPLE
    .\link-issues.ps1 -Out PROJ-100 -In PROJ-123 -Type "Relates"

.EXAMPLE
    .\link-issues.ps1 -Out PROJ-123 -In PROJ-124 -Type "Duplicate" -Output result.json

.NOTES
    Common Link Types:
    - Blocks      : Outward issue blocks inward issue
    - Relates     : General relationship
    - Duplicate   : Mark as duplicate
    - Causes      : Issue causes another issue (for bugs)

    To see all available link types, use: .\list-link-types.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Out,

    [Parameter(Mandatory=$true)]
    [string]$In,

    [Parameter(Mandatory=$true)]
    [string]$Type,

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
$cmd = "acli jira workitem link create --out `"$Out`" --in `"$In`" --type `"$Type`""

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
