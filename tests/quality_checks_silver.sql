/*
=======================================================================
Quality Checks
========================================================================
Script purpose:
  This script performs various quality checks for adta consistency, accuracy,
  and standardization across the 'silver' schema. it includes checls for:
    -Null or duplicate primary keys.
    -Unwanted spaces in string fields.
    -Data standardization and consistency.
    -Invalid data ranges ad orders.
    -Data consistency between related fields.

Usage Notes:
  -Run these checks after data loading Silver Layer-
  -Investigate and resolve any discrepencies found during the checks.
============================================================================
  */

-- =========================================================================
-- Checking 'silver.crm_prd_info'
-- =========================================================================
  
--checking for duplicate primary key and any null values in primary key
--Expectation: No Results
SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

--checking for any spaces before and after
--Expectation: No Results
SELECT prd_nm FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

--Check for NULLS and negative Numbers
--Expectation: No Results
SELECT prd_cost FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

--Check FOR Data Standardization & Consistency

SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

--Check for invalid Date Orders
SELECT
*
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

--Query for checking prd_start_date and prd_end_date
SELECT
prd_id,
prd_key,
prd_nm,
prd_start_dt,
prd_end_dt,
DATEADD(DAY, -1 ,LEAD(prd_start_dt) OVER(PARTITION BY  prd_key ORDER BY prd_start_dt)) AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R' , 'AC-HE-HL-U509');

-- =========================================================================
-- Checking 'silver.crm_cust_info'
-- =========================================================================
--check for unwanted spaces
--EXPECTAION: No Results

SELECT
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

SELECT cst_firstname FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT cst_gender FROM bronze.crm_cust_info
WHERE cst_gender != TRIM(cst_gender);

SELECT cst_material_status FROM bronze.crm_cust_info
WHERE cst_material_status != TRIM(cst_material_status);

--Data Standardization & Consistency
SELECT DISTINCT cst_gender
FROM bronze.crm_cust_info;


-- =========================================================================
-- Checking 'bronze.crm_sales_details'
-- =========================================================================
--check for invalid dates
--for sls_order_dt entity
SELECT
NULLIF(sls_order_dt ,0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101 
OR sls_order_dt < 1900101

--check for invalid dates
--for sls_ship_dt entity
SELECT
NULLIF(sls_ship_dt ,0) AS sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101 
OR sls_ship_dt < 1900101

--check for invalid dates
--for sls_due_dt entity
SELECT
NULLIF(sls_due_dt ,0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101 
OR sls_due_dt < 1900101

--check for INVALID date Orders
SELECT *
FROM 
bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

--check for Data Consistency: between Sales, Quantity and Price
-->> Sales = Quantity * Price
-->> Values must not be NULL, Zero or negative
-->> RULES FOR CONVERTING VALUES IN SALES, Quantity and Price
-->If sales is negative, zero, or null, derive it using quantity and price
--> If price is zero or null, calculate it using Sales and Quantity
--> If price is negative, convert it to a positive value
SELECT DISTINCT
sls_sales As old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
	END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
	ELSE sls_price 
	END AS sls_price
	FROM bronze.crm_sales_details;
	
WHERE sls_sales != (sls_quantity * sls_price)
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity,sls_price ;


---check for quality for silver table after insertion from bronze table
SELECT * FROM silver.crm_sales_details;
