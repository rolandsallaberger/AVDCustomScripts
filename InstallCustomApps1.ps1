$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
Write-Host "SLR Standard Apps installieren"
Set-Content -Path "c:\PfadZurDatei.txt" -Value "test"
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe -Verbose
winget install --id=7zip.7zip -e --accept-package-agreements --accept-source-agreements --disable-interactivity > "c:\winget-log-$timestamp.txt" 2>&1
winget install --id=Foxit.FoxitReader -e --accept-package-agreements --accept-source-agreements --disable-interactivity > "c:\winget-log-$timestamp.txt" 2>&1
winget install --id=Chocolatey.Chocolatey  -e --accept-package-agreements --accept-source-agreements --disable-interactivity > "c:\winget-log-$timestamp.txt" 2>&1
winget install --id=Greenshot.Greenshot  -e --accept-package-agreements --accept-source-agreements --disable-interactivity > "c:\winget-log-$timestamp.txt" 2>&1
#winget install --id=Microsoft.Teams  -e --accept-package-agreements --accept-source-agreements --disable-interactivity > "c:\winget-log-$timestamp.txt" 2>&1
#choco install FileZilla -y
Set-Content -Path "c:\PfadZurDatei1.txt" -Value "test"
$stopwatch.Stop()
$elapsedTime = $stopwatch.Elapsed
Exit 0
