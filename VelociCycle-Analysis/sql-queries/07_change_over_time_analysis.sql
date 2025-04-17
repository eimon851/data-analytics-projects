-- Total sales, total customers and total quantity over time (month)
select date_trunc(order_date, month) as month
, sum(sales_amount) as total_revenue
, count(distinct customer_key) as total_customer
, sum(quantity) as total_quantity
from datawarehouse-454113.gold.fact_sales
where order_date is not null
group by date_trunc(order_date, month)
order by month asc
;

-- Format date column as Year-mon
select format_date('%Y-%b', order_date) as month
, sum(sales_amount) as total_revenue
, count(distinct customer_key) as total_customer
, sum(quantity) as total_quantity
from datawarehouse-454113.gold.fact_sales
where order_date is not null
group by format_date('%Y-%b', order_date), date_trunc(order_date, month)
order by date_trunc(order_date, month)
;

