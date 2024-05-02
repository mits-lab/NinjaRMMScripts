# NinjaOne Script to Install Comet backup
# 
# version 1.01
#
# Download installer to Local directory
$DownloadURL = "https://files.monocleitsolutions.com/s/5yWoGYq6Neeej6y/download/DATACAGE%20LITE%2024.2.3.zip"
$DownloadLocation = "C:\MITSCB\2024.2.3\" 
# Test DownloadLocation to make sure that nothing is overwritten, create folder if missing, and download zip from file server
$TestDownloadLocation = Test-Path $DownloadLocation 
if(!$TestDownloadLocation){
new-item $Downloadlocation -ItemType Directory -force
Invoke-Webrequest -Uri $DownloadURL -OutFile "$($DownloadLocation)\DATACAGELITE_24.2.3.zip" 
}
# Unzip the app
Expand-Archive -Path "$DownloadLocation\DATACAGELITE_24.2.3.zip" -DestinationPath "$DownloadLocation\"
# Executing msiexec command to install Comet backup using unique username and password for each user
Start-Process "$DownloadLocation\install.exe" -ArgumentList "/S", "/LOBBY", "/SHORTCUT=disable", /TRAYICON="disable"
$date = Get-Date | Out-String
Ninja-Property-Set CometbackupInstalled $date
