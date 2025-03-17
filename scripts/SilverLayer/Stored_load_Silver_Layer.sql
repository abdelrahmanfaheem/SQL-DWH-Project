/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		- Remove Duplication in ID
			- and take the latest row by Date
			- and filter the row that take 1	
		- not Selected the Null IDS
		- Replace the null value in ( cst_marital_status and cst_gndr ) with n/a
		- Make a Data Standrization
		- celan unwanted white space 

		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/	


CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------';

        -- Loading silver.crm_cust_info
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;
        PRINT '>> Inserting Data Into: silver.crm_cust_info';
        INSERT INTO silver.crm_cust_info (
            cust_id, 
            cust_key, 
            cust_firstname, 
            cust_lastname, 
            cust_marital_status, 
            cust_gndr,
            cust_create_date
        )
        SELECT
            cust_id AS cust_id,
            cust_key AS cust_key,
            LTRIM(RTRIM(cust_firstname)) AS cust_firstname,
            LTRIM(RTRIM(cust_lastname)) AS cust_lastname,
            CASE 
                WHEN UPPER(LTRIM(RTRIM(cust_marital_status))) = 'S' THEN 'Single'
                WHEN UPPER(LTRIM(RTRIM(cust_marital_status))) = 'M' THEN 'Married'
                WHEN UPPER(LTRIM(RTRIM(cust_marital_status))) = 'D' THEN 'Divorced'
                ELSE 'n/a'
            END AS cust_marital_status,
            CASE 
                WHEN UPPER(LTRIM(RTRIM(cust_gndr))) = 'F' THEN 'Female'
                WHEN UPPER(LTRIM(RTRIM(cust_gndr))) = 'M' THEN 'Male'
                ELSE 'n/a'
            END AS cust_gndr,
            cust_create_date
        FROM (
            SELECT
                *,
                ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY cust_create_date DESC) AS flag_last
            FROM bronze.crm_cust_info
            WHERE cust_id IS NOT NULL
        ) t
        WHERE flag_last = 1;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading silver.crm_poduct_info
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_poduct_info';
        TRUNCATE TABLE silver.crm_poduct_info;
        PRINT '>> Inserting Data Into: silver.crm_poduct_info';


        INSERT INTO silver.crm_poduct_info (
            product_id,
            product_nm,
            product_key,
			Cat_Id,
            product_cost,
            product_line,
            product_start_date,
            product_end_date
        )
        SELECT
            product_id AS product_id,
            product_nm AS product_nm,
            SUBSTRING(product_key, 7, LEN(product_key)) AS product_key,
			Replace (SUBSTRING(product_key,4,LEN(product_key)),'-','_') As Cat_Id,
            ISNULL(product_cost, 0) AS product_cost, --- Replace Null with Zero 
            --CASE 
            --    WHEN UPPER(LTRIM(RTRIM(product_line))) = 'M' THEN 'Mountain'
            --    WHEN UPPER(LTRIM(RTRIM(product_line))) = 'R' THEN 'Road'
            --    WHEN UPPER(LTRIM(RTRIM(product_line))) = 'S' THEN 'Other Sales'
            --    WHEN UPPER(LTRIM(RTRIM(product_line))) = 'T' THEN 'Touring'
            --    ELSE 'n/a'
            --END AS product_line,
			  CASE UPPER(LTRIM(RTRIM(product_line)))
                WHEN   'M' THEN 'Mountain'
                WHEN   'R' THEN 'Road'
                WHEN   'S' THEN 'Other Sales'
                WHEN   'T' THEN 'Touring'
                ELSE 'n/a'
            END AS product_line,
            CAST(product_start_date AS DATE) AS product_start_date,
            CAST(
                LEAD(product_start_date) OVER (PARTITION BY product_key ORDER BY product_start_date)   --- the the lead of the current and the end date of the current 
                AS DATE
            ) AS product_end_date
        FROM bronze.crm_poduct_info;




        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading crm_sales_details  
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>> Inserting Data Into: silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details (
			sales_ord_num,
			sales_prd_key,
			sales_cust_id,
			sales_order_dt,
			sales_ship_dt,
			sales_due_dt,
			sales_sales,
			sales_quantity,
			sales_price
		)
		SELECT 
			sales_ord_num,
			sales_prd_key,
			sales_cust_id,
			CASE 
				WHEN sales_order_dt = 0 OR LEN(sales_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sales_order_dt AS VARCHAR) AS DATE) -- can't convert from int to date directly so you must convert to varchar first 
			END AS sales_order_dt
			,
			CASE 
				WHEN sales_ship_dt = 0 OR LEN(sales_ship_dt) != 8 THEN NULL
				ELSE CAST(CAST(sales_ship_dt AS VARCHAR) AS DATE)
			END AS sales_ship_dt
			,
			CASE 
				WHEN sales_due_dt = 0 OR LEN(sales_due_dt) != 8 THEN NULL
				ELSE CAST(CAST(sales_due_dt AS VARCHAR) AS DATE)
			END AS sales_due_dt
			,
			CASE 
				WHEN sales_sales IS NULL OR sales_sales <= 0 OR sales_sales != sales_quantity * ABS(sales_price) 
					THEN sales_quantity * ABS(sales_price) --- if the price is negative convert it to positive 
				ELSE sales_sales
			END AS sales_sales
			
			, -- Recalculate sales if original value is missing or incorrect
			sales_quantity,
			CASE 
				WHEN sales_price IS NULL OR sales_price <= 0 
					THEN sales_sales / NULLIF(sales_quantity, 0) -- repalce zore to null value 
				ELSE sales_price  -- Derive price if original value is invalid
			END AS sales_price


		FROM bronze.crm_sales_details;


        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

------------------------------------------------------------------------------------------------------------------------
        -- Loading erp_cust_az12
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT '>> Inserting Data Into: silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12 (
			cust_id,
			cust_bdate,
			cust_gen
		)
		SELECT
			CASE
				WHEN cust_id LIKE 'NAS%' THEN SUBSTRING(cust_id, 4, LEN(cust_id)) -- Remove 'NAS' prefix if present and return the substirng to the end of the id 
				ELSE cust_id -- if not start with 'NAS' return the cust_id
			END AS cust_id, 
			CASE
				WHEN cust_bdate > GETDATE() THEN NULL
				ELSE cust_bdate
			END AS bdate, -- Set future birthdates to NULL
			CASE -- make a cleanup and Generalization for the data
				WHEN UPPER(LTRIM(RTRIM(cust_gen))) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(LTRIM(RTRIM(cust_gen))) IN ('M', 'MALE') THEN 'Male'
				ELSE 'n/a'
			END AS gen -- Normalize gender values and handle unknown cases
		FROM bronze.erp_cust_az12;
	    SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';
        

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Loading erp_loc_a101
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Inserting Data Into: silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101 (
			cust_id,
			loc_country
		)
		SELECT
			REPLACE(cust_id, '-', '') AS cust_id, 
			CASE
				WHEN LTRIM(RTRIM(loc_country)) = 'DE' THEN 'Germany'
				WHEN LTRIM(RTRIM(loc_country)) IN ('US', 'USA') THEN 'United States'
				WHEN LTRIM(RTRIM(loc_country)) = '' OR loc_country IS NULL THEN 'n/a'
				ELSE LTRIM(RTRIM(loc_country))
			END AS cntry -- Normalize and Handle missing or blank country codes
		FROM bronze.erp_loc_a101;
	    SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		
------------------------------------------------------------------------------------------------------------------------

		-- Loading erp_px_cat_g1v2
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2 (
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
		FROM bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
