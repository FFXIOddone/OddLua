param(
    [string]$SqlRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) 'server\sql'),
    [string]$ScriptsItemsRoot = (Join-Path (Split-Path -Parent $PSScriptRoot) 'server\scripts\items'),
    [string]$OutputPath = (Join-Path $PSScriptRoot 'data\oddlua_stats.sqlite')
)

$ErrorActionPreference = 'Stop'

$script = Join-Path $PSScriptRoot 'build_stats_db.py'
& python $script `
    --sql-root $SqlRoot `
    --scripts-items-root $ScriptsItemsRoot `
    --output-path $OutputPath

if ($LASTEXITCODE -ne 0) {
    throw "OddLua stats database build failed with exit code $LASTEXITCODE."
}
