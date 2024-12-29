Set-MpPreference -DisableRealtimeMonitoring $true
net use \\10.91.0.4\BMDSourcesTemporary /user:vmbmd01\bmdinstall safdmnk3DAN##a3324
dir \\vmbmd01.ad.heschik.at\BMDSourcesTemporary >c:\dirbmd.txt
\\vmbmd01.ad.heschik.at\BMDSourcesTemporary\BMDNetClient.exe /SILENT /localntcs=Y /localntcsx64=Y /localntcsupdate=Y /localmacros=Y /pdfdriver=Y /desktoplinks=Y
start-sleep -seconds 600
