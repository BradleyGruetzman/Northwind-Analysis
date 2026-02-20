-- Step 1 - Calculate shipping delay for each order
-- This query calculates the shipping delay for each order by taking the difference between the shipped date and the order date. It helps to understand how long it takes for orders to be shipped after they are placed, which can be an important metric for fulfillment performance analysis.

SELECT order_id, DATEDIFF(shipped_date, order_date) AS shipping_delay
FROM northwind_orders;

-- Step 2 - Calculate average shipping delay
-- This query calculates the average shipping delay across all orders by taking the average of the difference between the shipped date and the order date. It provides an overall measure of how long it takes for orders to be shipped after they are placed, which can be used to assess the efficiency of the fulfillment process.

SELECT AVG(DATEDIFF(shipped_date, order_date)) AS average_shipping_delay
FROM northwind_orders;

-- Step 3 - Identify orders that were shipped late (shipped after required date)
-- This query identifies orders that were shipped late by comparing the shipped date with the required date. It flags orders as late if the shipped date is after the required date. This information can be used to analyze the reasons for late shipments and to identify areas for improvement in the fulfillment process.

SELECT
    order_id,
    order_date,
    required_date,
    shipped_date,
    CASE
        WHEN shipped_date IS NULL THEN NULL
        WHEN shipped_date > required_date THEN 1
        ELSE 0
    END AS late_shipment_flag
FROM northwind_orders;

-- Step 4 - Calculate percentage of late shipments
-- This query calculates the percentage of late shipments by counting the number of orders that were shipped late (shipped after the required date) and dividing it by the total number of orders. This metric can be used to assess the overall performance of the fulfillment process and to identify trends in late shipments over time.

WITH late_shipments AS (
    SELECT
        CASE
            WHEN shipped_date IS NULL THEN NULL
            WHEN shipped_date > required_date THEN 1
            ELSE 0
        END AS late_shipment_flag
    FROM northwind_orders
)
SELECT
    SUM(late_shipment_flag) * 100.0 / COUNT(*) AS late_shipment_percentage
FROM late_shipments
WHERE late_shipment_flag IS NOT NULL;

-- Step 5 - Analyze shipping delay by employee
-- This query analyzes the shipping delay by employee by calculating the average shipping delay, the number of late shipments, the total number of shipments, and the percentage of late shipments for each employee. This information can be used to identify employees who may need additional training or support to improve their fulfillment performance.

SELECT
    employee_id,
    AVG(DATEDIFF(shipped_date, order_date)) AS avg_shipping_delay,
    SUM(CASE WHEN shipped_date > required_date THEN 1 ELSE 0 END) AS late_shipments,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN shipped_date > required_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS late_shipment_percentage
FROM northwind_orders
GROUP BY employee_id
ORDER BY late_shipment_percentage DESC;
-- Step 6 - Analyze shipping delay by shipper
-- This query analyzes the shipping delay by shipper by calculating the average shipping delay, the number of late shipments, the total number of shipments, and the percentage of late shipments for each shipper (identified by ship_via). This information can be used to evaluate the performance of different shippers and to identify any issues with specific shippers that may be contributing to late shipments.

SELECT
    ship_via,
    AVG(DATEDIFF(shipped_date, order_date)) AS avg_shipping_delay,
    SUM(CASE WHEN shipped_date > required_date THEN 1 ELSE 0 END) AS late_shipments,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN shipped_date > required_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS late_shipment_percentage
FROM northwind_orders
GROUP BY ship_via
ORDER BY late_shipment_percentage DESC;

-- Step 7 - Analyze shipping delay by country
-- This query analyzes the shipping delay by country by calculating the average shipping delay, the number of late shipments, the total number of shipments, and the percentage of late shipments for each shipping country. This information can be used to identify any geographic trends in shipping delays and to target improvement efforts in specific regions.

SELECT
    ship_country,
    AVG(DATEDIFF(shipped_date, order_date)) AS avg_shipping_delay,
    SUM(CASE WHEN shipped_date > required_date THEN 1 ELSE 0 END) AS late_shipments,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN shipped_date > required_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS late_shipment_percentage
FROM northwind_orders
GROUP BY ship_country
ORDER BY late_shipment_percentage DESC;
-- Step 8 - Analyze shipping delay by year
-- This query analyzes the shipping delay by year by calculating the average shipping delay, the number of late shipments, the total number of shipments, and the percentage of late shipments for each year based on the order date. This information can be used to identify any trends in shipping delays over time and to evaluate the effectiveness of any improvement initiatives that have been implemented.

SELECT
    YEAR(order_date) AS order_year,
    AVG(DATEDIFF(shipped_date, order_date)) AS avg_shipping_delay,
    SUM(CASE WHEN shipped_date > required_date THEN 1 ELSE 0 END) AS late_shipments,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN shipped_date > required_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS late_shipment_percentage
FROM northwind_orders
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Step 9 - Calculate Freight cost as a percentage of total revenue for each order
-- This query calculates the freight cost as a percentage of total revenue for each order by joining the northwind_orders and northwind_order_details tables on the order_id. The total revenue for each order is calculated by summing the revenue from the order details, and then the freight cost is divided by the total revenue to get the percentage. This information can be used to analyze the cost efficiency of shipping for each order.

SELECT
    O.order_id,
    O.freight,
    SUM(OD.revenue) AS total_revenue,
    CASE
        WHEN SUM(OD.revenue) = 0 THEN NULL
        ELSE O.freight * 100.0 / SUM(OD.revenue)
    END AS freight_percentage_of_revenue
FROM northwind_orders AS O
JOIN northwind_order_details AS OD
    ON O.order_id = OD.order_id
GROUP BY O.order_id, O.freight
ORDER BY freight_percentage_of_revenue DESC;

-- Step 10 - Analyze freight cost as a percentage of revenue by shipper
-- This query analyzes the freight cost as a percentage of revenue by shipper (identified by ship_via) by first calculating the total revenue for each order and then averaging the freight percentage of revenue for each shipper. This information can be used to evaluate the cost efficiency of different shippers and to identify any issues with specific shippers that may be contributing to high freight costs relative to revenue.

WITH order_revenue AS (
    SELECT
        O.order_id,
        O.ship_via,
        O.freight,
        SUM(OD.revenue) AS order_revenue
    FROM northwind_orders O
    JOIN northwind_order_details OD
        ON O.order_id = OD.order_id
    GROUP BY O.order_id, O.ship_via, O.freight
)

SELECT
    ship_via,
    AVG(
        CASE
            WHEN order_revenue = 0 THEN NULL
            ELSE freight * 100.0 / order_revenue
        END
    ) AS avg_freight_percentage_of_revenue
FROM order_revenue
GROUP BY ship_via
ORDER BY avg_freight_percentage_of_revenue DESC;

-- Step 11 - Analyze freight cost as a percentage of revenue by country
-- This query analyzes the freight cost as a percentage of revenue by country by first calculating the total revenue for each order and then averaging the freight percentage of revenue for each shipping country. This information can be used to identify any geographic trends in freight costs relative to revenue and to target improvement efforts in specific regions.

WITH order_revenue AS (
    SELECT
        O.order_id,
        O.ship_country,
        O.freight,
        SUM(OD.revenue) AS order_revenue
    FROM northwind_orders O
    JOIN northwind_order_details OD
        ON O.order_id = OD.order_id
    GROUP BY O.order_id, O.ship_country, O.freight
)
SELECT
    ship_country,
    AVG(
        CASE
            WHEN order_revenue = 0 THEN NULL
            ELSE freight * 100.0 / order_revenue
        END
    ) AS avg_freight_percentage_of_revenue
FROM order_revenue
GROUP BY ship_country
ORDER BY avg_freight_percentage_of_revenue DESC;

-- Step 12 - Identify high-cost shipments (freight cost > 20% of revenue)
-- This query identifies high-cost shipments by calculating the freight cost as a percentage of total revenue for each order and filtering for orders where this percentage exceeds 20%. This information can be used to investigate the reasons for high freight costs relative to revenue and to identify opportunities for cost reduction in the fulfillment process.

WITH order_revenue AS (
    SELECT
        O.order_id,
        O.freight,
        SUM(OD.revenue) AS order_revenue
    FROM northwind_orders O
    JOIN northwind_order_details OD
        ON O.order_id = OD.order_id
    GROUP BY O.order_id, O.freight
)
SELECT
    order_id,
    freight,
    order_revenue,
    CASE
        WHEN order_revenue = 0 THEN NULL
        ELSE freight * 100.0 / order_revenue
    END AS freight_percentage_of_revenue
FROM order_revenue
WHERE
    CASE
        WHEN order_revenue = 0 THEN NULL
        ELSE freight * 100.0 / order_revenue
    END > 20
ORDER BY freight_percentage_of_revenue DESC;







