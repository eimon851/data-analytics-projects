-- What’s the average order value across different account creation methods in the first two months of 2022? Which method had the most new customers in this time?

select customers.account_creation_method,
  avg(usd_price) as aov,
	count(distinct customers.id) as num_customers
from elist.orders
left join elist.customers
	on orders.customer_id = customers.id
where created_on between '2022-01-01' and '2022-02-28'
group by 1
order by 3 desc;

-- In 2022, desktop users spent the most ($231.46) while tablet users had the highest average order value per customer (444.63) despite being a much smaller group. Desktop brough the most new customers (2359) with mobile bringing in the second most (591)
