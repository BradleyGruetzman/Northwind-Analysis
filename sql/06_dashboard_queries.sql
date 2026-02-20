-- 01 Northwind Product & Employee Performance --

-- KPI: Number of Employees
SELECT 
    COUNT(DISTINCT employee_id) AS number_of_employees
FROM northwind_orders;

-- KPI: Number of Products
SELECT 
    COUNT(DISTINCT product_id) AS number_of_products
FROM northwind_order_details;

-- KPI: Overall Late Order Percentage
SELECT 
    ROUND(100.0 * SUM(CASE WHEN shipped_date > required_date THEN 1 ELSE 0 END) / COUNT(*), 2) AS late_order_pct
FROM northwind_orders
WHERE shipped_date IS NOT NULL;

-- KPI: Total Units Sold
SELECT 
    SUM(quantity) AS total_units_sold
FROM northwind_order_details;

-- Chart: Revenue by Employee ID
SELECT 
    o.employee_id,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS total_revenue
FROM northwind_orders o
JOIN northwind_order_details od ON o.order_id = od.order_id
GROUP BY o.employee_id
ORDER BY total_revenue DESC;

-- Chart: Orders Sold by Employee ID
SELECT 
    employee_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM northwind_orders
GROUP BY employee_id
ORDER BY total_orders DESC;

-- Chart: Late Orders by Employee ID
SELECT 
    employee_id,
    SUM(CASE WHEN shipped_date > required_date THEN 1 ELSE 0 END) AS late_orders
FROM northwind_orders
WHERE shipped_date IS NOT NULL
GROUP BY employee_id
ORDER BY late_orders DESC;

-- Chart: Late Order Percentage by Employee ID
SELECT 
    employee_id,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN shipped_date > required_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(SUM(CASE WHEN shipped_date > required_date THEN 1 ELSE 0 END) / COUNT(*), 2) AS late_order_pct
FROM northwind_orders
WHERE shipped_date IS NOT NULL
GROUP BY employee_id
ORDER BY late_order_pct DESC;

-- Chart: Revenue by Product ID (Top 10)
SELECT 
    product_id,
    ROUND(SUM(unit_price * quantity * (1 - discount)), 2) AS total_revenue
FROM northwind_order_details
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Chart: Units Sold by Product ID (Top 10)
SELECT 
    product_id,
    SUM(quantity) AS total_units_sold
FROM northwind_order_details
GROUP BY product_id
ORDER BY total_units_sold DESC
LIMIT 10;







-- 02 Northwind Customer Analysis --

-- KPI: Total Customers
SELECT 
    COUNT(DISTINCT customer_id) AS total_customers
FROM northwind_orders;

-- KPI: Revenue per Customer
SELECT 
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)) / 
        COUNT(DISTINCT o.customer_id), 2) AS revenue_per_customer
FROM northwind_orders o
JOIN northwind_order_details od ON o.order_id = od.order_id;

-- KPI: Average Orders per Customer
SELECT 
    ROUND(1.0 * COUNT(DISTINCT order_id) / COUNT(DISTINCT customer_id), 2) AS avg_orders_per_customer
FROM northwind_orders;

-- KPI: Revenue Percentage of Top 10 Customers
WITH customer_revenue AS (
    SELECT 
        o.customer_id,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS revenue
    FROM northwind_orders o
    JOIN northwind_order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
),
total AS (
    SELECT SUM(revenue) AS total_revenue FROM customer_revenue
),
top10 AS (
    SELECT SUM(revenue) AS top10_revenue
    FROM (SELECT revenue FROM customer_revenue ORDER BY revenue DESC LIMIT 10) AS t
)
SELECT 
    ROUND(100.0 * top10.top10_revenue / total.total_revenue, 2) AS top10_revenue_pct
FROM top10, total;

-- KPI: Average Revenue per Order
SELECT 
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)) / 
        COUNT(DISTINCT od.order_id), 2) AS avg_revenue_per_order
FROM northwind_order_details od;

-- Chart: Revenue by Customer (Top 10)
SELECT 
    o.customer_id,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS total_revenue
FROM northwind_orders o
JOIN northwind_order_details od ON o.order_id = od.order_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Chart: Orders per Customer (Top 10)
SELECT 
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM northwind_orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 10;

-- Customer Segmentation (Low < $20K, Medium $20K-$50K, High > $50K)
WITH customer_revenue AS (
    SELECT 
        o.customer_id,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS revenue
    FROM northwind_orders o
    JOIN northwind_order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
),
segmented AS (
    SELECT 
        customer_id,
        revenue,
        CASE 
            WHEN revenue > 50000 THEN 'High Value'
            WHEN revenue > 20000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS segment
    FROM customer_revenue
)
-- Chart: Customer Percentage by Segment
SELECT 
    segment,
    COUNT(*) AS customer_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM segmented), 1) AS customer_pct
FROM segmented
GROUP BY segment
ORDER BY customer_count DESC;

-- Chart: Revenue Percentage by Segment
WITH customer_revenue AS (
    SELECT 
        o.customer_id,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS revenue
    FROM northwind_orders o
    JOIN northwind_order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
),
segmented AS (
    SELECT 
        revenue,
        CASE 
            WHEN revenue > 50000 THEN 'High Value'
            WHEN revenue > 20000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS segment
    FROM customer_revenue
)
SELECT 
    segment,
    ROUND(SUM(revenue), 2) AS segment_revenue,
    ROUND(100.0 * SUM(revenue) / (SELECT SUM(revenue) FROM segmented), 1) AS revenue_pct
FROM segmented
GROUP BY segment
ORDER BY segment_revenue DESC;

-- Chart: Average Revenue per Customer by Segment
WITH customer_revenue AS (
    SELECT 
        o.customer_id,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS revenue
    FROM northwind_orders o
    JOIN northwind_order_details od ON o.order_id = od.order_id
    GROUP BY o.customer_id
),
segmented AS (
    SELECT 
        revenue,
        CASE 
            WHEN revenue > 50000 THEN 'High Value'
            WHEN revenue > 20000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS segment
    FROM customer_revenue
)
SELECT 
    segment,
    ROUND(AVG(revenue), 2) AS avg_revenue_per_customer
FROM segmented
GROUP BY segment
ORDER BY avg_revenue_per_customer DESC;






-- 03 Northwind Sales Overview --

-- KPI: Total Revenue
SELECT 
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS total_revenue
FROM northwind_order_details od;

-- KPI: Total Orders
SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM northwind_orders;

-- KPI: Average Order Value
SELECT 
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)) / COUNT(DISTINCT od.order_id), 2) AS avg_order_value
FROM northwind_order_details od;

-- Chart: Monthly Revenue Trend
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS monthly_revenue
FROM northwind_orders o
JOIN northwind_order_details od ON o.order_id = od.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- Table: Revenue and Revenue Percentage by Country
SELECT 
    o.ship_country,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS total_revenue,
    ROUND(100.0 * SUM(od.unit_price * od.quantity * (1 - od.discount)) /
        (SELECT SUM(unit_price * quantity * (1 - discount)) FROM northwind_order_details), 2) AS revenue_pct
FROM northwind_orders o
JOIN northwind_order_details od ON o.order_id = od.order_id
GROUP BY o.ship_country
ORDER BY total_revenue DESC;

-- Table: Year-over-Year Revenue Summary (Average Monthly Revenue, Total Revenue, YoY Growth)
WITH yearly AS (
    SELECT 
        YEAR(o.order_date) AS year,
        ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount)), 2) AS total_revenue,
        COUNT(DISTINCT DATE_FORMAT(o.order_date, '%Y-%m')) AS months_active
    FROM northwind_orders o
    JOIN northwind_order_details od ON o.order_id = od.order_id
    GROUP BY YEAR(o.order_date)
),
with_avg AS (
    SELECT
        year,
        total_revenue,
        ROUND(total_revenue / months_active, 2) AS avg_monthly_revenue
    FROM yearly
)
SELECT 
    year,
    avg_monthly_revenue,
    total_revenue,
    ROUND(100.0 * (avg_monthly_revenue - LAG(avg_monthly_revenue) OVER (ORDER BY year)) / 
        LAG(avg_monthly_revenue) OVER (ORDER BY year), 2) AS yoy_growth_pct
FROM with_avg
ORDER BY year;