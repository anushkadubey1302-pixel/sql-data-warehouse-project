# 🏘️ sql-data-warehouse-project
Welcome to the "sql-data-warehouse-project" repository! This project is part of my SQL and Data Engineering learning journey
From raw data to meaningful insights - building a sql data warehouse for data-driven analytics. Building a data warehouse project with SQL server, that involves ETL processes, data modeling and analytics

Using Microsoft SQL Server, this project demonstrates the design and development of a modern SQL-based data warehouse, covering data integration, ETL workflows,data transformations, data modeling and analytical reporting.
The goal is to apply practical data engineering concepts and SQL skills to organize data, explore business trends, and generate meaningful insights that support data-driven decision-making.

---
## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
![Data Architecture](docs/DataArchitecture.png)

1. **Bronze Layer**: Stores raw data as-it-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Business-ready data is modelled into a star schema further required for reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.
---
## 👩‍🎓 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective 
Main objective is to design a system to consolidate raw data, maintain data quality, and perform analytical operations

#### Specifications

**▪️ Data Sources** : Data is sourced from **ERP and CRM CSV files**. The datasets will be integrated and transformed to build the data warehouse.

**▪️Data Quality** : Data quality issues will be identified and resolved before analysis. The data will be cleaned & validated to ensure accurate and reliable results.

**▪️Integration** : Integrate ERP and CRM data into a centralized SQL Server data warehouse. Transform and combine the data to provide a unified view for analysis.

**▪️Scope** : The project focuses on processing the latest available ERP and CRM datasets; data historization is not required.

**▪️Documentation**:Documentation will support business stakeholders and the analytics team. It will cover key data, processes, and insights.

---

## 🛠️ Important Links & Tools:

Everything is for Free!
- **[Datasets](datasets/):** Access to the project dataset (csv files).
- **[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads):** Lightweight server for hosting your SQL database.
- **[SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16):** GUI for managing and interacting with databases.
- **[Git Repository](https://github.com/):** Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- **[DrawIO](https://www.drawio.com/):** Design data architecture, models, flows, and diagrams.
- **[Notion](https://www.notion.com/templates/sql-data-warehouse-project):** Get the Project Template from Notion

---

### ➡️📶 Analytics & Reporting


#### Objectives

Develop SQL-based analytics to deliver detailed insights into:


**▪️Customer Behavior**

**▪️Product Performance**

**▪️Sales Trends**

These insights help stakeholders with enhancing the business performance and decision-making

---


## License

This project is licensed under the [MIT License](LICENSE).


---



## About Me


Hello! I am **Anushka Dubey** an MCA graduate exploring **SQL, Data Analytics, and Data Engineering**.
This project is part of my journey to build practical skills through real-world data projects.


---
