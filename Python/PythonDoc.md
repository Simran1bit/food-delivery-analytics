# 🐍 Food Delivery Analytics (Python)

This module focuses on **data preprocessing, exploratory data analysis (EDA), and business-oriented visualizations** for the Food Delivery Analytics project.

The objective of this Python implementation is to transform messy delivery data into an analysis-ready dataset, explore business patterns, and generate actionable insights through visualizations.

> **Note:** This repository also contains SQL and Power BI implementations. This README documents only the Python workflow.

---

# 📌 Workflow

```text
Raw Dataset
      │
      ▼
Data Cleaning
      │
      ▼
Feature Engineering
      │
      ▼
Exploratory Data Analysis
      │
      ▼
Business Insights
      │
      ▼
Visualizations
```

---

# 📂 Files

| File | Description |
|------|-------------|
| `cleaning.py` | Cleans and preprocesses the raw dataset |
| `analysis.py` | Performs exploratory analysis and business analytics |
| `food_delivery_raw_messy_dataset.csv` | Original dataset |
| `cleaned_food_delivery.csv` | Cleaned dataset generated after preprocessing |
| `images/` | Saved charts and visualizations |

---

# 📊 Dataset

The dataset intentionally contains real-world data quality issues, including:

- Missing values
- Duplicate records
- Invalid prices
- Invalid quantities
- Invalid customer ratings
- Invalid delivery times
- Mixed data types
- Inconsistent text values

The goal of this project is to practice realistic preprocessing techniques rather than working with a perfectly clean dataset.

---

# 🧹 Data Cleaning

The preprocessing pipeline transforms raw delivery data into an analysis-ready dataset.

## Cleaning Performed

### Duplicate Removal

- Removed duplicate orders using `Order_ID`.

### Data Validation

Validated business-critical fields including:

- Price
- Quantity
- Customer Rating
- Delivery Time

Invalid values were converted into missing values before further processing.

### Missing Value Handling

Instead of relying on global averages, contextual imputation was performed wherever appropriate.

Examples include:

- Restaurant + Food Item + City
- Food Item + City
- Restaurant-level averages

This approach helps preserve realistic business patterns while minimizing distortion.

### Quantity Standardization

Converted textual quantities (for example, `"three"`) into numeric values instead of discarding the records.

### Feature Engineering

Created additional analytical columns including:

- Revenue
- Day
- Month
- Month Name
- Date Flag

Revenue was calculated as:

```
Revenue = Price × Quantity
```

The `Date_Flag` column identifies records with unreliable dates, allowing trend analysis to exclude those records without creating artificial timestamps.

---

# 📈 Exploratory Data Analysis

The cleaned dataset was analyzed to answer business-oriented questions.

## Revenue Analysis

- Revenue by City
- Revenue by Restaurant
- Revenue by Category

## Restaurant Performance

- Top Restaurants
- Highest Rated Restaurants
- Average Delivery Time by Restaurant

## Customer Analysis

- Rating by City
- Rating vs Delivery Speed

Delivery times were grouped into meaningful categories using `pd.cut()` to improve interpretability.

## Operational Analysis

- Monthly Order Trends
- Fastest Delivery Cities
- Payment Method Usage

---

# 📷 Visualizations

The project automatically generates visualizations including:

- Revenue by City
- Revenue by Category
- Revenue by Restaurant
- Monthly Orders
- Customer Rating vs Delivery Speed
- Payment Method Distribution
- Average Delivery Time by Restaurant

# 📸 Sample 

## Revenue per City
![Revenue per City](Python/images/revenue_per_city.png)

## Number of orders per Month
![Number of orders per Month](Python/images/number_of_orders_per_month.png)

## Revenue per Category
![Revenue per Category](Python/images/revenue_per_category.png)

Generated charts are saved inside the `images/` directory.

---

# 💡 Key Learnings

This project strengthened understanding of:

- Data Cleaning
- Data Validation
- Missing Value Handling
- Feature Engineering
- Exploratory Data Analysis (EDA)
- Business-Oriented Analytics
- Data Visualization

One of the biggest lessons learned during this project was:

> Missing values should not always be forcefully filled. Preserving trustworthy data is often more valuable than creating artificial data.

---

# 🛠️ Technologies Used

- Python
- Pandas
- NumPy
- Matplotlib

---

# 👩‍💻 Author

**Simran**

Built as a hands-on learning project to practice realistic data cleaning, exploratory data analysis, and business-oriented analytics using Python.
