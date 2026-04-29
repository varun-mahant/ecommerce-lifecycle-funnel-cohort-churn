- =============================
-- DATA INGESTION & TABLE SETUP
-- =============================

-- USERS TABLE: Stores user level attributes and lifecycle data

CREATE TABLE users
(
user_id	INT PRIMARY KEY NOT NULL,
signup_date	DATE NOT NULL,
country VARCHAR(100),
device VARCHAR(50),
acquisition_channel VARCHAR(100),
is_premium BOOLEAN DEFAULT FALSE
);

COPY users
FROM 'C:\Users\Public\Documents\E-commerce User Lifecycle Analytics Funnel Optimization, Cohort Retention & Churn Modeling\users000.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM users;

-- SESSIONS TABLE: Captures individual user sessions

CREATE TABLE sessions
(
session_id	BIGINT PRIMARY KEY NOT NULL,
user_id	INT NOT NULL,
session_start TIMESTAMP NOT NULL,
session_end	TIMESTAMP NOT NULL CHECK (session_end >= session_start),
session_duration_sec INT,
device VARCHAR(50),
FOREIGN KEY (user_id) REFERENCES users(user_id)
);

COPY sessions
FROM 'C:\Users\Public\Documents\E-commerce User Lifecycle Analytics Funnel Optimization, Cohort Retention & Churn Modeling\sessions_final.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM sessions;

-- EVENTS TABLE: Logs user actions within sessions

CREATE TABLE events
(
event_id BIGINT PRIMARY KEY NOT NULL,
session_id BIGINT NOT NULL,
user_id	INT NOT NULL,
event_type VARCHAR(50) NOT NULL CHECK (event_type IN(
'session_start', 
'view',
'product_click',
'add_to_cart', 
'checkout', 
'purchase', 
'session_end')),
event_time TIMESTAMP NOT NULL,
FOREIGN KEY (session_id) REFERENCES sessions(session_id),
FOREIGN KEY (user_id) REFERENCES users(user_id)
);

COPY events
FROM 'C:\Users\Public\Documents\E-commerce User Lifecycle Analytics Funnel Optimization, Cohort Retention & Churn Modeling\events.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM events;

-- TRANSACTIONS TABLE: Stores completed purchases derived from purchase events

CREATE TABLE transactions
(
txn_id	BIGINT PRIMARY KEY NOT NULL,
event_id BIGINT NOT NULL,
user_id	INT NOT NULL,
txn_time	TIMESTAMP NOT NULL,
amount	INT NOT NULL CHECK (amount > 0),
payment_method	VARCHAR(50),
product_category	VARCHAR(50),
FOREIGN KEY (event_id) REFERENCES events(event_id),
FOREIGN KEY (user_id) REFERENCES users(user_id)
);

COPY transactions 
FROM 'C:\Users\Public\Documents\E-commerce User Lifecycle Analytics Funnel Optimization, Cohort Retention & Churn Modeling\transactions_clean.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM transactions;

-- =============================
-- DATA VALIDATION
-- =============================

-- Counting total rows in each table

SELECT COUNT(*) FROM users;   
SELECT COUNT(*) FROM sessions;
SELECT COUNT(*) FROM events;
SELECT COUNT(*) FROM transactions;

-- Checking every session has a valid user

SELECT COUNT(*) FROM sessions s
LEFT JOIN users u
ON s.user_id = u.user_id
WHERE u.user_id IS NULL;

-- Checking every event has a valid session

SELECT COUNT(*) FROM events e
LEFT JOIN sessions s
ON e.session_id = s.session_id
WHERE s.session_id IS NULL;

-- Checking every transaction maps to a purchase event

SELECT COUNT(*) FROM transactions t
JOIN events e
ON t.event_id = e.event_id AND e.event_type != 'purchase';

-- Time consistency checks (Event time should be between session start and session end, and Transaction time must match purchase event time)

SELECT COUNT(*) FROM events e
JOIN sessions s 
ON e.session_id = s.session_id
WHERE e.event_time NOT BETWEEN s.session_start AND s.session_end;

SELECT COUNT(*) FROM transactions t
JOIN events e
ON t.event_id = e.event_id AND e.event_type = 'purchase'
WHERE t.txn_time <> e.event_time;

-- =============================
-- FUNNEL ANALYSIS
-- =============================

-- FUNNEL STAGES:
-- view -> product_click -> add_to_cart -> checkout -> purchase

-- FUNNEL TABLE: Stage wise user counts with conversion and drop off percentages

WITH funnel AS 
(SELECT event_type AS stage, COUNT(DISTINCT user_id) AS total_users FROM events
WHERE event_type IN('view', 'product_click', 'add_to_cart', 'checkout', 'purchase')
GROUP BY event_type)
SELECT *, 
COALESCE(ROUND(total_users  * 100.0 / LAG(total_users, 1) OVER
(ORDER BY CASE stage 
               WHEN 'view' THEN 1
               WHEN 'product_click' THEN 2 
			   WHEN 'add_to_cart' THEN 3
               WHEN 'checkout' THEN 4  
			   WHEN 'purchase' THEN 5 END), 2), 100) AS stage_conversion_rate,
100 - COALESCE(ROUND(total_users  * 100.0 / LAG(total_users, 1) OVER
(ORDER BY CASE stage 
               WHEN 'view' THEN 1
               WHEN 'product_click' THEN 2 
			   WHEN 'add_to_cart' THEN 3
               WHEN 'checkout' THEN 4  
			   WHEN 'purchase' THEN 5 END), 2), 100) AS drop_off_rate,
COALESCE(LAG(total_users, 1) OVER
(ORDER BY CASE stage 
               WHEN 'view' THEN 1
               WHEN 'product_click' THEN 2 
			   WHEN 'add_to_cart' THEN 3
               WHEN 'checkout' THEN 4  
			   WHEN 'purchase' THEN 5 END) - total_users, 0) AS absolute_drop_off
FROM funnel
ORDER BY CASE stage 
               WHEN 'view' THEN 1
               WHEN 'product_click' THEN 2
               WHEN 'add_to_cart' THEN 3
               WHEN 'checkout' THEN 4
               WHEN 'purchase' THEN 5 END;

-- OVERALL FUNNEL CONVERSION: Percentage of users who viewed a product and eventually made a purchase

SELECT
ROUND((SELECT COUNT(DISTINCT user_id) FROM events
WHERE event_type = 'purchase') * 100.0 /
(SELECT COUNT(DISTINCT user_id) FROM events
WHERE event_type = 'view'), 2) as conversion_rate;

-- KEY OBSERVATIONS: 

-- 1. A significant number of users abandon the page at product_click -> add_to_cart stage, indicates weak conversion from interest to intent. 
-- 2. Highest drop off (~69%) is observed at checkout -> purchase, indicating users are facing issues at the checkout.
-- 3. A strong conversion rate (~66%) at view -> product_click indicates healthy product interaction.

-- =============================
-- COHORT ANALYSIS
-- =============================

-- OBJECTIVE: Tracking how user cohorts behave over time by measuring retention across months since signup

-- COHORT ASSIGNMENT: Assigns each user to a cohort based on their signup month

SELECT user_id, CAST(DATE_TRUNC('MONTH', signup_date) AS DATE) AS cohort_month FROM users
ORDER BY user_id;

-- COHORT SIZE: Total users in each cohort

SELECT CAST(DATE_TRUNC('MONTH', signup_date) AS DATE) AS cohort_month, COUNT(user_id) AS cohort_size FROM users
GROUP BY cohort_month
ORDER BY cohort_month;

-- ACTIVE MONTHS: All months in which each user was active (signup is treated as the first activity)

SELECT user_id, CAST(DATE_TRUNC('MONTH', signup_date) AS DATE) AS active_month FROM users
UNION
SELECT DISTINCT user_id, CAST(DATE_TRUNC('MONTH', event_time) AS DATE) AS active_month FROM events
ORDER BY user_id, active_month;

-- COHORT INDEX: Shows how many months after signup a user was active

SELECT u.user_id, CAST(DATE_TRUNC('MONTH', u.signup_date) AS DATE) AS cohort_month,
a.active_month, ((DATE_PART('YEAR', a.active_month) - DATE_PART('YEAR', u.signup_date)) * 12
+ (DATE_PART('MONTH', a.active_month) - DATE_PART('MONTH', u.signup_date))) AS cohort_index
FROM users u
JOIN(SELECT user_id, CAST(DATE_TRUNC('MONTH', signup_date) AS DATE) AS active_month FROM users
UNION
SELECT user_id, CAST(DATE_TRUNC('MONTH', event_time) AS DATE) AS active_month FROM events
) a
ON u.user_id = a.user_id
ORDER BY u.user_id, cohort_month, active_month;


-- COHORT ENGAGEMENT OVER TIME: Shows how user activity changes over time for each cohort 

SELECT CAST(DATE_TRUNC('MONTH', u.signup_date) AS DATE) AS cohort_month, (
(DATE_PART('YEAR', a.active_month) - DATE_PART('YEAR', u.signup_date)) * 12 +
(DATE_PART('MONTH', a.active_month) - DATE_PART('MONTH', u.signup_date))
) AS cohort_index, 
COUNT(DISTINCT u.user_id) AS active_users FROM users u
JOIN (SELECT user_id, DATE_TRUNC('MONTH', signup_date) AS active_month FROM users
UNION
SELECT user_id, DATE_TRUNC('MONTH', event_time) AS active_month FROM events
) a
ON u.user_id = a.user_id
GROUP BY cohort_month, cohort_index
ORDER BY cohort_month, cohort_index; 

-- RETENTION CALCULATION: % of users from each cohort who return in each subsequent month

SELECT CAST(DATE_TRUNC('MONTH', u.signup_date) AS DATE) AS cohort_month, 
((DATE_PART('YEAR', a.active_month) - DATE_PART('YEAR', u.signup_date)) * 12 +
(DATE_PART('MONTH', a.active_month) - DATE_PART('MONTH', u.signup_date))) AS cohort_index, 
COUNT(DISTINCT u.user_id) AS active_users,
FIRST_VALUE(COUNT(DISTINCT u.user_id)) OVER(PARTITION BY CAST(DATE_TRUNC('MONTH', u.signup_date) AS DATE) 
ORDER BY ((DATE_PART('YEAR', a.active_month) - DATE_PART('YEAR', u.signup_date)) * 12 + 
(DATE_PART('MONTH', a.active_month) - DATE_PART('MONTH', u.signup_date)))) AS cohort_size,
ROUND(COUNT(DISTINCT u.user_id) * 100. / FIRST_VALUE(COUNT(DISTINCT u.user_id)) OVER(
PARTITION BY CAST(DATE_TRUNC('MONTH', u.signup_date) AS DATE) ORDER BY ((DATE_PART('YEAR', a.active_month) - 
DATE_PART('YEAR', u.signup_date)) * 12 + (DATE_PART('MONTH', a.active_month) - DATE_PART('MONTH', u.signup_date)))), 2) AS retention_rate
FROM users u
JOIN (SELECT user_id, DATE_TRUNC('MONTH', signup_date) AS active_month FROM users
UNION
SELECT DISTINCT user_id, DATE_TRUNC('MONTH', event_time) AS active_month FROM events
) a
ON u.user_id = a.user_id
GROUP BY cohort_month, cohort_index
ORDER BY cohort_month, cohort_index; 

-- KEY OBSERVATIONS: 

-- 1. Failure to retain over one third of users immediately after signup.
-- 2. Retention stabilizes after Month 4, revealing a small but loyal customer base.
-- 3. Long term retention is negligible, signaling weak product stickiness.

-- =============================
-- MONTHLY CHURN ANALYSIS
-- =============================

-- OBJECTIVE: To quantify user churn by comparing active users across consecutive months

-- ACTIVITY BASE: Identifies when users were active  

SELECT user_id, CAST(DATE_TRUNC('MONTH', signup_date) AS DATE) AS active_months FROM users
UNION
SELECT user_id, CAST(DATE_TRUNC('MONTH', event_time) AS DATE) AS active_months FROM events
ORDER BY user_id, active_months;

-- MAU (MONTHLY ACTIVE USERS): Calculates the total number of distinct users who were active in each month

SELECT active_months AS month, COUNT(DISTINCT user_id) AS total_active_users FROM (
SELECT user_id, CAST(DATE_TRUNC('MONTH', signup_date) AS DATE) AS active_months FROM users
UNION
SELECT user_id, CAST(DATE_TRUNC('MONTH', event_time) AS DATE) AS active_months FROM events)
GROUP BY active_months
ORDER BY active_months;

--  CHURNED USERS: Identifies users who were active in one period but did not return in the next

WITH active_users AS (
SELECT user_id, CAST(DATE_TRUNC('MONTH', signup_date)AS DATE) AS activity_month FROM users
UNION
SELECT user_id, CAST(DATE_TRUNC('month', event_time)AS DATE) AS activity_month FROM events),
user_next_month AS (
SELECT a.user_id, a.activity_month, b.user_id AS next_month_user FROM active_users a
LEFT JOIN active_users b
ON a.user_id = b.user_id AND b.activity_month = a.activity_month + INTERVAL '1 month'
)
SELECT activity_month AS month, COUNT(DISTINCT user_id) FILTER (WHERE next_month_user IS NULL) AS churned_users
FROM user_next_month
GROUP BY activity_month
ORDER BY activity_month;

-- CHURN ANALYSIS OUTPUT: Shows active users, churned_users, and churn rate for each period

WITH activity_base AS (
SELECT user_id, CAST(DATE_TRUNC('MONTH', signup_date)AS DATE) AS activity_month FROM users
UNION
SELECT user_id, CAST(DATE_TRUNC('month', event_time)AS DATE) AS activity_month FROM events),
user_next_month AS (
SELECT a.user_id, a.activity_month, b.user_id AS next_month_user FROM activity_base a
LEFT JOIN activity_base b
ON a.user_id = b.user_id AND b.activity_month = a.activity_month + INTERVAL '1 month'
)
SELECT activity_month AS month, COUNT(DISTINCT user_id) AS active_users, 
COUNT(DISTINCT user_id) FILTER (WHERE next_month_user IS NULL) AS churned_users,
ROUND(COUNT(DISTINCT user_id) FILTER (WHERE next_month_user IS NULL) * 100.0 / COUNT(DISTINCT user_id), 2) AS churn_rate
FROM user_next_month
WHERE activity_month < (SELECT MAX(activity_month) FROM activity_base)
GROUP BY activity_month
ORDER BY activity_month;

-- KEY OBSERVATIONS: 

-- 1. Active users grew ~3x, but churn remained high, indicating strong acquisition but weak retention.
-- 2. Nearly half of users churn every month.
-- 3. A sharp spike of ~60% in Feb 2026 deviates from a stable trend, indicating a potential disruption in user behaviour.

-- =============================
-- REVENUE ANALYSIS 
-- =============================

-- TOTAL REVENUE: Calculates overall revenue generated from transactions

SELECT SUM(amount) AS total_revenue FROM transactions;

-- MONTHLY REVENUE: Tracks revenue trends over time

SELECT CAST(DATE_TRUNC('MONTH', txn_time) AS DATE) AS month, SUM(amount) AS revenue FROM transactions
GROUP BY month
ORDER BY month;

-- OVERALL AOV: Calculates the average order value across all transactions

SELECT (ROUND(SUM(amount) * 1.0 / COUNT(txn_id), 2)) AS aov FROM transactions;

-- MONTHLY AOV: Calculates the average order value for each month

SELECT CAST(DATE_TRUNC('MONTH', txn_time) AS DATE) AS month, 
(ROUND(SUM(amount) * 1.0 / COUNT(txn_id), 2)) AS aov
FROM transactions
GROUP BY month
ORDER BY month;

-- ARPU (Average Revenue Per User): Average revenue generated per active user each month

SELECT m.month, r.revenue, m.active_users, ROUND(r.revenue * 1.0 / m.active_users, 2) AS arpu
FROM (SELECT CAST(DATE_TRUNC('MONTH', activity_time) AS DATE) AS month,
COUNT(DISTINCT user_id) AS active_users FROM 
(SELECT user_id, signup_date AS activity_time FROM users
UNION
SELECT user_id, event_time FROM events) 
GROUP BY month) m
LEFT JOIN (SELECT CAST(DATE_TRUNC('MONTH', txn_time) AS DATE) AS month,
SUM(amount) AS revenue FROM transactions
GROUP BY month) r
ON m.month = r.month
ORDER BY m.month;

-- REVENUE SEGMENTATION: Analyzes how revenue is distributed across different dimensions

--product_category
SELECT product_category, SUM(amount) AS revenue FROM transactions
GROUP BY product_category
ORDER BY revenue DESC;

--country
SELECT u.country, SUM(t.amount) AS revenue
FROM transactions t
JOIN users u
ON t.user_id = u.user_id
GROUP BY u.country
ORDER BY revenue DESC;

--payment_method
SELECT payment_method, SUM(amount) AS revenue FROM transactions
GROUP BY payment_method
ORDER BY revenue DESC;

--acquisition_channel
SELECT u.acquisition_channel, SUM(t.amount) AS revenue
FROM transactions t
JOIN users u
ON t.user_id = u.user_id
GROUP BY u.acquisition_channel
ORDER BY revenue DESC;

--device
SELECT u.device, SUM(t.amount) AS revenue
FROM transactions t
JOIN users u
ON t.user_id = u.user_id
GROUP BY u.device
ORDER BY revenue DESC;

--premium vs non premium
SELECT u.is_premium, SUM(t.amount) AS revenue
FROM transactions t
JOIN users u
ON t.user_id = u.user_id
GROUP BY u.is_premium
ORDER BY revenue DESC;

-- KEY OBSERVATIONS:

-- 1. Revenue growth is primarily driven by increased user activity rather than higher spending per order.
-- 2. Stable AOV indicates no significant change in customer purchase behaviour over time.
-- 3. ARPU consistency suggests monetization efficiency remains steady across the user base.
