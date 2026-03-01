USE DataWarehouseAnalytics
/*
GOAL:Explore all dataset
*/
 
--explore all objects in database
SELECT * FROM INFORMATION_SCHEMA.TABLES

--explore all Columns in Database

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products'

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'

--ÅU«È°ê®a

SELECT DISTINCT 
country
FROM gold.dim_customers

--²£«~Ãþ§O

SELECT DISTINCT 
category,
subcategory,
product_name
FROM gold.dim_products
ORDER BY 1,2,3

----------------------------------------
--¤é´Á±´¯Á
----------------------------------------
SELECT
MIN(order_date) firstorderdate,
MAX(order_date) lastorderdate,
DATEDIFF(YEAR, MIN(order_date),MAX(order_date)) order_year_range,
MIN(shipping_date) firstshipping_date,
MAX(shipping_date) lastshipping_date,
MIN(due_date) firstdue_date,
MAX(due_date) lastdue_date
FROM gold.fact_sales

--«È¸s¦~ÄÖ¤ÀªR
SELECT
MIN(birthdate) AS oldest,
DATEDIFF(YEAR, MIN(birthdate),GETDATE()) AS oldest_age,
MAX(birthdate) AS youngest,
DATEDIFF(YEAR, MAX(birthdate),GETDATE()) AS youngest_age
FROM gold.dim_customers

----------------------------------------
--¾P°â»PÀç·~±´¯Á
----------------------------------------

--total sales
SELECT
SUM(sales_amount) AS TotalSales
FROM gold.fact_sales

--how many item are sold
SELECT
SUM(quantity) AS Totalitems
FROM gold.fact_sales

--avg selling price
SELECT
AVG(price) AS avg_selling_price
FROM gold.fact_sales

--number of order
SELECT
COUNT(order_number) AS number_of_order,
COUNT(DISTINCT order_number) AS number_of_order2
FROM gold.fact_sales

--total number of product
SELECT
COUNT(product_name) AS total_products
FROM gold.dim_products

--total number of customer
SELECT
COUNT(customer_key) AS TotalCustomer
FROM gold.dim_customers

--total number of customers that has placed an order
SELECT
COUNT(DISTINCT customer_key) AS TotalCustomer
FROM gold.fact_sales

--overview chart
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value 
FROM gold.fact_sales
UNION ALL 
SELECT 'Total Quantity' AS measure_name, SUM(quantity) AS measure_value 
FROM gold.fact_sales
UNION ALL 
SELECT 'AVG Price' AS measure_name, AVG(price) AS measure_value 
FROM gold.fact_sales
UNION ALL 
SELECT 'Total Nr.orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value 
FROM gold.fact_sales
UNION ALL 
SELECT 'Total Nr.Products' AS measure_name, COUNT(product_name)  AS measure_value 
FROM gold.dim_products
UNION ALL 
SELECT 'Total Nr.Customers' AS measure_name, COUNT(DISTINCT customer_key)AS measure_value 
FROM gold.fact_sales









