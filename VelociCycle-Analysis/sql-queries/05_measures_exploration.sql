-- Find total sales
select 
sum(sales_amount) as total_sales
from datawarehouse-454113.gold.fact_sales
;

-- Find how many items are sold
select 
sum(quantity) as total_quantity
from datawarehouse-454113.gold.fact_sales
;

-- Find average selling price
select
avg(price) as avg_selling_price
from datawarehouse-454113.gold.fact_sales
;

-- Find total number of orders made
select 
count(distinct order_number) as total_orders_made
from datawarehouse-454113.gold.fact_sales
;

-- Find the total number of products that were purchased
select count(distinct product_key) as total_products_purchased
from datawarehouse-454113.gold.fact_sales
;

-- Find the total number of customers that made an order
select count(distinct customer_key) as total_customers_who_ordered
from datawarehouse-454113.gold.fact_sales
;

-- Generate a report that shows all key metrics of a business

select "Total Sales" as measure_name
, sum(sales_amount) as measure_value
from datawarehouse-454113.gold.fact_sales
    union all
select "Total Quantity" as measure_name
, sum(quantity) as measure_value
from datawarehouse-454113.gold.fact_sales
    union all
select "Average Selling Price" as measure_name
, avg(price) as measure_value
from datawarehouse-454113.gold.fact_sales
    union all
select "Total Order Made" as measure_name
, count(distinct order_number) as measure_value
from datawarehouse-454113.gold.fact_sales
    union all
select "Total Products Purchased" as measure_name
, count(distinct product_key) as measure_value
from datawarehouse-454113.gold.fact_sales
    union all
select "Total Customers Who Ordered" as measure_name
, count(distinct customer_key) as measure_value
from datawarehouse-454113.gold.fact_sales
;
