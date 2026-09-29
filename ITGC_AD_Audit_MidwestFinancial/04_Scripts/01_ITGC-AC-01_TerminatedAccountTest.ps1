<#
.SYNOPSIS
    ITGC-AC-01: Tests whether terminated/inactive employees have lost AD access.
.DESCRIPTION
    Simulates comparing an HR termination list against live AD account status.
    Run as Administrator with the ActiveDirectory module loaded.
#>

Import-Module ActiveDirectory

# --- Setup ---
New-Item -Path "C:\ITGC_Audit" -ItemType Directory -Force | Out-Null

# --- Step 1: (one-time) tag 3 accounts as simulated terminations ---
# Set-ADUser -Identity "gcockrum"     -Description "TERMINATED 2026-06-07 - ITGC lab test account"
# Set-ADUser -Identity "cphilbrook"   -Description "TERMINATED 2026-07-08 - ITGC lab test account"
# Set-ADUser -Identity "mwatlington"  -Description "TERMINATED 2026-09-10 - ITGC lab test account"

# --- Step 2: the "HR termination list" ---
$TermList = @("gcockrum", "cphilbrook", "mwatlington")

# --- Step 3: compare HR list against AD reality ---
$Results = foreach ($user in $TermList) {
    Get-ADUser -Identity $user -Properties Enabled, LastLogonDate, Description |
        Select-Object Name, SamAccountName, Enabled, LastLogonDate, Description
}

$Results | Export-Csv -Path "C:\ITGC_Audit\ITGC-AC-01_TerminatedAccountTest.csv" -NoTypeInformation
$Results | Format-Table -AutoSize

# --- Step 4 (optional): full-population inactivity scan ---
Get-ADUser -Filter * -SearchBase "OU=Users,DC=joshdomain,DC=com" -Properties LastLogonDate, Enabled, Created |
    Where-Object { $_.Enabled -eq $true -and ($_.LastLogonDate -eq $null -or $_.LastLogonDate -lt (Get-Date).AddDays(-90)) } |
    Select-Object Name, SamAccountName, Enabled, Created, LastLogonDate |
    Export-Csv -Path "C:\ITGC_Audit\AD_FullPopulation_InactiveScan.csv" -NoTypeInformation
