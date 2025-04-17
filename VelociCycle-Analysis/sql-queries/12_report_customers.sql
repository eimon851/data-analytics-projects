/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		  - average order value
		  - average monthly spend
===============================================================================
*/

with base_query as
(
	select sa.order_number
	, sa.product_key
	, sa.order_date
	, sa.sales_amount
	, sa.quantity
	, cu.customer_key
	, cu.customer_number
	, concat(first_name, ' ', last_name) as customer_name
	, date_diff(current_date, birthdate, year) as age
	from datawarehouse-454113.gold.fact_sales sa
	left join datawarehouse-454113.gold.dim_customers cu
		on sa.customer_key = cu.customer_key
	where order_date is not null
)

, customer_aggregation as 
(
	select 
	customer_key 
	, customer_number
	, customer_name
	, age
	, count(distinct order_number) as total_orders
	, sum(sales_amount) as total_sales
	, sum(quantity) as total_quantity
	, count(distinct product_key) as total_products
	, max(order_date) as last_order_date
	, date_diff(max(order_date), min(order_date), month) as lifespan
	from base_query
	group by customer_key
	, customer_number
	, customer_name
	, age
)

select 
customer_key
, customer_number
, customer_name
, age
, case when age < 20 then 'Under 20'
			 when age >= 20 and age < 30 then '20-29'
			 when age >= 30 and age < 40 then '30-39'
			 when age >= 40 and age < 50 then '40-49'
			 else '50 and above'
	end as age_group
, case when lifespan >= 12 and total_sales > 5000 then 'VIP'
			 when lifespan >= 12 and total_sales <= 5000 then 'Regular'
			 else 'New'
	end as customer_segment
, last_order_date
, date_diff(current_date(), last_order_date, month) as recency
, total_orders
, total_sales
, total_quantity
, total_products
, lifespan
, case when total_orders = 0 then 0
			 else round((total_sales / total_orders),2)
	end as avg_order_value
, case when lifespan = 0 then total_sales
			 else round((total_sales / lifespan),2)
	end as avg_monthly_spend
from customer_aggregation
;