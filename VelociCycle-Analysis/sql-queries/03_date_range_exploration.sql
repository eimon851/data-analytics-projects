-- Find the date of the first and last order
-- How many years of sales are available
select 
min(order_date) as first_order_date
, max(order_date) as last_order_date
, date_diff(max(order_date), min(order_date), month) as month_diff
from datawarehouse-454113.gold.fact_sales
;

-- Find the oldest and youngest customer age
select
min(birthdate) as oldest_customer_birthdate
, date_diff(current_date(), min(birthdate), year) as oldest_customer_age
, max(birthdate) as youngest_customer_birthdate
, date_diff(current_date(), max(birthdate), year) as youngest_customer_age
from datawarehouse-454113.gold.dim_customers
;