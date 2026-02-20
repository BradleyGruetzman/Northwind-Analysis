-- Step 1 - Calculate monthly revenue trends
-- This query calculates the total revenue for each month and year by joining the northwind_order_details and northwind_orders tables on the order_id. The results are grouped by month and year to identify trends in revenue over time.

SELECT
	MONTH(order_date) as order_month, 
    YEAR(order_date) as order_year, 
    SUM(northwind_order_details.revenue) as monthly_revenue
FROM northwind_order_details
LEFT JOIN northwind_orders
ON  northwind_order_details.order_id = northwind_orders.order_id
GROUP BY order_month, order_year;

-- Step 2 - Calculate yearly revenue totals
-- This query calculates the total revenue for each year by joining the northwind_order_details and northwind_orders tables on the order_id. The results are grouped by year to identify trends in revenue over time.

SELECT
    YEAR(order_date) as order_year, 
    SUM(northwind_order_details.revenue) as yearly_revenue
FROM northwind_order_details
LEFT JOIN northwind_orders
ON  northwind_order_details.order_id = northwind_orders.order_id
GROUP BY  order_year;

-- Step 3 - Calculate month over month revenue change
-- This query calculates the month-over-month revenue change by first calculating the monthly revenue for each month and year, and then using the LAG window function to compare the current month's revenue with the previous month's revenue. The results are ordered by year and month to identify trends in revenue over time.

WITH monthly_revenue AS (
    SELECT
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(od.revenue) AS monthly_revenue
    FROM northwind_orders AS o
    JOIN northwind_order_details AS od
        ON o.order_id = od.order_id
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
    order_year,
    order_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY order_year, order_month) AS previous_month_revenue,
    monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY order_year, order_month) AS revenue_change
FROM monthly_revenue
ORDER BY order_year, order_month;

-- Step 4 - Identify best and worst performing months
-- Best performing month

SELECT
    order_year,
    order_month,
    monthly_revenue
FROM (
    SELECT
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(od.revenue) AS monthly_revenue
    FROM northwind_orders AS o
    JOIN northwind_order_details AS od
        ON o.order_id = od.order_id
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
) AS monthly_revenue
ORDER BY monthly_revenue DESC
LIMIT 1;

-- Worst performing month

SELECT
    order_year,
    order_month,
    monthly_revenue
FROM (
    SELECT
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(od.revenue) AS monthly_revenue
    FROM northwind_orders AS o
    JOIN northwind_order_details AS od
        ON o.order_id = od.order_id
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
) AS monthly_revenue
ORDER BY monthly_revenue ASC
LIMIT 1;

-- Step 5 - Calculate average order value over time
-- This query calculates the average order value for each month and year by first calculating the total revenue and total number of orders for each month and year, and then dividing the total revenue by the total number of orders. The results are ordered by year and month to identify trends in average order value over time.

WITH order_monthly_revenue AS (
    SELECT 
        o.order_id,  -- fully qualified
        YEAR(o.order_date) AS order_year,
        MONTH(o.order_date) AS order_month,
        SUM(od.revenue) AS order_revenue
    FROM northwind_orders o
    JOIN northwind_order_details od
        ON o.order_id = od.order_id
    GROUP BY o.order_id, YEAR(o.order_date), MONTH(o.order_date)
)
SELECT 
    order_year,
    order_month,
    AVG(order_revenue) AS avg_order_value
FROM order_monthly_revenue
GROUP BY order_year, order_month
ORDER BY order_year, order_month;




