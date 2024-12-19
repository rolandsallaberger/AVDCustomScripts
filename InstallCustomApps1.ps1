Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

New-Item -Type Directory -Path "c:\\" -Name temp
invoke-webrequest -uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile "c:\\temp\\azcopy.zip"
Expand-Archive "c:\\temp\\azcopy.zip" "c:\\temp"
copy-item "C:\\temp\\azcopy_windows_amd64_*\\azcopy.exe\\" -Destination "c:\\temp" 

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

winget |tee-object -filepath c:\win.txt
&"C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_1.21.10120.0_x64__8wekyb3d8bbwe\winget.exe" |tee-object -filepath c:\win1.txt

# Ergebnis von winget install anzeigen und in Log-Datei speichern
Write-Host "Running winget install command..."
$logFile = "C:\winget-log-7zip$timestamp.txt"
$wingetResult = &"C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_1.21.10120.0_x64__8wekyb3d8bbwe\winget.exe" install --id=7zip.7zip -e --accept-package-agreements --accept-source-agreements --disable-interactivity --verbose| Tee-Object -FilePath $logFile
Write-Host "Winget install result: $wingetResult"
$logFile = "C:\winget-log-foxit$timestamp.txt"
$wingetResult = &"C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_1.21.10120.0_x64__8wekyb3d8bbwe\winget.exe" install --id=Foxit.FoxitReader -e --accept-package-agreements --accept-source-agreements --disable-interactivity  --verbose| Tee-Object -FilePath $logFile
Write-Host "Winget install result: $wingetResult"
$logFile = "C:\winget-log-choco$timestamp.txt"
$wingetResult = &"C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_1.21.10120.0_x64__8wekyb3d8bbwe\winget.exe" install --id=Chocolatey.Chocolatey  -e --accept-package-agreements --accept-source-agreements --disable-interactivity  --verbose | Tee-Object -FilePath $logFile
Write-Host "Winget install result: $wingetResult"
$logFile = "C:\winget-log-greenshot$timestamp.txt"
$wingetResult = &"C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_1.21.10120.0_x64__8wekyb3d8bbwe\winget.exe" install --id=Greenshot.Greenshot  -e --accept-package-agreements --accept-source-agreements --disable-interactivity  --verbose | Tee-Object -FilePath $logFile
Write-Host "Winget install result: $wingetResult"


#winget install --id=Microsoft.Teams  -e --accept-package-agreements --accept-source-agreements --disable-interactivity  | Tee-Object -FilePath $logFile
#choco install FileZilla -y
Set-Content -Path "c:\PfadZurDatei1.txt" -Value "test"
$stopwatch.Stop()
$elapsedTime = $stopwatch.Elapsed
Exit 0
