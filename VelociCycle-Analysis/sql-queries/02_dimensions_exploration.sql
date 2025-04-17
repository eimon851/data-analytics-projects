-- Dimensions to check: country
select distinct country
from datawarehouse-454113.gold.dim_customers
;


-- Dimensions to check: category, subcategory, product_line?
select distinct 
product_name
, category
, subcategory
from datawarehouse-454113.gold.dim_products
;