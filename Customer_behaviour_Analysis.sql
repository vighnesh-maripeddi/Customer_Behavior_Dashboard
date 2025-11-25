select * from customer limit 20
--Q1--

select gender, SUM(purchse_amount) as revenue
from customer
group by gender


--Q2--

select customer_id,purchse_amount
from customer
where discount_applied = 'Yes' and purchse_amount >= (select AVG(purchse_amount) from customer)


--Q3--

select item_purchased,ROUND(AVG(review_rating::numeric),2) as " Average Product Rating"
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

--Q4--
select shipping_type,
ROUND(AVG(purchse_amount),2)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type

--Q5--

select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchse_amount),2) as avg_spend,
ROUND(SUM(purchse_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc;

select * from customer


--Q6--

select item_purchased,
ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;


--Q7 Segment Customers used ct query--

with customer_type as(
select customer_id, previous_purchases,
CASE 
    WHEN previous_purchases = 1 THEN 'New'
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END AS customer_segment
from customer
)

select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment


--Q8--

with item_counts as(
select category, 
item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id)DESC) as item_rank
from customer
group by category, item_purchased
)
select item_rank,category,item_purchased, total_orders
from item_counts
where item_rank<=3;

--Q9--

select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status


--Q10--
select age_group,
Sum(purchse_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;