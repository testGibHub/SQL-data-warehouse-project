--Date Exploration
--Find the date of the first and last order
--How many years of sales are available

SELECT MIN(order_date) As first_order_Date, 
MAX(order_date) As last_order_date ,
DATEDIFF(MONTH,MIN(order_date), MAX(order_date)) AS diff_in_dates
FROM gold.fact_sales;

--Find the youngest and oldest customer
SELECT MIN(birthdate)As oldest_customer,
DATEDIFF(year,MIN(birthdate), GETDATE()) AS oldest_age,
MAX(birthdate) AS youngest_customer,
DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_date FROM gold.dim_customers ;
