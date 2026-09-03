# 💼 Payroll Automation & Financial Audit System

![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-blue)
![SQL](https://img.shields.io/badge/Language-PL%2FpgSQL-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## 📌 Problem Statement
Manual payroll calculation for a medium-sized enterprise created critical processing bottlenecks, human computation errors, and significant delays in monthly financial reporting. Furthermore, tracking post-processing salary adjustments lacked auditing visibility.

## 💡 Solution Architecture
Engineered a robust, automated PostgreSQL pipeline that replaces manual calculations with stored procedures, complex views, window functions, and real-time audit triggers.

### Key Features:
- **Automated Calculation Engine:** PL/pgSQL Stored Procedure (`process_payroll`) executing dynamic gross, bonus, tax, and net wage processing.
- **Financial Audit & Logging:** Trigger-based mechanism (`trg_payroll_audit`) tracking post-processing adjustments in real time.
- **Budget Execution & MoM Analytics:** SQL Views leveraging CTEs and Window Functions (`LAG()`, `PARTITION BY`) to track department spending and budget utilization.

## 🛠️ Data Model
The database follows a normalized relational structure consisting of 5 core tables:
- `departments` & `job_titles`: Organizational structures and salary benchmarks.
- `employees`: Active/Inactive employee status tracking.
- `payroll_records`: Generated payment records with computed net payout.
- `payroll_audit_log`: Audit trail for financial balance verification.

## 🚀 Execution Steps
1. Execute `sql/01_schema.sql` to initialize tables and relational integrity.
2. Load mock data with `sql/02_seed_data.sql`.
3. Create the procedure: `sql/03_stored_procedures.sql`.
4. Compile analytical views: `sql/04_views_analytics.sql`.
5. Enable automated auditing: `sql/05_triggers_audit.sql`.

### Example Execution:
```sql
-- Process payroll for January 2026 with a 5% bonus performance rate
CALL process_payroll('2026-01-01', '2026-01-31', 0.05);

-- Check department budget utilization
SELECT * FROM vw_budget_execution;
