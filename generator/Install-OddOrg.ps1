param(
    [string]$CatseyeAshitaRoot = "C:\Games\CatsEyeXI\catseyexi-client\Ashita",
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceDir = Resolve-Path (Join-Path $scriptRoot "..\client\Ashita\addons\oddorg")
$targetDir = Join-Path $CatseyeAshitaRoot "addons\oddorg"
$configDir = Join-Path $CatseyeAshitaRoot "config\addons\oddorg"
$sourceFile = Join-Path $sourceDir "oddorg.lua"
$targetFile = Join-Path $targetDir "oddorg.lua"

Write-Host "OddOrg source: $sourceDir"
Write-Host "OddOrg target: $targetDir"
Write-Host "OddOrg config: $configDir"

if ($DryRun) {
    Write-Host "Dry run: no files copied."
    exit 0
}

New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
New-Item -ItemType Directory -Force -Path $configDir | Out-Null

Copy-Item -Path (Join-Path $sourceDir "*") -Destination $targetDir -Recurse -Force

$sourceHash = (Get-FileHash -Algorithm SHA256 -Path $sourceFile).Hash
$targetHash = (Get-FileHash -Algorithm SHA256 -Path $targetFile).Hash

[pscustomobject]@{
    Source = $sourceFile
    Target = $targetFile
    SourceSha256 = $sourceHash
    TargetSha256 = $targetHash
    Match = ($sourceHash -eq $targetHash)
} | Format-List

if ($sourceHash -ne $targetHash) {
    throw "OddOrg install hash mismatch."
}
