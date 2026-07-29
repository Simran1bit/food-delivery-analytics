# 🍔 Food Delivery Analytics | End-to-End Data Analytics Project

![Python](https://img.shields.io/badge/Python-3.x-blue)
![SQL](https://img.shields.io/badge/SQL-SQLite-green)
![Power BI](https://img.shields.io/badge/Power_BI-Dashboard-yellow)
![Status](https://img.shields.io/badge/Project-Completed-brightgreen)

An end-to-end **Data Analytics** project that transforms a messy food delivery dataset into interactive business insights using **Python, SQL (SQLite), and Power BI**.

The project follows a realistic analytics workflow including data auditing, cleaning, exploratory analysis, business reporting, and dashboard development.

---

## 🚀 Project Highlights

- 🧹 Cleaned and validated raw operational data using SQL and Python
- 📊 Performed business-oriented exploratory data analysis (EDA)
- 🗄️ Built reusable SQL reporting views
- 📈 Developed an interactive Power BI dashboard
- 💡 Generated actionable business insights for restaurant operations and sales performance

---

## 🏗️ Project Architecture

```text
                              Raw Food Delivery Dataset
                                         │
                     ┌───────────────────┴───────────────────┐
                     │                                       │
                     ▼                                       ▼
             🐍 Python Analytics                     🗄️ SQL Analytics
                     │                                       │
             Data Cleaning                           Data Import
                     │                                       │
             Feature Engineering                     Data Quality Audit
                     │                                       │
         Exploratory Data Analysis                  Data Cleaning
                     │                                       │
            Business Visualizations               Business Analysis
                     │                                       │
             Charts & Insights                    Reporting Views
                                                             │
                                                             ▼
                                                      ODBC Connection
                                                             │
                                                             ▼
                                                     📊 Power BI Dashboard
                                                             │
                                                             ▼
                                                   Executive Business Insights
```

---

## 📂 Repository Structure

```text
Food-Delivery-Analytics/
│
├── README.md                    ← Main project overview
│
├── Python/
│   ├── README.md                ← Python documentation
│   ├── scripts/
│   │   ├── cleaning.py
│   │   └── analysis.py
│   │
│   ├── data/
│   │   └── cleaned_food_delivery.csv
│   │
│   └── images/
│       ├── revenue_per_city.png
│       ├── revenue_per_category.png
│       ├── ...
│
├── Raw_Data/
│   ├── food_delivery_raw_messy_dataset.csv
│   └── dataset_issues_summary.md
│
├── SQL/
│   ├── README.md                ← SQL walkthrough
│   ├── 01_import.sql
│   ├── 02_data_audit.sql
│   ├── 03_cleaning.sql
│   ├── 04_business_queries.sql
│   └── 05_views.sql
│
└── PowerBI/
    ├── README.md  
    ├── Food Delivery Dashboard.pbix
    └── dashboard.png
```

---

## 🔄 Analytics Workflow

### 🐍 Python

- Data preprocessing
- Feature engineering
- Exploratory Data Analysis (EDA)
- Business visualizations

📖 **Detailed documentation:** `Python/README.md`

---

### 🗄️ SQL

Built a complete SQL analytics pipeline including:

- Data Import
- Data Quality Audit
- Data Cleaning & Validation
- Business Analysis
- SQL Views
- Reporting Layer

📖 **Detailed documentation:** `SQL/README.md`

---

### 📊 Power BI

Built an interactive dashboard featuring:

- Executive KPIs
- Revenue Analysis
- Restaurant Performance
- Product Performance
- Monthly Trends
- Delivery Performance
- Interactive Filters

---

## 📊 Dashboard Preview

![Food Delivery Analytics Dashboard](PowerBI/dashboard.png)

---

## 🛠️ Technologies Used

- Python
- Pandas
- NumPy
- Matplotlib
- SQLite
- SQL
- Power BI
- DAX
- Power Query
- ODBC

---

## 💼 Skills Demonstrated

### Data Engineering

- Data Auditing
- Data Cleaning
- Data Validation
- Missing Value Handling
- Feature Engineering

### SQL

- Common Table Expressions (CTEs)
- Window Functions
- SQL Views
- Business Reporting
- Data Modeling

### Analytics

- Exploratory Data Analysis (EDA)
- Business Analysis
- KPI Development
- Business Insight Generation

### Visualization

- Power BI Dashboard Design
- Interactive Reporting
- Business Storytelling

---

## 💡 Key Business Insights

- Delhi generated the highest overall revenue.
- Healthy Bites contributed the highest share of restaurant revenue.
- Sushi was the highest revenue-generating product.
- Fast Food and Indian cuisines generated the largest share of revenue.
- Most deliveries were completed within 30–60 minutes.
- Monthly revenue increased from April to May before declining slightly in June.

---

## 🎯 Project Outcome

This project demonstrates a complete analytics workflow—from raw operational data to executive-level reporting.

By combining **Python for exploratory analysis**, **SQL for data preparation and reporting**, and **Power BI for visualization**, the project closely reflects the workflow followed by data analysts in real-world business environments.

---

## 👩‍💻 Author

**Simran**

Built as a hands-on portfolio project to strengthen practical skills in **Data Analytics**, **SQL**, **Python**, and **Power BI**.
