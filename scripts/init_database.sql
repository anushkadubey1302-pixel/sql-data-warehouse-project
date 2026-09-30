/*
=================================================
Create db and schemas
=====================================================
Script Purpose:
This script creates a new db named 'DataWarehouse' after checking if it already exists.
within the database: 'bronze','silver','gold'.

WARNING:
  Running this script will drop the entire 'DataWarehouse' database if it exists
  All data in the database will be permanently deleted. Proceed with caution.
  and ensure u have proper backups before running this script.
*/


Use master;                                     
GO

-- drop & recreate the 'DataWarehouse' db
If EXISTS (SELECT 1 FROM sys.databases where name='DataWarehouse'
BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;                  
GO
  
Use datawarehouse;                             
GO
  
-- Create Schemas
  
create schema bronze;  
GO
  
create schema silver;      
GO
  
create schema gold;  
GO
