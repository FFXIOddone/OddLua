param(
    [string]$GearexportRoot = 'C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport',
    [string]$LuashitacastRoot = 'C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\luashitacast',
    [string]$OutputRoot = (Join-Path $PSScriptRoot 'dist'),
    [string]$BackupRoot = (Join-Path $PSScriptRoot 'backups\luashitacast'),
    [string]$ReportRoot = (Join-Path $PSScriptRoot 'reports\apply'),
    [string]$StatsDbPath = (Join-Path $PSScriptRoot 'data\oddlua_stats.sqlite'),
    [string]$TargetName = '',
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$script = Join-Path $PSScriptRoot 'apply_all_jobs.py'
$arguments = @(
    '--gearexport-root', $GearexportRoot,
    '--luashitacast-root', $LuashitacastRoot,
    '--output-root', $OutputRoot,
    '--backup-root', $BackupRoot,
    '--report-root', $ReportRoot
)

if ($StatsDbPath) {
    $arguments += @('--stats-db-path', $StatsDbPath)
}
if ($TargetName) {
    $arguments += @('--target-name', $TargetName)
}
if ($DryRun) {
    $arguments += '--dry-run'
}

& python $script @arguments

if ($LASTEXITCODE -ne 0) {
    throw "OddLua all-jobs apply failed with exit code $LASTEXITCODE."
}
