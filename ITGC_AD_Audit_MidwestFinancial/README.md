# ITGC & Active Directory Audit Simulation

A mock IT General Controls (ITGC) audit performed against a self-built Active Directory
lab environment (1,000+ user population), modeled on real consulting audit methodology
and mapped to NIST SP 800-53 and AICPA SOC 1/2 testing standards.

## Scope

- **Client (fictional):** Midwest Financial Services
- **System in scope:** Active Directory Domain Controller (DC-01)
- **Testing date:** September 28, 2026
- **Standards referenced:** NIST SP 800-53 Rev. 5 (AC-2, AC-6, CM-3, AU-2, AU-6)

## Summary of Findings

| Control ID | Control Area | Result | Risk Rating |
|---|---|---|---|
| ITGC-AC-01 | Terminated/inactive account management | Exception | High |
| ITGC-AC-02 | Privileged access (Domain/Enterprise Admins) | Exception | High |
| ITGC-CM-01 / AU-01 | Change management & audit logging | Pass | Medium |

**ITGC-AC-01:** 3 of 3 sampled terminated accounts remained enabled and showed active
logons 18–113 days after their stated termination date.

**ITGC-AC-02:** 2 of 4 Domain Admins members (`chydrick`, `alowenthal`) were not on the
approved admin roster; 0 exceptions in Enterprise Admins after correcting a false-positive
in the initial approved-list definition.

**ITGC-CM-01/AU-01:** Privileged group membership changes were accurately captured in the
Windows Security event log (Event ID 4728) with correct actor, target, and timestamp detail.

## Repository Structure

```
ITGC_AD_Audit_MidwestFinancial/
├── 01_Workpaper/
│   └── ITGC_Audit_Workpaper_Final.xlsx        # Full workpaper + CCER findings
├── 02_Report/
│   └── Executive_Audit_Summary_Final.docx     # Finalized report, no placeholders
├── 03_Evidence/
│   ├── ITGC-AC-01_TerminatedAccountTest.csv
│   ├── AD_FullPopulation_InactiveScan.csv
│   ├── ITGC-AC-02_DomainAdminsRoster.csv
│   ├── ITGC-AC-02_EnterpriseAdminsRoster.csv
│   ├── ITGC-AC-02_Exceptions2.csv
│   ├── ITGC-AC-02_Enterprise-Exceptions.csv
│   └── ITGC-CMO1-AU01_EventLogEvidence.csv
├── 04_Scripts/
│   ├── 01_ITGC-AC-01_TerminatedAccountTest.ps1
│   ├── 02_ITGC-AC-02_PrivilegedAccessTest.ps1
│   └── 03_ITGC-CM01-AU01_ChangeLoggingTest.ps1
└── 05_Screenshots/                             # Exhibits A–H, cited in the report appendix
    ├── 01_AC01_OU-Structure_and_RandomSampleSelection.png
    ├── 02_AC01_ADUC_TerminatedAccount_Description-Tag.png
    ├── 03_AC01_PowerShell_TestResults_Export.png
    ├── 04_AC02_RandomSampleSelection_DomainAdminsTest.png
    ├── 05_AC02_ADUC_alowenthal_MemberOf_DomainAdmins.png
    ├── 06_CM01_GPO_AccountLockoutPolicy_Change.png
    ├── 07_AU01_EventID4728_PowerShell_Evidence.png
    └── 08_AU01_EventID4728_EventViewer_chydrick.png
```

## Methodology

Testing followed AICPA SOC 1/2 approach: **inquiry** (reviewing simulated HR/IT process),
**observation** (executing changes live in the lab), and **inspection** (reviewing exported
AD data and Windows Security event logs as evidence). Each control test was scripted in
PowerShell against the `ActiveDirectory` module, with results exported to CSV as audit
evidence and cited directly in the workpaper.

## Notable methodology note

During ITGC-AC-02 testing, the first test pass flagged an account (`a-jbassey`) as an
exception that was, in fact, a legitimately issued admin account — the approved-admin
comparison list used in testing was initially incomplete. This was caught, the baseline
was corrected, and the test was re-run before finalizing results. Included here
deliberately, since validating your own comparison baseline before trusting output is a
real part of the job.
