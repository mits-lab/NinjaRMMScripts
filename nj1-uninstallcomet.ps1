# NinjaOne Script to Uninstall Comet backup!
# 
# version 1.01
#

# Executing process command to uninstall Comet backup 

Start-Process "C:\Program Files\Comet Backup\Uninstall.exe" /S /ISDELETECREDENTIAL=yes

# Cleaning up installation files

Get-ChildItem -Path C:\MITSCB -File -Recurse | Remove-Item

# Add log of the uninstallation to RMM

$date = Get-Date | Out-String
Ninja-Property-Set CometbackupUninstalled $date
