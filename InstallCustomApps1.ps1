Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.Winget.Source_8wekyb3d8bbwe --Verbose

function Install-WinGet {
  $tempFolderName = 'WinGetInstall'
  $tempFolder = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath $tempFolderName
  New-Item $tempFolder -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

  $apiLatestUrl = if ($Prerelease) { 'https://api.github.com/repos/microsoft/winget-cli/releases?per_page=1' } else { 'https://api.github.com/repos/microsoft/winget-cli/releases/latest' }
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  $WebClient = New-Object System.Net.WebClient

  function Get-LatestUrl	{
		((Invoke-WebRequest $apiLatestUrl -UseBasicParsing | ConvertFrom-Json).assets | Where-Object { $_.name -match '^Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle$' }).browser_download_url
  }

  function Get-LatestHash {
    $shaUrl = ((Invoke-WebRequest $apiLatestUrl -UseBasicParsing | ConvertFrom-Json).assets | Where-Object { $_.name -match '^Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.txt$' }).browser_download_url
    $shaFile = Join-Path -Path $tempFolder -ChildPath 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.txt'
    $WebClient.DownloadFile($shaUrl, $shaFile)
    Get-Content $shaFile
  }
  $desktopAppInstaller = @{
    fileName = 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
    url      = $(Get-LatestUrl)
    hash     = $(Get-LatestHash)
  }
  $vcLibsUwp = @{
    fileName = 'Microsoft.VCLibs.x64.14.00.Desktop.appx'
    url      = 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
    hash     = '9BFDE6CFCC530EF073AB4BC9C4817575F63BE1251DD75AAA58CB89299697A569'
  }
  $uiLibsUwp = @{
    fileName = 'Microsoft.UI.Xaml.2.7.zip'
    url      = 'https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.0'
    hash     = '422FD24B231E87A842C4DAEABC6A335112E0D35B86FAC91F5CE7CF327E36A591'
  }
  $dependencies = @($desktopAppInstaller, $vcLibsUwp, $uiLibsUwp)
  Write-Host '--> Checking dependencies'
  foreach ($dependency in $dependencies) {
    $dependency.file = Join-Path -Path $tempFolder -ChildPath $dependency.fileName
    if (-Not ((Test-Path -Path $dependency.file -PathType Leaf) -And $dependency.hash -eq $(Get-FileHash $dependency.file).Hash)) {
      Write-Host @"
    - Downloading:
      $($dependency.url)
"@
      try {
        $WebClient.DownloadFile($dependency.url, $dependency.file)
      }
      catch {
        #Pass the exception as an inner exception
        throw [System.Net.WebException]::new("Error downloading $($dependency.url).", $_.Exception)
      }
      if (-not ($dependency.hash -eq $(Get-FileHash $dependency.file).Hash)) {
        throw [System.Activities.VersionMismatchException]::new('Dependency hash does not match the downloaded file')
      }
    }
  }

  if (-Not (Test-Path (Join-Path -Path $tempFolder -ChildPath \Microsoft.UI.Xaml.2.7\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx)))	{
    Expand-Archive -Path $uiLibsUwp.file -DestinationPath ($tempFolder + '\Microsoft.UI.Xaml.2.7') -Force
  }
  $uiLibsUwp.file = (Join-Path -Path $tempFolder -ChildPath \Microsoft.UI.Xaml.2.7\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx)
  Add-AppxPackage -Path $($desktopAppInstaller.file) -DependencyPath $($vcLibsUwp.file), $($uiLibsUwp.file)
  Remove-Item $tempFolder -recurse -force
}
Write-Host -ForegroundColor Green "--> Updating Winget`n"
Install-Winget

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
