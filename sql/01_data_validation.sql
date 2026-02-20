-- Query 1 (to check how many orders are in the orders table)
-- This query checks the total number of orders in the northwind_orders table. It helps to understand the size of the dataset and can be used as a baseline for further analysis.

SELECT COUNT(*) FROM northwind_orders;

-- Query 2 (to check how many line items are in the order details table)
-- This query checks the total number of line items in the northwind_order_details table. It helps to understand the size of the dataset and can be used as a baseline for further analysis.

SELECT COUNT(*) FROM northwind_order_details;

-- Query 3 (to check how many unique orders are in the order details table)
-- This query checks the total number of unique orders in the northwind_order_details table. It helps to understand if there are any duplicate order IDs in the order details, which could indicate data quality issues.

SELECT COUNT(DISTINCT order_id) FROM northwind_order_details;

-- Query 4 (to check how many line items each order has)
-- This query checks how many line items each order has in the northwind_order_details table. It helps to understand the distribution of line items across orders and can be used to identify any orders with an unusually high or low number of line items, which could indicate data quality issues.

SELECT O.order_id as order_id, COUNT(O.order_id) as line_item_count
FROM northwind_orders as O
LEFT JOIN northwind_order_details as OD ON O.order_id = OD.order_id
GROUP BY order_id;

-- Query 5 (to check the minimum order date in the orders table)
-- This query checks the minimum order date in the northwind_orders table. It helps to understand the time range of the dataset and can be used as a baseline for further analysis.

SELECT MIN(order_date) FROM northwind_orders;

-- Query 6 (to check the maximum order date in the orders table)
-- This query checks the maximum order date in the northwind_orders table. It helps to understand the time range of the dataset and can be used as a baseline for further analysis.

SELECT MAX(order_date) FROM northwind_orders;

-- Query 7 (to check if there are any orders with shipped date before order date)
-- This query checks if there are any orders in the northwind_orders table where the shipped date is before the order date. Such cases are likely data entry errors and should be investigated further to ensure data quality.

SELECT COUNT(*) FROM northwind_orders
WHERE shipped_date < order_date;

-- Query 8 (to check which orders have shipped date before order date)
-- This query retrieves the order IDs of orders in the northwind_orders table where the shipped date is before the order date. Such cases are likely data entry errors and should be investigated further to ensure data quality.

SELECT order_id FROM northwind_orders
WHERE shipped_date < order_date;

-- Query 9 (to check if there are any orders with required date before order date)
-- This query checks if there are any orders in the northwind_orders table where the required date is before the order date. Such cases are likely data entry errors and should be investigated further to ensure data quality.

SELECT COUNT(*) FROM northwind_orders
WHERE required_date < order_date;

-- Query 10 (How many NULL values are there in orders table)
-- This query checks for the number of NULL values in each column of the northwind_orders table. It helps to identify any missing data and can be used to assess the overall data quality of the orders dataset.

SELECT 
    SUM(order_id IS NULL) AS order_id_nulls,
    SUM(customer_id IS NULL) AS customer_id_nulls,
    SUM(employee_id IS NULL) AS employee_id_nulls,
    SUM(order_date IS NULL) AS order_date_nulls,
    SUM(required_date IS NULL) AS required_date_nulls,
    SUM(shipped_date IS NULL) AS shipped_date_nulls,
    SUM(ship_via IS NULL) AS ship_via_nulls,
    SUM(freight IS NULL) AS freight_nulls,
    SUM(ship_name IS NULL) AS ship_name_nulls,
    SUM(ship_address IS NULL) AS ship_address_nulls,
    SUM(ship_city IS NULL) AS ship_city_nulls,
    SUM(ship_region IS NULL) AS ship_region_nulls,
    SUM(ship_postal_code IS NULL) AS ship_postal_code_nulls,
    SUM(ship_country IS NULL) AS ship_country_nulls
FROM northwind_orders;

-- Query 11 (How many NULL values are there in order details table)
-- This query checks for the number of NULL values in each column of the northwind_order_details table. It helps to identify any missing data and can be used to assess the overall data quality of the order details dataset.

SELECT
    SUM(order_id IS NULL) AS order_id_nulls,
    SUM(product_id IS NULL) AS product_id_nulls,
    SUM(unit_price IS NULL) AS unit_price_nulls,
    SUM(quantity IS NULL) AS quantity_nulls,
    SUM(discount IS NULL) AS discount_nulls
FROM northwind_order_details;
