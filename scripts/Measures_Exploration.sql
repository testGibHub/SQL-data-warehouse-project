-- Find the total sales
SELECT SUM(sales_amount)  As total_sales FROM gold.fact_sales;
-- FInd how many items are sold
SELECT SUM(quantity) As total_quantity FROM gold.fact_sales;
-- find the average selling price
SELECT AVG(price) As average_selling_price FROM gold.fact_sales;
-- find the total number of orders
SELECT COUNT(Order_number) AS total_no_orders FROM gold.fact_sales;
SELECT COUNT(DISTINCT(Order_number)) AS total_no_orders FROM gold.fact_sales;

-- find the total number of products
SELECT COUNT(product_key) As total_products FROM gold.dim_products;
-- find the total number of customers
SELECT COUNT(customer_key) As total_number_of_customers FROM gold.dim_customers;
-- find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) FROM gold.fact_sales
;

--Generate a report that shows all key metrics of the business
SELECT 'Total Sales' as mesaure_name, SUM(sales_amount)  As mesaure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' as mesaure_name, SUM(quantity)  As mesaure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average price' as mesaure_name , AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total  no. of orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total no. of products', COUNT(product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total no. of customers', COUNT(customer_key) FROM gold.dim_customers;
