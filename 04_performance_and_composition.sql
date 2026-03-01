/*
===============================================================================
Performance & Part-to-Whole Analysis
===============================================================================
*/

 /* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

--CTE
WITH yearly_product_sales AS (
SELECT
YEAR(f.order_date) AS order_year,
p.product_name,
SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
WHERE YEAR(f.order_date) IS NOT NULL
GROUP BY 
YEAR(f.order_date),
p.product_name
)
--Query
SELECT
order_year,
product_name,
current_sales,
AVG(current_sales) OVER(PARTITION BY product_name) AS Avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
	 WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
	 ELSE 'Avg'
END avg_change,
--Year-Over-year 
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ) previous_sale,
current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ) AS diff_py,
CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ) > 0 THEN 'Increase'
	 WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year ) < 0 THEN 'Decrease'
	 ELSE 'No Change'
END py_change
FROM yearly_product_sales 
ORDER BY product_name, order_year

/*
===============================================================================
--Part-to-whole Analysis
===============================================================================

だ猂い竲今ósales琌程orderぃ琌程璹虫畉薄猵
SALES畉禯ㄓ盢48琌皌ン虫基セㄓ碞竲今ó
祔稬猔種或旧璓硂莉挡篶

*/

--Which categories contribute the most to overall sales
WITH Category_sales AS (
SELECT
p.category,
SUM(sales_amount) AS Total_Sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
GROUP BY p.category)

SELECT
category,
total_sales,
SUM(total_sales) OVER () overall_sales,
CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER () )* 100 , 2), '%') AS percentage_of_total
FROM Category_sales
ORDER BY total_sales DESC ;

--Which categories contribute the most to overall order

WITH Category_order AS (
SELECT
p.category,
COUNT(order_number) AS Total_order
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
GROUP BY p.category)

SELECT
category,
Total_order,
SUM(Total_order) OVER () overall_order,
CONCAT(ROUND((CAST(Total_order AS FLOAT) / SUM(Total_order) OVER () )* 100 , 2), '%') AS percentage_of_total
FROM Category_order
ORDER BY Total_order DESC

