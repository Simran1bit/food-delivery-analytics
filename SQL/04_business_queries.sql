
------------------------------------------
-- 1. Executive Summary
------------------------------------------

-- 1.1 Total Orders
select count(*) as Total_orders
from clean_orders;

-- 1.2 Total Revenue
select 
	round(sum(cast(Price as real) * cast(Quantity as integer)),2)
	as Total_Revenue
from clean_orders;

-- 1.3 Avg Order value
with summary as (
	select
	sum(cast(price as real)* cast(Quantity as INTEGER)) as total_revenue,
	count(*) as total_orders
from clean_orders
)
select round((total_revenue/total_orders),2)
as Avg_order_value
from summary;

-- 1.4 Avg Rating
select 
	round(avg(cast(Customer_Rating as real)),2)
	as avg_rating
from clean_orders;

-- 1.5 Avg Delivery Time Minutes
select 
	round(avg(cast(Delivery_Time_Minutes as real)),2)
	as avg_delivery_time
from clean_orders;

------------------------------------------
-- 2. Sales Performance
------------------------------------------

-- 2.1 Revenue by Restaurant
select Restaurant,
	round(sum(cast(price as real) * (cast(Quantity as INTEGER))),2)
	as Revenue_by_Restaurant
from clean_orders
group by Restaurant;

-- 2.2 Revenue by City
select City,
	round(sum(cast(price as real) * cast(Quantity as INTEGER)),2)
	as Revenue_by_City
from clean_orders
group by City
order by Revenue_by_city desc;

-- 2.3 Revenue by Category
select Category,
	round(sum(cast(price as real) * cast(Quantity as INTEGER)),2)
	as Revenue_by_Category
from clean_orders
group by Category;


-- 2.4 Revenue by Food Item
select Food_Item,
	round(sum(cast(price as real) * cast(Quantity as INTEGER)),2)
	as Revenue_by_Food_Item
from clean_orders
group by Food_Item;

------------------------------------------
-- 3. Customer Insights
------------------------------------------

-- 3.1 Average Rating
-- Already calculated in Executive Summary (1.4)

-- 3.2 Rating by Restaurant
select Restaurant,
	round(avg(cast(Customer_Rating as real)),2)
	as Avg_Rating
from clean_orders
group by Restaurant
order by Avg_Rating desc;

-- 3.3 Rating by City
select City,
	round(avg(cast(Customer_Rating as real)),2)
	as Avg_Rating
from clean_orders
group by City
order by Avg_Rating desc;

-- 3.4 Highest Rated
with restaurant_rating as (
	select Restaurant,
		round(avg(cast(Customer_Rating as real)),2)
		as Avg_Rating
	from clean_orders
	group by Restaurant
)
select Restaurant,
	Avg_rating,
	rank() over(order by Avg_Rating desc) as Rating_rank
from restaurant_rating
order by Rating_rank;

-- 3.5 Lowest Rated
with restaurant_rating as (
	select Restaurant,
		round(avg(cast(Customer_Rating as real)),2) as Avg_rating
	from clean_orders
	group by Restaurant
)
select Restaurant,
	Avg_rating,
	rank() over(order by Avg_rating) as Rating_rank
from restaurant_rating
order by Rating_rank;

------------------------------------------
-- 4. Delivery Performance
------------------------------------------

-- 4.1 Average Delivery Time
-- Already calculated in Executive Summary (1.5)

-- 4.2 Fastest Restaurants
with restaurant_delivery as (
	select Restaurant,
		round(avg(cast(Delivery_Time_Minutes as real)),2)
		as Avg_delivery_time
	from clean_orders
	group by Restaurant
)
select Restaurant,
	Avg_delivery_time,
	rank() over(order by Avg_delivery_time) as Delivery_rank
from restaurant_delivery
order by Delivery_rank;

-- 4.3 Slowest Restaurants
with restaurant_delivery as (
	select Restaurant,
		round(avg(cast(Delivery_Time_Minutes as real)),2)
		as Avg_delivery_time
	from clean_orders
	group by Restaurant
)
select Restaurant,
	Avg_delivery_time,
	rank() over(order by Avg_delivery_time DESC) as Delivery_rank
from restaurant_delivery
order by Delivery_rank;

-- 4.4 Fastest Cities
with city_delivery as (
	select City,
		round(avg(cast(Delivery_Time_Minutes as real)),2)
		as Avg_delivery_time
	from clean_orders
	group by City
)
select City,
	Avg_delivery_time,
	rank() over(order by Avg_delivery_time) as Delivery_rank
from city_delivery
order by Delivery_rank;

-- 4.5 Slowest Cities
with city_delivery as (
	select City,
		round(avg(cast(Delivery_Time_Minutes as real)),2)
		as Avg_delivery_time
	from clean_orders
	group by City
)
select City,
	Avg_delivery_time,
	rank() over(order by Avg_delivery_time DESC)
	as Delivery_rank
from city_delivery
order by Delivery_rank;

-- 4.6 Delivery Time Distribution
select 
	case 
		when cast(Delivery_Time_Minutes as real) <=30 then 'Fast'
		when cast(Delivery_Time_Minutes as real) <=60 then 'Moderate'
		else 'Slow'
	end as Delivery_category,
	count(*) as Total_orders
from clean_orders
group by Delivery_category;

------------------------------------------
-- 5. Geographic Analysis
------------------------------------------

-- 5.1 Orders by City
select City, 
	count(*) as total_orders
from clean_orders
group by City
order by total_orders DESC;

-- 5.2 Revenue by City
select City,
	round(sum(cast(price as real) * cast(Quantity as integer)),2)
	as total_revenue
from clean_orders
group by City
order by total_revenue desc;

-- 5.3 Ratings by City
select City,
	round(avg(cast(Customer_Rating as real)),1)
	as Avg_rating
from clean_orders
group by City
order by Avg_rating desc;

-- 5.4 Delivery by City
select City,
	round(avg(cast(Delivery_Time_Minutes as real)),2)
	as Avg_delivery_time
from clean_orders
group by City
order by Avg_delivery_time;

-- 5.5 City Performance
select City,
	count(*) as Total_orders,
	round(sum(cast(price as real)*cast(Quantity as integer)),2) as Total_revenue,
	round(avg(cast(Customer_Rating as real)),1) as Avg_rating,
	round(avg(cast(Delivery_Time_Minutes as real)),2) as Avg_delivery_time
from clean_orders
group by City
order by Total_revenue;


------------------------------------------
-- 6. Restaurant Performance
------------------------------------------

-- 6.1 Restaurant KPIs
select Restaurant,
	count(*) as Total_orders,
	round(sum(cast(price as real) * cast(Quantity as integer)),2) as Total_revenue,
	round(avg(cast(Customer_Rating as real)),1) as Avg_rating,
	round(avg(cast(Delivery_Time_Minutes as real)),2) as Avg_delivery_time
from clean_orders
group by Restaurant
order by Total_revenue desc;

-- 6.2 Top Restaurants
with Restaurant_sales as (
	select Restaurant,
		round(sum(cast(price as real)*cast(Quantity as integer)),2)
		as Total_revenue
	from clean_orders
	group by Restaurant
)
select Restaurant,
	Total_revenue,
	dense_rank() over(order by Total_revenue desc)
	as Restaurant_rank
from Restaurant_sales
order by Restaurant_rank;

-- 6.3 Bottom Restaurants
with Restaurant_sales as (
	select Restaurant,
		round(sum(cast(price as real)*cast(Quantity as integer)),2)
		as Total_revenue
	from clean_orders
	group by Restaurant
)
select Restaurant, Total_revenue,
	dense_rank() over(order by Total_revenue)
	as Restaurant_rank
from Restaurant_sales
order by Restaurant_rank;


------------------------------------------
-- 7. Product Performance
------------------------------------------

-- 7.1 Top Food Items
with Food_sales as (
	select Food_Item,
		round(sum(cast(price as real)* cast(Quantity as integer)),2)
		as Total_revenue
	from clean_orders
	group by Food_Item
)
select Food_Item,
	Total_revenue,
	row_number() over(order by Total_revenue desc)
	as Food_rank
from Food_sales;

-- 7.2 Bottom Food Items
with Food_sales as (
	select Food_Item,
		round(sum(cast(price as real)*cast(Quantity as integer)),2)
		as Total_revenue
	from clean_orders
	group by Food_Item
)
select Food_Item,
	Total_revenue,
	row_number() over(order by Total_revenue)
	as Food_rank
from Food_sales;

-- 7.3 Category Analysis
select Category,
	count(*) as Total_orders,
	round(sum(cast(price as real) * cast(Quantity as integer)),2) as total_revenue,
	round(avg(cast(Customer_Rating as real)),2) as Avg_rating,
	round(avg(cast(Delivery_Time_Minutes as real)),2) as Avg_delivery_time
from clean_orders
group by Category
order by Total_revenue desc;

------------------------------------------
-- 8. Date Analysis
------------------------------------------

-- 8.1 Month to Month Revenue trend
with monthly_revenue as (
	select substr(Date,4,2) as Month_no,
		CASE substr(Date,4,2)
			WHEN '01' THEN 'January'
			WHEN '02' THEN 'February'
			WHEN '03' THEN 'March'
			WHEN '04' THEN 'April'
			WHEN '05' THEN 'May'
			WHEN '06' THEN 'June'
		END AS Month,
		round(sum(cast(price as real)*cast(Quantity as integer)),2) as Total_revenue
	from clean_orders
	where `date` <> 'invalid_date'
	group by Month_no, Month
)
select Month_no, Month, Total_revenue,
	lag(Total_revenue) over(order by Month_no) 
	as Previous_month_revenue,
	round(Total_revenue - (lag(Total_revenue) over(order by Month_no)),2)
	as Revenue_change
from monthly_revenue;

-- 8.2 Monthly orders
with monthly_orders as (
	select substr(Date,4,2) as Month_no,
		CASE substr(Date,4,2)
			WHEN '01' THEN 'January'
			WHEN '02' THEN 'February'
			WHEN '03' THEN 'March'
			WHEN '04' THEN 'April'
			WHEN '05' THEN 'May'
			WHEN '06' THEN 'June'
		END AS Month,
		count(*) as Total_orders
	from clean_orders
	where `date` <> 'invalid_date'
	group by Month_no, Month
)
select Month_no, Month, Total_orders,
	lag(Total_orders) over(order by month_no)
	as previous_month_orders,
	Total_orders - (lag(Total_orders) over(order by month_no))
	as Order_change
from monthly_orders
order by Month_no;

-- 8.3 Monthly rating
-- May
with monthly_rating as (
	select substr(Date,4,2) as Month_no,
		CASE substr(Date,4,2)
			WHEN '01' THEN 'January'
			WHEN '02' THEN 'February'
			WHEN '03' THEN 'March'
			WHEN '04' THEN 'April'
			WHEN '05' THEN 'May'
			WHEN '06' THEN 'June'
		END AS Month,
		round(avg(cast(Customer_Rating as real)),2) as Avg_rating
	from clean_orders
	where `date` <> 'invalid_date'
	group by Month_no, Month
)
select Month_no, Month, Avg_rating,
	dense_rank() over(order by Avg_rating desc) as Month_rank
from monthly_rating
order by Month_no;

-- 8.4 Monthly Delivery Time
-- April
with monthly_delivery_time as (
	select substr(Date,4,2) as Month_no,
		CASE substr(Date,4,2)
			WHEN '01' THEN 'January'
			WHEN '02' THEN 'February'
			WHEN '03' THEN 'March'
			WHEN '04' THEN 'April'
			WHEN '05' THEN 'May'
			WHEN '06' THEN 'June'
		END AS Month,
		round(avg(cast(Delivery_Time_Minutes as real)),2) as Avg_delivery_time
	from clean_orders
	where `date` <> 'invalid_date'
	group by Month_no, Month
)
select Month_no, Month, Avg_delivery_time,
	dense_rank() over(order by Avg_delivery_time)
	as Month_rank
from monthly_delivery_time
order by Month_no;

------------------------------------------
-- 9. Miscellaneous Analysis
------------------------------------------

-- 9.1 Highest Revenue Food_Item in each Category
with food_sales as(
	select 
		Category,
		Food_Item,
		round(sum(cast(price as real)*cast(Quantity as integer)),2) as Revenue
	from clean_orders
	group by Category, Food_Item
)
select *
	from(select *,
			row_number() over(
				PARTITION by Category
				order by Revenue desc
			) as rn
		from food_sales
	)
where rn = 1
order by Revenue desc;

-- 9.2 Revenue Contribution (%)
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
from Restaurant_sales
order by Contribution desc;

-- 9.3 Restaurant performance classification
with Restaurant_rating as (
	select Restaurant,
		round(avg(cast(Customer_Rating as real)),2) as Avg_rating
	from clean_orders
	group by Restaurant
)
select Restaurant,
	Avg_rating,
	case
		when Avg_rating >= 4.0 then 'Excellent'
		when Avg_rating >= 3.5 then 'Good'
		when Avg_rating >= 3.0 then 'Average'
		else 'Needs Improvement'
	end as Performance
from Restaurant_rating
order by Avg_rating desc;


/*
------------------------------------------
-- 10. Executive Business Insights
------------------------------------------
-	Revenue increased by ₹4,43,415.99 from April to May.
	Revenue declined by ₹1,66,270.58 in June compared to May. (8.1)

-	Total number of orders increased by 106 from April to May
	but declined by 96 in June in comparison to May (8.2)
	
-	Restaurant Healthy Bites contributes 11.09% of revenue 
	whereas Restaurant Biryani House is in a close competition contributing 11.03%. (9.2)
	
-	Delhi contributes the largest share of revenue (4.4)
	Delivery logistics should be reviewed for City Hyderabad (4.5)
	June became the fastest Delivery month (8.4)
	
-	Most orders are delivered within 30–60 minutes, indicating this is the standard delivery window.
	Only 1,265 orders are completed within 30 minutes, while 1,745 orders take more than 60 minutes.
	Reducing the number of slow deliveries could improve customer satisfaction and operational efficiency. (4.6)

-	Customers consistently rate Restaurant Cafe Aroma highest 
	but Restaurant Burger Hub is also not far in the line (3.4)
	Restaurant Biryani House, Healthy Bites, Pasta Point may require 
	improvements in food quality or customer service (3.5)
	Average rating is highest in May (8.3)

-	Restaurant Spice Villa maintains quickest average delivery time (4.2)
	Restaurant Sushi World experiences the longest delivery times (4.3)

-	Food Item Sushi is the top revenue-generating product (7.1)

-	Fast Food and Indian cuisines are the strongest revenue-generating categories, 
	significantly outperforming the remaining categories. 
	This suggests these cuisines should receive continued investment in promotions 
	and menu expansion. (7.3)

-	Customers spend approximately 3618.4 per order on average (1.3)

-	Each food category has a clear top-performing item. 
	Sushi leads the Japanese category, for Healthier options Salad is the top priority,
	Paneer Tikka dominates Indian cuisine, Pasta outperforms in Italian category
	and Coffee generates the highest revenue in Beverages. 
	These signature items should be prioritized in 
	marketing campaigns, inventory planning, and promotional offers. (9.1)
	
-	Restaurant performance classification shows that only four restaurants fall into the 'Average' category, 
	while six restaurants require improvement based on customer ratings. 
	This indicates an opportunity to improve customer satisfaction 
	through better food quality and service across most restaurant partners. (9.3)
	
*/