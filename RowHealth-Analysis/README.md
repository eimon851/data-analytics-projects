# Row Health Wellness Program Analysis (2019-2023)

# Table of Content

- About This Project

- Excel Insight + Technical Analysis

- SQL Insights + Technical Analysis

- Tableau Dashboard + Insights

- Recommendations

# About This Project

Founded in 2016, Row Health is a tech-focused insurance company with over 100,000 U.S. customers, offering a Wellness Reimbursement program since 2019 to subsidize popular wellbeing supplements and promote daily health care through diverse digital marketing efforts. 

As a new data analyst on the patient research team, I prioritize understanding company trends, answering ad-hoc questions, and providing recommendations to the product and marketing teams, all to support the team in enhancing customer acquisition and boosting brand awareness.

# Project Overview

  

## Part A: Claim Trend + Campaign Performance Analysis (Excel)

- Conduct **claim analysis** to determine **seasonal growth** on various claim metrics, including **product-specific** claim metrics.

- Analyzed **campaign performance** by evaluating **costs, impressions, and sign-up rates** for **customer acquisition**, and **CPC, CPA, and CTR** for customer engagement.

## Part B: Specific Insights (SQL)

- Delivered comprehensive insights to the Claims department on **top hair-related products**, states with the **highest claims**, most **frequent users** of the reimbursement program, and more.

## Part C: Visualizations (Tableau)

- Create interactive dashboards for campaign performance

## Part 4: Recommendations & Next Steps

- Provide targeted marketing strategies and optimization suggestions.

  
# Excel Insights + Technical Analysis

![image](https://github.com/user-attachments/assets/1dcfc675-8c44-4ce8-ad14-636b67adc30c)

## MONTH ON MONTH CLAIM GROWTH RATE (2023)

### Claim Numbers and Trends

#### Fluctuations Throughout 2023:

- Claim numbers showed variability during 2023, with a noticeable decline at the start of the year.
- A significant increase of 22% was observed in March.
- The latter half of the year saw a sharp decline, with July experiencing the most substantial decrease in claim numbers (almost 33%).

#### Trends Based on Previous Years:

- Historically, claim numbers tend to fluctuate slightly for the remainder of the year.


### Claim Amount and Impact on Costs

#### Highest Growth in March:

- In March 2023, the claim amount monthly growth rate peaked with a 24% increase, indicating that the increase in claims also involved higher costs, possibly due to higher claim values or more expensive supplements being claimed.

#### March to April Decline:

- From March to April, the total claim amount decreased by only 4.28%, which is less than the 11.13% decrease in the number of claims. This suggests that certain higher-cost 
supplements were claimed more frequently.

#### June to July Decline:

There was a sharp decline in both claims and claim amounts from June to July, potentially due to external factors such as policy changes, reduced demand, or seasonality.

### Average Claim Amount and Its Correlation with Claim Numbers

#### Positive Growth Correlation:

- During months with positive Average Claim Amount Growth (e.g., February, April, June), fewer claims were made, but they were of higher value on average.

#### Negative Growth Correlation:

- In months where the average claim amount growth was negative (e.g., May, July), an increase in the number of claims resulted in lower average claim amounts, indicating that more claims were of lower value.

#### Exceptions:

- March and July did not follow the expected relationship, suggesting other factors might have influenced the average claim amounts in these months.

## CAMPAIGN PERFORMANCE BY CAMPAIGN CATEGORY 

![image](https://github.com/user-attachments/assets/99dffb6a-48db-403a-8725-811be2f2c776)
![image](https://github.com/user-attachments/assets/725dbca6-f36f-45fc-a32d-ec86389c8590)


#### #CoverageMatters and Health For All:

- Both campaigns are highlly cost efficient and have sigh sign-up rates making them standout campaigns
- Health For All has the highest sign-up rate (2.08%) and low cost per sign-up ($1.23)

#### Golden Years Security and Benefit Updates
- These campaigns have poor performance with very high cost per sign-up ($176.73 and $47.81, respectifvely) and low sign-up rates (0.01% and 0.02%, respectively)
- Indicates inefficiency in converting impression to sign-ups.

#### Marketing Channels

- Social Media outperforms other channels in terms of the number of sign-ups (7610) and has a relatively low cost per sign-up($2.25)
- Email and SEO also perform well, with reasonable cost per sign-up and significant reach
- TV has the lowest perfoamnce amoung channnels with high cost per sign-up ($10.48) and low sign-up rate (0.08%)

#### Campaign Reach

- Campaigns like Tailored Health Plans and Preventive Care News have high impression but relatively low sign-up rates, indicating a need for better targeting or ad relevance to improve conversion.

### Recommendations

- "Golden Years Security", "Benefit Updates", and the TV channel need improvements due to their high cost per sign-up and low sign-up rates.
- Campaigns with high impressions but low sign-up rates (e.g., "Tailored Health Plans") should focus on improving ad relevance and targeting to convert impressions into sign-ups.
  

# SQL Insights + Technical Analysis

In this section, I focused on addressing specific business queries using BigQuery SQL. My analysis involved using aggregation functions, window functions, joins, filtering, CASE expressions, common table expressions (CTEs), and the QUALIFY clause with ranking function like ROW_NUMBER() to refine the results. You can find the SQL queries for these insights [here](/RowHealth-Analysis/rowhealth_queries/allqueries.md). Code is attached to the last 3 insight in this list.

### Monthly Product Claim Totals for 2020

- In 2020, Hair Growth Supplement has consistently had the highest number of claim each month except in May where Vitamin B+ Advanced Complex had the highest (392).

### June 2023 Claims Summary

- In June 2023, the total number of claim was 1069 with a total cost of $13.7K and a total of $83K was covered for those cost.

### Top 2 Hair Products in June 2023

- The top two hair products in June 2023 were Hair Vitamins Trio ($18K) and Hair Growth Supplements (~$12K) in claim amount.

### State with Most Claims vs. Highest Claim Amounts in 2023

- New Jersey had the highest number of claims (3.9K), which was correlated with the highest claim amount ($479K)

### Top Covered Amount Category on Christmas 2022

- Hair has the highest covered amount of $570 

### Top 10 Customers with Most Claims

- Eduardo and Marylee are tied for most claims (55). The remaining customer are very close to this number.

### Platinum Customers in 2023 or Signed Up in 2022

- 8 customers have a platinum plan and either signed up in 2022 or 2023

### Avg Percent Reimbursement for Hair Products in NY or Supplements

```sql
-- What was the average percent reimbursement across all years for products that were either hair related and sold in NY, or a supplement product?

select
  extract(year from claim_date) as year,
  -- have to make sure all sum of claim_amount = 0 are null
  case when sum(cl.claim_amount) = 0 then null else
    round(sum(cl.covered_amount)/sum(cl.claim_amount)*100,1) end as avg_reimbursement
from rowhealth.customers as cu
left join rowhealth.claims as cl
  on cu.customer_id = cl.customer_id
where (lower(cl.product_name) like '%hair%' and cu.state = 'NY')
  or lower(cl.product_name) = '%supplement'
group by 1
order by 1 desc;
```
- The average reimburstment  percentage was consistently around 60% each year with 2019 having the highest (63.3%)

### Average Days Between Claims for Multi-Claim Customers

```sql
-- For customers with more than one claim, what's the average number of days between claims for each customer?

with cte as
(select cl.customer_id,
  cl.claim_date,
  lag(cl.claim_date,1) over (partition by cl.customer_id order by cl.claim_date) as prev_date
from rowhealth.claims as cl
left join rowhealth.customers as cu
  on cl.customer_id = cu.customer_id)

select cte.customer_id,
  avg(date_diff(cte.claim_date,cte.prev_date,day)) as avg_days_betw_claims
from cte
where prev_date is not null
group by 1
order by 1;
```

- On average, most customer makes claims every ~360 days (almost every year then).

### Most Common Second Product for Multi-Order Customers

```sql
 -- For customers who have more than 1 order, which product is most often bought as the second product?

with cte as 
(select cl.customer_id,
  cl.product_name,
  cl.claim_date,
  row_number() over(partition by cl.customer_id order by cl.claim_date)
from rowhealth.claims as cl
left join rowhealth.customers as cu
  on cl.customer_id = cu.customer_id
qualify row_number() over(partition by cl.customer_id order by cl.claim_date) = 2
order by 1)

select
  cte.product_name,
  count(2) as product_count
from cte
group by 1
order by 2 desc;
```

- Vitamin B+ Advanced Complex is the second most bought product (3822 purchases) with Hair Growth Supplements as the third most purchased (1946 purchases)


# Tableau Insights

![Dashboard 2](https://github.com/user-attachments/assets/9bc8dd05-8852-4ad0-ada5-e234150b5e6f)

# Recommendations
