 /* Analyze the yearly performance of products by comparing their sales to both the average sales performance of the product and the previous year's sales */

with yearly_product_sales as
(
  select extract(year from order_date) as order_year
  , product_name
  , sum(sales_amount) as current_sales
  from datawarehouse-454113.gold.dim_products pr 
  left join datawarehouse-454113.gold.fact_sales sa
    on pr.product_key = sa.product_key
  where order_date is not null
  group by extract(year from order_date), product_name
)

select order_year
, product_name
, current_sales
, avg(current_sales) over (partition by product_name) as avg_sales
, current_sales - avg(current_sales) over (partition by product_name) as diff_avg
, case when current_sales - avg(current_sales) over (partition by product_name) > 0 then 'Above Avg'
       when current_sales - avg(current_sales) over (partition by product_name) < 0 then 'Below Avg'
       else 'Avg'
  end as avg_change
, lag(current_sales) over (partition by product_name order by order_year) as py_sales
, current_sales - lag(current_sales) over (partition by product_name order by order_year) as diff_py
, case when current_sales - lag(current_sales) over (partition by product_name order by order_year) > 0 then 'Increase'
       when current_sales - lag(current_sales) over (partition by product_name order by order_year) < 0 then 'Decrease'
       else 'No Change'
  end as py_change
from yearly_product_sales
order by lower(product_name), order_year
;