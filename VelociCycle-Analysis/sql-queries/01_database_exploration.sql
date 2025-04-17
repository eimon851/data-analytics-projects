-- Explore all objects in db
select *
from datawarehouse-454113.gold.INFORMATION_SCHEMA.TABLES
;

-- Explore all objects in columns
-- Dimensions to check: country
select *
from datawarehouse-454113.gold.INFORMATION_SCHEMA.COLUMNS
where table_name = 'dim_customers'
;

-- Dimensions to check: category, subcategory, product_line?
select *
from datawarehouse-454113.gold.INFORMATION_SCHEMA.COLUMNS
where table_name = 'dim_products'
;

select *
from datawarehouse-454113.gold.INFORMATION_SCHEMA.COLUMNS
where table_name = 'fact_sales'
;