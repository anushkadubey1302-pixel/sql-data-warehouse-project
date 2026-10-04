/*
===========================================================
STORED PROCEDURE: Load Silver Layer (FROM Source To Bronze)
===========================================================
Script Purpose:
  Checking the Quality of Silver Layer & performs the ETL (Extract, Transform , Load) to transform the data of 'Bronze' schema & store it into the 'Silver' one.
  Actions performed:
  - Removing Unwanted Spaces
  - Handle Missing Data
  - Handle Invalid Data Like NULLS & Data TypeCasting
  - Data Standardization and Normalization
  - Data Filtering
  - Derived Columns
  - Remove Duplicates
  - Data Enrichment
  - Uses the 'Insert' cmd to load the data (Bronze table -> Silver Layer) after transforming it.

Parameters:
  None (doesn't return any values)

Usage Example: 
  To load the data 
  EXEC silver.load_bronze
============================================================*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		print'----------------------------------------------------------------------------';
		print 'Loading Bronze Layer';
		print'----------------------------------------------------------------------------';
		print'----------------------------------------------------------------------------';
		print 'Loading CRM Tables ';
		print'----------------------------------------------------------------------------';

		-- Load silver.crm_cust_info
		SET @start_time = GETDATE();
		print'=========================================================================';
		PRINT '>>TRUNCATE TABLE: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '>> Inserting Data Into: silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info (
			  cst_id,
			  cst_key,
			  cst_firstname,
			  cst_lastname,
			  cst_marital_status,
			  cst_gndr,
			  cst_create_date )
		select
		cst_id,
		cst_key,
		TRIM(cst_firstname) as firstname,
		TRIM(cst_lastname) as lastname,
		CASE WHEN UPPER(TRIM(cst_marital_status)) ='M' THEN 'Married'
			 WHEN UPPER(TRIM(cst_marital_status)) ='S' THEN 'Single'
			 ELSE 'Unknown'
		END AS cst_marital_status,
		CASE WHEN UPPER(TRIM(cst_gndr)) ='M' THEN 'Male'
			 WHEN UPPER(TRIM(cst_gndr)) ='F' THEN 'Female'
			 ELSE 'Unknown'
		END AS cst_gndr,
		cst_create_date
		from (
			select 
			*, 
			row_number() over (PARTITION BY cst_id order by cst_create_date desc) as flag_
			from bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		)T WHERE flag_ =1;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>> ------------------------';

		-- Load silver.crm_prd_info
		SET @start_time = GETDATE();
		PRINT'==============================================================';

		PRINT '>>TRUNCATE TABLE: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>> Inserting Data Into: silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info(
			 prd_id,
			 cat_id,
			 prd_key,
			 prd_nm,
			 prd_cost,
			 prd_line,
			 prd_start_dt,
			 prd_end_dt
		)
		select 
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1,5), '-','_') as cat_id,
			SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key,
			prd_nm,
			ISNULL(prd_cost,0) as prd_cost,
			CASE UPPER(TRIM(prd_line))
				WHEN 'M' THEN 'Mountain'
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'other Sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'Unknown'
			END AS prd_line,
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER By prd_start_dt)-1 AS DATE) AS prd_end_dt

		from bronze.crm_prd_info;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>> ------------------------';

		-- Load silver.crm_sales_details
		SET @start_time = GETDATE();
		PRINT'==============================================================';

		PRINT '>>TRUNCATE TABLE: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>> Inserting Data Into: silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price)

		SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN sls_order_dt=0 OR LEN(sls_order_dt) !=8 THEN NULL
			ELSE CAST(CAST(sls_order_dt AS VARCHAR)AS DATE)
		END AS sls_order_dt,
		CASE WHEN sls_ship_dt=0 OR LEN(sls_ship_dt) !=8 THEN NULL
			ELSE CAST(CAST(sls_ship_dt AS VARCHAR)AS DATE)
		END AS sls_ship_dt,
		CASE WHEN sls_due_dt=0 OR LEN(sls_due_dt) !=8 THEN NULL
			ELSE CAST(CAST(sls_due_dt AS VARCHAR)AS DATE)
		END AS sls_due_dt,

		CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales!= sls_quantity * ABS(sls_price) 
			 THEN sls_quantity * ABS(sls_price) 
			 ELSE sls_sales
		END AS sls_sales,

		sls_quantity,

		CASE WHEN sls_price IS NULL OR  sls_price <= 0 
			 THEN sls_sales / NULLIF(sls_quantity,0)
			 ELSE sls_price 
		END AS sls_price
		from bronze.crm_sales_details;
 		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>> ------------------------';
		
		print'----------------------------------------------------------------------------';
		print 'Loading ERP Tables ';
		print'----------------------------------------------------------------------------';
		
		-- Load silver.erp_cust_az12
		SET @start_time = GETDATE();
		PRINT'==============================================================';

		PRINT '>>TRUNCATE TABLE: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT '>> Inserting Data Into: silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12 (
		cid,
		bdate,
		gen)

		select
		CASE WHEN cid LIke 'NAS%' THEN SUBSTRING (cid, 4,Len(cid))
			ELSE cid
		END cid,
		CASE WHEN bdate > getdate() THEN null
		ELSE bdate
		end as bdate,
		CASE WHEN UPPER(TRIM(gen)) IN ('F','Female') THEN 'Female'
			 WHEN UPPER(TRIM(gen)) IN ('M','Male') THEN 'Male'
		ELSE 'n/a'
		END gen
		from bronze.erp_cust_az12;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>> ------------------------';

		-- Load silver.erp_loc_a101
		SET @start_time = GETDATE();
		PRINT'==============================================================';

		PRINT '>>TRUNCATE TABLE: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Inserting Data Into: silver.erp_loc_a101';
		 INSERT INTO silver.erp_loc_a101 (
		 cid,
		 cntry
		  )
		select
		REPLACE(cid,'-','') cid,
		CASE WHEN TRIM(cntry)='DE' THEN 'Germany'
			 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
			 WHEN TRIM(cntry)='' or cntry IS NULL THEN 'n/a'
			 ELSE TRIM(cntry)  
		END AS cntry
		from bronze.erp_loc_a101
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>> ------------------------';

		-- Load silver.erp_px_cat_giv2
		SET @start_time = GETDATE();
		PRINT'==============================================================';

		PRINT '>>TRUNCATE TABLE: silver.erp_px_cat_giv2';
		TRUNCATE TABLE silver.erp_px_cat_giv2;
		PRINT '>> Inserting Data Into: silver.erp_px_cat_giv2';

		INSERT INTO silver.erp_px_cat_giv2(
		id,
		cat,
		subcat,
		maintenance
		)
		SELECT
		id,
		cat,
		subcat,
		maintenance
		FROM bronze.erp_px_cat_giv2;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '>> ------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '==================================';
		PRINT'loading Silver Layer is Completed';
		PRINT ' >>Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
		PRINT '==================================';

	END TRY

	BEGIN CATCH
		PRINT '==================================================================';
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE ();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '==================================================================';
	END CATCH
END

EXEC silver.load_silver
