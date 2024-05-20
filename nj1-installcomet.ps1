# NinjaOne Script to Install Comet backup
# 
# version 1.03
#

# Download installer to Local directory

$DownloadURL = "https://files.monocleitsolutions.com/s/5yWoGYq6Neeej6y/download/DATACAGE%20LITE%2024.2.3.zip"
$DownloadLocation = "C:\MITSCB\2024.2.3\"
$date = Get-Date | Out-String

# Test DownloadLocation to make sure that nothing is overwritten, create folder if missing, and download zip from file server

function TempPath
{
    if(Test-Path $DownloadLocation)
    {
        Remove-Item "$DownloadLocation\*";
    }
    else
    {
        New-Item $DownloadLocation -ItemType Directory -force;
    }
}

TempPath;

function InstalledCheck
{
if (Test-Path "C:\Program Files\DATACAGE LITE\launch.exe") 
    {
	        Ninja-Property-Set CometAgentFailedInstall $Date
            Write-Output "===== CometAgent: Comet Agent is currently installed. No actions taken."
            Exit
    } 
     else 
    {
    }
}

InstalledCheck;

# Download application package to $DownloadLocation

Invoke-Webrequest -Uri $DownloadURL -OutFile "$($DownloadLocation)\DATACAGELITE_24.2.3.zip" 

# Specify the pwd for the running shell to permit the installer to access its local .dat file.

Set-Location -Path $DownloadLocation

# Unzip the app

Expand-Archive -Path "$DownloadLocation\DATACAGELITE_24.2.3.zip" -DestinationPath "$DownloadLocation\"

# Executing msiexec command to install Comet backup using unique username and password for each user

Start-Process "$DownloadLocation\install.exe" -ArgumentList "/S", "/LOBBY", "/SHORTCUT=disable", "/TRAYICON=disable"

# Log app installation

Ninja-Property-Set CometbackupInstalled $date
