--Which 5 products generate the highest revenue?
SELECT TOP 5 
p.product_name,
SUM(f.sales_amount) As revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY revenue DESC

--What are the 5 worst-performing products in terms of sales?
SELECT TOP 5 
p.product_name,
SUM(f.sales_amount) As revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY revenue

--Using window function
SELECT *
FROM(
	SELECT
	p.product_name,
	SUM(f.sales_amount) As revenue,
	ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount)) AS rank_products
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
	GROUP BY p.product_name)t
WHERE rank_products <= 5


