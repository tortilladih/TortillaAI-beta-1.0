$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$electron = Join-Path $root 'node_modules\electron\dist\electron.exe'
$icon = Join-Path $root 'assets\tortilla.ico'

if (-not (Test-Path -LiteralPath $electron)) {
    throw "Electron fehlt. Öffne PowerShell in diesem Ordner und führe einmal npm install aus."
}

if (-not (Test-Path -LiteralPath $icon)) {
    Add-Type -AssemblyName System.Drawing
    $bitmap = New-Object System.Drawing.Bitmap(64,64,[System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.Clear([System.Drawing.Color]::Transparent)

    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc(2,2,60,60,180,90)
    $path.AddArc(2,2,60,60,270,90)
    $path.AddArc(2,2,60,60,0,90)
    $path.AddArc(2,2,60,60,90,90)
    $path.CloseFigure()
    $background = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(34,41,29))
    $graphics.FillPath($background,$path)
    $border = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(65,71,53),1.5)
    $graphics.DrawPath($border,$path)

    $tortillaRect = New-Object System.Drawing.Rectangle(12,12,40,40)
    $tortilla = [System.Drawing.Drawing2D.LinearGradientBrush]::new($tortillaRect,[System.Drawing.Color]::FromArgb(248,216,143),[System.Drawing.Color]::FromArgb(217,158,60),45)
    $graphics.FillEllipse($tortilla,12,12,40,40)
    $ring = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(190,255,240,194),1)
    $graphics.DrawEllipse($ring,15,15,34,34)

    $tPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255,52,68,43),4.2)
    $tPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $tPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $graphics.DrawLine($tPen,22,25,42,25)
    $graphics.DrawLine($tPen,32,25,32,42)
    $leafPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255,102,125,72),2.3)
    $leafPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $leafPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $graphics.DrawArc($leafPen,24,23,16,15,0,180)

    $spot = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,189,129,48))
    $graphics.FillEllipse($spot,17,33,3,3)
    $graphics.FillEllipse($spot,42,38,3,3)
    $spark = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,214,231,163))
    $points = [System.Drawing.Point[]]@(
      [System.Drawing.Point]::new(46,12),[System.Drawing.Point]::new(48,17),[System.Drawing.Point]::new(53,19),
      [System.Drawing.Point]::new(48,21),[System.Drawing.Point]::new(46,26),[System.Drawing.Point]::new(44,21),
      [System.Drawing.Point]::new(39,19),[System.Drawing.Point]::new(44,17)
    )
    $graphics.FillPolygon($spark,$points)

    $hIcon = $bitmap.GetHicon()
    $ico = [System.Drawing.Icon]::FromHandle($hIcon)
    $stream = [System.IO.File]::Create($icon)
    $ico.Save($stream)
    $stream.Dispose()
    $ico.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
    $path.Dispose()
    $background.Dispose()
    $border.Dispose()
    $tortilla.Dispose()
    $ring.Dispose()
    $tPen.Dispose()
    $leafPen.Dispose()
    $spot.Dispose()
    $spark.Dispose()
}

$desktop = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktop 'TortillaAI.lnk'
$shell = New-Object -ComObject WScript.Shell
$link = $shell.CreateShortcut($shortcutPath)
$link.TargetPath = $electron
$link.Arguments = '.'
$link.WorkingDirectory = $root
$link.IconLocation = "$icon,0"
$link.Description = 'TortillaAI – lokaler KI-Chat mit Ollama'
$link.Save()
Write-Host "Desktop-Verknüpfung erstellt: $shortcutPath"
Write-Host 'Ab jetzt TortillaAI auf dem Desktop doppelklicken. Ollama muss laufen.'