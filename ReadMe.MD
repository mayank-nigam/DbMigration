# k19 (MySMS) — Multi-Tenancy to Single-Tenancy Migration

> **Project:** MySMS CRM Platform — Database Architecture Migration  
> **From:** Multi-tenant shared databases on SQL Server 2019 Standard (on-premises)  
> **To:** Single-tenant per-client databases on Azure SQL Database  
> **Server:** K19Prod — `aznetpocdbs01` (20.244.xxx.xx)  
> **Replica:** K19ReplicaWeb — `AZNETPOCDBS04` (20.244.yyy.yyy)  
> **Pilot Client:** ParentID `34594` (internal test account)  
> **Active Clients:** ~420 ParentIDs confirmed from `MySMS.dbo.UserLeads`

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Current Architecture](#2-current-architecture)
3. [Target Architecture](#3-target-architecture)
4. [Databases in Scope](#4-databases-in-scope)
5. [Migration Strategy — Two Phases](#5-migration-strategy--two-phases)
6. [Known Compatibility Issues](#6-known-compatibility-issues)
7. [Pre-Migration Fixes Required](#7-pre-migration-fixes-required)
8. [SQL Agent Jobs — Replacement Plan](#8-sql-agent-jobs--replacement-plan)
9. [Data Exclusions — Confirmed](#9-data-exclusions--confirmed)
10. [Pilot Client — ParentID 34594](#10-pilot-client--parentid-34594)
11. [Elastic Pool Sizing](#11-elastic-pool-sizing)
12. [Rollback Plan](#12-rollback-plan)
13. [Pending Items](#13-pending-items)
14. [Key Contacts](#14-key-contacts)

---

## 1. Project Overview

MySMS is a multi-tenant CRM platform where all clients share the same set of databases, isolated by `ParentID` column filtering. The goal of this project is to migrate each client into their own dedicated database (`MySMS_{ParentID}`) on Azure SQL Database, improving isolation, security, performance, and scalability.

**Post-migration architecture:**
- ~420 databases total (one per active client)
- Naming convention: `MySMS_{ParentID}` (e.g. `MySMS_34594`)
- Each client database contains all modules: leads, enquiries, conversations, audit, invoicing, reports, HR, social, email
- Each client database has its own dedicated SQL login

---

## 2. Current Architecture

```
K19Prod (aznetpocdbs01)
├── MySMS              — Core CRM (6,830 tables, 7,291 SPs)
├── MySMSAudit         — Audit trail (3,669 tables, 7,475 SPs)
├── MySMSInvoicing     — Billing (73 tables, 132 SPs)
├── MySMSReport        — Campaign/report data (144 tables, 3.7B rows)
├── MySMSReportCache   — Pre-computed report cache (106 tables, 195M rows)
├── MysmsTimeTrack     — Time tracking (17 tables, 74 SPs)
├── kit19HR            — HR module (26 tables, 84 SPs)
├── Kit19Social        — Social media integration (29 tables, 92 SPs)
└── MYSMST             — Email integration module (1,056 tables total; 9 tables + 90 SPs in scope)

K19ReplicaWeb (AZNETPOCDBS04)
└── MySMSConversations — WhatsApp/conversations (1,135 tables, 756 SPs)
```

**Replication:** 3 transactional publications (MySMS_PUB 73 tables, PUB_2 14 tables, PUB_3 17 tables) pushing from K19Prod to K19ReplicaWeb. **Confirmed for decommission after migration.**

**Per-client table pattern:** Many tables follow `tbl_tp_TicketMaster_{ParentID}` naming. These are extracted per client during migration.

---

## 3. Target Architecture

```
Azure SQL Database
├── MySMS_34594        — All modules for ParentID 34594
├── MySMS_46831        — All modules for ParentID 46831
├── MySMS_{ParentID}   — One database per client (~420 total)
└── ...

Elastic Pools
├── Pool 1 — HIGH activity (~85 clients)   → Premium P4 500 eDTU
├── Pool 2 — MID activity (~55 clients)    → Premium P2 250 eDTU
└── Pool 3 — LOW/dormant (~280 clients)    → Standard S3 or Serverless
```

**K19ReplicaWeb** stays as a consolidated read replica. Azure SQL DB Premium readable secondary replaces the replication feed.

---

## 4. Databases in Scope

All 10 databases are consolidated into **one database per client**:

| Database | Tables | SPs | Per-Client Tables | Total Rows | Notes |
|---|---|---|---|---|---|
| MySMS | 6,830 | 7,291 | 564 | — | Core CRM |
| MySMSConversations | 1,135 | 756 | 52 | — | On K19ReplicaWeb |
| MySMSAudit | 3,669 | 7,475 | 1 per client (`tbl_Audit_{ParentID}`) | 18M | Per-client audit tables |
| MySMSInvoicing | 73 | 132 | 54 | 81K | |
| MySMSReport | 144 | 96 | 33 | 3.7B | Heavy — see exclusions |
| MySMSReportCache | 106 | 47 | 98 | 195M | Archive tables migrate; 24 cache tables excluded |
| MysmsTimeTrack | 17 | 74 | 1 | — | |
| kit19HR | 26 | 84 | 0 | 3 | Skeleton module — minimal data |
| Kit19Social | 29 | 92 | 5 | 55K | 45 SPs cross-ref MySMS — resolved by consolidation |
| MYSMST (email only) | 9 | 90 | — | 3.7M | Only 9 tables + 90 SPs in scope; rest of 1,056 tables ignored |

---

## 5. Migration Strategy — Two Phases

### Phase 1 — Local SQL Server Pre-Validation

1. Create `MySMS_34594` on local SQL Server
2. Set compatibility level to 150:
   ```sql
   ALTER DATABASE MySMS_34594 SET COMPATIBILITY_LEVEL = 150;
   ```
3. Migrate schema and data for ParentID `34594`
4. Apply all pre-migration fixes (see Section 7)
5. Point application to local `MySMS_34594`
6. Run three test rounds:
   - **Compatibility Test** — all SPs, views, functions execute without errors
   - **Performance Test** — key SPs vs K19Prod baseline (`automatedmails`, `MassOperations`, `usp_SmsDeliveryReportUpdateByJob`, `JobTicketSLA`)
   - **Smoke Test** — end-to-end: login, lead creation, campaign execution, ticket management, reporting
7. Fix all issues found before proceeding to Phase 2

> ⚠️ Local SQL Server validation does not fully emulate Azure SQL Database behaviour. Final validation must still be performed after migration to Azure.

### Phase 2 — Azure SQL Database Migration

1. Migrate validated local `MySMS_34594` to Azure SQL Database
2. Perform Azure-side validation: compatibility, performance, connectivity, application behaviour
3. Run parallel with K19Prod for 7 days before decommissioning K19Prod data for this client
4. On success — proceed to next batch of clients

---

## 6. Known Compatibility Issues

Full details in `Azure_Master_Tracker_Final.docx`. Summary:

| # | Issue | Priority | Status |
|---|---|---|---|
| 1 | Hardcoded `P@ssword3110` in 108 SPs | P1 ⚠️ Security | Rotate now |
| 2 | Plaintext passwords in `User_detail.Pwd` | P1 ⚠️ Security | Hash before migration |
| 3 | App routing via `User_detail.ParentID` | P1 Go-live blocker | App team to implement |
| 4 | SQL Server Linked Servers (13) | P1 | Audit SP callers |
| 5 | Service Broker — MySMSConversations (185 queues) | P1 | Azure Service Bus |
| 6 | Service Broker — MySMS (~210 queues) | P1 | Azure Service Bus |
| 7 | SqlQueryNotification queues (~100) | P1 | Azure SignalR — app team |
| 8 | SQL Agent Jobs — K19Prod (128 active) | P2 | See Section 8 |
| 9 | SQL Agent Jobs — K19ReplicaWeb (22) | P2 | See Section 8 |
| 10 | Database Mail — 13 SPs | P2 | Azure Monitor + Logic App |
| 11 | OPENROWSET — 50+ SPs | P2 | Resolves by consolidation |
| 12 | `##Global` temp tables — 83 SPs | P2 | Replace `##` with `#` |
| 13 | Cross-DB references — 488 objects | P2 | Resolves by consolidation |
| 14 | SSIS Maintenance Plan jobs — 5 | P2 | Azure Data Factory or T-SQL |
| 15 | Transactional Replication (3 pubs, 104 tables) | P2 | Decommission confirmed |
| 16 | `xp_cmdshell` — 3 SPs | P3 | Drop all 3 |
| 17 | OLE Automation job (every 1 min) | P3 | Investigate + remove |
| 18 | Collation — `Latin1_General_BIN` in 1 SP | P3 | Test post-migration |
| 19 | Startup SPs — 2 | P4 | Drop after replication removed |
| 20 | Windows Auth — 6 orphaned users | P4 | Drop before migration |
| 21 | SSRS | ✅ Clean | Not installed |
| 22 | File storage | ✅ Clean | Already on `docs.kit19.com` CDN |
| 23 | CLR / FileStream / Synonyms | ✅ Clean | None found |

---

## 7. Pre-Migration Fixes Required

These must be applied **before** testing begins in Phase 1:

### Fix 1 — Replace ##global temp tables (83 SPs)
```sql
-- Find all SPs using ##global temp tables in MySMS
SELECT name FROM sys.procedures
WHERE OBJECT_DEFINITION(object_id) LIKE '%##%'
ORDER BY name;
-- Replace ## with # in each SP definition
```

### Fix 2 — Remove hardcoded credentials (108 SPs)
```sql
-- Find all SPs with hardcoded password
SELECT name FROM sys.procedures
WHERE OBJECT_DEFINITION(object_id) LIKE '%P@ssword3110%'
ORDER BY name;
-- Rotate kit19 password + remove from SP definitions
```

### Fix 3 — Hash passwords in User_detail
```sql
-- Confirm plaintext passwords exist
SELECT TOP 5 User_Login, Pwd FROM User_detail WHERE ParentID = 34594;
-- Coordinate hashing algorithm with app team before updating
```

### Fix 4 — Drop orphaned Windows users
```sql
USE MySMS;
DROP USER [PELSOFTLAB\shekhar];
DROP USER [PELSOFTLAB\sunils];
DROP USER [PELSOFTLAB\SMSREPORT$];
DROP USER [WSERVER142-IND\sanjay];
DROP USER [WSERVER142-IND\santosh];
DROP USER [WSERVER142-IND\backupuser];
GO
```

### Fix 5 — Drop temporary replication database
```sql
-- One week reminder — drop MySMS_Repl on K19Prod
-- Located at H:\MySMSReplication\MySMS_Repl
DROP DATABASE MySMS_Repl;
```

---

## 8. SQL Agent Jobs — Replacement Plan

| Category | Count | Azure Replacement |
|---|---|---|
| Business logic jobs | 68 | Azure Elastic Jobs |
| Real-time jobs (every 1–5 min) | 8 | Azure Functions (timer trigger) |
| DBA monitoring jobs | 13 | Azure Monitor Alerts |
| Archive / cleanup jobs | 18 | Azure Elastic Jobs |
| Backup jobs | 6 | ✅ Delete — Azure auto-backup |
| Replication agent jobs | 12 | ✅ Delete — replication removed |
| SSIS Maintenance Plan jobs | 5 | Azure Data Factory or T-SQL rewrite |
| Misc / no-schedule | 5 | Review individually |

**Real-time jobs (Azure Functions):**
`automatedmails` (5min), `MassOperations` (1min), `getscheduledmails` (5min), `processmktsequence` (1min), `usp_ExecLeadInteractionTriggerTasks_multi_lihid_async` (1min), `usp_force_run_taskid` (1min), `usp_playCRMpipelineVoice` (5min), `usp_SmsDeliveryReportUpdateByJob` (10min)

---

## 9. Data Exclusions — Confirmed

All confirmed by Mayank:

| Table / Data | Action | Reason |
|---|---|---|
| `_23042026` suffix tables in MySMSReport | ❌ Do not migrate | Temporary data dump (confirmed by Mayank) |
| `ParentID = 0` rows in MySMSReport | ❌ Drop before migration | No client owner |
| 24 `_Cache` tables in MySMSReportCache | ❌ Do not migrate — regenerate | Nightly `Report_Cache_Job` rebuilds these |
| `MySMSReportCache` Archive tables | ✅ Migrate | Historical data — cannot regenerate |
| MYSMST — 1,047 tables outside email module | ❌ Ignore | Only 9 tables + 90 SPs confirmed in scope |
| `MySMS_Dev_Migration` database | ❌ Ignore | Offline dev database |

---

## 10. Pilot Client — ParentID 34594

Internal test account. Data confirmed clean for migration:

| Database | Table | Rows | Action |
|---|---|---|---|
| MySMS | UserLeads | 1,464 | ✅ Migrate |
| MySMS | UserEnquiry | 6,376 | ✅ Migrate |
| MySMS | LeadInteractionHistory_latest | 3,118 | ✅ Migrate |
| MySMS | User_detail | 83 accounts | ✅ Migrate |
| MySMSReport | UserCampaignHistory_Archive | 1,356,664 | ⚠️ Optional — truncate for faster pilot |
| MySMSReport | usercampaignhistory | 0 | ✅ Empty — nothing to migrate |
| MySMSReport | UserLeads_23042026 | 612,031 | ❌ Do not migrate — temp dump |
| MySMSAudit | tbl_Audit_34594 | ~18M | ✅ Migrate — internal logins from `182.75.38.29` |
| Child accounts | — | 0 | ✅ No child accounts |

**Do not use as pilot:** ParentID `335` (41.2M rows), `16301` (37.9M rows), `28665` (34.6M rows) — heaviest data clients.

---

## 11. Elastic Pool Sizing

Based on activity data from `MySMS.dbo.UserLeads` on K19Prod:

| Pool | Clients | Tier | Est. Monthly Cost |
|---|---|---|---|
| Pool 1 — HIGH (active last 30 days) | ~85 | Premium P4 — 500 eDTU | ~$1,550/mo |
| Pool 2 — MID (30–90 days) | ~55 | Premium P2 — 250 eDTU | ~$465/mo |
| Pool 3 — LOW / dormant (90+ days) | ~280 | Standard S3 or Serverless | ~$150/mo |
| Shared services (Jobs, Functions, Bus, Logic Apps) | — | — | ~$210/mo |
| **Total** | **~420 clients** | | **~$2,375/mo** |

---

## 12. Rollback Plan

Five-stage parallel run. K19Prod stays active throughout:

| Stage | K19Prod | Azure DB | Action |
|---|---|---|---|
| 1 — Setup | ✅ Active | Schema only | Create DB, deploy schema, validate |
| 2 — Dry run | ✅ Active | Test data | Migrate data, run jobs, compare output |
| 3 — Dual write | ✅ Active (source) | ✅ Active (shadow) | App writes to both, compare daily |
| 4 — Cutover | 🟡 Standby (read-only) | ✅ Primary | Switch traffic to Azure, K19Prod on standby 7 days |
| 5 — Decommission | ❌ Remove client data | ✅ Active | Only after 7 days zero issues |

**Rollback trigger:** Any data mismatch, SP failure, or performance issue → switch traffic back to K19Prod in under 5 minutes.

---

## 13. Pending Items

| Item | Status |
|---|---|
| Mayank's 6 pre-migration questions | ⏳ Awaiting reply |
| Create `MySMS_34594` on local SQL Server | ⏳ Jay's action |
| Drop `MySMS_Repl` temporary database on K19Prod | ⏳ 1-week reminder |
| App team — ParentID-based DB routing implementation | ⏳ Mayank's app team |
| Password hashing for `User_detail.Pwd` | ⏳ Coordinate with app team |
| `##global` temp table fix across 83 SPs | ⏳ Before Phase 1 testing |

---

## 14. Key Contacts

| Role | Name | Notes |
|---|---|---|
| Database Architect | Jayakumar | Migration planning, audit, compatibility assessment |
| Application & Infrastructure | Mayank Nigam | Client-side decisions, app team coordination |

---

*Last updated: May 2026 — based on direct audit of K19Prod (aznetpocdbs01) and K19ReplicaWeb (AZNETPOCDBS04)*
