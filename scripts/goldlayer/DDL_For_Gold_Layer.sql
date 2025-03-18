/*
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================

------------------------- customer_dim View --------------------------------
IF OBJECT_ID('gold.customer_dim', 'V') IS NOT NULL
    DROP VIEW gold.customer_dim;
GO
create view gold.customer_dim 
as 
select
Row_number() over (order by ci.cust_id asc)as customer_key,
	ci.cust_id as customer_id,
	ci.cust_key customer_number,
	ci.cust_firstname customer_firstname,
	ci.cust_lastname customer_lastname,
	ci.cust_marital_status customer_marital_status,
	-- crm_cust_info is a master data  ( but if the gender is null or N/A get the data from (erp_cust_az12)
	case 
	  when ci.cust_gndr is null then ca.cust_gen  -- master data get from the CRM so if null get the the data from CRM 
	  when ci.cust_gndr ='n/a' then ca.cust_gen else ci.cust_gndr end as customer_gendar ,
	ci.cust_create_date as create_date,
	ca.cust_bdate as customer_birthdate,
	la.loc_country as customer_countery
From 
	silver.crm_cust_info ci
		left join silver.erp_cust_az12 ca
	on ci.cust_key=ca.cust_id
	left join silver.erp_loc_a101 la
	on ci.cust_key=la.cust_id



-- =============================================================================
-- Create Dimension: gold.product_dim
-- =============================================================================
----------------------------------- product_dim  -----------------------------------


 

IF OBJECT_ID('gold.product_dim', 'V') IS NOT NULL
    DROP VIEW gold.product_dim;
GO

create view gold.product_dim 
as 
select 
	ROW_NUMBER()over (order by pin.product_key ,pin.product_start_date)as product_key,
	pin.product_id,
	pin.product_key as product_number,
	pin.product_nm as product_name,
	pin.Cat_Id as category_id,
	pcat.cat as category ,
	pcat.subcat as sub_category,
	pcat.maintenance,
	pin.product_cost,
	pin.product_line,
	pin.product_start_date 	as start_date
	
	
From 
	silver.crm_poduct_info  pin left join silver.erp_px_cat_g1v2 pcat
	on pin.product_id=pcat.id
where pin.product_end_date is  null  -- get the only current proudct ( filter historical data )


------------------------------------------------------------------------------------------------------------------


-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
--------------------- create a fact_tables-----------------------------

create  view gold.fact_sales 
as 
select  
	s.sales_ord_num as order_number,
	p.product_key ,
	c.customer_key,
 	s.sales_order_dt order_date,
	s.sales_ship_dt ship_date,
	s.sales_due_dt due_date,
	s.sales_sales sales_amount,
	s.sales_quantity quantity,
	s.sales_price price
from 
	silver.crm_sales_details s
	left join gold.customer_dim c on c.customer_id =s.sales_cust_id
	left join gold.product_dim p on p.product_number=s.sales_prd_key


 

 ----- test the lookup between fact & Dim
 select 
	c.customer_firstname,s.customer_key,c.customer_id,product_name,category,p.product_cost 
 from 
	gold.fact_sales s inner join gold.customer_dim c
 on 
	s.customer_key=c.customer_key
 inner join
	gold.product_dim p on c.customer_key=p.product_key
