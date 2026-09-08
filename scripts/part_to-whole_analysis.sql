--Which categories contribute the most overall sales
WITH category_sales AS(
SELECT
category,
SUM(sales_amount) As total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE category IS NOT NULL
GROUP BY category)

SELECT category,
total_sales,
SUM(total_sales) OVER() AS overall_sales,
CONCAT(ROUND((CAST(total_sales AS FLOAT)/SUM(total_sales) OVER()) *100, 2) , '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;

