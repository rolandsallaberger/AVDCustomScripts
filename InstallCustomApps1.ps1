Write-Host "Installing Custom Apps..."
Write-Host "Installing Choco"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install 7zip.install -y
choco install foxitreader -y
choco install filezilla -y
choco install greenshot -y --execution-timeout 300
choco install office365business --params "'/productid:O365BusinessEEANoTeamsRetail /exclude:Access Groove Lync Onedrive /language:de-de /updates:true /eula:true'" -y

New-Item -Type Directory -Path "c:\\" -Name temp
invoke-webrequest -uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile "c:\\temp\\azcopy.zip"
Expand-Archive "c:\\temp\\azcopy.zip" "c:\\temp"
copy-item "C:\\temp\\azcopy_windows_amd64_*\\azcopy.exe\\" -Destination "c:\\temp" 

Write-Host "Installing Custom Apps...done"
Exit 0
