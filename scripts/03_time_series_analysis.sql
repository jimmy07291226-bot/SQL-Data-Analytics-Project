/*
===============================================================================
 Time Series & Cumulative Analysis
===============================================================================
*/

--Analze Sales Performance Over time by Year

SELECT
YEAR(order_date) AS Order_year,
SUM(sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_customer,
SUM(quantity) AS Total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

--Analze Sales Performance Over time by month
/*聖誕節銷售最高，2月銷售最低，2010跟2014數據非完整數據*/
SELECT
DATETRUNC(month,order_date) AS Order_year,
SUM(sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_customer,
SUM(quantity) AS Total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)
ORDER BY DATETRUNC(month,order_date)

--Calculate the total sales per month
--and the running total of sales over time
SELECT
Order_date,
Total_Sales,
SUM(Total_Sales) OVER(PARTITION BY Order_date ORDER BY Order_date) AS running_total_sales
FROM(
	SELECT
		DATETRUNC(month,order_date) AS Order_date,
		SUM(sales_amount) AS Total_Sales
	FROM gold.fact_sales
	WHERE Order_date IS NOT NULL
	GROUP BY DATETRUNC(month,order_date)
)t

