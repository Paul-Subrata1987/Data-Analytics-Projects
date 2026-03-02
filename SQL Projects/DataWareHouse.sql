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


-- Drop the table if exists, then create a new table.
IF OBJECT_ID ('bronze.crm_cust_info','U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
)

-- Drop the table if exists, then create a new table.
IF OBJECT_ID ('bronze.crm_prd_info','U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,	
	prd_line NVARCHAR(50),	
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
)


-- Drop the table if exists, then create a new table.
IF OBJECT_ID ('bronze.crm_sales_details','U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
)


-- Drop the table if exists, then create a new table.
IF OBJECT_ID ('bronze.erp_cust_az12','U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50)
)



-- Drop the table if exists, then create a new table.
IF OBJECT_ID ('bronze.erp_loc_a101','U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
)


-- Drop the table if exists, then create a new table.
IF OBJECT_ID ('bronze.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50)
)




--Empty the table if there is any data.
TRUNCATE TABLE bronze.crm_cust_info;

-- Bulk insert in the table.
BULK INSERT bronze.crm_cust_info
FROM 'D:\MS SQL Server and Database\Datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2, -- Start from 2nd row as the first row is headers.
	FIELDTERMINATOR = ',', -- delimiter is = comma (,)
	TABLOCK --locking table during loading.
);


-- Checking the load quality and review the data.
SELECT * FROM bronze.crm_cust_info;
SELECT COUNT(*) FROM bronze.crm_cust_info;
