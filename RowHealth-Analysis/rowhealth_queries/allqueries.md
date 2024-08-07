1. What are the total number of claims per month, per product in 2020?

```sql
select date_trunc(claim_date, month) as claim_month,
  product_name,
  count(distinct claim_id) as num_claims
from rowhealth.claims
where extract(year from claim_date) = 2020
group by 1,2
order by 1
```

2. What was the total number of claims, total claim cost, and total covered cost in June 2023?

```sql
SELECT count(distinct claim_id) as total_claim_num,
  round(sum(claim_amount),1) as total_claim_cost,
  round(sum(covered_amount),1) as total_covered_cost
from `rowhealth-430401.rowhealth.claims`
where extract(month from claim_date) = 6
  and extract(year from claim_date) = 2023
```

3.What were the top 2 hair products in June 2023? 

```sql
select date_trunc(claim_date,month) as claim_month,
  product_name,
  round(sum(claim_amount))
from rowhealth.claims
where date_trunc(claim_date,month) = '2023-06-01'
  and lower(product_name) like 'hair%'
group by 1,2
order by 3 desc
limit 2
```

4. Which state had the highest number of claims in the program in 2023? How would you compare this to the state with the highest claim amounts?

```sql
select state,
  count(claim_id),
  sum(claim_amount) as total_claim_amount
from rowhealth.claims 
left join rowhealth.customers
  on claims.customer_id = customers.customer_id
where extract(year from claim_date) = 2023
group by 1
order by 3 desc
```

5. Which category had the highest covered amount on Christmas in 2022: Hair supplements, Biotin supplements, or Vitamin B supplements? Assume each product has the keyword in its name.

```sql
with cte as (
  select
    case 
      when lower(product_name) like '%hair%' then 'Hair'
      when lower(product_name) like '%biotin%' then 'Bioten'
      when lower(product_name) like '%vitamin b%' then 'Vitamin B'
    end as category,
    round(sum(covered_amount)) as covered_amount
  from rowhealth.claims
  where claim_date = '2022-12-25'
  group by 1)

  select *
  from cte
  where cte.category is not null
  order by cte.covered_amount desc
  ```

6. Which 10 customers have the most claims across all time? Return their first and last name as one field.

```sql
select customers.customer_id,
  concat(customers.first_name, ' ', customers.last_name) as full_name,
  count(distinct claims.claim_id) as total_claims
from rowhealth.customers
left join rowhealth.claims
  on customers.customer_id = claims.customer_id
group by 1,2
order by 3 desc
limit 10
```

7. How many customers either have a platinum plan and signed up in 2023, or signed up in 2022?

```sql
with cte as (
select customer_id,
  plan,
  signup_date
from rowhealth.customers
where plan = 'platinum'
  and (extract(year from signup_date) = 2023 or extract(year from signup_date) = 2022)
)

select count(cte.customer_id) as customer_count
from cte
```




