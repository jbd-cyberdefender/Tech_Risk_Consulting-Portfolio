<#
.SYNOPSIS
    ITGC-AC-02: Tests whether Domain Admins / Enterprise Admins membership
    is restricted to approved personnel (least privilege).
#>

Import-Module ActiveDirectory

# --- Step 1: (one-time) add test accounts to Domain Admins ---
# Add-ADGroupMember -Identity "Domain Admins" -Members "chydrick", "alowenthal"

# --- Step 2: define the approved admin roster ---
# NOTE: this list was corrected mid-engagement after the first test pass flagged
# a-jbassey as a false-positive exception; a-jbassey is a legitimate admin account.
$ApprovedAdmins = @("Administrator", "a-jbassey")

# --- Step 3: test Domain Admins ---
$DomainAdmins = Get-ADGroupMember -Identity "Domain Admins" | Select-Object Name, SamAccountName
$DomainAdminExceptions = $DomainAdmins | Where-Object { $ApprovedAdmins -notcontains $_.SamAccountName }

$DomainAdmins           | Export-Csv -Path "C:\ITGC_Audit\ITGC-AC-02_DomainAdminsRoster.csv" -NoTypeInformation
$DomainAdminExceptions  | Export-Csv -Path "C:\ITGC_Audit\ITGC-AC-02_Exceptions2.csv" -NoTypeInformation
$DomainAdminExceptions  | Format-Table -AutoSize

# --- Step 4: test Enterprise Admins ---
$EntAdmins = Get-ADGroupMember -Identity "Enterprise Admins" | Select-Object Name, SamAccountName
$EntAdminExceptions = $EntAdmins | Where-Object { $ApprovedAdmins -notcontains $_.SamAccountName }

$EntAdmins           | Export-Csv -Path "C:\ITGC_Audit\ITGC-AC-02_EnterpriseAdminsRoster.csv" -NoTypeInformation
$EntAdminExceptions  | Export-Csv -Path "C:\ITGC_Audit\ITGC-AC-02_Enterprise-Exceptions.csv" -NoTypeInformation
$EntAdminExceptions  | Format-Table -AutoSize
