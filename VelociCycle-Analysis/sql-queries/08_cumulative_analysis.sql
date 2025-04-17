-- Calculate the total sales per month and the running total sales over time
-- Include average and moving average price
select
year
, total_sales
, sum(total_sales) over (order by year) as running_total_sales
, average_price
, avg(average_price) over (order by year) as moving_average_price
from
(
  select date_trunc(order_date, month) as year
  , sum(sales_amount) as total_sales
  , avg(price) as average_price
  from datawarehouse-454113.gold.fact_sales
  where order_date is not null
  group by date_trunc(order_date, month)
  order by year
) x1
;