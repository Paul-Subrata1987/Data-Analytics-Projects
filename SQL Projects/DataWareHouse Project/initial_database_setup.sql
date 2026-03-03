/*
=========================================
Creating Database & Schemas
=========================================
Purpose: 
	This script is for creating a new database name "DataWareHouse" after checking if it already exists. 
	If the database exists, it is dropped and recreated. Additionally, the schemas have been setup within the database: 
	"bronze", "silver", & "gold".
*/

--Using master database.
USE master;

--Drop and recreate the database "DataWareHouse"
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWareHouse')
BEGIN 
	ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DateWareHouse;
END;
GO


-- Creating a new database called "DataWareHouse"
CREATE DATABASE DataWareHouse;
GO

USE DataWareHouse;
GO



--Creating 3 seprate Schemas.

CREATE SCHEMA bronze;
GO --Seperator
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
