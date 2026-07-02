/*
================================================================================
 NAIRAFLOW  FINTECH SQL ANALYTICS PROJECT
================================================================================
 Author      : Maryam Hussaini
 Institution : Mewar International University.
 Database    : MySQL 8.0 (XAMPP / phpMyAdmin)
 Domain      : Nigerian fintech  digital wallets, P2P transfers,
               fraud detection

 ABOUT THIS PROJECT
 -------------------
 NairaFlow is a simulated Nigerian fintech transaction platform built to
 practice and demonstrate SQL skills required for data engineering and
 analytics roles from schema design through advanced window functions,
 CTEs, and business intelligence queries.

 This single file contains the full project:
   SECTION 1  Database & Table Schema
   SECTION 2  Seed Data
   SECTION 3  Capstone Business Intelligence Queries (10 queries)
================================================================================
*/


-- ============================================================================
-- SECTION 1: DATABASE & TABLE SCHEMA
-- ============================================================================

CREATE DATABASE IF NOT EXISTS nairaflow;
USE nairaflow;

-- ----------------------------------------------------------------------------
-- TABLE: users
-- Platform users  tier, state, KYC verification status
-- ----------------------------------------------------------------------------
CREATE TABLE users (
    user_id      INT AUTO_INCREMENT PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(100) UNIQUE NOT NULL,
    phone        VARCHAR(20) UNIQUE NOT NULL,
    state        VARCHAR(50) NOT NULL,
    tier         ENUM('basic', 'premium', 'business') DEFAULT 'basic',
    kyc_verified TINYINT(1) DEFAULT 0,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- TABLE: wallets
-- User wallets  balance, currency, active status
-- A user can hold more than one wallet (e.g. NGN and USD)
-- ----------------------------------------------------------------------------
CREATE TABLE wallets (
    wallet_id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    balance     DECIMAL(15,2) DEFAULT 0.00,
    currency    ENUM('NGN', 'USD', 'GBP') DEFAULT 'NGN',
    is_active   TINYINT(1) DEFAULT 1,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ----------------------------------------------------------------------------
-- TABLE: merchants
-- Registered merchants by category (independent of users/wallets)
-- ----------------------------------------------------------------------------
CREATE TABLE merchants (
    merchant_id INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    category    ENUM('ecommerce','telco','utility','transport','food') NOT NULL,
    state       VARCHAR(50),
    is_verified TINYINT(1) DEFAULT 0,
    joined_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- TABLE: transactions
-- All payment activity  transfers, withdrawals, deposits, airtime, data
-- sender_wallet_id / receiver_wallet_id can be NULL for withdrawal/airtime/data
-- ----------------------------------------------------------------------------
CREATE TABLE transactions (
    txn_id              INT AUTO_INCREMENT PRIMARY KEY,
    sender_wallet_id    INT,
    receiver_wallet_id  INT,
    amount              DECIMAL(15,2) NOT NULL,
    fee                 DECIMAL(10,2) DEFAULT 0.00,
    txn_type            ENUM('transfer','withdrawal','deposit','airtime','data') NOT NULL,
    status              ENUM('success','failed','pending','flagged') DEFAULT 'pending',
    is_international     TINYINT(1) DEFAULT 0,
    created_at           DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_wallet_id) REFERENCES wallets(wallet_id),
    FOREIGN KEY (receiver_wallet_id) REFERENCES wallets(wallet_id)
);

-- ----------------------------------------------------------------------------
-- TABLE: fraud_flags
-- Flagged transactions with reason, risk score, and review status
-- ----------------------------------------------------------------------------
CREATE TABLE fraud_flags (
    flag_id     INT AUTO_INCREMENT PRIMARY KEY,
    txn_id      INT NOT NULL,
    flag_reason VARCHAR(200),
    risk_score  DECIMAL(5,2),
    reviewed    TINYINT(1) DEFAULT 0,
    flagged_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (txn_id) REFERENCES transactions(txn_id)
);


-- ============================================================================
-- SECTION 2: SEED DATA
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Seed: users
-- ----------------------------------------------------------------------------
INSERT INTO users (full_name, email, phone, state, tier, kyc_verified, created_at) VALUES
('Maryam Hussaini',   'maryam@nairaflow.ng',   '08012345678', 'Kaduna',  'premium',  1, '2025-01-10 09:00:00'),
('Chidi Okonkwo',      'chidi@nairaflow.ng',    '08023456789', 'Lagos',   'business', 1, '2025-01-12 10:30:00'),
('Amina Bello',        'amina@nairaflow.ng',    '08034567890', 'Kano',    'basic',    1, '2025-01-15 11:00:00'),
('Emeka Eze',          'emeka@nairaflow.ng',    '08045678901', 'Enugu',   'premium',  1, '2025-01-20 08:00:00'),
('Fatima Usman',       'fatima@nairaflow.ng',   '08056789012', 'Abuja',   'business', 1, '2025-01-22 14:00:00'),
('Tunde Adeyemi',      'tunde@nairaflow.ng',    '08067890123', 'Lagos',   'basic',    0, '2025-02-01 09:30:00'),
('Ngozi Obi',          'ngozi@nairaflow.ng',    '08078901234', 'Anambra', 'premium',  1, '2025-02-05 16:00:00'),
('Yusuf Garba',        'yusuf@nairaflow.ng',    '08089012345', 'Sokoto',  'basic',    0, '2025-02-10 11:00:00'),
('Blessing Okafor',    'blessing@nairaflow.ng', '08090123456', 'Rivers',  'business', 1, '2025-02-14 13:00:00'),
('Ibrahim Musa',       'ibrahim@nairaflow.ng',  '08001234567', 'Kaduna',  'basic',    1, '2025-02-20 10:00:00');

-- ----------------------------------------------------------------------------
-- Seed: wallets
-- ----------------------------------------------------------------------------
INSERT INTO wallets (user_id, balance, currency, is_active) VALUES
(1,  250000.00, 'NGN', 1),
(1,  150.00,    'USD', 1),
(2,  1500000.00,'NGN', 1),
(3,  45000.00,  'NGN', 1),
(4,  320000.00, 'NGN', 1),
(5,  2800000.00,'NGN', 1),
(5,  500.00,    'GBP', 1),
(6,  12000.00,  'NGN', 1),
(7,  180000.00, 'NGN', 1),
(8,  5000.00,   'NGN', 0),
(9,  950000.00, 'NGN', 1),
(10, 78000.00,  'NGN', 1);

-- ----------------------------------------------------------------------------
-- Seed: merchants
-- ----------------------------------------------------------------------------
INSERT INTO merchants (name, category, state, is_verified) VALUES
('Jumia Nigeria',     'ecommerce', 'Lagos', 1),
('MTN Nigeria',       'telco',     'Lagos', 1),
('Eko Electricity',   'utility',   'Lagos', 1),
('Bolt Nigeria',      'transport', 'Abuja', 1),
('Chicken Republic',  'food',      'Lagos', 1),
('Konga',             'ecommerce', 'Lagos', 1),
('Airtel Nigeria',    'telco',     'Lagos', 1),
('IKEDC',             'utility',   'Lagos', 0);

-- ----------------------------------------------------------------------------
-- Seed: transactions
-- ----------------------------------------------------------------------------
INSERT INTO transactions (sender_wallet_id, receiver_wallet_id, amount, fee, txn_type, status, is_international, created_at) VALUES
(1,  4,    50000.00,  50.00,   'transfer',   'success', 0, '2026-01-05 10:15:00'),
(3,  1,    200000.00, 100.00,  'transfer',   'success', 0, '2026-01-06 14:30:00'),
(5,  NULL, 1000.00,   0.00,    'airtime',    'success', 0, '2026-01-07 08:00:00'),
(6,  9,    500000.00, 500.00,  'transfer',   'flagged', 0, '2026-01-08 02:15:00'),
(1,  NULL, 5000.00,   100.00,  'withdrawal', 'success', 0, '2026-01-09 11:00:00'),
(9,  11,   150000.00, 150.00,  'transfer',   'success', 0, '2026-01-10 16:45:00'),
(2,  3,    75000.00,  500.00,  'transfer',   'success', 1, '2026-01-11 09:30:00'),
(4,  NULL, 2000.00,   0.00,    'data',       'success', 0, '2026-01-12 12:00:00'),
(11, 1,    30000.00,  30.00,   'transfer',   'failed',  0, '2026-01-13 15:00:00'),
(5,  4,    10000.00,  10.00,   'transfer',   'success', 0, '2026-01-14 10:00:00'),
(6,  NULL, 50000.00,  200.00,  'withdrawal', 'success', 0, '2026-01-15 09:00:00'),
(3,  9,    800000.00, 1000.00, 'transfer',   'flagged', 1, '2026-01-16 01:30:00'),
(9,  NULL, 3000.00,   0.00,    'airtime',    'success', 0, '2026-01-17 14:00:00'),
(1,  12,   25000.00,  25.00,   'transfer',   'success', 0, '2026-01-18 11:30:00'),
(7,  NULL, 1500.00,   0.00,    'data',       'failed',  0, '2026-01-19 08:45:00'),
(6,  3,    1200000.00,2000.00, 'transfer',   'flagged', 1, '2026-01-20 03:00:00'),
(4,  1,    15000.00,  15.00,   'transfer',   'success', 0, '2026-02-01 10:00:00'),
(11, 5,    450000.00, 450.00,  'transfer',   'success', 0, '2026-02-03 13:00:00'),
(12, NULL, 8000.00,   100.00,  'withdrawal', 'success', 0, '2026-02-05 09:30:00'),
(9,  6,    600000.00, 800.00,  'transfer',   'flagged', 1, '2026-02-07 00:45:00');

-- ----------------------------------------------------------------------------
-- Seed: fraud_flags
-- ----------------------------------------------------------------------------
INSERT INTO fraud_flags (txn_id, flag_reason, risk_score, reviewed) VALUES
(4,  'Large transfer at unusual hour',               0.87, 0),
(12, 'International transfer exceeds daily limit',   0.92, 1),
(16, 'Multiple large international transfers',       0.95, 0),
(20, 'Suspicious night-time international transfer', 0.89, 0);


-- ============================================================================
-- SECTION 3: CAPSTONE BUSINESS INTELLIGENCE QUERIES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- QUERY 1: Monthly Fraud Rate Report
-- Business question: What percentage of transactions are flagged as
-- fraudulent each month?
-- ----------------------------------------------------------------------------
SELECT
    DATE_FORMAT(created_at, '%Y-%m')                     AS month,
    COUNT(*)                                              AS total_transactions,
    SUM(CASE WHEN status = 'flagged' THEN 1 ELSE 0 END)  AS flagged_count,
    ROUND(
        (SUM(CASE WHEN status = 'flagged' THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    )                                                      AS fraud_rate_pct
FROM transactions
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY month;


-- ----------------------------------------------------------------------------
-- QUERY 2: High-Risk Users
-- Business question: Which users have more than 2 flagged transactions,
-- and how much total flagged volume do they represent?
-- ----------------------------------------------------------------------------
SELECT
    u.full_name,
    u.tier,
    SUM(t.amount)               AS total_flagged_amount,
    ROUND(AVG(f.risk_score), 2) AS avg_risk_score,
    COUNT(*)                    AS flagged_txn_count
FROM users u
INNER JOIN wallets w       ON u.user_id = w.user_id
INNER JOIN transactions t  ON w.wallet_id = t.sender_wallet_id
INNER JOIN fraud_flags f   ON t.txn_id = f.txn_id
GROUP BY u.user_id, u.full_name, u.tier
HAVING COUNT(*) > 2
ORDER BY total_flagged_amount DESC;


-- ----------------------------------------------------------------------------
-- QUERY 3: Transaction Velocity Analysis
-- Business question: How quickly is each wallet sending consecutive
-- transactions? Flag any gap under 1 hour as a potential velocity-based
-- fraud signal.
-- ----------------------------------------------------------------------------
SELECT
    sender_wallet_id,
    txn_id,
    created_at,
    LAG(created_at) OVER (
        PARTITION BY sender_wallet_id ORDER BY created_at
    )                                       AS prev_txn_time,
    ROUND(
        TIMESTAMPDIFF(
            MINUTE,
            LAG(created_at) OVER (PARTITION BY sender_wallet_id ORDER BY created_at),
            created_at
        ) / 60.0,
        2
    )                                       AS hours_since_last,
    CASE
        WHEN TIMESTAMPDIFF(
                MINUTE,
                LAG(created_at) OVER (PARTITION BY sender_wallet_id ORDER BY created_at),
                created_at
             ) < 60
        THEN 'Rapid'
        ELSE 'Normal'
    END                                     AS velocity_flag
FROM transactions
WHERE sender_wallet_id IS NOT NULL
ORDER BY sender_wallet_id, created_at;


-- ----------------------------------------------------------------------------
-- QUERY 4: Revenue Report  Ranked by Month and Overall
-- Business question: Which transaction type generates the most fee
-- revenue, both within each month and across the entire dataset?
-- ----------------------------------------------------------------------------
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(created_at, '%Y-%m') AS month,
        txn_type,
        SUM(fee)                         AS total_fees,
        COUNT(*)                         AS txn_count
    FROM transactions
    GROUP BY DATE_FORMAT(created_at, '%Y-%m'), txn_type
)
SELECT
    month,
    txn_type,
    total_fees,
    txn_count,
    RANK() OVER (PARTITION BY month ORDER BY total_fees DESC) AS rank_within_month,
    RANK() OVER (ORDER BY total_fees DESC)                    AS rank_overall
FROM monthly_revenue
ORDER BY total_fees DESC;

-- Variant: show ONLY the single highest-revenue month+type combination
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(created_at, '%Y-%m') AS month,
        txn_type,
        SUM(fee)                         AS total_fees
    FROM transactions
    GROUP BY DATE_FORMAT(created_at, '%Y-%m'), txn_type
),
ranked_revenue AS (
    SELECT
        month,
        txn_type,
        total_fees,
        RANK() OVER (ORDER BY total_fees DESC) AS rank_overall
    FROM monthly_revenue
)
SELECT month, txn_type, total_fees
FROM ranked_revenue
WHERE rank_overall = 1;


-- ----------------------------------------------------------------------------
-- QUERY 5: Night Owl Fraud Analysis
-- Business question: What proportion of flagged transactions happen at
-- night (12AM-6AM) versus during the day?
-- ----------------------------------------------------------------------------
SELECT
    CASE
        WHEN HOUR(created_at) BETWEEN 0 AND 5 THEN 'Night (12AM-6AM)'
        ELSE 'Daytime (6AM-11:59PM)'
    END                                              AS time_bucket,
    COUNT(*)                                         AS flagged_count,
    ROUND((COUNT(*) / SUM(COUNT(*)) OVER ()) * 100, 2) AS pct_of_flagged
FROM transactions
WHERE status = 'flagged'
GROUP BY time_bucket;


-- ----------------------------------------------------------------------------
-- QUERY 6: User Tier Performance Summary
-- Business question: How do basic, premium, and business tier users
-- compare across volume, fraud rate, and balance?
-- ----------------------------------------------------------------------------
SELECT
    u.tier,
    COUNT(DISTINCT u.user_id)                            AS user_count,
    SUM(t.amount)                                         AS total_transaction_volume,
    ROUND(AVG(t.amount), 2)                               AS avg_transaction_size,
    ROUND(
        (SUM(CASE WHEN t.status = 'flagged' THEN 1 ELSE 0 END)
         / NULLIF(COUNT(t.txn_id), 0)) * 100,
        2
    )                                                      AS fraud_rate_pct,
    ROUND(AVG(w.balance), 2)                              AS avg_wallet_balance
FROM users u
INNER JOIN wallets w      ON u.user_id = w.user_id
LEFT JOIN transactions t  ON w.wallet_id = t.sender_wallet_id
GROUP BY u.tier
ORDER BY total_transaction_volume DESC;

-- NOTE: NULLIF(COUNT(t.txn_id), 0) prevents a division-by-zero error
-- for tiers where a user (via LEFT JOIN) has no transactions yet.


-- ----------------------------------------------------------------------------
-- QUERY 7: International vs Domestic Transfer Risk
-- Business question: Are international transfers riskier than domestic
-- ones, and by how much?
-- ----------------------------------------------------------------------------
SELECT
    CASE WHEN is_international = 1 THEN 'International' ELSE 'Domestic' END AS txn_scope,
    COUNT(*)                                                                 AS total_txns,
    SUM(CASE WHEN status = 'flagged' THEN 1 ELSE 0 END)                     AS flagged_txns,
    ROUND(
        (SUM(CASE WHEN status = 'flagged' THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    )                                                                       AS fraud_rate_pct
FROM transactions
GROUP BY is_international;


-- ----------------------------------------------------------------------------
-- QUERY 8: Wallet Balance vs Transaction Activity
-- Business question: Do the wealthiest users on the platform also have
-- any flagged transaction history?
-- ----------------------------------------------------------------------------
SELECT
    u.full_name,
    w.balance,
    COUNT(t.txn_id) AS total_txns_sent,
    CASE
        WHEN SUM(CASE WHEN t.status = 'flagged' THEN 1 ELSE 0 END) > 0
        THEN 'Yes' ELSE 'No'
    END             AS has_flagged_txns
FROM users u
INNER JOIN wallets w      ON u.user_id = w.user_id
LEFT JOIN transactions t  ON w.wallet_id = t.sender_wallet_id
GROUP BY u.user_id, u.full_name, w.balance
ORDER BY w.balance DESC
LIMIT 5;


-- ----------------------------------------------------------------------------
-- QUERY 9: State Performance Report
-- Business question: Which Nigerian state generates the highest
-- transaction volume on the platform?
-- ----------------------------------------------------------------------------
SELECT
    u.state,
    SUM(t.amount)                                       AS total_volume,
    COUNT(DISTINCT u.user_id)                            AS user_count,
    ROUND(SUM(t.amount) / COUNT(DISTINCT u.user_id), 2)  AS avg_volume_per_user
FROM users u
INNER JOIN wallets w      ON u.user_id = w.user_id
INNER JOIN transactions t ON w.wallet_id = t.sender_wallet_id
WHERE u.state IS NOT NULL
GROUP BY u.state
ORDER BY total_volume DESC;
-- Top row = highest performing state. Full ranking shown for comparison.


-- ----------------------------------------------------------------------------
-- QUERY 10: Full Fraud Intelligence Dashboard
-- Business question: Give a single summary view of fraud activity 
-- total flagged amount, average risk, most common reason, international
-- share, and the most-flagged user.
-- ----------------------------------------------------------------------------
WITH flagged_txns AS (
    SELECT
        f.txn_id,
        f.flag_reason,
        f.risk_score,
        t.amount,
        t.is_international,
        t.sender_wallet_id
    FROM fraud_flags f
    INNER JOIN transactions t ON f.txn_id = t.txn_id
),
user_flag_counts AS (
    SELECT
        w.user_id,
        COUNT(*) AS flag_count
    FROM flagged_txns ft
    INNER JOIN wallets w ON ft.sender_wallet_id = w.wallet_id
    GROUP BY w.user_id
)
SELECT
    (SELECT SUM(amount) FROM flagged_txns)               AS total_flagged_amount,
    (SELECT ROUND(AVG(risk_score), 2) FROM flagged_txns)  AS avg_risk_score,
    (SELECT flag_reason
     FROM flagged_txns
     GROUP BY flag_reason
     ORDER BY COUNT(*) DESC
     LIMIT 1)                                             AS most_common_flag_reason,
    (SELECT ROUND((SUM(is_international) / COUNT(*)) * 100, 2)
     FROM flagged_txns)                                   AS pct_flagged_international,
    (SELECT u.full_name
     FROM user_flag_counts ufc
     INNER JOIN users u ON ufc.user_id = u.user_id
     ORDER BY ufc.flag_count DESC
     LIMIT 1)                                              AS user_with_most_flags;

-- ============================================================================
-- END OF FILE
-- ============================================================================
