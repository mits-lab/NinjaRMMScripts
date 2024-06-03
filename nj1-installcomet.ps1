# NinjaOne Script to Install Comet backup
# 
# version 1.03
#

# Download installer to Local directory

$DownloadURL = "https://files.monocleitsolutions.com/s/5yWoGYq6Neeej6y/download/DATACAGE%20LIT3%2024.2.3.zip"
$DownloadLocation = "C:\MITSCB\"
$date = Get-Date | Out-String

# Test DownloadLocation to make sure that nothing is overwritten, create folder if missing, and download zip from file server.

function InstalledCheck
{
if (Test-Path "C:\Program Files\DATACAGE LITE\launch.exe") 
    {
        Write-Output "=== CometAgent: Comet Agent is currently installed. No actions taken. ==="
        Exit
    } 
     else 
    {
    }
}

InstalledCheck;

function TempPath
{
    if(Test-Path $DownloadLocation)
    {
        Get-ChildItem -Path $DownloadLocation -File -Recurse | Remove-Item -Force;
    }
    else
    {
        New-Item $DownloadLocation -ItemType Directory -force;
    }
}

TempPath;

# Download application package to $DownloadLocation

Invoke-Webrequest -Uri $DownloadURL -OutFile "$($DownloadLocation)\DATACAGELITE_24.2.3.zip" 

# Specify the pwd for the running shell to permit the installer to access its local .dat file.

Set-Location -Path $DownloadLocation

# Unzip the app

Expand-Archive -Path "$DownloadLocation\DATACAGELITE_24.2.3.zip" -DestinationPath "$DownloadLocation\"

# Executing msiexec command to install Comet backup using unique username and password for each user

Start-Process "$DownloadLocation\install.exe" -ArgumentList "/S", "/LOBBY", "/SHORTCUT=disable", "/TRAYICON=disable", "/SERVER='https://comet.monocleitsolutions.com/'"

# Log app installation

Ninja-Property-Set cometinstalldate $date
