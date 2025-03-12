-- Insert dummy data into bronze.crm_cust_info
INSERT INTO bronze.crm_cust_info (cust_id, cust_key, cust_lastname, cust_firstname, cust_gndr, cust_material_status, cust_create_date)
VALUES 
(1, 'CUST001', 'Smith', 'John', 'Male', 'Single', '2023-01-15'),
(2, 'CUST002', 'Doe', 'Jane', 'Female', 'Married', '2023-02-20'),
(3, 'CUST003', 'Brown', 'Michael', 'Male', 'Single', '2023-03-10');

-- Insert dummy data into bronze.crm_poduct_info
INSERT INTO bronze.crm_poduct_info (product_id, product_nm, product_key, product_cost, product_line, product_start_date, product_end_date)
VALUES 
(101, 'Laptop', 'PRD101', 1200, 'Electronics', '2023-01-01', '2025-12-31'),
(102, 'Smartphone', 'PRD102', 800, 'Electronics', '2023-02-01', '2025-11-30'),
(103, 'Tablet', 'PRD103', 600, 'Electronics', '2023-03-01', '2025-10-31');

-- Insert dummy data into bronze.crm_sales_details
INSERT INTO bronze.crm_sales_details (sales_ord_num, sales_prd_key, sales_cust_id, sales_order_dt, sales_ship_dt, sales_due_dt, sales_sales, sales_quantity, sales_price)
VALUES 
('ORD001', 'PRD101', 1, 20240101, 20240105, 20240110, 1200, 1, 1200),
('ORD002', 'PRD102', 2, 20240201, 20240206, 20240212, 1600, 2, 800),
('ORD003', 'PRD103', 3, 20240301, 20240307, 20240314, 600, 1, 600);

-- Insert dummy data into bronze.erp_cust_az12
INSERT INTO bronze.erp_cust_az12 (cust_id, cust_bdate, cust_gen)
VALUES 
('CUST001', '1990-05-12', 'Male'),
('CUST002', '1985-08-24', 'Female'),
('CUST003', '1992-11-03', 'Male');

-- Insert dummy data into bronze.erp_loc_a101
INSERT INTO bronze.erp_loc_a101 (loc_id, locc_country)
VALUES 
(1, 'USA'),
(2, 'Canada'),
(3, 'UK');

-- Insert dummy data into bronze.erp_px_cat_g1v2
INSERT INTO bronze.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
VALUES 
(1, 'Electronics', 'Computers', 'Warranty'),
(2, 'Electronics', 'Phones', 'Repair'),
(3, 'Electronics', 'Tablets', 'Replacement');
