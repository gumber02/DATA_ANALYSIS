select * from df_orders

--find top 10 highest revenue generating products
select  top 10 product_id,sum(sale_price)as sales
from df_orders
group by product_id
order by sales DESC

--top 5 highest selling product in each region
with cte as(
select region, product_id, sum(sale_price) as sales
from df_orders
group by region, product_id)
select * from(
select *,
ROW_NUMBER() over(partition by region order by sales desc)as rn
from cte) a
where rn<=5

--find month over month growth comparison for 2022 and 2023 sales eg: jan2022 vs jan2023
with cte as(
select year (order_date) as order_year , month(order_date) as order_month, sum(sale_price) as sales
from df_orders
group by year(order_date), month(order_date))

select order_month, 
(case when order_year = 2022 then sales else 0 end) as sales_2022,
(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte
order by order_month
-- for each category which month has highest salary
with cte as(
select category , FORMAT(CAST(order_date), 'yyyyMM')  , sum(sale_price) as sales
from df_orders
group by category ,FORMAT(CAST(order_date), 'yyyyMM' )
order by category , FORMAT(CAST(order_date), 'yyyyMM' )
)
select * from (
select *,
row_number() over(partition by category order by sales desc) as rn from cte) a 
where rn = 1

--which  sub category has highest growth by profit in 2023 compare to 2022
