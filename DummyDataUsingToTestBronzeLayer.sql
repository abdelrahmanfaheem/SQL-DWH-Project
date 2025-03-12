-- Insert into bronze.crm_cust_info (Duplicate IDs, NULL values, and inconsistencies)
INSERT INTO bronze.crm_cust_info (cust_id, cust_key, cust_lastname, cust_firstname, cust_gndr, cust_material_status, cust_create_date)
VALUES
(1, 'CUST001', 'Smith', 'John', 'Male', 'Single', '2023-01-10'),
(2, 'CUST002', 'Johnson', 'Emily', 'Female', 'Married', '2023-02-15'),
(3, 'CUST003', 'Williams', 'Michael', 'Male', 'Divorced', '2023-03-20'),
(1, 'CUST001', 'Smith', 'John', 'Male', 'Single', '2023-01-10'), -- Duplicate
(4, 'CUST004', 'Brown', 'Sophia', 'Female', 'Married', '2023-04-05'),
(5, 'CUST005', 'Jones', 'Daniel', 'Male', NULL, '2023-05-12'), -- NULL Marital Status
(6, 'CUST006', 'Garcia', 'Olivia', 'Female', 'Single', '2023-06-18'),
(7, 'CUST007', 'Martinez', 'David', 'Male', 'Married', '2023-07-25'),
(8, 'CUST008', 'Lopez', 'Emma', NULL, 'Single', '2023-08-30'), -- NULL Gender
(9, 'CUST009', 'Harris', 'Matthew', 'Male', 'Divorced', '2023-09-05'),
(10, 'CUST010', 'Clark', 'Sophia', 'Female', 'Widowed', '2023-10-10'),
(10, 'CUST010_DUP', 'Clark', 'Sophia', 'Female', 'Widowed', '2023-10-10'), -- Duplicate
(11, 'CUST011', 'Anderson', 'Ethan', 'Male', 'Single', '2023-11-15'),
(12, 'CUST012', 'Thomas', 'Ava', 'Female', NULL, '2023-12-20'), -- NULL Marital Status
(13, 'CUST013', 'White', 'James', 'Male', 'Married', '2024-01-01');

-- Insert into bronze.crm_poduct_info
INSERT INTO bronze.crm_poduct_info (product_id, product_nm, product_key, product_cost, product_line, product_start_date, product_end_date)
VALUES
(1, 'Laptop', 'PRD001', 1000, 'Electronics', '2022-01-01', '2025-01-01'),
(2, 'Smartphone', 'PRD002', 800, 'Electronics', '2022-02-15', NULL), -- NULL End Date
(3, 'Tablet', 'PRD003', 500, 'Electronics', '2022-03-20', '2024-12-31'),
(1, 'Laptop', 'PRD001', 1000, 'Electronics', '2022-01-01', '2025-01-01'), -- Duplicate
(4, 'Headphones', 'PRD004', 200, 'Accessories', '2022-04-05', '2026-06-30'),
(5, 'Monitor', 'PRD005', 300, 'Electronics', '2022-05-10', '2025-10-10'),
(6, 'Keyboard', 'PRD006', 50, 'Accessories', '2022-06-15', NULL), -- NULL End Date
(7, 'Mouse', 'PRD007', 30, 'Accessories', '2022-07-20', '2025-07-20'),
(8, 'Gaming Console', 'PRD008', 600, 'Electronics', '2022-08-25', '2026-08-25'),
(9, 'Smartwatch', 'PRD009', 250, 'Electronics', '2022-09-30', '2026-09-30'),
(10, 'External Hard Drive', 'PRD010', 120, 'Accessories', '2022-10-10', '2025-10-10'),
(11, 'Wireless Router', 'PRD011', 150, 'Networking', '2022-11-15', '2025-11-15');

-- Insert into bronze.crm_sales_details
INSERT INTO bronze.crm_sales_details (sales_ord_num, sales_prd_key, sales_cust_id, sales_order_dt, sales_ship_dt, sales_due_dt, sales_sales, sales_quantity, sales_price)
VALUES
('ORD001', 'PRD001', 1, 20240110, 20240112, 20240115, 1000, 1, 1000),
('ORD002', 'PRD002', 2, 20240215, 20240218, 20240220, 1600, 2, 800),
('ORD003', 'PRD003', 3, 20240320, 20240322, 20240325, 500, 1, 500),
('ORD004', 'PRD004', 4, 20240405, 20240407, 20240410, 400, 2, 200),
('ORD005', 'PRD005', 5, 20240512, 20240514, 20240517, 600, 2, 300),
('ORD006', 'PRD006', 6, 20240618, 20240620, 20240622, 100, 2, 50),
('ORD007', 'PRD007', 7, 20240725, 20240728, 20240730, 60, 2, 30),
('ORD008', 'PRD008', 8, 20240830, 20240902, 20240905, 1200, 2, 600),
('ORD009', 'PRD009', 9, 20240905, 20240908, 20240910, 500, 2, 250),
('ORD010', 'PRD010', 10, 20241010, 20241013, 20241015, 240, 2, 120);

-- Insert into bronze.erp_cust_az12
INSERT INTO bronze.erp_cust_az12 (cust_id, cust_bdate, cust_gen)
VALUES
('C001', '1985-05-10', 'Male'),
('C002', '1990-07-20', 'Female'),
('C003', '1975-03-15', 'Male'),
('C004', NULL, 'Female'), -- NULL Birthdate
('C005', '1995-09-25', 'Male'),
('C006', '1988-11-30', 'Female'),
('C007', '2000-02-10', NULL), -- NULL Gender
('C008', '1982-06-15', 'Male'),
('C009', '1979-08-22', 'Female'),
('C010', '1992-12-05', 'Male');

-- Insert into bronze.erp_loc_a101
INSERT INTO bronze.erp_loc_a101 (cust_id, loc_country)
VALUES
(1, 'USA'),
(2, 'Canada'),
(3, 'Mexico'),
(4, 'UK'),
(5, 'Germany'),
(6, 'France'),
(7, 'Japan'),
(8, 'China'),
(9, 'Brazil'),
(10, 'India');

-- Insert into bronze.erp_px_cat_g1v2
INSERT INTO bronze.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
VALUES
(1, 'Electronics', 'Laptops', 'High'),
(2, 'Electronics', 'Smartphones', 'Medium'),
(3, 'Accessories', 'Headphones', 'Low'),
(4, 'Home Appliances', 'Refrigerators', 'High'),
(5, 'Furniture', 'Chairs', 'Medium'),
(6, 'Furniture', 'Tables', 'Low'),
(7, 'Automotive', 'Tires', 'High'),
(8, 'Toys', 'Board Games', 'Low'),
(9, 'Clothing', 'Shirts', 'Medium'),
(10, 'Sports', 'Running Shoes', 'High');

