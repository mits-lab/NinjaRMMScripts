# NinjaOne Script to Install Keeper Desktop
# 
# version 2024060303
#

# !!! The script uses an Appx (appx links auto update) package so it must be run as a specific user. The script will need to be rerun for each user on a given system who would like to use the software. !!!

# Download installer to Local directory

$DownloadURL = "https://www.keepersecurity.com/desktop_electron/packages/KeeperPasswordManager.appinstaller"
$DownloadLocation = "C:\MITSKPR\"
$date = Get-Date | Out-String

# Test DownloadLocation to make sure that nothing is overwritten, create folder if missing, and download zip from file server

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

function InstalledCheck
{
if (Test-Path "C:\Program Files\DATACAGE LITE\launch.exe") 
    {
            Write-Output "=== Keeper Desktop Installer: Application is already installed. No actions taken. ==="
            Exit
    } 
     else 
    {
    }
}

InstalledCheck;

# Download application package to $DownloadLocation

Invoke-Webrequest -Uri $DownloadURL -OutFile "$($DownloadLocation)\KeeperPasswordManager.appinstaller" 

# Specify the pwd for the running shell to permit the installer to access its local .dat file.

Set-Location -Path $DownloadLocation

# Executing msiexec command to install Comet backup using unique username and password for each user

Add-AppxPackage -AppInstallerFile .\KeeperPasswordManager.appinstaller

# Log app installation

Ninja-Property-Set keeperinstalldate $date
