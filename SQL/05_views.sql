--------------------------------------------------
-- FOOD DELIVERY ANALYTICS
-- 05_views.sql
--------------------------------------------------

------------------------------------------
-- 1. vw_executive_summary
------------------------------------------
drop view if exists vw_executive_summary;
create view vw_executive_summary as
select
	count(*) as Total_orders,
	round(sum(cast(price as real)*cast(Quantity as integer)),2)
	as Total_revenue,
	round(sum(cast(price as real)*cast(Quantity as integer))
	/ count(*),2) as Avg_order_value,
	round(avg(cast(Customer_Rating as real)),2)
	as Avg_rating,
	round(avg(cast(Delivery_Time_Minutes as real)),2)
	as Avg_delivery_time
from clean_orders;

SELECT *
FROM vw_executive_summary;


------------------------------------------
-- 2. vw_city_performance
------------------------------------------
drop view if exists vw_city_performance;
create view vw_city_performance as
select City,
	count(*) as Total_orders,
	round(sum(cast(price as real)*cast(Quantity as integer)),2) as Total_revenue,
	round(avg(cast(Customer_Rating as real)),1) as Avg_rating,
	round(avg(cast(Delivery_Time_Minutes as real)),2) as Avg_delivery_time
from clean_orders
group by City;

select * from vw_city_performance
order by Total_revenue desc;


------------------------------------------
-- 3. vw_restaurant_performance
------------------------------------------
drop view if exists vw_restaurant_performance;
create view vw_restaurant_performance as
select Restaurant,
	count(*) as Total_orders,
	round(sum(cast(price as real) * cast(Quantity as integer)),2) as Total_revenue,
	round(avg(cast(Customer_Rating as real)),1) as Avg_rating,
	round(avg(cast(Delivery_Time_Minutes as real)),2) as Avg_delivery_time
from clean_orders
group by Restaurant;

select * from vw_restaurant_performance
order by Total_revenue desc;


------------------------------------------
-- 4. vw_product_performance
------------------------------------------
drop view if exists vw_product_performance;
create view vw_product_performance as
select
	Category,
	Food_Item,
	count(*) as Total_orders,
	round(sum(cast(price as real) * cast(Quantity as integer)),2) as Total_revenue,
	round(avg(cast(Customer_Rating as real)),1) as Avg_rating,
	round(avg(cast(Delivery_Time_Minutes as real)),2) as Avg_delivery_time
from clean_orders
group by Category, Food_Item;

select * from vw_product_performance
order by Total_revenue desc;

------------------------------------------
-- 5. vw_monthly_trends
------------------------------------------
drop view if exists vw_monthly_trends;
create view vw_monthly_trends as
select 
	substr(Date,4,2) as Month_no,
	CASE substr(Date,4,2)
		WHEN '01' THEN 'January'
		WHEN '02' THEN 'February'
		WHEN '03' THEN 'March'
		WHEN '04' THEN 'April'
		WHEN '05' THEN 'May'
		WHEN '06' THEN 'June'
	END AS Month,
	round(sum(cast(price as real)*cast(Quantity as integer)),2) as Total_revenue,
	count(*) as Total_orders,
	round(avg(cast(Customer_Rating as real)),2) as Avg_rating,
	round(avg(cast(Delivery_Time_Minutes as real)),2) as Avg_delivery_time
from clean_orders
where `date` <> 'invalid_date'
group by Month_no, Month;

select * from vw_monthly_trends;


------------------------------------------
-- 6. vw_delivery_distribution
------------------------------------------
drop view if exists vw_delivery_distribution;
create view vw_delivery_distribution as
select 
	case 
		when cast(Delivery_Time_Minutes as real) <=30 then 'Fast'
		when cast(Delivery_Time_Minutes as real) <=60 then 'Moderate'
		else 'Slow'
	end as Delivery_category,
	count(*) as Total_orders
from clean_orders
group by Delivery_category;

select * from vw_delivery_distribution;


------------------------------------------
-- 7. vw_revenue_contribution
------------------------------------------
drop view if exists vw_revenue_contribution;
create view vw_revenue_contribution as
with Restaurant_sales as (
	select Restaurant,
		round(sum(cast(price as real)*cast(Quantity as integer)),2)
		as Revenue
	from clean_orders
	group by Restaurant
)
select Restaurant, Revenue,
	round(Revenue*100/
	sum(Revenue) over(),2)
	as Contribution
from Restaurant_sales;

select * from vw_revenue_contribution
order by Revenue desc;


------------------------------------------
-- 8. vw_top_products
------------------------------------------
drop view if exists vw_top_products;
create view vw_top_products as
with food_sales as(
	select 
		Category,
		Food_Item,
		round(sum(cast(price as real)*cast(Quantity as integer)),2) as Revenue
	from clean_orders
	group by Category, Food_Item
)
select Category,
    Food_Item,
    Revenue
	from(select 
			Category,
			Food_Item,
			Revenue,
			row_number() over(
				PARTITION by Category
				order by Revenue desc
			) as rn
		from food_sales
	)
where rn = 1;

select * from vw_top_products;
