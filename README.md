📊 E-Commerce User Lifecycle Analytics: Funnel, Cohort Retention & Churn Analysis
🚀 Overview
This project performs an end-to-end analysis of user behavior across the e-commerce lifecycle, focusing on how users convert, engage, and generate revenue over time.

By combining funnel analysis, cohort retention, churn modeling, and revenue analytics, the project provides a comprehensive view of user dynamics and business performance.

🎯 Objectives
Understand how users move through the conversion funnel
Analyze retention patterns across user cohorts
Identify when and why users churn
Evaluate revenue performance and monetization efficiency
🛠 Tech Stack
SQL – Core data analysis and metric computation
Python – Data generation
Power BI – Dashboard and visualization
📊 Dataset Overview
This project is based on a simulated e-commerce dataset with the following scale:

Users: 100,000
Sessions: 726,000
Events: 3,200,000
Transactions: 3,100
Data Tables
Users → demographic and acquisition data
Sessions → user visit behavior
Events → in-session actions (view, click, cart, purchase)
Transactions → completed purchases and revenue
🔍 Analysis Breakdown
1. Funnel Analysis
Tracks user progression through key stages: view → product_click → add_to_cart → checkout → purchase
Identifies conversion rates and drop-offs
Highlights friction points in the purchase journey
2. Cohort Retention Analysis
Groups users by signup month (cohorts)
Tracks engagement over time using cohort index
Measures retention rates across lifecycle stages
Reveals long-term user behavior patterns
3. Monthly Churn Analysis
Defines churn as users who do not return in the next month
Calculates churned users and churn rate
Evaluates retention stability over time
Detects anomalies in user behavior
4. Revenue Analysis
Tracks total and monthly revenue trends
Calculates key monetization metrics:
AOV (Average Order Value)
ARPU (Average Revenue Per User)
Analyzes how revenue is distributed across:
Product category
Country
Device
Acquisition channel
Payment method
Premium vs non-premium users
Evaluates whether growth is driven by user volume or spending behavior
📈 Key Insights
Revenue growth is primarily driven by increased user activity rather than higher spending per order
High churn (~45–50%) indicates weak user retention despite strong acquisition
AOV remains stable (~1500–1800), reflecting consistent purchase behavior
ARPU is steady, indicating stable monetization per user
Revenue fluctuations align with changes in user activity rather than pricing
💡 Recommendations
Fix early-stage retention (critical): A significant portion of users drop off immediately after signup, indicating poor onboarding or weak initial value delivery. Improve first-session experience with guided onboarding, incentives, or personalized content.

Address consistently high churn (~45–50%): Nearly half of active users fail to return each month. Introduce retention strategies such as lifecycle messaging, re-engagement campaigns, and habit-forming features to improve stickiness.

Investigate worsening churn trend: The spike in churn (~60%) suggests a potential disruption (product, UX, or external factors). Conduct deeper analysis on that period to identify root causes.

Optimize checkout experience: High drop-off at checkout indicates friction in the purchase process. Simplify flows, reduce steps, and improve payment reliability.

Shift focus from acquisition to retention: Growth is currently driven by new users rather than sustained engagement. Prioritize retention and repeat usage to achieve sustainable revenue growth.

Increase repeat purchase behavior: Stable AOV but high churn suggests users spend normally but don’t return. Introduce loyalty programs, discounts, or personalized recommendations to drive repeat transactions.

🧠 Business Takeaway
The platform demonstrates strong acquisition and monetization capabilities but struggles with retention.
Sustainable growth will depend on improving user engagement and reducing churn.
