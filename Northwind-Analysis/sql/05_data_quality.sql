-- Step 1 - Identify orders with missing shipped dates
-- Orders with missing shipped dates may indicate incomplete data or orders that have not yet been fulfilled. This should be investigated further to determine if there are any issues with the order fulfillment process.

SELECT order_id, order_date, required_date, shipped_date
FROM northwind_orders
WHERE shipped_date IS NULL;

-- Step 2 - Identify orders with shipped dates before order dates
-- This could indicate data entry errors and should be investigated further.

SELECT order_id, order_date, required_date, shipped_date
FROM northwind_orders
WHERE shipped_date < order_date;

-- Step 3 - Identify orders with required dates before order dates
-- This could also indicate data entry errors and should be investigated further.

SELECT order_id, order_date, required_date, shipped_date
FROM northwind_orders
WHERE required_date < order_date;

-- Step 4 - Check for orders with zero or negative quantity in order details
-- Orders with zero or negative quantity may indicate data entry errors and should be investigated further.

SELECT order_id, product_id, unit_price, quantity, discount
FROM northwind_order_details
WHERE quantity <= 0;

-- Step 5 - Check for outlier order values in order details
-- Orders with extremely high or low values may indicate data entry errors and should be investigated further.

SELECT order_id, product_id, unit_price, quantity, discount
FROM northwind_order_details
WHERE unit_price < 0 OR quantity < 0 OR (unit_price * quantity * (1 - discount)) > 10000;

-- Step 6 - Check for duplicate orders
-- Duplicate orders may indicate data entry errors and should be investigated further.

SELECT order_id, COUNT(*)
FROM northwind_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Step 7 - Check for orders with missing customer or employee information
-- Orders with missing customer or employee information may indicate data entry errors and should be investigated further.

SELECT order_id, customer_id, employee_id
FROM northwind_orders
WHERE customer_id IS NULL OR employee_id IS NULL;

-- Step 8 - Check for orders with missing or inconsistent shipping information
-- Orders with missing or inconsistent shipping information may indicate data entry errors and should be investigated further.

SELECT order_id, ship_via, freight, ship_name, ship_address, ship_city, ship_region, ship_postal_code, ship_country
FROM northwind_orders
WHERE ship_via IS NULL OR freight IS NULL OR ship_name IS NULL OR ship_address IS NULL OR ship_city IS NULL OR ship_region IS NULL OR ship_postal_code IS NULL OR ship_country IS NULL;

-- Step 9 - Check for orders with missing or inconsistent product information in order details
-- Orders with missing or inconsistent product information may indicate data entry errors and should be investigated further.

SELECT order_id, product_id, unit_price, quantity, discount
FROM northwind_order_details
WHERE product_id IS NULL OR unit_price IS NULL OR quantity IS NULL OR discount IS NULL;









