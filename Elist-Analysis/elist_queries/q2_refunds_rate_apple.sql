-- What was the monthly refund rate for purchases made in 2020? How many refunds did we have each month in 2021 for Apple products?

with cte as (
  select date_trunc(purchase_ts, month) as purchase_month,
    count(order_status.order_id) as order_count,
    sum(case when order_status.refund_ts is not null then 1 else 0 end) as refund_count,
    -- sum(case when order_status.refund_ts is not null then 1 else 0 end)/count(order_status.order_id) as refund_rate
  from elist.order_status
  group by 1) 

select purchase_month,
  round(refund_count/order_count * 100)
from cte
where extract(year from purchase_month) = 2020
order by 1

-- Monthly refunds rates of orders placed in 2020 ranged between 8-10%

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select date_trunc(order_status.refund_ts, month) as month,
  sum(case when order_status.refund_ts is not null then 1 else 0 end) as refund,
from elist.orders
left join elist.order_status
  on orders.id = order_status.order_id
where extract(year from order_status.refund_ts) = 2021
  and lower(product_name) like '%apple%'
group by 1
order by 1;

-- In 2021, Apple products had the lease refund in January (22) and most refunds in December (95) possible due to it being the holiday season, but would have 30-60 refunds each month