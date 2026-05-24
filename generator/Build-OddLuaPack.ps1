param(
    [string]$Player = 'Aahtacos',
    [string]$PlayerId = '30102',
    [string]$Job = 'THF',
    [string]$GearPath = 'C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport\Aahtacos_30102_gear.lua',
    [string]$CharacterPath = 'C:\Games\CatsEyeXI\catseyexi-client\Ashita\config\addons\gearexport\Aahtacos_30102\Aahtacos_30102_character.json',
    [string]$OutputRoot = (Join-Path $PSScriptRoot 'dist'),
    [string]$StatsDbPath = '',
    [string]$TargetName = ''
)

$ErrorActionPreference = 'Stop'

$script = Join-Path $PSScriptRoot 'build_pack.py'
$arguments = @(
    '--player', $Player,
    '--player-id', $PlayerId,
    '--job', $Job,
    '--gear-path', $GearPath,
    '--character-path', $CharacterPath,
    '--output-root', $OutputRoot
)
if ($StatsDbPath) {
    $arguments += @('--stats-db-path', $StatsDbPath)
}
if ($TargetName) {
    $arguments += @('--target-name', $TargetName)
}

& python $script @arguments

if ($LASTEXITCODE -ne 0) {
    throw "OddLua pack build failed with exit code $LASTEXITCODE."
}
