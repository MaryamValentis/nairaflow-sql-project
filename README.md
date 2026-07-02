# NairaFlow  Fintech SQL Analytics Project

A complete MySQL project simulating a Nigerian fintech transaction platform.
Built to practice and demonstrate SQL skills required for data engineering
and analytics roles  from basic filtering through advanced window functions
and CTEs.

## Tech Stack

- **Database:** MySQL 8.0
- **Environment:** XAMPP / phpMyAdmin
- **Domain:** Nigerian fintech digital wallets, P2P transfers, fraud detection

## Schema Overview

Five tables modeling a realistic payment platform:

| Table | Purpose |
|---|---|
| `users` | Platform users tier, state, KYC status |
| `wallets` | User wallets  balance, currency |
| `transactions` | All payment activity â€” transfers, withdrawals, airtime, data |
| `merchants` | Registered merchants by category |
| `fraud_flags` | Flagged transactions with risk scores and reasons |

## What's Inside

- `schema/`  table creation scripts with constraints and foreign keys
- `seed/` realistic sample data (Nigerian names, states, fintech transaction patterns)
- `queries/01_basic.sql` SELECT, WHERE, ORDER BY, aggregate functions
- `queries/02_intermediate.sql`  JOINs, subqueries, CASE statements, date functions
- `queries/03_advanced.sql`  window functions, CTEs, views, stored procedures
- `queries/10_capstone_business_queries.sql`  10 business intelligence queries simulating real analyst tasks

## Capstone Highlights

The capstone file answers real business questions a fintech analyst would face:

- Monthly fraud rate trends
- High-risk user identification
- Transaction velocity / rapid-fire fraud detection using `LAG()`
- Revenue ranking by transaction type using `RANK()`
- Night-time fraud pattern analysis
- Tier-based performance comparison
- International vs domestic transfer risk
- Full fraud intelligence dashboard using chained CTEs

## How to Run

1. Install XAMPP and start MySQL
2. Open phpMyAdmin  SQL tab
3. Run `schema/create_tables.sql` to create the database
4. Run `seed/seed_data.sql` to populate sample data
5. Run any file in `queries/` to explore the analysis

## Author

Maryam Hussaini  Final-year Software Engineering student, Mewar International
University. Built as part of a self-directed roadmap toward MLOps and Data
Engineering, with a focus on fintech and financial systems.
