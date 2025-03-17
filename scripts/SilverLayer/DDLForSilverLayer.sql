/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

 

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cust_id             INT,
    cust_key            NVARCHAR(50),
    cust_firstname      NVARCHAR(50),
    cust_lastname       NVARCHAR(50),
    cust_marital_status NVARCHAR(50),
    cust_gndr           NVARCHAR(50),
    cust_create_date    DATE,
    dwh_create_date     DATETIME   DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_poduct_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_poduct_info;
GO 

CREATE TABLE silver.crm_poduct_info (
    product_id      INT,
    product_nm      NVARCHAR(50),
    product_key     NVARCHAR(50),
    product_cost    INT,
    product_line    NVARCHAR(50),
	Cat_Id NVARCHAR(50),
    product_start_date DATE,
    product_end_date   DATE,
    dwh_create_date DATETIME  DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sales_ord_num   NVARCHAR(50),
    sales_prd_key   NVARCHAR(50),
    sales_cust_id   INT,
    sales_order_dt  DATE,
    sales_ship_dt   DATE,
    sales_due_dt    DATE,
    sales_sales     INT,
    sales_quantity  INT,
    sales_price     INT,
    dwh_create_date DATETIME  DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
    cust_id        NVARCHAR(50),
    cust_bdate     DATE,
    cust_gen       NVARCHAR(50),
    dwh_create_date DATETIME   DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    cust_id        INT,
    loc_country    NVARCHAR(50),
    dwh_create_date DATETIME  DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
    id              INT,
    cat             NVARCHAR(50),
    subcat          NVARCHAR(50),
    maintenance     NVARCHAR(50),
    dwh_create_date DATETIME  DEFAULT GETDATE()
);
GO
