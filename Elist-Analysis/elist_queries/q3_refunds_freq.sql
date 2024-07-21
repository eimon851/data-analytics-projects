-- Are there certain products that are getting refunded more frequently than others? What are the top 3 most frequently refunded products across all years?

select
  case when orders.product_name = '27in"" 4k gaming monitor' 
    then '27in 4K gaming monitor' else orders.product_name end as product_name,
  sum(case when order_status.refund_ts is not null then 1 else 0 end) as refund_count, 
  round(sum(case when order_status.refund_ts is not null then 1 else 0 end)/count(distinct orders.id)*100,2) as refund_rate,
from elist.orders
join elist.order_status
  on orders.id = order_status.order_id
group by 1
order by 3 desc

-- The ThinkPad Laptop gets refunded the most at 17.77%, while the Macbook Air Laptop and Apple iPhone are the second and third most refunded items (16.75% and 11.62%, respectively). However, this does not mean they have the highest number of refunds - the Apple Airpods Headphones have the highest count of refunds, at 3348 refunds across all years. The 27in 4K gaming monitor and Macbook Air Laptop have 1824 and 565 refunds, respectively.

