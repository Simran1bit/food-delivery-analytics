# 🗄️ Food Delivery Analytics (SQL)

This folder demonstrates a complete SQL-based data analytics workflow using SQLite.

The project simulates how raw operational data is transformed into business-ready reporting datasets through data auditing, cleaning, business analysis, and reporting views.

---

# 📌 SQL Workflow

```text
Raw Dataset
      │
      ▼
01_import.sql
      │
      ▼
02_audit.sql
      │
      ▼
03_cleaning.sql
      │
      ▼
04_business_queries.sql
      │
      ▼
05_views.sql
      │
      ▼
Power BI Dashboard
```

---

# 📂 SQL Files

| File | Purpose |
|------|---------|
| 01_import.sql | Import raw dataset and validate import |
| 02_audit.sql | Profile dataset and identify data quality issues |
| 03_cleaning.sql | Clean, standardize and validate the dataset |
| 04_business_queries.sql | Perform business analysis using SQL |
| 05_views.sql | Create reusable reporting views for Power BI |

---

# 📥 Phase 1 — Data Import

The first step imports the raw CSV dataset into SQLite.

Objectives:

- Import raw dataset
- Verify successful import
- Validate row count
- Inspect table schema

A separate cleaned table (`clean_orders`) is created later to preserve the original dataset.

---

# 🔍 Phase 2 — Data Audit

Before cleaning, the dataset is profiled to understand data quality.

The audit includes:

## Duplicate Analysis

- Duplicate Order IDs
- Duplicate record count

## Missing Values

Inspected missing values for:

- City
- Price
- Customer Rating
- Delivery Time

## Data Validation

Validated business constraints such as:

- Invalid prices
- Invalid quantities
- Invalid ratings
- Invalid delivery times

## Categorical Inspection

Reviewed distinct values for:

- Restaurant
- Category
- Food Item
- Payment Method
- Quantity

The audit phase determines which columns require cleaning before analysis.

---

# 🧹 Phase 3 — Data Cleaning

Cleaning is performed on a new table (`clean_orders`) to preserve the original raw dataset.

## Duplicate Removal

Removed duplicate records using `Order_ID` while preserving the first occurrence.

---

## Quantity Cleaning

- Converted textual quantities into numeric values
- Converted invalid quantities to NULL

---

## Price Cleaning

Business Rules:

- Placeholder values converted to NULL
- Invalid prices converted to NULL

Hierarchical imputation strategy:

Level 1

Restaurant + Food Item + City

↓

Level 2

Restaurant + Food Item

This preserves local pricing behaviour instead of relying on global averages.

---

## Customer Rating

Business Rules:

- Ratings outside 0–5 considered invalid
- Invalid ratings converted to NULL

Imputation Strategy:

Restaurant + City average

---

## Delivery Time

Business Rules:

- Delivery time ≤ 0 considered invalid

Imputation Strategy:

Restaurant + City average

---

## City Cleaning

Text standardized using:

- LOWER()
- TRIM()

After auditing, every restaurant was found to operate across multiple cities.

Therefore, missing city values could not be inferred reliably.

Instead of creating incorrect values, missing cities were assigned:

```
Unknown
```

---

## Date Handling

Rows containing placeholder dates were intentionally preserved.

Artificial dates were not generated because doing so could distort:

- Revenue trends
- Monthly analysis
- Operational reporting

These values are handled during Power BI date conversion.

---

## Validation

Every cleaning step follows the same workflow:

```
Inspect

↓

Validate

↓

Business Rule

↓

Update

↓

Verify
```

This ensures every transformation is backed by data rather than assumptions.

---

# 📊 Phase 4 — Business Analysis

Business questions are answered entirely using SQL.

## Executive KPIs

- Total Orders
- Total Revenue
- Average Order Value
- Average Rating
- Average Delivery Time

---

## Sales Analysis

- Revenue by City
- Revenue by Restaurant
- Revenue by Category
- Revenue by Food Item

---

## Customer Analysis

- Highest Rated Restaurants
- Lowest Rated Restaurants
- Ratings by City

---

## Delivery Analysis

- Fastest Restaurants
- Slowest Restaurants
- Delivery Distribution
- Fastest Cities
- Slowest Cities

---

## Restaurant Analysis

- Restaurant KPIs
- Top Restaurants
- Bottom Restaurants

---

## Product Analysis

- Top Products
- Category Performance

---

## Monthly Analysis

Performed month-over-month analysis using:

- Revenue
- Orders
- Ratings
- Delivery Time

Month-over-month revenue change was calculated using:

```
LAG()
```

---

## Advanced Analysis

Additional business insights include:

- Revenue Contribution (%)
- Restaurant Performance Classification
- Top Revenue Product within each Category

---

# 🚀 Advanced SQL Concepts Used

This project demonstrates practical usage of:

## Common Table Expressions

```
WITH
```

---

## Window Functions

- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LAG()

---

## Window Aggregates

```
SUM() OVER()
```

---

## Ranking

Used to identify:

- Top Restaurants
- Highest Rated Restaurants
- Top Products

---

## Partitioning

```
PARTITION BY
```

Used to identify the highest revenue product within each category.

---

## Conditional Logic

```
CASE
```

Used for:

- Delivery Speed Classification
- Restaurant Performance Classification
- Month Name Generation

---

# 🗄️ Phase 5 — SQL Reporting Layer

Instead of connecting Power BI directly to raw SQL queries, reusable reporting views were created.

Views include:

- vw_executive_summary
- vw_city_performance
- vw_restaurant_performance
- vw_product_performance
- vw_monthly_trends
- vw_delivery_distribution
- vw_revenue_contribution
- vw_top_products

These views simulate a production reporting layer and simplify dashboard development.

---

# 💡 Business Insights Generated

Examples include:

- Highest revenue cities
- Highest performing restaurants
- Customer satisfaction trends
- Delivery performance
- Revenue contribution
- Monthly revenue growth
- Product performance
- Restaurant rankings

---

# 🛠️ SQL Features Demonstrated

- Data Auditing
- Data Cleaning
- Missing Value Handling
- Business Rule Validation
- Hierarchical Imputation
- Aggregate Functions
- CASE Statements
- Common Table Expressions
- Window Functions
- SQL Views
- Reporting Layer Design

---

# 💻 Database

- SQLite

---

# 🎯 Learning Outcome

This SQL implementation demonstrates how SQL can be used beyond simple querying to build a complete analytics pipeline.

The workflow follows the same structure commonly used in business intelligence projects:

Raw Data → Data Audit → Cleaning → Business Analysis → Reporting Layer → Dashboard
