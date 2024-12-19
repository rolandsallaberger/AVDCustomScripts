$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host "SLR Standard Apps installieren"
Set-Content -Path "c:\PfadZurDatei.txt" -Value "test"

# Log-Datei mit Zeitstempel erstellen
$timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
$logFile = "C:\winget-log-$timestamp.txt"

# Ergebnis von Add-AppxPackage anzeigen und in Log-Datei speichern
Write-Host "Running Add-AppxPackage -RegisterByFamilyName..."
$addAppxResult = Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe -Verbose | Tee-Object -FilePath $logFile
Write-Host "Add-AppxPackage result: $addAppxResult"

# Ergebnis von winget install anzeigen und in Log-Datei speichern
Write-Host "Running winget install command..."
$wingetResult = winget install --id=7zip.7zip -e --accept-package-agreements --accept-source-agreements --disable-interactivity | Tee-Object -FilePath $logFile
Write-Host "Winget install result: $wingetResult"
$wingetResult = winget install --id=Foxit.FoxitReader -e --accept-package-agreements --accept-source-agreements --disable-interactivity  | Tee-Object -FilePath $logFile
Write-Host "Winget install result: $wingetResult"
$wingetResult = winget install --id=Chocolatey.Chocolatey  -e --accept-package-agreements --accept-source-agreements --disable-interactivity  | Tee-Object -FilePath $logFile
Write-Host "Winget install result: $wingetResult"
$wingetResult = winget install --id=Greenshot.Greenshot  -e --accept-package-agreements --accept-source-agreements --disable-interactivity  | Tee-Object -FilePath $logFile
Write-Host "Winget install result: $wingetResult"


#winget install --id=Microsoft.Teams  -e --accept-package-agreements --accept-source-agreements --disable-interactivity  | Tee-Object -FilePath $logFile
#choco install FileZilla -y
Set-Content -Path "c:\PfadZurDatei1.txt" -Value "test"
$stopwatch.Stop()
$elapsedTime = $stopwatch.Elapsed
Exit 0
