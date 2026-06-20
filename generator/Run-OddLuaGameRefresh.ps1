param(
    [string]$LogRoot = (Join-Path $PSScriptRoot 'reports\game-refresh'),
    [string]$StatusPath = ''
)

$ErrorActionPreference = 'Stop'

if (-not $StatusPath) {
    $StatusPath = Join-Path $LogRoot 'latest-status.json'
}

New-Item -ItemType Directory -Path $LogRoot -Force | Out-Null

$runId = Get-Date -Format 'yyyyMMdd-HHmmss'
$logPath = Join-Path $LogRoot "oddlua-game-refresh-$runId.log"

function Write-RefreshStatus {
    param(
        [Parameter(Mandatory = $true)][string]$State,
        [Parameter(Mandatory = $true)][string]$Message,
        [string]$Step = ''
    )

    $payload = [ordered]@{
        state = $State
        status = $State
        message = $Message
        step = $Step
        runId = $runId
        logPath = $logPath
        updatedAt = (Get-Date).ToString('o')
    }

    $tmp = "$StatusPath.tmp"
    $payload | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $tmp -Encoding UTF8
    Move-Item -LiteralPath $tmp -Destination $StatusPath -Force
}

$transcriptStarted = $false
$pushedLocation = $false
try {
    Write-RefreshStatus -State 'running' -Message 'Starting OddLua game-triggered refresh.' -Step 'start'
    Start-Transcript -Path $logPath -Force | Out-Null
    $transcriptStarted = $true

    Push-Location $PSScriptRoot
    $pushedLocation = $true

    Write-RefreshStatus -State 'running' -Message 'Building OddLua stats database.' -Step 'stats'
    & (Join-Path $PSScriptRoot 'Build-OddLuaStatsDb.ps1')

    Write-RefreshStatus -State 'running' -Message 'Building and applying OddLua profiles.' -Step 'apply'
    & (Join-Path $PSScriptRoot 'Apply-OddLuaAllJobs.ps1')

    Write-RefreshStatus -State 'running' -Message 'Checking generated Lua syntax.' -Step 'syntax'
    & python (Join-Path $PSScriptRoot 'tools\check_lua_syntax.py') --root (Join-Path $PSScriptRoot 'dist\packs') --min-files 1
    if ($LASTEXITCODE -ne 0) {
        throw "Lua syntax check failed with exit code $LASTEXITCODE."
    }

    Write-RefreshStatus -State 'success' -Message 'OddLua refresh complete; LuAshitacast can reload.' -Step 'complete'
    exit 0
}
catch {
    Write-RefreshStatus -State 'failed' -Message $_.Exception.Message -Step 'failed'
    Write-Error $_ -ErrorAction Continue
    exit 1
}
finally {
    if ($pushedLocation) {
        Pop-Location
    }
    if ($transcriptStarted) {
        Stop-Transcript | Out-Null
    }
}
