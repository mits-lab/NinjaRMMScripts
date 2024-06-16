# NinjaOne Script to Install Outlook2019 Package to Endpoint
# 
# version 2024060303
#

# Download installer to Local directory

$DownloadURL = "https://files.example.com/Outlook%202019%20%2864bit%29-English.zip"
$DownloadLocation = "C:\MITS-Outlook2019\"
$Configurexml = Ninja-Property-Docs-Get 'Application' 'Outlook2019' Configurationxml

# Test DownloadLocation to make sure that nothing is overwritten, create folder if missing, and download zip from file server

function InstalledCheck
{
if (Test-Path "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE") 
    {
            Write-Output "!!! Outlook2019 Client: Outlook 2019 client is already installed. No actions taken. !!!"
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
        New-Item $DownloadLocation -ItemType Directory -Force;
    }
}

TempPath;

# Download application package to $DownloadLocation

Invoke-Webrequest -Uri $DownloadURL -OutFile "$($DownloadLocation)\Outlook2019.zip" 

# Unzip the app

Expand-Archive -Path "$DownloadLocation\Outlook2019.zip" -DestinationPath "$DownloadLocation\"

# Specify the pwd for the running shell to permit the installer to access its local 'configuration' file.

Set-Location -Path $DownloadLocation\English_64\

# Replace default Configuration.xml with client version. 

$Configurexml | Out-file -FilePath "$DownloadLocation\English_64\Configuration.xml" -Force

# Executing msiexec command to install Comet backup using unique username and password for each user

Start-Process "$DownloadLocation\English_64\setup.exe" -ArgumentList "/configure $DownloadLocation\English_64\Configuration.xml"

# Log app installation in RMM

$date = Get-Date | Out-String
Ninja-Property-Set outlook2019installdate $date
