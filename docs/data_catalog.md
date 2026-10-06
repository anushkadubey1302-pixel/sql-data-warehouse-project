# DATA CATALOG FOR GOLD LAYER

## Overview

THE Gold Layer is the representation for the data (business-level) that support the analytical & reporting use cases.
It consist of a **fact table** & two **dimension tables**.

---
### 1. **gold.fact_sales**

 - **Purpose :**  Stores transactional sales data for analytical purposes.
 - **Columns:**

| Column Name     | Data Type     | Description                                                                                      |
|-----------------|---------------|--------------------------------------------------------------------------------------------------|
| order_number    | NVARCHAR(50)  | A unique alphanumeric identifier for each sales order (e.g., 'SO44622').                         |
| product_key     | INT           | Surrogate key to link the order to the product dimension table.                                  |
| customer_key    | INT           | Surrogate key to link the order to the customer dimension table.                                 |
| order_date      | DATE          | The date when the order was placed.                                                              |
| shipping_date   | DATE          | The date when the order was shipped to the customer.                                             |
| due_date        | DATE          | The date when the order payment was due.                                                         |
| sales_amount    | INT           | The total amount of sale for the line item in the currency unit (e.g., 3578).                    |
| quantity        | INT           | The number of units of the product ordered for the line item (e.g., 1).                          |
| price           | INT           | The price of the product for the line item per unit, in currency units (e.g., 3578).             |


### 2. **gold.dim_customers**
- **Purpose:** Stores customer details for data enrichment.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                      |
|------------------|---------------|--------------------------------------------------------------------------------------------------|
| customer_key     | INT           | Surrogate key we used to uniquely identifying each customer record in the dimension table.       |  
| customer_id      | INT           | Unique identifier assigned to each customer.                                                     |
| customer_number  | NVARCHAR(50)  | Alphanumeric identifier representing the customer, used for tracking and referencing.            |
| first_name       | NVARCHAR(50)  | The customer's first name, as recorded in the system.                                            |
| last_name        | NVARCHAR(50)  | The customer's last name or family name.                                                         |
| country          | NVARCHAR(50)  | The country of residence for the customer (e.g., 'USA').                                         |
| marital_status   | NVARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single').                                  |
| gender           | NVARCHAR(50)  | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                      |
| birthdate        | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1979-01-14).                   |
| create_date      | DATE          | The date and time when the customer record was created in the system                             |

---

### 3. **gold.dim_products**
- **Purpose:** Provides information about the products and their attributes.
- **Columns:**

| Column Name         | Data Type     | Description                                                                                    |
|---------------------|---------------|------------------------------------------------------------------------------------------------|
| product_key         | INT           | Surrogate key uniquely identifying each product record in the product dimension table.         |
| product_id          | INT           | Unique  identifier assigned to each product for internal tracking and referencing.             |
| product_number      | NVARCHAR(50)  | Alphanumeric identifier representing the product, often used for categorization or inventory.  |
| product_name        | NVARCHAR(50)  | Descriptive name of the product, including key details such as type, color, and size.          |
| category_id         | NVARCHAR(50)  | A unique identifier for the product's category, linking to its high-level classification.      |
| category            | NVARCHAR(50)  | Classification of the product (e.g., Bikes, Components) to group related items.                |
| subcategory         | NVARCHAR(50)  | More detailed classification of the product within the category, such as product type.         |
| maintenance_required| NVARCHAR(50)  | Indicates whether the product requires maintenance (e.g., 'Yes', 'No').                        |
| cost                | INT           | The cost or base price of the product.                                                         |
| product_line        | NVARCHAR(50)  | The specific product line or series to which the product belongs (e.g., Road, Mountain).       |
| start_date          | DATE          | The date when the product became available for sale or stored to use                           |

---


