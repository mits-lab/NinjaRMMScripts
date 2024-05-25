<#
    .SYNOPSIS
        Monitoring - Windows - Battery Health
    .DESCRIPTION
        This script will monitor the health of the battery in a Windows device and report back to NinjaOne.
    .NOTES
        2022-02-15: Initial version
    .LINK
        Blog post: https://homotechsual.dev/2022/12/22/NinjaOne-custom-fields-endless-possibilities/
#>
[CmdletBinding()]
param(
    # Path to output battery report files to.
    [System.IO.DirectoryInfo]$OutputPath = 'C:\MITS-Data\Battery'
)

if (-not (Test-Path -Path $OutputPath)) {
    New-Item -Type Directory -Path $OutputPath | Out-Null
}

& powercfg /batteryreport /XML /OUTPUT "$OutputPath\batteryreport.xml" | Out-Null

[xml]$Report = Get-Content "$OutputPath\batteryreport.xml"
     
$BatteryStatus = $Report.BatteryReport.Batteries.Battery | ForEach-Object {
    [PSCustomObject]@{
        DesignCapacity = [int]$_.DesignCapacity
        FullChargeCapacity = [int]$_.FullChargeCapacity
        CycleCount = [int]$_.CycleCount
        Id = $_.id
    }
}

if (!$BatteryStatus) {
    Ninja-Property-Set hasbatteries false | Out-Null
    Write-Output 'No batteries found.'
} else {
    Ninja-Property-Set hasbatteries true | Out-Null
}

$Battery = @{}

if ($BatteryStatus.Count -gt 1) {
    Ninja-Property-Set additionalbattery true | Out-Null
    $Battery = $BatteryStatus[0]
    Write-Output 'More than 1 battery found.'
} elseif ($BatteryStatus.Count -eq 1) {
    Ninja-Property-Set additionalbattery false | Out-Null
    Write-Output 'One battery found.'
    $Battery = $BatteryStatus[0]
} elseif ($BatteryStatus.Id) {
    Ninja-Property-Set additionalbattery false | Out-Null
    $Battery = $BatteryStatus
}

if ($Battery) {
    Write-Output 'Setting NinjaOne custom fields for first battery.'
  
    Ninja-Property-Set batteryidentifier $Battery.id | Out-Null
    Ninja-Property-Set batterydesigncapacity $Battery.DesignCapacity | Out-Null
    Ninja-Property-Set batteryfullchargecapacity $Battery.FullChargeCapacity | Out-Null

    [int]$HealthPercent = ([int]$Battery.FullChargeCapacity / [int]$Battery.DesignCapacity) * 100

    Ninja-Property-Set batteryhealthpercent $HealthPercent | Out-Null
    Ninja-Property-Set batterycyclecount $Battery.CycleCount | Out-Null
} else {
    Write-Output 'Failed to parse battery status correctly.'
}
