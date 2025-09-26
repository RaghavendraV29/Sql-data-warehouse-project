/**********************************************************************************************
 Author       : Raghavendra
 Procedure    : Silver.load_silver
 Description  : This procedure creates/refreshes tables in the Silver layer by loading data 
                from CSV files (CRM & ERP sources). 
                It also performs cleansing, transformations, and inserts cleaned data back 
                into the Silver tables.
**********************************************************************************************/

-- ==========================================================================================
-- Create or Alter Procedure
-- ==========================================================================================
CREATE OR ALTER PROCEDURE Silver.load_silver AS
BEGIN

    -------------------------------------------------------------------
    -- SECTION 1: CUSTOMER INFO TABLES
    -------------------------------------------------------------------
    PRINT 'Dropping and creating Silver.crm_cust_info table';
    IF OBJECT_ID('Silver.crm_cust_info','U') IS NOT NULL
        DROP TABLE Silver.crm_cust_info;

    CREATE TABLE Silver.crm_cust_info(
        cst_id INT,
        cst_key NVARCHAR (50),
        cst_firstname NVARCHAR (50),
        cst_lastname NVARCHAR (50),
        cst_material_status NVARCHAR (50),
        cst_gndr NVARCHAR (50),
        cst_create_date DATE,
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT 'Dropping and creating Silver.crm_cust_info_staging table';
    IF OBJECT_ID('Silver.crm_cust_info_staging','U') IS NOT NULL
        DROP TABLE Silver.crm_cust_info_staging;

    CREATE TABLE Silver.crm_cust_info_Staging(
        cst_id INT,
        cst_key NVARCHAR (50),
        cst_firstname NVARCHAR (50),
        cst_lastname NVARCHAR (50),
        cst_material_status NVARCHAR (50),
        cst_gndr NVARCHAR (50),
        cst_create_date DATE
    );

    -------------------------------------------------------------------
    -- SECTION 2: PRODUCT INFO TABLES
    -------------------------------------------------------------------
    PRINT 'Dropping and creating Silver.crm_prd_info table';
    IF OBJECT_ID('Silver.crm_prd_info','U') IS NOT NULL
        DROP TABLE Silver.crm_prd_info; 

    CREATE TABLE Silver.crm_prd_info(
        prd_id INT,
        prd_cat_id NVARCHAR (50),
        prd_key NVARCHAR (50),
        prd_nm NVARCHAR (50),
        prd_cost INT,
        prd_line NVARCHAR (50),
        prd_start_dt DATE,
        prd_end_dt DATE,
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT 'Dropping and creating Silver.crm_prd_info_staging table';
    IF OBJECT_ID('Silver.crm_prd_info_staging','U') IS NOT NULL
        DROP TABLE Silver.crm_prd_info_staging; 

    CREATE TABLE Silver.crm_prd_info_staging(
        prd_id INT,
        prd_key NVARCHAR (50),
        prd_nm NVARCHAR (50),
        prd_cost INT,
        prd_line NVARCHAR (50),
        prd_start_dt DATE,
        prd_end_dt DATE
    );

    -------------------------------------------------------------------
    -- SECTION 3: SALES DETAILS TABLES
    -------------------------------------------------------------------
    PRINT 'Dropping and creating Silver.crm_sales_details table';
    IF OBJECT_ID('Silver.crm_sales_details','U') IS NOT NULL
        DROP TABLE Silver.crm_sales_details;

    CREATE TABLE Silver.crm_sales_details (
        sls_ord_num NVARCHAR(50),
        sls_prd_key NVARCHAR(50),
        sls_cust_id INT,
        sls_order_dt DATE,
        sls_ship_dt DATE,
        sls_due_dt DATE,
        sls_sales INT,
        sls_quantity INT,
        sls_price INT,
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT 'Dropping and creating Silver.crm_sales_details_staging table';
    IF OBJECT_ID('Silver.crm_sales_details_staging','U') IS NOT NULL
        DROP TABLE Silver.crm_sales_details_staging;

    CREATE TABLE Silver.crm_sales_details_staging (
        sls_ord_num NVARCHAR(50),
        sls_prd_key NVARCHAR(50),
        sls_cust_id INT,
        sls_order_dt INT,
        sls_ship_dt INT,
        sls_due_dt INT,
        sls_sales INT,
        sls_quantity INT,
        sls_price INT    
    );

    -------------------------------------------------------------------
    -- SECTION 4: ERP CUSTOMER TABLES
    -------------------------------------------------------------------
    PRINT 'Dropping and creating Silver.erp_cust_az12 table';
    IF OBJECT_ID('Silver.erp_cust_az12','U') IS NOT NULL
        DROP TABLE Silver.erp_cust_az12;

    CREATE TABLE Silver.erp_cust_az12(
        cid NVARCHAR (50),
        bdate DATE,
        gen NVARCHAR (50),
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT 'Dropping and creating Silver.erp_cust_az12_staging table';
    IF OBJECT_ID('Silver.erp_cust_az12_staging','U') IS NOT NULL
        DROP TABLE Silver.erp_cust_az12_staging;

    CREATE TABLE Silver.erp_cust_az12_staging(
        cid NVARCHAR (50),
        bdate DATE,
        gen NVARCHAR (50)
    );

    -------------------------------------------------------------------
    -- SECTION 5: ERP LOCATION TABLES
    -------------------------------------------------------------------
    PRINT 'Dropping and creating Silver.erp_loc_a101 table';
    IF OBJECT_ID('silver.erp_loc_a101','U') IS NOT NULL
        DROP TABLE Silver.erp_loc_a101;

    CREATE TABLE Silver.erp_loc_a101 (
        cid NVARCHAR (50),
        cntry NVARCHAR (50),
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT 'Dropping and creating Silver.erp_loc_a101_staging table';
    IF OBJECT_ID('silver.erp_loc_a101_staging','U') IS NOT NULL
        DROP TABLE Silver.erp_loc_a101_staging;

    CREATE TABLE Silver.erp_loc_a101_staging (
        cid NVARCHAR (50),
        cntry NVARCHAR (50),
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    -------------------------------------------------------------------
    -- SECTION 6: ERP PRODUCT CATEGORY TABLES
    -------------------------------------------------------------------
    PRINT 'Dropping and creating Silver.erp_px_cat_g1v2 table';
    IF OBJECT_ID('Silver.erp_px_cat_g1v2','U') IS NOT NULL
        DROP TABLE Silver.erp_px_cat_g1v2;

    CREATE TABLE Silver.erp_px_cat_g1v2(
        id NVARCHAR (50),
        cat NVARCHAR (50),
        subcat NVARCHAR (50),
        maintenance NVARCHAR (50),
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT 'Dropping and creating Silver.erp_px_cat_g1v2_staging table';
    IF OBJECT_ID('Silver.erp_px_cat_g1v2_staging','U') IS NOT NULL
        DROP TABLE Silver.erp_px_cat_g1v2_staging;

    CREATE TABLE Silver.erp_px_cat_g1v2_staging(
        id NVARCHAR (50),
        cat NVARCHAR (50),
        subcat NVARCHAR (50),
        maintenance NVARCHAR (50),
        dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    -------------------------------------------------------------------
    -- SECTION 7: BULK LOAD DATA INTO STAGING TABLES
    -------------------------------------------------------------------
    PRINT 'Loading data into crm_cust_info_staging from CSV';
    TRUNCATE TABLE Silver.crm_cust_info_staging;
    BULK INSERT Silver.crm_cust_info_staging
    FROM 'C:\...\datasets\source_crm\cust_info.csv'
    WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

    PRINT 'Loading data into crm_prd_info_staging from CSV';
    TRUNCATE TABLE Silver.crm_prd_info_staging;
    BULK INSERT Silver.crm_prd_info_staging
    FROM 'C:\...\datasets\source_crm\prd_info.csv'
    WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

    PRINT 'Loading data into crm_sales_details_staging from CSV';
    TRUNCATE TABLE Silver.crm_sales_details_staging;
    BULK INSERT Silver.crm_sales_details_staging
    FROM 'C:\...\datasets\source_crm\sales_details.csv'
    WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

    PRINT 'Loading data into erp_cust_az12_staging from CSV';
    TRUNCATE TABLE Silver.erp_cust_az12_staging;
    BULK INSERT Silver.erp_cust_az12_staging
    FROM 'C:\...\datasets\source_erp\CUST_AZ12.csv'
    WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

    PRINT 'Loading data into erp_loc_a101_staging from CSV';
    TRUNCATE TABLE Silver.erp_loc_a101_staging;
    BULK INSERT Silver.erp_loc_a101_staging
    FROM 'C:\...\datasets\source_erp\LOC_A101.csv'
    WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

    PRINT 'Loading data into erp_px_cat_g1v2_staging from CSV';
    TRUNCATE TABLE Silver.erp_px_cat_g1v2_staging;
    BULK INSERT Silver.erp_px_cat_g1v2_staging
    FROM 'C:\...\datasets\source_erp\PX_CAT_G1V2.csv'
    WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK);

    -------------------------------------------------------------------
    -- SECTION 8: TRANSFORM & LOAD DATA FROM STAGING TO FINAL
    -------------------------------------------------------------------
    PRINT 'Transforming and loading customer info';
    TRUNCATE TABLE silver.crm_cust_info;
    INSERT INTO Silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_gndr, cst_material_status, cst_create_date)
    SELECT 
        cst_id,
        cst_key,
        TRIM(cst_firstname),
        TRIM(cst_lastname),
        CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
             WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
             ELSE 'n/a' END,
        CASE WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
             WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
             ELSE 'n/a' END,
        cst_create_date
    FROM silver.crm_cust_info_Staging;
    DROP TABLE silver.crm_cust_info_Staging;

    PRINT 'Transforming and loading product info';
    TRUNCATE TABLE silver.crm_prd_info;
    INSERT INTO silver.crm_prd_info (prd_id, prd_cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
    SELECT 
        prd_id,
        REPLACE(SUBSTRING(prd_key,1,5),'-','_'),
        SUBSTRING(prd_key,7,LEN(prd_key)),
        prd_nm,
        ISNULL(prd_cost, 0),
        CASE UPPER(TRIM(prd_line))
             WHEN 'R' THEN 'Road'
             WHEN 'S' THEN 'Other sales'
             WHEN 'M' THEN 'Mountain'
             WHEN 'T' THEN 'Touring'
             ELSE 'n/a' END,
        prd_start_dt,
        DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))
    FROM Silver.crm_prd_info_staging;
    DROP TABLE Silver.crm_prd_info_staging;

    PRINT 'Transforming and loading sales details';
    TRUNCATE TABLE Silver.crm_sales_details;
    INSERT INTO Silver.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
    SELECT 
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) END,
        CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) END,
        CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) END,
        CASE WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price)
                 THEN sls_quantity * ABS(sls_price)
             ELSE sls_sales END,
        sls_quantity,
        CASE WHEN sls_price = 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity,0)
             ELSE sls_price END
    FROM silver.crm_sales_details_staging;
    DROP TABLE silver.crm_sales_details_staging;

    PRINT 'Transforming and loading ERP customer info';
    TRUNCATE TABLE [Silver].[erp_cust_az12];
    INSERT INTO Silver.erp_cust_az12 (cid, bdate, gen)
    SELECT 
        CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid)) ELSE cid END,
        CASE WHEN bdate > GETDATE() THEN NULL ELSE bdate END,
        CASE WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
             WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female'
             WHEN UPPER(TRIM(gen)) = 'Female' THEN 'Female'
             WHEN UPPER(TRIM(gen)) = 'Male' THEN 'Male'
             ELSE 'n/a' END
    FROM [Silver].[erp_cust_az12_staging];
    DROP TABLE [Silver].[erp_cust_az12_staging];

    PRINT 'Transforming and loading ERP location info';
    TRUNCATE TABLE silver.erp_loc_a101;
    INSERT INTO silver.erp_loc_a101 (cid, cntry)
    SELECT 
        REPLACE(cid,'-',''),
        CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
             WHEN TRIM(cntry) IN ('US','USA') THEN 'United states'
             WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
             ELSE TRIM(cntry) END
    FROM Silver.erp_loc_a101_staging;
    DROP TABLE Silver.erp_loc_a101_staging;

    PRINT 'Transforming and loading ERP product category info';
    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
    SELECT id, cat, subcat, maintenance
    FROM [Silver].[erp_px_cat_g1v2_staging];
    DROP TABLE [Silver].[erp_px_cat_g1v2_staging];

PRINT 'Procedure Silver.load_silver execution completed successfully';

END;


select * from [Silver].[crm_cust_info]
