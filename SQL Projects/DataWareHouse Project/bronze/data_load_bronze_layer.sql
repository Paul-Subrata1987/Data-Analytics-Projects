/*
=================================================================
Store Procedure: Load data for bronze layer
=================================================================
Script Purpose: 
	This store procedure loads data into the bronze schema from external csv files.
	It performs the following actions:
		- Truncate the tables before loading data.
		- Load data from csv files using BULK INSERT command.
Parameter:
	None

Usage:
	EXEC bronze.load_bronze;
=================================================================

*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '========================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '========================================================';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>>>> Inserting Data: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\MS SQL Server and Database\Datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
		PRINT '>>>> ----------------------------'

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>>>> Inserting Data: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\MS SQL Server and Database\Datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',', 
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
		PRINT '>>>> ----------------------------'

		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>>>> Inserting Data: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\MS SQL Server and Database\Datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',',
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
		PRINT '>>>> ----------------------------'

	
		PRINT 'Loading ERP Tables';
		PRINT '---------------------------------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>>>> Inserting Data: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\MS SQL Server and Database\Datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',', 
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
		PRINT '>>>> ----------------------------'


		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>>>> Inserting Data: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\MS SQL Server and Database\Datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',', 
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
		PRINT '>>>> ----------------------------'


		SET @start_time = GETDATE();
		PRINT '>>>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>>>> Inserting Data: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\MS SQL Server and Database\Datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',', 
			TABLOCK 
		);
		SET @end_time = GETDATE();
		PRINT '>>>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
		PRINT '>>>> ----------------------------';

		SET @batch_end_time = GETDATE();
		PRINT '=====================================================';
		PRINT 'Loading Bonze Layer is Completed';
		PRINT '   >> Total Load Duration: '+ CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' Seconds';
		PRINT '=====================================================';

	END TRY

	BEGIN CATCH
		PRINT '====================================================';
		PRINT 'Error Occured During Loading Bonze Layer';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);	
		PRINT '====================================================';
	END CATCH

END
