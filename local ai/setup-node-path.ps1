$ErrorActionPreference = 'Stop'
$nodeHome = 'C:\Users\d2516\Documents\Codex\tools\nodejs\node-v24.22.0-win-x64'
$nodeExe = Join-Path $nodeHome 'node.exe'
if (-not (Test-Path -LiteralPath $nodeExe)) {
    throw "Node.js wurde unter $nodeHome nicht gefunden."
}

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$entries = @()
if (-not [string]::IsNullOrWhiteSpace($userPath)) {
    $entries = @($userPath -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}
$exists = @($entries | Where-Object { $_.TrimEnd('\') -ieq $nodeHome.TrimEnd('\') }).Count -gt 0
if (-not $exists) {
    $entries += $nodeHome
    [Environment]::SetEnvironmentVariable('Path', ($entries -join ';'), 'User')
}

$env:Path = $nodeHome + ';' + $env:Path
Write-Host 'Node.js ist im PATH dieser Sitzung verfügbar:'
& $nodeExe --version
Write-Host 'Schließe danach PowerShell und öffne ein neues Fenster, damit node dauerhaft erkannt wird.'

