# 📊 E-Commerce User Lifecycle Analytics: Funnel, Cohort Retention & Churn Analysis

## 🚀 Overview

This project performs an end-to-end analysis of user behavior across the e-commerce lifecycle, focusing on how users convert, engage, and generate revenue over time.

By combining funnel analysis, cohort retention, churn modeling, and revenue analytics, the project provides a comprehensive view of user dynamics and business performance.

---

## 🔄 Project Workflow

Python → PostgreSQL → SQL Analysis → Power BI Modeling → Dashboarding

---

## 🎯 Objectives

- Understand how users move through the conversion funnel
- Analyze retention patterns across user cohorts
- Identify when and why users churn
- Evaluate revenue performance and monetization efficiency

---

## 🛠 Tech Stack

- SQL – Core data analysis and metric computation
- Python – Data generation
- PostgreSQL – Data storage and querying
- Power BI – Dashboard and visualization

---

## 📊 Dataset Overview

This project is based on a simulated e-commerce dataset.

The dataset was synthetically generated using Python to simulate realistic e-commerce user behavior across acquisition, engagement, retention, and monetization stages.

### Dataset Scale

- Users: 100,000
- Sessions: 726,000
- Events: 3,200,000
- Transactions: 3,100

### Data Tables

- Users → demographic and acquisition data
- Sessions → user visit behavior
- Events → in-session actions (view, click, cart, purchase)
- Transactions → completed purchases and revenue

---

## 📁 Repository Structure

- data-generation/
- sql-analysis/
- data-model/
- powerbi-dashboard/

---

## 🔍 Analysis Breakdown

### 1. Funnel Analysis

Tracks user progression through key stages:

view → product_click → add_to_cart → checkout → purchase

- Identifies conversion rates and drop-offs
- Highlights friction points in the purchase journey

---

### 2. Cohort Retention Analysis

- Groups users by signup month (cohorts)
- Tracks engagement over time using cohort index
- Measures retention rates across lifecycle stages
- Reveals long-term user behavior patterns

---

### 3. Monthly Churn Analysis

- Defines churn as users who do not return in the next month
- Calculates churned users and churn rate
- Evaluates retention stability over time
- Detects anomalies in user behavior

---

### 4. Revenue Analysis

- Tracks total and monthly revenue trends

#### Key Monetization Metrics

- AOV (Average Order Value)
- ARPU (Average Revenue Per User)

#### Revenue Segmentation

- Product category
- Country
- Device
- Acquisition channel
- Payment method
- Premium vs non-premium users

- Evaluates whether growth is driven by user volume or spending behavior

---

## 📈 Key Insights

- Revenue growth is primarily driven by increased user activity rather than higher spending per order
- High churn (~45–50%) indicates weak user retention despite strong acquisition
- AOV remains stable (~1500–1800), reflecting consistent purchase behavior
- ARPU is steady, indicating stable monetization per user
- Revenue fluctuations align with changes in user activity rather than pricing

---

## 💡 Recommendations

### Fix Early-Stage Retention (Critical)

A significant portion of users drop off immediately after signup, indicating poor onboarding or weak initial value delivery.

Recommended improvements:

- Guided onboarding
- Incentives
- Personalized content
- Better first-session experience

---

### Address Consistently High Churn (~45–50%)

Nearly half of active users fail to return each month.

Recommended improvements:

- Lifecycle messaging
- Re-engagement campaigns
- Habit-forming features
- Retention-focused engagement

---

### Investigate Worsening Churn Trend

The spike in churn (~60%) suggests a potential disruption (product, UX, or external factors).

Recommended improvements:

- Root-cause analysis
- Behavioral diagnostics
- Funnel investigation during churn spike periods

---

### Optimize Checkout Experience

High drop-off at checkout indicates friction in the purchase process.

Recommended improvements:

- Simplify checkout flow
- Reduce unnecessary steps
- Improve payment reliability

---

### Shift Focus from Acquisition to Retention

Growth is currently driven by new users rather than sustained engagement.

Recommended improvements:

- Improve repeat usage
- Increase customer stickiness
- Build retention-first growth strategies

---

### Increase Repeat Purchase Behavior

Stable AOV but high churn suggests users spend normally but do not return.

Recommended improvements:

- Loyalty programs
- Personalized recommendations
- Repeat-purchase incentives

---

## 📷 Dashboard Preview

### Funnel Analysis

![Funnel Analysis](powerbi-dashboard/screenshots/funnel-analysis.png)

---

### Cohort Analysis

![Cohort Analysis](powerbi-dashboard/screenshots/cohort-analysis.png)

---

### Churn Analysis

![Churn Analysis](powerbi-dashboard/screenshots/churn-analysis.png)

---

### Revenue Analysis

![Revenue Analysis](powerbi-dashboard/screenshots/revenue-analysis.png)

---

## 🧠 Business Takeaway

The platform demonstrates strong acquisition and monetization capabilities but struggles with retention.

Sustainable growth will depend on improving user engagement, reducing churn, and increasing repeat user activity.
