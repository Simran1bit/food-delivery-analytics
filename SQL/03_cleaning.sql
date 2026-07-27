-- creating new TABLE
create table 
if not EXISTS
clean_orders as
select * from orders_raw;

---------------------------------------------------
-- STEP 1 : Remove duplicate Order IDs
---------------------------------------------------

--150 duplicates
select Order_ID,
count(*) as duplicate_count
from clean_orders
group by Order_ID
having count(*) > 1;

/*sql keeps row id for each record we want to keep lower row id*/
delete from clean_orders
where rowid not in (
SELECT MIN(rowid)
FROM clean_orders
GROUP BY Order_ID
);

SELECT
    Order_ID,
    COUNT(*) AS duplicate_count
FROM clean_orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

---------------------------------------------------
-- STEP 2 : Standardize text Columns
---------------------------------------------------

-- [A] Quantity
select DISTINCT Quantity
from clean_orders;

UPDATE clean_orders
set Quantity = 
case 
when Quantity = 'two' then '2'
when Quantity = 'three' then '3'
when cast(Quantity as INTEGER) <1 then NULL
else Quantity
end;

select DISTINCT Quantity
from clean_orders;

--[B] Price
select DISTINCT Price
from clean_orders
order by Price;

--100
select count(*) as placeholder
from clean_orders
where price = "not_available";

update clean_orders
set price = NULL
where price = 'not_available';

--201
select count(*) as null_price
from clean_orders
where price is null;

--87
select count(*) as invalid_price
from clean_orders
where price is not NULL
and cast(price as real)<=0;

update clean_orders
set price = NULL
where price is not null
and cast(price as real)<=0;

--288
select count(*) as null_price
from clean_orders
where price is null;

-- [C] Customer_Rating
--140 invalid
select count(*) as invalid_rating
from clean_orders
where cast(Customer_Rating as real)<0 
or cast(Customer_Rating as real)>5;

update clean_orders
set Customer_Rating = NULL
where Customer_Rating is not NULL
AND (
cast(Customer_Rating as real) <0
or cast(Customer_Rating as real) >5
);

select count(*) as invalid_rating
from clean_orders
where cast(Customer_Rating as real)<0 
or cast(Customer_Rating as real)>5;

--204
select count(*) as null_rating
from clean_orders
where Customer_Rating is null;

-- [D] Delivery_Time_Minutes
--89 invalid
select count(*) as invalid_delivery_time
from clean_orders
where cast(Delivery_Time_Minutes as INTEGER)<=0;

update clean_orders
set Delivery_Time_Minutes = NULL
where Delivery_Time_Minutes is not NULL
and CAST(Delivery_Time_Minutes as INTEGER) <=0;

SELECT COUNT(*) AS invalid_delivery_time
FROM clean_orders
WHERE CAST(Delivery_Time_Minutes AS INTEGER) <= 0;

--258
SELECT COUNT(*) AS null_delivery_time
FROM clean_orders
WHERE Delivery_Time_Minutes IS NULL;

-- [E] City
select DISTINCT City
from clean_orders
order by city;

update clean_orders
set city = lower(trim(city));

select DISTINCT City
from clean_orders
order by city;

/* Checking for Leading or trailing space
SELECT COUNT(*)
FROM clean_orders
WHERE City != TRIM(City);*/

-- [F] Restaurant
select distinct Restaurant
from clean_orders;

-- [G] Category
select DISTINCT Category
from clean_orders;

-- [H] Payment_Method
select DISTINCT Payment_Method
from clean_orders;

--[I] Food_Item
SELECT DISTINCT Food_Item
FROM clean_orders;
/*From F to I all data is distinct that's why no need to standardize them*/

---------------------------------------------------
-- STEP 3 : Hierarchical Imputation
---------------------------------------------------
-- [A] City

-- Inspect: 398 NULL
select count(*) as null_cities
from clean_orders
where city is null;

-- Check hierarchy
-- Every restaurant appears in all seven cities.
select Restaurant,
count(DISTINCT city) as non_null_cities
from clean_orders
where city is not null
group by Restaurant
having count(DISTINCT City)>1;

--returns 7 distinct cities + 1 NULL
select DISTINCT city from clean_orders; 

-- Every restaurant appears in multiple cities (7 distinct cities),
-- so Restaurant cannot uniquely determine City.
SELECT restaurant,
group_concat(DISTINCT city) as cities
from clean_orders
where city is not NULL
group by Restaurant;

/*
===== Business Rule: =====
- Every restaurant operates in all seven cities in the dataset.
- Therefore, Restaurant cannot uniquely determine City.
- Missing City values cannot be inferred reliably.
- Replace NULL with 'unknown' to explicitly indicate missing information
  while preserving the record for analysis.
*/
--Impute
update clean_orders
set City = 'unknown'
where city is null;

-- Verify
select count(*) as null_cities
from clean_orders
where city is null;

select count(*) as unknown_cities
from clean_orders
where city = 'unknown';

-- [B] Price

-- Inspect: 288 null prices
select count(*) as null_price
from clean_orders
where price is null;

-- Check Hierarchy: 
-- Level 1: 2 records returned
select Restaurant, Food_Item, City,
count(Price) as non_null_price
from clean_orders
group by Restaurant, Food_Item, City
having count(price) = 0;

--Impute
update clean_orders
set Price = (
	select avg(cast(c2.price as real))
	from clean_orders c2
	where c2.Restaurant = clean_orders.Restaurant
	and c2.Food_Item = clean_orders.Food_Item
	and c2.City = clean_orders.City
	and c2.price is not null
)where price is null;

--Verify
SELECT COUNT(*) AS remaining_null_price
FROM clean_orders
WHERE Price IS NULL;

-- Check Hierarchy 
-- Level 2: 0 records returned
select Restaurant, Food_Item,
count(Price) as non_null_price
from clean_orders
group by Restaurant, Food_Item
having count(Price) = 0;

-- Impute
update clean_orders
set Price = (
	select avg(cast(rf.price as real))
	from clean_orders rf
	where rf.Restaurant = clean_orders.Restaurant
	and rf.Food_Item = clean_orders.Food_Item
	and rf.Price is not null
)
where Price is null;

-- Verify
select count(*) as remaining_null_prices
from clean_orders
where price is null;

/*
===== Business Rule: =====
- Product prices may vary across restaurants and cities.
- Use the most specific hierarchy available:
    Level 1: Restaurant + Food_Item + City
    Level 2: Restaurant + Food_Item
- This preserves local pricing while ensuring missing values are
  imputed using the closest available business context.
*/

-- [C] Quantity

-- Inspect : 208
SELECT COUNT(*) AS null_quantity
FROM clean_orders
WHERE Quantity IS NULL;

-- Check Hierarchy
select Food_Item, Category, 
count(*) as non_null_quantity
from clean_orders
group by Food_Item, Category
having count(*) = 0;

--Impute
update clean_orders
set Quantity = (
	select avg(cast(q.Quantity as INTEGER))
	from clean_orders q
	where q.Food_Item = clean_orders.Food_Item
	and q.Category = clean_orders.Category
	and q.Quantity is not null
)
where Quantity is null;

-- Verify
SELECT COUNT(*) AS null_quantity
FROM clean_orders
WHERE Quantity IS NULL;

-- [C] Customer_Rating

-- Inspect: 204
select count(*) as null_rating
from clean_orders
where Customer_Rating is null;

-- Check Hierarchy: 0 records returned
select Restaurant, City,
count(Customer_Rating) as non_null_rating
from clean_orders
group by Restaurant, City
having count(customer_rating) = 0;

--Impute
update clean_orders
set Customer_Rating = (
	select avg(cast(cr.Customer_Rating as real))
	from clean_orders cr
	where cr.Restaurant = clean_orders.Restaurant
	and cr.City = clean_orders.City
	and cr.Customer_Rating is not null
)where Customer_Rating is null;

--Verify
select count(*) as null_rating
from clean_orders
where Customer_Rating is null;


-- [D] Delivery_Time_Minutes

--Inspect: 258 records
select count(*) as null_delivery_time
from clean_orders
where Delivery_Time_Minutes is null;

-- Check Hierarchy: 
select Restaurant, City,
count(Delivery_time_minutes) as non_null_delivery_time
from clean_orders
group by Restaurant, City
having count(delivery_time_minutes) = 0;

/*
===== Business Rule: =====
- Delivery time depends on both the restaurant branch and the city.
- Validation confirmed every Restaurant + City combination has
  at least one non-null delivery time.
- Therefore, missing values can be reliably imputed using the
  average delivery time of the same Restaurant and City.
*/

-- Impute
update clean_orders
set Delivery_Time_Minutes = (
	select avg(cast(rcd.Delivery_Time_Minutes as real)) 
	from clean_orders rcd
	where rcd.Restaurant = clean_orders.Restaurant
	and rcd.city = clean_orders.City
	and rcd.Delivery_Time_Minutes is not null
) where Delivery_Time_Minutes is null;

--Verify
select count(*) as null_delivery_time
from clean_orders
where Delivery_Time_Minutes is null;

-- [E] Date
-- Inspect
select DISTINCT `Date`
from clean_orders
order by `Date`;

-- 149 invalid_date
select count(*) as invalid_date
from clean_orders
where `Date` = 'invalid_date';
/*
Business Rule:
- 149 records contain the placeholder value 'invalid_date'.
- The correct dates cannot be inferred from the available data.
- No imputation is performed.
- These values will be handled during date conversion
  in the analysis stage.
*/


---------------------------------------------------
-- FINAL DATA QUALITY CHECK
---------------------------------------------------

-- Duplicate Orders
SELECT COUNT(*) - COUNT(DISTINCT Order_ID) AS duplicate_orders
FROM clean_orders;

-- Missing Values
SELECT
SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS missing_city,
SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS missing_price,
SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS missing_quantity,
SUM(CASE WHEN Customer_Rating IS NULL THEN 1 ELSE 0 END) AS missing_rating,
SUM(CASE WHEN Delivery_Time_Minutes IS NULL THEN 1 ELSE 0 END) AS missing_delivery_time

FROM clean_orders;

-- Invalid Quantity
SELECT COUNT(*) as invalid_quantity
FROM clean_orders
WHERE CAST(Quantity AS INTEGER) < 1;

-- Invalid Rating
SELECT COUNT(*) as invalid_rating
FROM clean_orders
WHERE CAST(Customer_Rating AS REAL) < 0
OR CAST(Customer_Rating AS REAL) > 5;

/*
==========================================================
Cleaning Summary

✔ Removed duplicate records
✔ Standardized categorical values
✔ Converted invalid values to NULL
✔ Hierarchically imputed missing values
✔ Preserved records with non-imputable dates
✔ Verified final data quality

Output:
clean_orders
==========================================================
*/
