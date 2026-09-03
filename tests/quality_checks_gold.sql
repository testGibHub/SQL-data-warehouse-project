/*
========================================================================
Quality checks
========================================================================
Script purpose:
  This script performs quality checks to validate the integrity, consistency
  and accuracy of the Gold layer. these checks ensur:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables
    - validation of relationships in the data model and analytical purposes.


Usage Notes:
  - Run these after data loading silver layer.
  - Investigate and resolve any discrepencies found during the checks.
========================================================================
*/

--=======================================================================
--Checking 'gold.dim_customers'
--=======================================================================
--Check for Uniqueness of customer key in  gold.dim_customers
--Expectation: No Results

SELECT
  customer_key,
  COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

--=======================================================================
--Checking 'gold.dim_products'
--=======================================================================
--Check for Uniqueness of customer key in  gold.dim_products
--Expectation: No Results
  SELECT
  product_key,
  COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

--=======================================================================
--Checking 'gold.fact_sales'
--=======================================================================
--Check the data model connectivity between fact and dimensions
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;
