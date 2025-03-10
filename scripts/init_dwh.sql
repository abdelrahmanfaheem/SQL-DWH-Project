
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'datawarehouse')
BEGIN
    CREATE DATABASE datawarehouse;
END
GO

USE datawarehouse;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
    EXEC('CREATE SCHEMA silver');
END
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
    EXEC('CREATE SCHEMA gold');
END
GO
