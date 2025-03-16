param (
    [string]$sourceFolder
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$destinationFolder = Join-Path -Path $scriptDir -ChildPath "build/install"
$fileListPath = Join-Path -Path $scriptDir -ChildPath "required_libs_for_windows.txt"
$windeployqtPath = Join-Path -Path $sourceFolder -ChildPath "windeployqt.exe"

# Check if windeployqt.exe exists
if (-Not (Test-Path $windeployqtPath)) {
    Write-Host "ERROR: windeployqt.exe not found in $sourceFolder" -ForegroundColor Red
    exit 1
}

if (!(Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Force -Path $destinationFolder | Out-Null
}

$fileList = Get-Content -Path $fileListPath

foreach ($file in $fileList) {
    $sourceFile = Join-Path -Path $sourceFolder -ChildPath $file
    $destinationFile = Join-Path -Path $destinationFolder -ChildPath $file
    Copy-Item -Path $sourceFile -Destination $destinationFile -Force
}

$exePath = Join-Path -Path $destinationFolder -ChildPath "xpwm.exe"
& "$sourceFolder\windeployqt.exe" --no-compiler-runtime $exePath

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed operation with windeployqt.exe"
    exit $LASTEXITCODE
}

Write-Host "DLL files successfully moved and application deployed."