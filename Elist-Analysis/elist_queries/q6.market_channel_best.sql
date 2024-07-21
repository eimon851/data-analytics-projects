-- Which marketing channels perform the best in each region? Does the top channel differ across regions?

with cte as (
select
  region,
  customers.market_channel,
  sum(orders.usd_price) as total_sales,
  dense_rank() over (partition by region order by sum(orders.usd_price) desc) as rnk,
  count(distinct orders.id) as order_count,
  avg(orders.usd_price) as aov
from elist.customers
left join elist.orders
  on customers.id = orders.customer_id
left join elist.geo_lookup
  on customers.country_code = geo_lookup.country
group by 1,2
order by 1,2) 

select *,
from cte
where rnk = 1;


-- Based on the analysis, North America leads in total sales with $17.67M, followed by EMEA with $10.73M, and APAC with $4.71M, primarily through direct market channels. The highest average order value (AOV) is in the APAC region at $303.27. The affiliate channel in an unspecified region has the lowest total sales at $11.88K and an AOV of $75.22.