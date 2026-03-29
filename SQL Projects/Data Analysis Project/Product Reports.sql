/*
=======================================================================
Product Report
=======================================================================
Purpose: 
	This report consolidates key products metrics and behaviors.
Highlights:
	Gathers essential fields, segments product performance, and aggregates product level metrics
	Calculates valuable KPIs
=======================================================================
*/
CREATE VIEW gold.report_products AS
--Base CTE retrives core columns from the tables
WITH base_query AS(
SELECT
	f.order_number,
	f.order_date,
	f.customer_key,
	f.sales_amount,
	f.quantity,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
),
--customer data aggregations
product_aggregations AS(
SELECT
    product_key,
	product_name,
	category,
	subcategory,
	cost,
	DATEDIFF(month, MIN(order_date),MAX(order_date)) AS lifespan,
	MAX(order_date) AS last_order_date,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS float)/NULLIF(quantity,0)),1) AS avg_selling_price
FROM base_query
GROUP BY product_key, product_name, category, subcategory, cost
)
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_order_date,
	DATEDIFF(month,last_order_date,GETDATE()) AS recency,
	CASE WHEN total_sales >50000 THEN 'High Performer'
		 WHEN total_sales >=10000 THEN 'Mid_Range'
		 ELSE 'Low-Performer'
	END AS product_segments,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales/total_orders 
	END AS avg_order_revenue,
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE total_sales/lifespan 
	END AS avg_monthly_revenue
FROM product_aggregations;




--Execute the customer report view: for advanced data analysis:
SELECT * FROM gold.report_products;
