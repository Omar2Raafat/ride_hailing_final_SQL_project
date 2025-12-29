# 🚖 Ride-Hailing Data Analysis  
**SQL • Data Warehouse Design • Power BI (Planned)**

---

## 📌 Project Overview

This project focuses on analyzing ride-hailing booking data using **SQL** and **data warehousing principles** to extract meaningful business insights related to customer behavior, cancellations, and booking patterns.

Instead of performing analysis on a flat dataset, the project emphasizes **designing a data warehouse from scratch**, transforming raw transactional data into a structured **fact and dimension model**. This approach closely reflects real-world analytics workflows used in reporting and business intelligence environments 📊.

---

## 🎯 Project Objective

The primary objective of this project is to:

- 🧱 Design a **star-schema data warehouse** from a single raw table  
- 🧠 Strengthen understanding of **fact vs dimension tables**  
- 🧹 Apply **SQL-based data cleaning and transformation**  
- 📈 Calculate key **business KPIs and behavioral metrics**  
- 🚀 Prepare an analytics-ready dataset for **Power BI dashboards**

Although the dataset size is modest, the focus of this project is on **architecture, logic, and analytical thinking**, rather than volume.

---

## 🗂 Dataset Description

- **Source:** :contentReference[oaicite:0]{index=0}  
- **Original Structure:**  
  - One flat transactional table  
  - ~150,000 rows  
- **Domain:** Ride-hailing / transportation bookings  

The dataset was intentionally reshaped to simulate a **production-style analytical database**.

---

## 🏗 Data Warehouse Design

The raw dataset was transformed into a **star schema** consisting of:

### 📊 Fact Table
- **fact_booking**  
  - Contains booking-level transactional data  
  - Acts as the central table for analysis  

### 📐 Dimension Tables
- **dim_date**  
- **dim_location**  
- **dim_customer**  
- **dim_vehicle**  
- **dim_cancel_reason**  
- **dim_payment_method**

This design enables:
- Efficient joins  
- Flexible slicing and filtering  
- Clear separation between metrics and descriptive attributes  

> ⚠️ **ERD Status**  
> An Entity Relationship Diagram (ERD) is planned and will be added in a future update.

---

## 🧹 Data Cleaning & Transformation (SQL)

All data preparation was performed using SQL, including:

- Handling **NULL values**
- Splitting raw attributes into **dimension tables**
- Applying **INNER JOIN** and **LEFT JOIN** logic based on business requirements
- Ensuring **referential integrity** between fact and dimensions
- Filtering data using business-driven conditions

This process resulted in a **clean, analysis-ready data model**.

---

## 📈 Exploratory Data Analysis (SQL)

SQL was used extensively to explore and analyze booking behavior through:

- Aggregations using `COUNT`, `SUM`, and `AVG`
- Conditional logic for behavioral analysis
- Calculation of **rates and percentages** for KPIs
- Grouping and filtering to answer business questions

All queries are organized and written with **readability and reusability** in mind.

---

## 📊 Key Metrics & KPIs

Examples of metrics calculated include:

- Customer vs driver cancellation rates  
- Distribution of cancellation reasons  
- Booking behavior patterns  
- Percentage-based behavioral indicators  

> 🔍 A dedicated **Business Questions & Answers** section (≈16 questions) will be added and documented in detail.

---
## 📊 Business Questions & Insights

This section presents the key business questions answered using SQL.
Each question includes the business context and the exact SQL query used in the analysis.

---

### Q1. How many total rides were completed?

**Why it matters:**  
Completed rides represent successful transactions and form the basis for all revenue analysis.

<details>
<summary><strong>SQL Query</strong></summary>

```sql
SELECT COUNT(*) AS total_completed_rides
FROM fact_bookings
WHERE booking_status = 'Completed';
</details> ```


## 📉 Power BI Visualization (Planned)

Power BI will be used to:

- Build interactive dashboards  
- Visualize KPIs and trends  
- Translate SQL results into business insights  

> ⏳ This section will be completed after finishing Power BI learning.

---

## 🛠 Tools & Technologies

- :contentReference[oaicite:1]{index=1} — SQL querying & data transformation  
- :contentReference[oaicite:2]{index=2} — Learning support & query refinement  
- ERD — *Planned*  
- :contentReference[oaicite:3]{index=3} — *Planned*

---

## 📁 Project Structure

