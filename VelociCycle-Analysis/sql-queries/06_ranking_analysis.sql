-- Which 5 product generates the highest revenue
select pr.product_name
, sum(sales_amount) as total_revenue
from datawarehouse-454113.gold.fact_sales sa
left join datawarehouse-454113.gold.dim_products pr
  on sa.product_key = pr.product_key 
group by pr.product_name 
order by total_revenue desc
limit 5
;

-- What are the 5 worst performing products in terms of sale
select pr.product_name
, sum(sales_amount) as total_revenue
from datawarehouse-454113.gold.fact_sales sa
left join datawarehouse-454113.gold.dim_products pr
  on sa.product_key = pr.product_key 
group by pr.product_name 
order by total_revenue 
limit 5
;

-- Find the top 10 customers who have generated the highest revenue
select concat(cu.first_name, ' ', cu.last_name) as name
, sum(sales_amount) as total_revenue
from datawarehouse-454113.gold.fact_sales sa
left join datawarehouse-454113.gold.dim_customers cu
  on sa.customer_key = cu.customer_key
group by cu.first_name, cu.last_name
order by total_revenue desc
limit 10
;

-- The 3 customer with fewest orders placed
select concat(cu.first_name, ' ', cu.last_name) as name
, count(distinct order_number) as total_orders
from datawarehouse-454113.gold.fact_sales sa
left join datawarehouse-454113.gold.dim_customers cu
  on sa.customer_key = cu.customer_key
group by cu.first_name, cu.last_name
order by total_orders
limit 3
;
