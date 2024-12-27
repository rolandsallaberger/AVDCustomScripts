Set-MpPreference -DisableRealtimeMonitoring $true
dir \\vmbmd01.ad.heschik.at\BMDSourcesTemporary >c:\dirbmd.txt
\\vmbmd01.ad.heschik.at\BMDSourcesTemporary\BMDNetClient.exe /SILENT /localntcs=Y /localntcsx64=Y /localntcsupdate=Y /localmacros=Y /pdfdriver=Y /desktoplinks=Y
start-sleep -seconds 600
