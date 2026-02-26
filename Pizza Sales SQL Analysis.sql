create database pizza_sales;
use pizza_sales;

DESCRIBE pizza_sale;
-- change date datatype (text to date ) datatype

alter table pizza_sale
add column order_date_clean date;
SET SQL_SAFE_UPDATES = 0;
update  pizza_sale
set order_date_clean =
    CASE
        WHEN order_date LIKE '%/%' THEN STR_TO_DATE(order_date, '%m/%d/%Y')
        WHEN order_date LIKE '%-%' THEN STR_TO_DATE(order_date, '%d-%m-%Y')
        ELSE NULL
    END;

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE pizza_sale
DROP COLUMN order_date;

ALTER TABLE pizza_sale
CHANGE order_date_clean order_date DATE;

select * from pizza_sale;


-- Total Sales
SELECT 
    ROUND(SUM(total_price), 2) AS total_revenue
FROM
    pizza_sale;

-- Average order value
SELECT 
    round(sum(total_price) / COUNT(DISTINCT order_id),2) AS avg_order_value
FROM pizza_sale;

-- Total pizza sold
SELECT SUM(quantity) AS total_pizza_sold FROM pizza_sale;

-- Total order
select count(distinct order_id) as total_orders from pizza_sale;

-- Average pizza per order
select round(sum(quantity)/ count(distinct order_id),2) as avg_pizza_per_order from pizza_sale;

-- Hourly Trend for Total Pizzas Sold
select hour(order_time) as order_hours , sum(quantity) as total_pizza_sold from pizza_sale
group by hour(order_time)
order by sum(quantity) desc;

-- Weekly Trend for Orders

select week(order_date,3) as weeknumber, year(order_date) as year, count(distinct order_id) as total_orders from pizza_sale
group by week(order_date,3), year(order_date)
order by year, weeknumber;

-- % of Sales by Pizza Category
SELECT pizza_category,
    ROUND(SUM(total_price), 2) AS total_revenue,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sale), 2) AS PCT
FROM pizza_sale 
GROUP BY pizza_category;

-- % of Sales by Pizza Size
SELECT pizza_size,
    ROUND(SUM(total_price), 2) AS total_revenue,
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sale), 2) AS PCT
FROM pizza_sale
GROUP BY pizza_size
ORDER BY pizza_size;

-- Total Pizzas Sold by Pizza Category
SELECT pizza_category, SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sale
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;

-- Top 5 Pizzas by Revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM  pizza_sale
GROUP BY pizza_name
ORDER BY Total_Revenue DESC LIMIT 5;

-- Bottom 5 Pizzas by Revenue
SELECT pizza_name, round(SUM(total_price),2) AS Total_Revenue
FROM pizza_sale
GROUP BY pizza_name
ORDER BY Total_Revenue ASC LIMIT 5;

-- Top 5 Pizzas by Quantity
SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sale
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC
 LIMIT 5;
 
 -- Top 5 Pizzas by Total Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sale
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5;

-- Borrom 5 Pizzas by Total Orders
SELECT 
    pizza_name, 
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sale
GROUP BY pizza_name
ORDER BY Total_Orders ASC
LIMIT 5;







