/*
================================================================
DDL Script: Create Bronze Tables
================================================================
Script Purpose:
This script creates tables in the 'bronze' schema, dropping existing tables if they already exist.
Run this script to re-define the DDL structure of 'bronze Tables
================================================================
*/

if OBJECT_ID('Bronze.crm_cust_info','U') is not null
    drop table Bronze.crm_cust_info;


create table Bronze.crm_cust_info(
cst_id int,
cst_key nvarchar (50),
cst_firstname nvarchar (50),
cst_lastname nvarchar (50),
cst_material_status nvarchar (50),
cst_gndr nvarchar (50),
cst_create_date date);

if OBJECT_ID('Bronze.crm_prd_info','U') is not null
    drop table Bronze.crm_prd_info; 

create table Bronze.crm_prd_info(
prd_id int,
prd_key nvarchar (50),
prd_nm nvarchar (50),
prd_cost int,
prd_line nvarchar (50),
prd_start_dt date,
prd_end_dt date
);

if OBJECT_ID('Bronze.crm_sales_details','U') is not null
    drop table Bronze.crm_sales_details;

CREATE TABLE Bronze.crm_sales_details (
    sls_ord_num NVARCHAR(max),
    sls_prd_key NVARCHAR(max),
    sls_cust_id NVARCHAR(max),
    sls_order_dt NVARCHAR(max),
    sls_ship_dt NVARCHAR(max),
    sls_due_dt NVARCHAR(max),
    sls_sales NVARCHAR(max),
    sls_quantity NVARCHAR(max),
    sls_price NVARCHAR(max),
    Delete_1 NVARCHAR(max),
    Delete_2 NVARCHAR(max),
    Delete_3 NVARCHAR(max),
    Delete_4 NVARCHAR(max),
    Delete_5 NVARCHAR(max),
    Delete_6 NVARCHAR(max)
);




if OBJECT_ID('Bronze.erp_cust_az12','U') is not null
    drop table Bronze.erp_cust_az12;

create table Bronze.erp_cust_az12(
cid	nvarchar (50),
bdate date,
gen nvarchar (50)
)


if OBJECT_ID('Bronze.erp_loc_a101','U') is not null
    drop table Bronze.erp_loc_a101;

create table Bronze.erp_loc_a101 (
cid nvarchar (50),
cntry nvarchar (50)
)

if OBJECT_ID('Bronze.erp_px_cat_g1v2','U') is not null
    drop table Bronze.erp_px_cat_g1v2;

create table Bronze.erp_px_cat_g1v2(
id nvarchar (50),
cat nvarchar (50),
subcat nvarchar (50),
 maintenance nvarchar (50)
)


CREATE OR ALTER PROCEDURE Bronze.load_bronze as

begin


truncate table Bronze.crm_cust_info;

   BULK INSERT Bronze.crm_cust_info
FROM 'C:\Users\raghavendra.v\OneDrive - B-Informative IT Services Pvt ltd\Practice\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

select count(*) from bronze.crm_cust_info


truncate table bronze.crm_prd_info 

BULK INSERT Bronze.crm_prd_info
from 'C:\Users\raghavendra.v\OneDrive - B-Informative IT Services Pvt ltd\Practice\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
with(
  firstrow = 2,
  fieldterminator = ',',
  rowterminator = '\n',
  tablock
);

select count(*) from Bronze.crm_prd_info


truncate table bronze.crm_sales_details 

BULK INSERT Bronze.crm_sales_details
FROM 'C:\Users\raghavendra.v\OneDrive - B-Informative IT Services Pvt ltd\Practice\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

INSERT INTO Bronze.crm_sales_details (
    sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt,
    sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price
)
SELECT 
    sls_ord_num, 
    sls_prd_key, 
    CAST(sls_cust_id AS INT),
    sls_order_dt, 
    sls_ship_dt, 
    sls_due_dt,
    CAST(sls_sales AS INT), 
    CAST(sls_quantity AS INT), 
    CAST(sls_price AS INT)
FROM Bronze.crm_sales_details;

ALTER TABLE Bronze.crm_sales_details
DROP COLUMN Delete_1, Delete_2, Delete_3, Delete_4, Delete_5, Delete_6;


select * from Bronze.crm_sales_details





truncate table bronze.erp_cust_az12 

BULK INSERT bronze.erp_cust_az12
from 'C:\Users\raghavendra.v\OneDrive - B-Informative IT Services Pvt ltd\Practice\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
with(
  firstrow = 2,
  fieldterminator = ',',
  rowterminator = '\n',
  tablock
);

select * from bronze.erp_cust_az12

truncate table bronze.erp_loc_a101 

BULK INSERT bronze.erp_loc_a101  
from 'C:\Users\raghavendra.v\OneDrive - B-Informative IT Services Pvt ltd\Practice\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
with(
  firstrow = 2,
  fieldterminator = ',',
  rowterminator = '\n',
  tablock
);

select * from bronze.erp_loc_a101 


truncate table Bronze.erp_px_cat_g1v2

BULK INSERT  Bronze.erp_px_cat_g1v2 
from 'C:\Users\raghavendra.v\OneDrive - B-Informative IT Services Pvt ltd\Practice\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
with(
  firstrow = 2,
  fieldterminator = ',',
  rowterminator = '\n',
  tablock
);

select * from Bronze.erp_px_cat_g1v2

end
