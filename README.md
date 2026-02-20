# Northwind Analysis

SQL and Power BI analysis of Northwind Trading's sales, customer, and employee/product performance data from 1996–1998.

---

## Project Overview

This project analyzes two years of order data from Northwind Trading, a fictional specialty food supplier. Using MySQL for data exploration and validation, and Power BI for visualization, the project surfaces insights across three key areas: overall sales performance, customer behavior, and employee and product metrics.

---

## Tools & Technologies

- **MySQL** — data validation, revenue analysis, fulfillment tracking, and dashboard queries
- **Power BI** — interactive dashboard development and data visualization

---

## Dataset

The dataset consists of two tables:

- **northwind_orders** — order-level data including customer, employee, dates, shipping, and freight information
- **northwind_order_details** — line-item data including product, unit price, quantity, and discount per order

---

## Dashboards

### 1. Northwind Sales Overview
Provides a high-level view of overall business performance from 1996 to 1998.

**KPIs:** Total Revenue ($1.35M) · Total Orders (830) · Average Order Value ($1.63K)

**Key Insights:**
- Average monthly revenue grew 45% in 1997 and 71% in 1998, indicating strong business momentum
- USA and Germany together account for 37.5% of total revenue
- Revenue acceleration entering 1998 suggests a strong growth trajectory

---

### 2. Northwind Customer Analysis
Examines customer value, order behavior, and revenue concentration across the customer base.

**KPIs:** Total Customers (89) · Revenue per Customer ($15.22K) · Avg Orders per Customer (9.33) · Top 10 Customer Revenue Share (45.50%) · Avg Revenue per Order ($628.52)

**Key Insights:**
- 75% of customers fall into the Low Value segment (< $20K), contributing a significant portion of revenue through volume
- High Value customers (> $50K) represent a small share of the base but generate significantly higher revenue per account
- Revenue concentration among the top 10 customers highlights both retention priority and dependency risk

---

### 3. Northwind Product & Employee Performance
Tracks employee output, fulfillment reliability, and product-level revenue and volume.

**KPIs:** Number of Employees (9) · Number of Products (77) · Late Order Percentage (4.50%) · Total Units Sold (51.32K)

**Key Insights:**
- Employee 4 leads all employees in both total revenue and orders sold
- Employee 9 has the highest late order rate at ~9% despite having a lower order volume
- Product 38 is the top revenue-generating product, while Product 60 leads in units sold — suggesting Product 38 commands a significantly higher price point
- The overall late order rate of 4.50% reflects strong fulfillment performance across the team

---

## SQL Scripts

| File | Description |
|------|-------------|
| `01_data_validation.sql` | Initial checks for nulls, duplicates, and data integrity |
| `02_revenue_analysis.sql` | Revenue breakdowns by country, customer, and product |
| `03_time_analysis.sql` | Monthly and yearly revenue trends |
| `04_fulfillment_analysis.sql` | Late order analysis by employee |
| `05_data_quality.sql` | Additional data quality checks |
| `06_dashboard_queries.sql` | All queries powering the three Power BI dashboards |

---

## Repository Structure

```
Northwind-Analysis/
├── README.md
├── data/
│   ├── northwind_orders.xlsx
│   └── northwind_order_details.xlsx
├── sql/
│   ├── 01_data_validation.sql
│   ├── 02_revenue_analysis.sql
│   ├── 03_time_analysis.sql
│   ├── 04_fulfillment_analysis.sql
│   ├── 05_data_quality.sql
│   └── 06_dashboard_queries.sql
└── powerbi/
    ├── Northwind_Sales_Overview.pbix
    ├── Northwind_Customer_Analysis.pbix
    ├── Northwind_Product_Employee_Performance.pbix
    └── dashboards/
        ├── Sales_Overview.pdf
        ├── Customer_Analysis.pdf
        └── Product_Employee_Performance.pdf
```
