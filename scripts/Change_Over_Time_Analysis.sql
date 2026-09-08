SELECT 
YEAR(order_date) order_year,
MONTH(order_date) order_month,
SUM(sales_amount) As total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM
gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date) ,MONTH(order_date)
ORDER BY YEAR(order_date) ,MONTH(order_date);
