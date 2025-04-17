/* Segment products into cost ranges and count how many products fall into each segment*/

select 
cost_range
, count(cost_range) as total_count
from 
(
  select product_key
  , product_name
  , cost
  , case when cost < 100 then 'Below 100'
        when cost between 100 and 500 then '100-500'
        when cost between 500 and 1000 then '500-1000'
        else 'Above 1000'
    end as cost_range
  from datawarehouse-454113.gold.dim_products sa
  order by cost desc
)
group by cost_range
;