-- What’s the average time between customer registration and placing an order?

with cte as (
select orders.id,
  created_on,
  orders.purchase_ts,
  datetime_diff(orders.purchase_ts,created_on,day) as diff_in_day
from elist.customers 
join elist.orders
  on customers.id = orders.customer_id)

select avg(cte.diff_in_day)
from cte

-- The average time is 587 days.