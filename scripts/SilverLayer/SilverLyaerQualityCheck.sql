-- the End Date must > start Date
select * From silver.crm_poduct_info
where product_end_date< product_start_date

-- Check data Standrization & Consistant 
select distinct product_line From silver.crm_poduct_info


-- Check for null and negative Numbers

select * from silver.crm_poduct_info 
where product_cost<0 or product_cost is null
 

-- Check duplication in primary key


select product_id,count (*) from silver.crm_poduct_info group by product_id
having count (*) >1


-- Check unwanted space
select *
from 
	silver.crm_poduct_info
where product_nm !=LTRIM(RTRIM(product_nm))


------------------------------------- Sales Qulity Checks --------------------------------------

-- Check for invalid Dates

Select 
		sales_due_dt, sales_ship_dt , sales_order_dt  
From 
	silver.crm_sales_details
where 
	sales_due_dt<=0 or sales_ship_dt<=0 or sales_order_dt<=0 or len (sales_ship_dt)!=8 or   len (sales_order_dt)!=8  


-------------------------- Check that due_date < order_Date < ship_date ------------------------------
Select 
	*
from	
	silver.crm_sales_details
where
	sales_order_dt> sales_due_dt or 	sales_order_dt> sales_ship_dt


-------------------------- Busniss Rule Check ------------------------------------

select 
*
from
	silver.crm_sales_details
where
	sales_sales != sales_price * sales_quantity


	






