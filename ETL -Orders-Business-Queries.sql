

-- Basic Analysis
-- How many total orders have been placed?

SELECT COUNT(Order_Id) AS TOTAL_ORDERS 
FROM [msdb].[dbo].[df_orders]

-- What is the total sales revenue generated?

SELECT SUM(sale_price) AS TOTAL_SALES_REVENU  
FROM [msdb].[dbo].[df_orders]

-- List all unique ship modes used in the orders.

SELECT 
    DISTINCT(ship_mode) AS Unique_Ship_Modes  
FROM [msdb].[dbo].[df_orders]

-- Date & Time Analysis
-- Find the total number of orders placed each month.

SELECT 
    DATENAME(MONTH, order_date) AS "MONTH", 
    COUNT(order_id) AS TOTAL_ORDERS  
FROM [msdb].[dbo].[df_orders]
GROUP BY DATENAME(MONTH, order_date) 

-- Identify the month with the highest sales revenue.

SELECT 
    Month as Month_with_Highest_Revenu FROM (
        SELECT 
            TOP 1 DATENAME(MONTH, order_date) as Month , 
            SUM(sale_price) revenue   
        FROM [msdb].[dbo].[df_orders]
        GROUP BY DATENAME(MONTH, order_date)
        order by revenue desc ) ab
    

-- Calculate the average order value (total sales per order) for each year.

SELECT  
    YEAR(order_date) AS YEAR,
    ROUND(SUM(sale_price)/COUNT(order_id),2) AS AVERAGE_ORDER_VALUE
FROM [msdb].[dbo].[df_orders]
GROUP BY YEAR(order_date)



-- Customer & Region Analysis
-- Which city has the highest number of orders?

SELECT 
    TOP 1 CITY,
    COUNT(ORDER_ID) AS TOTAL_ORDERS 
FROM [msdb].[dbo].[df_orders] 
GROUP BY CITY 
ORDER BY TOTAL_ORDERS DESC

-- Find the top 5 states with the highest total sales.

SELECT 
    TOP 5 state, 
    ROUND(SUM(sale_price),2) AS TOTAL_SALES 
FROM [msdb].[dbo].[df_orders] 
GROUP BY state 
ORDER BY TOTAL_SALES DESC

-- Count the number of orders placed in each region.

SELECT 
    region, 
    count(order_id) AS Orders_Placed 
FROM [msdb].[dbo].[df_orders] 
GROUP BY region 
ORDER BY Orders_Placed DESC

-- Product & Category Analysis
-- What are the top 10 best-selling sub-categories by total sales?

SELECT TOP 10 
    sub_category, 
    ROUND(sum(sale_price),2) as Total_Revenue 
FROM  [msdb].[dbo].[df_orders]
group by sub_category
order by Total_Revenue DESC

-- Identify products that were sold at a discount of 3% or more.

SELECT * FROM (SELECT 
    product_id, 
    discount, 
    sale_PRICE, 
    CASE 
        WHEN sale_PRICE != 0 
        THEN round((CAST(discount AS DECIMAL(10, 2)) / CAST(sale_PRICE AS DECIMAL(10, 2))),2) * 100
        ELSE 0
    END AS discount_percentage  
FROM [msdb].[dbo].[df_orders]  )AB
WHERE discount_percentage  >3


-- Find the most profitable product category overall.

SELECT 
    TOP 1 category, 
    SUM(profit) AS "Profit"
FROM  [msdb].[dbo].[df_orders]
GROUP BY category
ORDER BY SUM(profit) DESC

-- Which product had the highest total discount applied across all orders?
SELECT 
    DISTINCT PRODUCT_ID 
FROM [msdb].[dbo].[df_orders]
WHERE discount = (SELECT MAX(discount) FROM [msdb].[dbo].[df_orders])

-- Profit & Revenue Analysis

-- Find the top 5 most profitable states based on total profit.
SELECT TOP 5  
        STATE, 
        SUM(profit) AS TOTAL_PROFIT
FROM  [msdb].[dbo].[df_orders]
GROUP BY STATE 
ORDER BY SUM(profit) DESC

-- Identify orders where the profit was negative (i.e., a loss was made).
       
SELECT ORDER_ID,
        profit  
FROM  [msdb].[dbo].[df_orders]
WHERE PROFIT < 0
ORDER BY PROFIT

-- Find the total discount given in each region.

SELECT 
    REGION,
    SUM(DISCOUNT) AS TOTAL_DISCOUNT
FROM [msdb].[dbo].[df_orders]
GROUP BY REGION 

-- Advanced Business Insights
-- Which segment (consumer, corporate, home office) contributes the most to revenue?
SELECT 
    segment,
    SUM(sale_price) AS REVENUE
FROM [msdb].[dbo].[df_orders]
GROUP BY segment
ORDER BY SUM(sale_price) DESC
-- Identify the average discount applied in each sub-category.

SELECT 
    sub_category, 
    AVG(discount) 
from [msdb].[dbo].[df_orders]
group by sub_category

-- Find the most frequently ordered product across all orders

SELECT 
    PRODUCT_ID,
    COUNT(Order_Id) AS Total_orders
FROM [msdb].[dbo].[df_orders]
GROUP BY PRODUCT_ID
ORDER BY Total_orders DESC
