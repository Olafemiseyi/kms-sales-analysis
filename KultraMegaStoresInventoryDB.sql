CREATE TABLE public.orders (
  row_id SERIAL PRIMARY KEY,
  order_id VARCHAR(50),
  order_date DATE,
  order_priority VARCHAR(50),
  order_quantity INTEGER,
  sales NUMERIC,
  discount NUMERIC,
  ship_mode VARCHAR(100),
  profit NUMERIC,
  unit_price NUMERIC,
  shipping_cost NUMERIC,
  customer_name VARCHAR(255),
  province VARCHAR(100),
  region VARCHAR(100),
  customer_segment VARCHAR(100),
  product_category VARCHAR(100),
  product_sub_category VARCHAR(100),
  product_name TEXT,
  product_container VARCHAR(100),
  product_base_margin NUMERIC,
  ship_date DATE
);

SELECT COUNT(*) 
FROM public.orders;

SELECT * 
FROM public.orders LIMIT 10;

--Product category with the highest sales
SELECT 
    product_category,
    SUM(sales) AS total_sales
FROM 
    public.orders
GROUP BY 
    product_category
ORDER BY 
    total_sales DESC
LIMIT 1;

--Top 3 Regions (Highest Sales)
SELECT 
    region,
    SUM(sales) AS total_sales
FROM 
    public.orders
GROUP BY 
    region
ORDER BY 
    total_sales DESC
LIMIT 3;

--Bottom 3 Regions (Lowest Sales)
SELECT 
    region,
    SUM(sales) AS total_sales
FROM 
    public.orders
GROUP BY 
    region
ORDER BY 
    total_sales ASC
LIMIT 3;

--Total sales of appliances in Ontario
SELECT
    SUM(sales) AS total_sales_appliances_ontario
FROM
    public.orders
WHERE
    product_sub_category = 'Appliances' 
    AND province = 'Ontario'; 

--Identify the Bottom 10 Customers by Sales
SELECT
    customer_name,
    SUM(sales) AS total_customer_sales
FROM
    public.orders
GROUP BY
    customer_name
ORDER BY
    total_customer_sales ASC 
LIMIT 10;

--Most expensive shipping cost method
SELECT
    ship_mode,
    SUM(shipping_cost) AS total_shipping_cost_incurred
FROM
    public.orders
GROUP BY
    ship_mode
ORDER BY
    total_shipping_cost_incurred DESC
LIMIT 1;

--Most valuable cutomers
SELECT
    customer_name,
    SUM(sales) AS total_customer_sales
FROM
    public.orders
GROUP BY
    customer_name
ORDER BY
    total_customer_sales DESC
LIMIT 5;

--Products/services they typically purchase
SELECT
    customer_name,
    product_category,
    SUM(sales) AS total_category_sales_for_customer,
    COUNT(*) AS number_of_orders_in_category
FROM
    public.orders
WHERE
    customer_name IN ('Emily Phan', 'Deborah Brumfield', 'Roy Skaria', 'Sylvia Foulston', 'Grant Carroll')
GROUP BY
    customer_name,
    product_category
ORDER BY
    customer_name,
    total_category_sales_for_customer DESC;

--Small business owners with highest sales
SELECT
    customer_name,
    SUM(sales) AS total_customer_sales
FROM
    public.orders
WHERE
    customer_segment = 'Small Business'
GROUP BY
    customer_name
ORDER BY
    total_customer_sales DESC
LIMIT 1;

--Corporate customer with the most orders
SELECT
    customer_name,
    COUNT(order_id) AS total_orders_placed
FROM
    public.orders
WHERE
    customer_segment = 'Corporate'
    AND order_date BETWEEN '2009-01-01' AND '2012-12-31'
GROUP BY
    customer_name
ORDER BY
    total_orders_placed DESC
LIMIT 1;


--Most profitable consumer customer
SELECT
    customer_name,
    SUM(profit) AS total_customer_profit
FROM
    public.orders
WHERE
    customer_segment = 'Consumer'
GROUP BY
    customer_name
ORDER BY
    total_customer_profit DESC
LIMIT 1;


CREATE TABLE public.order_status (
    order_id VARCHAR(50),
    status VARCHAR(50)
);

SELECT *
FROM order_status;

--Customers that returned items and segment they belong to
SELECT DISTINCT
    o.customer_name,
    o.customer_segment
FROM
    public.orders AS o
JOIN
    public.order_status AS os ON o.order_id = os.order_id
WHERE
    os.status = 'Returned';


-- Ordering by cost DESC to see highest cost methods per priority
SELECT
    order_priority,
    ship_mode,
    SUM(shipping_cost) AS total_shipping_cost_for_priority,
    COUNT(order_id) AS number_of_orders_for_priority_ship_mode
FROM
    public.orders
GROUP BY
    order_priority,
    ship_mode
ORDER BY
    order_priority ASC,
    total_shipping_cost_for_priority DESC; -- Ordering by cost DESC to see highest cost methods per priority









