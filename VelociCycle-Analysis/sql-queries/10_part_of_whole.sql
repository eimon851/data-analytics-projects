/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?

select category
, total_sales
, sum(total_sales) over () as sales_sum
, format('%s%%', cast(round((total_sales * 100 / sum(total_sales) over ()),2) as string)) as percentage_of_total
from 
(
    select category
    , sum(sales_amount) as total_sales
    from datawarehouse-454113.gold.dim_products pr
    right join datawarehouse-454113.gold.fact_sales sa
        on pr.product_key = sa.product_key
    group by category
) x1
order by percentage_of_total desc
;