# NinjaOne Script to Install SentinelOne
# 
# version 1.02
#

#Establish variable called from documentation fields

$packageid = Ninja-Property-Docs-Get 'Applications' 'SentinelOne' packageID 

#installer variables

$DownloadURL = "https://files.monocleitsolutions.com/s/YJoyrYMXrF93e28/download/SentinelInstaller_windows_64bit_v23_4_2_216.msi"
$DownloadLocation = "C:\MITSS1\23.4.2\" 

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

# Download application package to $DownloadLocation

Invoke-Webrequest -Uri $DownloadURL -OutFile "$($DownloadLocation)\SentinelInstaller_windows_64bit_v23_4_2_216.msi" 

# Specify the pwd for the running shell to permit the installer to access its local .dat file.

Set-Location -Path $DownloadLocation

#Executing msiexec command to install S1 while using unique Site Token from each organization

msiexec.exe /i "$DownloadLocation\SentinelInstaller_windows_64bit_v23_4_2_216.msi" /qn SITE_TOKEN="$packageid"

# Add log of the installation to RMM

$date = Get-Date | Out-String
Ninja-Property-Set SentinelOneInstalled $date