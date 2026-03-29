/*
=======================================================================
Customer Report
=======================================================================
Purpose: 
	This report consolidates key customer metrics and behaviours
Highlights:
	Gathers essential fields, segments customers, and aggregates customer level metrics
	Calculates valuable KPIs
=======================================================================
*/
CREATE VIEW gold.report_customers AS
--Base CTE retrives core columns from the tables
WITH base_query AS(
SELECT
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name,' ',c.last_name) AS customer_name,
	DATEDIFF(year,c.birthdate, GETDATE()) AS age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
WHERE f.order_date IS NOT NULL
),
--customer data aggregations
customer_aggregations AS(
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month, MIN(order_date),MAX(order_date)) AS lifespan
FROM base_query
GROUP BY customer_key, customer_number, customer_name, age
)
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN age < 20 THEN 'Under 20'
		 WHEN age BETWEEN 20 AND 29 THEN 'In Their 20s'
		 WHEN age BETWEEN 30 AND 39 THEN 'In Their 30s'
		 WHEN age BETWEEN 40 AND 49 THEN 'In Their 40s'
		 WHEN age BETWEEN 50 AND 59 THEN 'In Their 50s'
		 ELSE '60+'
	END age_group,
	CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
			 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
			 ELSE 'New'
	END customer_segment,
	last_order_date,
	DATEDIFF(month,last_order_date,GETDATE()) AS recency,
	total_orders,
	total_sales,
	total_quantity,
	lifespan,
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales/total_orders 
	END AS avg_order_value,
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE total_sales/lifespan 
	END AS avg_monthly_spends
FROM customer_aggregations;




--Execute the customer report view: for advanced data analysis:
SELECT * FROM gold.report_customers;
