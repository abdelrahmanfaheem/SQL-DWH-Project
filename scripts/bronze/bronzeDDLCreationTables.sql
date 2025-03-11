
 
 /*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

if OBJECT_ID('bronze.crm_cust_info','U') is not null
drop table bronze.crm_cust_info;
--cst_id	cst_key	cst_firstname	cst_lastname	cst_marital_status	cst_gndr	cst_create_date

Go
create table bronze.crm_cust_info(
cust_id int ,
cust_key nvarchar(50),
cust_lastname nvarchar(50),
cust_firstname nvarchar(50),
cust_gndr nvarchar(50),

cust_material_status nvarchar(50),
cust_create_date date


);

 Go

if OBJECT_ID('bronze.crm_poduct_info','U')is not null
drop table bronze.crm_poduct_info
GO
--Product File Column : prd_id	prd_key	prd_nm	prd_cost	prd_line	prd_start_dt	prd_end_dt

create table bronze.crm_poduct_info(
product_id int,
--product disciption
product_nm varchar(50),
product_key varchar(50),
product_cost int,
product_line varchar(50),
product_start_date Datetime ,
product_end_date Datetime ,


);
GO

IF OBJECT_ID('bronze.crm_sales_details', 'U') is not null
    DROP TABLE bronze.crm_sales_details;
GO
-- columns : sls_ord_num	sls_prd_key	sls_cust_id	sls_order_dt	sls_ship_dt	sls_due_dt	sls_sales	sls_quantity	sls_price

CREATE TABLE bronze.crm_sales_details (
    sales_ord_num  NVARCHAR(50),
    sales_prd_key  NVARCHAR(50),
    sales_cust_id  INT,
    sales_order_dt INT,
    sales_ship_dt  INT,
    sales_due_dt   INT,
    sales_sales    INT,
    sales_quantity INT,
    sales_price    INT
);
Go

IF OBJECT_ID('bronze.erp_cust_az12', 'U') is not null
drop table bronze.erp_cust_az12
--column :CID	BDATE	GEN
 Go

create table bronze.erp_cust_az12 (

cust_id varchar (50) ,
cust_bdate date ,
cust_gen varchar (50)

);
Go

IF OBJECT_ID('bronze.erp_loc_a101', 'U') is not null
drop table bronze.erp_loc_a101;
Go
-- column CID	CNTRY
 
create table bronze.erp_loc_a101(
loc_id int ,
locc_country varchar (50)

);
Go

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') is not null

drop table bronze.erp_px_cat_g1v2
Go
--ID	CAT	SUBCAT	MAINTENANCE

create table bronze.erp_px_cat_g1v2 (

id int ,
cat varchar (50),
subcat varchar (50),
maintenance varchar (50),
)

