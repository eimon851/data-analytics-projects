-- What are the monthly and quarterly sales trends for Macbooks sold in North America across all years?

with cte as (
  select date_trunc(purchase_ts, month) as purchase_month,
    round(sum(orders.usd_price),2) as total_sales,
    count(distinct orders.id) as count_order,
    round(avg(orders.usd_price),2) as average_sales
  from elist.orders
  join elist.customers 
    on orders.customer_id = customers.id
  join elist.geo_lookup
    on customers.country_code = geo_lookup.country
  where lower(orders.product_name) like '%macbook%'
    and geo_lookup.region = 'NA'
  group by 1
  order by 1 desc 
)

select 
  sum(cte.count_order) as order_count,
  round(sum(cte.total_sales), 2) as total_sales,
  round(avg(cte.average_sales), 2) as aov
from cte

-- The total orders of Macbooks sold in North America across all years is 1689. The total sales is $5,084,201. The average order value $1564