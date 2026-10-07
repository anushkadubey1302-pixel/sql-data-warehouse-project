/*
===================================================================================================================
Quality Checks
===================================================================================================================
Script Purpose:   
        This script performs the quality of silver layer after loading the data from bronze layer for data analysis.
        These checks validate consistency,standarization and accuracy of silver layer.
        It includes checks for:

        - String (Unwanted spaces)
        - Null or duplicate primary keys
        - Data Consistency & Standardization
        - Invalid & Out-of-Range Dates

Usage Notes:
        - Run these checks after loading the data into Silver Layer.
        - Investigate and resolve any discrepancies found during the checks.
*/

--===================================================================================================================
--Checking : 'silver.crm_cust_info
--===================================================================================================================
-- check for unwanted spaces
-- Expectation: No Result
  
select
cst_firstname
from silver.crm_cust_info
where cst_firstname != TRIM(cst_firstname)
 
select
cst_lastname
from silver.crm_cust_info
where cst_lastname != TRIM(cst_lastname)
 
select
cst_gndr
from silver.crm_cust_info
where cst_gndr != TRIM(cst_gndr)    -- if the og value != trim -> there r spaces

--===================================================================================================================
--Checking : 'silver.crm_cust_info
--===================================================================================================================
-- CHECK - Check for Nulls or Duplicates in Primary key (A pk must be unique & not null)
-- Expectation: No Result */

select
cst_id,
COUNT(*)
from silver.crm_cust_info

GROUP BY cst_id
HAVING COUNT (*)>1 OR cst_id IS NULL

 --===================================================================================================================
--Checking : 'silver.crm_cust_info
--====================================================================================================================
 -- CHECK : Data Consistency & Standardization
 -- Expectation : Aim to store clear & meaningful values rather than using abbreviated terms

 select distinct                       
 cst_gndr                              
 from silver.crm_cust_info

 select distinct    
 cst_marital_status
 from silver.crm_cust_info

-- ======================================================================================================================
-- Checking 'silver.crm_sales_details'
-- ======================================================================================================================
-- Check for Invalid Dates
-- Expectation: No Invalid Dates
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
    OR LEN(sls_due_dt) != 8 
    OR sls_due_dt > 20500101 
    OR sls_due_dt < 19000101;

-- Check for Invalid Date Orders (Order Date > Shipping/Due Dates)
-- Expectation: No Results
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Sales = Quantity * Price
-- Expectation: No Results
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- =======================================================================================================================
-- Checking 'silver.erp_cust_az12'
-- =======================================================================================================================
-- Identify Out-of-Range Dates
-- Expectation: Birthdates between 1924-01-01 and Today
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();

-- Data Standardization & Consistency
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- =======================================================================================================================
-- Checking 'silver.erp_loc_a101'
-- =======================================================================================================================
-- Data Standardization & Consistency
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

-- =======================================================================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- =======================================================================================================================
-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
