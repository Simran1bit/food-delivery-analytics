--viewing table
select * from orders_raw;

--total rows
--5150
select count(order_id) as total_rows
from orders_raw;

-- total columns
-- 11
select * from orders_raw
limit 0;

PRAGMA table_info(orders_raw);