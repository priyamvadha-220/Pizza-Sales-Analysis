create database pizza;
use pizza;

CREATE TABLE pizza_sales (
    pizza_id INT,
    order_id INT,
    pizza_name_id VARCHAR(50),
    quantity INT,
    order_date DATE,
    order_time TIME,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    pizza_size VARCHAR(1),
    pizza_category VARCHAR(50),
    pizza_ingredients TEXT,
    pizza_name VARCHAR(100)
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/Priyamvadha RK/Downloads/pizza_sales.csv'
INTO TABLE pizza_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'secure_file_priv'; -- 'secure_file_priv', 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\'

DROP TABLE IF EXISTS pizza_sales;

CREATE TABLE pizza_sales_raw (
    pizza_id TEXT,
    order_id TEXT,
    pizza_name_id TEXT,
    quantity TEXT,
    order_date TEXT,
    order_time TEXT,
    unit_price TEXT,
    total_price TEXT,
    pizza_size TEXT,
    pizza_category TEXT,
    pizza_ingredients TEXT,
    pizza_name TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pizza_sales.csv'
INTO TABLE pizza_sales_raw
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pizza_sales.txt'
INTO TABLE pizza_sales_raw
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE pizza_sales (
    pizza_id INT,
    order_id INT,
    pizza_name_id VARCHAR(50),
    quantity INT,
    order_date DATE,
    order_time TIME,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    pizza_size VARCHAR(10),
    pizza_category VARCHAR(50),
    pizza_ingredients TEXT,
    pizza_name VARCHAR(100)
);

INSERT INTO pizza_sales
SELECT
    CAST(pizza_id AS UNSIGNED),
    CAST(order_id AS UNSIGNED),
    pizza_name_id,
    CAST(quantity AS UNSIGNED),
    STR_TO_DATE(order_date, '%d-%m-%Y'),
    order_time,
    CAST(unit_price AS DECIMAL(10,2)),
    CAST(total_price AS DECIMAL(10,2)),
    pizza_size,
    pizza_category,
    pizza_ingredients,
    pizza_name
from pizza_sales_raw;

select count(*) from pizza_sales;

select * from pizza_sales;

-- 1. Total Revenue

select sum(unit_price* quantity) as Total_Revenue from pizza_sales;

-- 2. Average Order Value

select sum(total_price)/count(distinct(order_id)) as Average_Order_Value from pizza_sales;

-- 3. Total Pizzas Sold

select sum(quantity) as Total_Pizzas_Sold from pizza_sales;

-- 4. Total Orders

select count(distinct(order_id)) as Total_Orders from pizza_sales;

-- 5. Average Pizzas Per Order

select cast(cast(sum(quantity) as decimal(10,2)) / cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) 
as Average_Pizzas_per_order
from pizza_sales;

-- 6. Daily trend for total orders

select dayname(order_date) as Order_Day, count(distinct order_id) as Total_Orders from pizza_sales
group by Order_Day;

-- 7. Monthly trend for orders

select monthname(order_date) as Order_Month, count(distinct order_id) as Total_Orders from pizza_sales
group by Order_Month;

-- 8. % of sales by pizza category

select pizza_category, cast(sum(total_price) as decimal (10, 2)) as Total_Revenue, 
cast(sum(total_price) * 100/ (select sum(total_price) from pizza_sales) as decimal (10, 2)) as Percentage from pizza_sales
group by pizza_category;

-- 9. % of sales by pizza price

select pizza_size, cast(sum(total_price) as decimal(10,2)) as total_revenue,
cast(sum(total_price) * 100 / (select sum(total_price) from pizza_sales) as decimal(10,2)) as Percentage from pizza_sales
group by pizza_size
order by pizza_size;


-- 10. Total pizzas sold by pizza category

select pizza_category, sum(quantity) as Total_Quantity_Sold
from pizza_sales
group by pizza_category
order by Total_Quantity_Sold desc;

-- 11. Top 5 pizzas by revenue

select pizza_name, sum(total_price) as Total_Revenue
from pizza_sales
group by pizza_name
order by Total_Revenue desc
limit 5;

-- 12. Bottom 5 pizzas by revenue

select pizza_name, sum(total_price) as Total_Revenue
from pizza_sales
group by pizza_name
order by Total_Revenue asc
limit 5;

-- 13. Top 5 pizzas by quantity

select pizza_name, sum(quantity) as Total_Quantity
from pizza_sales
group by pizza_name
order by Total_Quantity desc
limit 5;

-- 14. Bottom 5 pizzas by quantity

select pizza_name, sum(quantity) as Total_Quantity
from pizza_sales
group by pizza_name
order by Total_Quantity
limit 5;

-- 15. Top 5 pizzas from total orders

select pizza_name, count(distinct(order_id)) as Total_Orders
from pizza_sales
group by pizza_name
order by Total_Orders desc
limit 5;

-- 16. Bottom 5 pizzas from total orders

select pizza_name, count(distinct(order_id)) as Total_Orders
from pizza_sales
group by pizza_name
order by Total_Orders
limit 5;

-- 17. Categorial wise orders

select pizza_name, count(distinct(order_id)) as Total_Orders
from pizza_sales
where pizza_category = 'Veggie'
group by pizza_name
order by Total_Orders desc
limit 5;






