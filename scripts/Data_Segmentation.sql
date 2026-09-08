/*Group customers into three segments based on their soending behaviuor:
-VIP: Customers with atleast 12 months of history and spending more than £5000
-Regular: Customers with atleast 12 months of history and spending £5000 or less.
-New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH total_customers AS(
SELECT
c.customer_key,
SUM(f.sales_amount) AS total_spending,
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
DATEDIFF(month, MIN(order_date),MAX(order_date)) AS lifespan,
CASE WHEN DATEDIFF(month, MIN(order_date),MAX(order_date)) >= 12 AND SUM(f.sales_amount) > 5000 THEN 'VIP'
	WHEN DATEDIFF(month, MIN(order_date),MAX(order_date)) >= 12 AND SUM(f.sales_amount) <= 5000 THEN 'Regular'
	ELSE 'NEW'
END As customer_segments
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)

SELECT
customer_segments,COUNT(customer_key) AS customer_group
FROM total_customers
GROUP BY customer_segments
ORDER BY customer_group DESC;

