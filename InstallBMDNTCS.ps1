Set-MpPreference -DisableRealtimeMonitoring $true
net use \\10.91.0.4\BMDSourcesTemporary /user:vmbmd01\bmdinstall safdmnk3DAN##a3324
dir \\10.91.0.4\BMDSourcesTemporary >c:\dirbmd.txt
\\10.91.0.4\BMDSourcesTemporary\BMDNetClient.exe /SILENT /localntcs=Y /localntcsx64=Y /localntcsupdate=Y /localmacros=Y /pdfdriver=Y /desktoplinks=Y
start-sleep -seconds 600
$infPath = "\\10.91.0.4\Install\PrinterDriver\Universal PCL6 x64 Multi-Lingual driver\KOAWUJ__.inf"
pnputil.exe -a $infPath
Add-PrinterDriver -name "KONICA MINOLTA Universal PCL"
