/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

with base_query as
(
    select
    order_number
    , sa.product_key
    , sa.customer_key
    , order_date
    , sales_amount
    , quantity
    , product_name
    , category
    , subcategory
    , cost
    from datawarehouse-454113.gold.fact_sales sa
    left join datawarehouse-454113.gold.dim_products pr
        on sa.product_key = pr.product_key
    where order_date is not null
)

, product_aggregation as
(
    select
    product_key
    , product_name
    , category
    , subcategory
    , cost
    , count(distinct customer_key) as total_customer
    , date_diff(max(order_date), min(order_date), month) as lifespan
    , max(order_date) as last_order_date
    , count(distinct order_number) as total_order
    , sum(sales_amount) as total_sales
    , sum(quantity) as total_quantity
    , round(avg(safe_divide(cast(sales_amount as numeric),quantity)),2) as avg_selling_price
    from base_query
    group by product_key
    , product_name
    , category
    , subcategory
    , cost
)

select 
product_key
, product_name
, category
, subcategory
, cost
, last_order_date
, date_diff(current_date(), last_order_date, month) as recency
, case when total_sales > 50000 then 'High Performer'
       when total_sales >= 10000 then 'Mid Performer'
       else 'Low Performer'
  end as product_segment
, lifespan
, total_order
, total_sales
, total_quantity
, total_customer
, avg_selling_price
, round(avg(safe_divide(cast(total_sales as numeric),total_order)),2) as average_order_revenue
, case when lifespan = 0 then 0
       else round((total_sales / lifespan),2)
  end as avg_monthly_revenue
from product_aggregation
group by
product_key
, product_name
, category
, subcategory
, cost
, last_order_date
, lifespan
, total_order
, total_sales
, total_quantity
, total_customer
, avg_selling_price
;