<#
.SYNOPSIS
    ITGC-CM-01 / AU-01: Tests whether privileged group / GPO changes
    are captured in the Windows Security audit log.
#>

# --- Step 1: check which advanced audit subcategories are enabled ---
auditpol /get /category:"DS Access","Account Management"

# --- Step 2: pull Event ID 4728 (security-enabled global group member added) ---
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4728} -MaxEvents 10 |
    Select-Object TimeCreated, Id, Message |
    Format-List

Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4728} -MaxEvents 10 |
    Select-Object TimeCreated, Id, Message |
    Export-Csv -Path "C:\ITGC_Audit\ITGC-CMO1-AU01_EventLogEvidence.csv" -NoTypeInformation

# --- Step 3 (optional): pull Event ID 5136 (directory service object modified / GPO changes) ---
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=5136} -MaxEvents 10 |
    Select-Object TimeCreated, Id, Message |
    Format-List
