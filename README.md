## General Description

This project focuses on building and analyzing a relational database using SQL. Starting from several CSV files, the work involves designing a **star‑schema database**, creating its tables, importing data, and performing analytical queries to extract insights.

The workflow follows a complete data engineering and analytics pipeline:

- Designing the database structure.
- Creating dimension and fact tables.
- Importing and validating data from multiple CSV sources.
- Handling MySQL configuration constraints such as `local_infile` and `secure_file_priv`.
- Executing analytical SQL queries involving joins, aggregations, and subqueries.

The result is a fully functional database (`sales_track`) ready for business analysis.


## 📗 Level 1 — Database Construction and Data Loading

This level covers all tasks required to set up the database environment:

- Creation of the database.
- Definition of the schema following a **star model**:
- Creation of all tables with appropriate data types, primary keys, and foreign keys.
- Configuration of MySQL to allow file imports:
  - Checking and enabling `local_infile`
  - Identifying the allowed directory via `secure_file_priv`
- Importing data from CSV files
- Verifying data integrity through exploratory queries.

This level establishes the full data infrastructure needed for analysis.


## 📙 Level 2 — Analytical SQL Queries

### **Exercise 1 — Find most active Users**

- Initial exploratory subquery to inspect transaction counts per user.
- Identification of the most active users in the dataset.

### **Exercise 2 — Calculation of Average Transaction Amount per credit card**

- Identification of the company ID of Donec Ltd and inspection of all transactions associated with that company.
- Analytical queries and calculation of the average spending per credit card for transactions made at Donec Ltd.

### **Language**
- **SQL (MySQL dialect)** — used for schema creation, data loading, and analytical queries.

### 🛠️ **Tools**
- **MySQL Workbench**

### **Technologies**
- **MySQL Server 8.0**
  - Relational database engine
  - Management of `secure_file_priv` and `local_infile`

