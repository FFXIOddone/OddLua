param(
    [string]$SqlRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) 'server\sql'),
    [string]$ScriptsItemsRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) 'server\scripts\items'),
    [string]$ClientItemsPath = 'C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport',
    [string]$OutputPath = (Join-Path $PSScriptRoot 'data\oddlua_stats.sqlite')
)

$ErrorActionPreference = 'Stop'

$script = Join-Path $PSScriptRoot 'build_stats_db.py'
$args = @(
    $script,
    '--sql-root', $SqlRoot,
    '--scripts-items-root', $ScriptsItemsRoot,
    '--output-path', $OutputPath
)

if (Test-Path -LiteralPath $ClientItemsPath) {
    $args += @('--client-items-path', $ClientItemsPath)
}

& python @args

if ($LASTEXITCODE -ne 0) {
    throw "OddLua stats database build failed with exit code $LASTEXITCODE."
}
