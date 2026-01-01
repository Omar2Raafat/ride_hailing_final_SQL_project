## 📌 Project Overview

🚖 **Ride-Hailing Data Analysis** is an end-to-end analytics project focused on transforming **synthetic ride-hailing data** into a **clean, well-structured data warehouse** and extracting **meaningful business insights** using SQL and data visualization.

The dataset used in this project is **simulated** and designed to resemble real-world ride-hailing operations. While the numerical values do not represent an actual company, the **data modeling, analytical logic, and analytical workflow reflect real production analytics practices**.

Throughout the project, the role of a data analyst is simulated by:
- Designing a **scalable star schema** suitable for analytical workloads  
- Cleaning and structuring data to ensure **data consistency and integrity**  
- Answering **business-driven questions** related to ride activity and cancellations  
- Communicating insights clearly through **SQL-based analysis and dashboards**

📊 The primary objective of this project is to demonstrate **strong analytical thinking and technical execution**, rather than to report real operational metrics.

## 🏢 Business Context

Ride-hailing platforms operate in a highly competitive environment where
**operational efficiency, customer satisfaction, and driver availability**
directly affect overall business performance.

Analyzing ride-level data enables stakeholders to:
- Monitor platform usage and ride demand
- Understand cancellation behavior and its impact on service reliability
- Distinguish between customer-driven and driver-driven operational issues
- Support data-driven decisions aimed at improving service quality

This project represents a common real-world analytics scenario where
structured data analysis is used to transform raw operational data into
**actionable insights** for business and operations teams.


## 🎯 Project Objectives

The objective of this project is to showcase a **professional data analytics workflow**
that reflects real-world analytical and reporting tasks.

The project focuses on the following goals:
- Design a **clean and scalable data warehouse** using a star schema approach  
- Convert raw ride-hailing data into a **structured analytical model**  
- Apply SQL to answer **business-oriented analytical questions**  
- Analyze ride activity and cancellation behavior to identify meaningful patterns  
- Communicate insights effectively through **clear metrics and dashboards**

Rather than emphasizing real operational results, the project prioritizes
**analytical reasoning, data modeling principles, and technical execution**.

## 📊 Dataset Description

The dataset used in this project is **synthetic** and was created to simulate
real-world ride-hailing operations for analytical and educational purposes.

It represents ride-level booking data and includes information related to:
- Ride status and trip details  
- Customers and drivers  
- Vehicle types and payment methods  
- Ride cancellations and cancellation reasons  
- Ratings and time-based metrics  

Although the numerical values do not correspond to an actual ride-hailing
company, the dataset is **internally consistent** and structured to support
realistic data modeling, SQL analysis, and business intelligence workflows.

## 🏗️ Data Warehouse Design

The project follows a **star schema** design to support efficient analytical
queries and clear separation between transactional events and descriptive
attributes.

A central **fact table** captures ride-level events, while multiple
**dimension tables** provide contextual information such as customer details,
driver attributes, time, and cancellation reasons.

This design approach:
- Simplifies analytical queries
- Improves query performance
- Supports scalability for future metrics and dimensions
- Aligns with industry-standard analytical modeling practices

## 🧩 Entity Relationship Diagram (ERD)

The Entity Relationship Diagram (ERD) illustrates how the fact table connects
to its associated dimension tables through surrogate keys.

The model enforces clear relationships between rides, customers, drivers,
dates, and cancellation reasons, ensuring **data integrity** and enabling
flexible, multi-dimensional analysis.

The ERD serves as a visual representation of the analytical data model used
throughout the project.

## 🧹 Data Cleaning & Preparation

Before analysis, the data was reviewed and prepared to ensure consistency
and analytical reliability. Key preparation steps included:

- Standardizing date and time fields
- Validating ride status and cancellation logic
- Ensuring consistency between ride outcomes and cancellation reasons
- Handling missing or non-applicable values appropriately
- Aligning fact and dimension tables to maintain referential integrity

These steps ensure that the analytical results are based on **clean and
logically consistent data**.

## ❓ Business Questions

The analysis aims to answer several business-relevant questions, including:

1. What is the overall volume of ride activity on the platform?
2. What proportion of rides are canceled?
3. How do customer-initiated cancellations compare to driver-initiated cancellations?
4. Are there noticeable patterns in cancellations over time?
5. How does ride activity vary across different vehicle types?

These questions reflect common analytical requirements used to evaluate
platform performance and operational behavior.

## 🧠 Analytical Approach

SQL was used as the primary analytical tool to explore and analyze the data.
The analysis involved:

- Joining fact and dimension tables to enrich ride-level data
- Applying aggregations to calculate key metrics
- Filtering and grouping data to compare behaviors across categories
- Using structured and readable queries to ensure clarity and maintainability

This approach mirrors how analysts typically work with data warehouses
in real-world environments.

## 📌 Key Insights & Findings

The analysis revealed several notable patterns:

- Ride cancellations represent a significant portion of total ride activity
- Customer-initiated and driver-initiated cancellations exhibit different
  behavioral characteristics
- Cancellation activity varies across time periods, indicating potential
  demand or supply-side patterns
- Certain vehicle types show differing levels of ride activity and stability

These insights demonstrate how structured data analysis can support
operational understanding and decision-making.

## 📈 Visualization & Dashboard Overview

A Power BI dashboard was developed to visually communicate key metrics and
analytical findings.

The dashboard provides:
- An overview of total rides and cancellation rates
- A breakdown of cancellations by type
- Time-based trends and comparisons
- Interactive visuals designed for stakeholder interpretation

The visualization layer complements the SQL analysis by transforming
results into **clear and actionable insights**.

## 🛠️ Tools & Technologies

The project was developed using the following tools and technologies:

- **SQL (PostgreSQL)** for data modeling, transformation, and analysis
- **Power BI** for data visualization and dashboard creation
- **Git & GitHub** for version control and project publishing
- **ERD design tools** for data model visualization

## ⚠️ Limitations & Assumptions

- The dataset used in this project is **synthetic** and does not represent
  real operational data
- Insights are illustrative and intended to demonstrate analytical logic
  rather than actual business performance
- Some real-world complexities, such as live pricing or dynamic driver
  availability, are not modeled

These limitations are acknowledged to ensure transparency and proper
interpretation of the results.

## 🧠 Skills Demonstrated

This project demonstrates the following skills:

- Data warehouse design and star schema modeling
- SQL querying, joins, aggregations, and filtering
- Data cleaning and validation techniques
- Business-focused analytical thinking
- Data visualization and insight communication
- Professional documentation and project structuring