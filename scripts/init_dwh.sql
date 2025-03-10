/* 
=========================================
Script: Create Data Warehouse and Schemas  
 
Description:  
- Drops the database if it exists.  
- Creates the database `datawarehouse`.  
- Creates schemas `bronze`, `silver`, and `gold` if they do not exist.  
=========================================
*/

-- Drop database if it exists  
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'datawarehouse')
BEGIN
    ALTER DATABASE datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE datawarehouse;
END
GO

-- Create the database  
CREATE DATABASE datawarehouse;
GO

-- Switch to the newly created database  
USE datawarehouse;
GO

-- Create schema 'bronze' if it does not exist  
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END
GO

-- Create schema 'silver' if it does not exist  
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
END
GO

-- Create schema 'gold' if it does not exist  
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
END
GO
