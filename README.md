# 📊 E-Commerce User Lifecycle Analytics: Funnel, Cohort Retention & Churn Analysis

## 🚀 Overview

This project performs an end-to-end analysis of user behavior across the e-commerce lifecycle, focusing on how users convert, engage, retain, churn, and generate revenue over time.

By combining funnel analysis, cohort retention analysis, churn modeling, and revenue analytics, the project provides a comprehensive business intelligence view of customer behavior and platform performance.

The project was designed using a modular analytics workflow to simulate a real-world business intelligence pipeline.

---

## 🔄 Project Workflow

Python Data Generation  
↓  
PostgreSQL Data Storage  
↓  
SQL Analysis & KPI Computation  
↓  
Power BI Data Modeling  
↓  
Interactive Dashboard Development

---

## 🎯 Objectives

- Understand how users move through the conversion funnel
- Analyze retention patterns across user cohorts
- Identify when and why users churn
- Evaluate revenue performance and monetization efficiency
- Detect business bottlenecks and user drop-off points

---

## 🛠 Tech Stack

- SQL – Core data analysis and KPI computation
- Python – Synthetic data generation
- Power BI – Dashboard development and visualization
- PostgreSQL – Data storage and querying

---

## 📊 Dataset Overview

The dataset was synthetically generated using Python to simulate realistic e-commerce user behavior across acquisition, engagement, conversion, retention, and monetization stages.

### Dataset Scale

- Users: 100,000
- Sessions: 726,000
- Events: 3,200,000
- Transactions: 3,100

### Core Tables

- Users → demographic and acquisition data
- Sessions → user visit behavior
- Events → in-session activity (view, click, add_to_cart, checkout, purchase)
- Transactions → completed purchases and revenue data

---

## 📁 Repository Structure

bash data-generation/      → Python scripts for synthetic data creation sql-analysis/         → SQL analysis and KPI computation scripts data-model/           → Power BI schema and relationship model powerbi-dashboard/    → Dashboard previews and Power BI resources 

---

## 🔍 Analysis Breakdown

### 1. Funnel Analysis

Tracks user progression through key conversion stages:

text view → product_click → add_to_cart → checkout → purchase 

Key focus areas:
- Conversion rates across funnel stages
- User drop-off analysis
- Purchase journey friction points
- Funnel efficiency optimization

---

### 2. Cohort Retention Analysis

Users are grouped by signup month to analyze long-term engagement behavior.

Key focus areas:
- Cohort-based retention tracking
- Repeat engagement behavior
- Retention decay patterns
- Long-term customer lifecycle trends

---

### 3. Churn & Retention Analysis

Defines churn as users who fail to return in the following month.

Key focus areas:
- Monthly churn trends
- Churn rate stability
- Retention performance over time
- User engagement deterioration
- Behavioral anomaly detection

---

### 4. Revenue Analysis

Tracks monetization performance and revenue trends over time.

Key metrics:
- Total Revenue
- Monthly Revenue
- AOV (Average Order Value)
- ARPU (Average Revenue Per User)

Revenue segmentation:
- Product category
- Country
- Device type
- Acquisition channel
- Payment method
- Premium vs non-premium users

The analysis evaluates whether growth is driven by:
- Increased user volume
- Higher user spending
- Improved monetization efficiency

---

## 📈 Key Insights

- Revenue growth was primarily volume-driven rather than AOV-driven
- Strong acquisition performance was offset by consistently high churn (~45–50%)
- Average Order Value remained stable (~1500–1800), indicating consistent purchase behavior
- ARPU remained relatively stable, reflecting predictable monetization performance
- Revenue fluctuations aligned more closely with changes in user activity than pricing behavior
- Significant user drop-off occurred during checkout, suggesting friction in the purchase flow
- Long-term cohort retention declined sharply after initial engagement

---

## 💡 Recommendations

### Improve Early-Stage Retention
A significant portion of users drop off shortly after signup, indicating onboarding friction or weak initial value delivery.

Recommended actions:
- Guided onboarding flows
- Personalized recommendations
- First-session incentives
- Improved activation experience

---

### Reduce High Churn Rates
Nearly half of active users fail to return each month.

Recommended actions:
- Lifecycle messaging campaigns
- Re-engagement workflows
- Push/email retention strategies
- Habit-forming engagement features

---

### Investigate Churn Spikes
The sudden churn increase (~60%) may indicate:
- Product experience issues
- UX disruptions
- Seasonal behavior shifts
- External market factors

Recommended actions:
- Root-cause analysis
- Session behavior diagnostics
- Funnel anomaly investigation

---

### Optimize Checkout Experience
High checkout-stage drop-offs suggest purchase friction.

Recommended actions:
- Simplify checkout flow
- Reduce form complexity
- Improve payment reliability
- Streamline purchase completion

---

### Shift Focus Toward Retention
Growth is currently driven more by acquisition than sustained engagement.

Recommended actions:
- Increase repeat purchase behavior
- Improve customer stickiness
- Invest in loyalty mechanisms
- Build retention-first growth strategies

---

## 📷 Dashboard Preview

### Funnel Analysis
Funnel Analysis

### Cohort Analysis
Cohort Analysis

### Churn Analysis
Churn Analysis

### Revenue Analysis
Revenue Analysis

---

## 🧠 Business Takeaway

The platform demonstrates strong acquisition and monetization capabilities but struggles with long-term retention and user stickiness.

While users convert and spend consistently, sustained growth will depend on improving retention, reducing churn, and increasing repeat engagement.

The project highlights how lifecycle analytics can uncover critical business bottlenecks and support data-driven product and growth decisions.
