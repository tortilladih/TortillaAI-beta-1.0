$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

$url = 'http://127.0.0.1:3000/'
try {
    $existing = Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 1
    if ($existing.StatusCode -eq 200) {
        Write-Host "Local AI läuft bereits unter $url. Kein zweiter Server wurde gestartet."
        exit 0
    }
} catch {}

$nodeCommand = Get-Command node -ErrorAction SilentlyContinue
if ($nodeCommand) {
    $node = $nodeCommand.Source
} else {
    $nodeHome = 'C:\Users\d2516\Documents\Codex\tools\nodejs\node-v24.22.0-win-x64'
    $node = Join-Path $nodeHome 'node.exe'
}

if (-not (Test-Path -LiteralPath $node)) {
    Write-Host 'Node.js wurde nicht gefunden. Installiere Node.js oder prüfe den Pfad in start.ps1.' -ForegroundColor Red
    Read-Host 'Enter zum Schließen'
    exit 1
}

Write-Host "Local AI startet unter $url"
Write-Host 'Dieses Fenster offen lassen. Beenden mit Strg+C.'
& $node .\server.mjs

