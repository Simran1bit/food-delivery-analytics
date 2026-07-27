-- Audit

--duplicate order ids
--output: 150 rows
select Order_ID,
count(*) as duplicate_count
from orders_raw
group by Order_ID
having count(*) >1;

--total duplicate
select sum((duplicate_count)-1) as total_duplicate
from(
	select Order_ID,
	count(*) as duplicate_count
	from orders_raw
	group by Order_ID
	having count(*) > 1
	) as duplicate_summary;

--missing values

/* We can use this for individual result
or case then
-- City
-- 409 rows
select count(*) as missing_city
from orders_raw
where City IS NULL
or trim(city)='';

-- Price
-- 104
select count(*) as missing_price
from orders_raw
where Price IS NULL
or trim(price)='';
*/

--Missing Values
SELECT
	--Missing City: 409
	count(case when City is null or trim(City) = '' then 1 end) as Missing_City,
	--Missing Price 104
	count(case when Price is null or trim(Price) = '' then 1 end) as Missing_Price,
	--Missing Quantity 75
	count(case when Quantity is null or trim(Quantity) = '' then 1 end) as Missing_Quantity,
	--Missing Customer_Rating 67
	count(case when Customer_Rating is null then 1 end) as Missing_Customer_rating,
	--Missing Delivery_Time_Minutes 86
	count(case when Delivery_Time_Minutes is null or trim(Delivery_Time_Minutes) = '' then 1 end) as Missing_Delivery_time,
	--Missing Restaurant 0
	count(case when Restaurant is null or trim(Restaurant) = '' then 1 end) as Missing_Restaurant,
	--Missing Payment_Method 0
	count(case when Payment_Method is null or trim(Payment_Method) = '' then 1 end) as Missing_Payment_method,
	--Missing Food_Item 0
	count(case when Food_Item is null or trim(Food_Item) = '' then 1 end) as Missing_Food_Item,
	--Missing Category 0
	count(case when Category is null or trim(Category) = '' then 1 end) as Missing_Category
from orders_raw;

-- Business Rule:
-- Customer ratings must be between 0 and 5.
-- Audit Result: 142 invalid ratings found.
select count(*) as invalid_rating
from orders_raw
where Customer_Rating<0 or Customer_Rating>5;

-- Business Rule:
-- Delivery_Time_Minutes can not be <= 0.
-- Audit Result: 93 invalid results found.
select count(*) as invalid_delivery_time
from orders_raw
where Delivery_Time_Minutes <=0;

-- Unique values in Quantity
select Quantity,
count(*) as frequency
from orders_raw
GROUP by Quantity
ORDER by frequency DESC;

-- Unique Payment_Method
select Payment_Method,
count(*) as frequency
from orders_raw
group by Payment_Method
order by frequency desc;

-- Unique Category
select Category,
count(*) as frequency
from orders_raw
group by Category
order by frequency desc;

--Sample visit of date
--for this query we saw that all 20 records had dd-mm-yyyy format
select "Date"
from orders_raw
where "date" is not null
limit 20;

-- 181 + invalid_date
select distinct `date`
from clean_orders
order by `date`;

-- Data Summary
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Order_ID) AS Unique_Orders,
    COUNT(DISTINCT Restaurant) AS Restaurants,
    COUNT(DISTINCT City) AS Cities,
    COUNT(DISTINCT Category) AS Categories
FROM orders_raw;
