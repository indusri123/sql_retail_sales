-- SQL Retail Sales Project
CREATE DATABASE SQL_Retail_Sales;

-- Create table
-- Drop table if exists
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
		(
				transactions_id	INT PRIMARY KEY,
				sale_date	DATE,
				sale_time	TIME,
				customer_id	INT,
				gender	VARCHAR(10),
				age	INT,
				category VARCHAR(35),	
				quantiy	INT,
				price_per_unit	FLOAT,
				cogs	FLOAT,
				total_sale FLOAT
		);


-- Data Cleaning
--check null values
DELETE FROM retail_sales
		WHERE 
			transactions_id IS NULL
			OR
			sale_date IS NULL
			OR
			sale_time IS NULL
			OR
			customer_id IS NULL
			OR
			gender IS NULL
			OR
			age IS NULL
			OR
			category IS NULL
			OR
			quantiy IS NULL
			OR
			price_per_unit IS NULL
			OR
			cogs IS NULL
			OR
			total_sale IS NULL
			;
	
-- Data Exploration

-- How many sales do we have?
SELECT COUNT(*) as "No of Sales" FROM retail_sales;

-- How many customers do we have?
SELECT COUNT(DISTINCT Customer_id) from retail_sales;

-- How many UNIQUE categories do we have?
SELECT COUNT(DISTINCT Category) from retail_sales;
SELECT DISTINCT Category from retail_sales;

-- Avg sales per category?
SELECT Category,Round(CAST(AVG(total_sale) AS NUMERIC),2) from retail_sales 
 GROUP BY 1;


-- Data Analysis & Business Key problems and answers


--Q.1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'?
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';



--Q.2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT * 
FROM retail_sales
WHERE 
	category = 'Clothing' 
	AND
	quantity > 4
	AND
	TO_CHAR(sale_date , 'YYYY-MM') = 2022-11;



--Q.3. Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	Category, 
	SUM(total_sale) as total_sales 
from retail_sales
GROUP BY 1;




--Q.4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	category, 
	ROUND(AVG(age), 2) as avg_age 
from retail_sales
GROUP BY 1
HAVING Category = 'Beauty';




--Q.5. Write a SQL query to find all transactions where total sale is greater than 1000.
SELECT * 
from retail_sales
WHERE total_sale > 1000;




--Q.6. Write a SQL query to find the total number of trasactions (transaction_id) made by each gender in each category
SELECT 
	Category, 
	gender, 
	COUNT(*) as total_trans 
from retail_sales
GROUP BY 1,2
ORDER BY 1;




--Q.7. Write a SQL query to calculate the avg sale for each month. Find out best selling month in each year.
SELECT 
	year, 
	month, 
	avg_sale 
FROM 
	(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
	    EXTRACT(MONTH FROM sale_date) as  month,
	    AVG(total_sale) as avg_sale,
	   RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 1,2
	) as t1
	WHERE rank = 1;	




--Q.8. Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT 
	customer_id, 
	SUM(total_Sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;




--Q.9.Write a SQL query to find the number of unique customers who purchased items from each category
SELECT 
	category, 
	COUNT(DISTINCT customer_id) as cnt_unique_cs 
FROM retail_sales
GROUP BY 1;




--Q.10. Write a SQL query to create each shift and number of orders (ex Morning < 12, Afternoon between 12 to 17, Evening >17)
SELECT * FROM retail_sales;

WITH hourly_sale 
AS (
SELECT *,
	CASE
		WHEN (EXTRACT (HOUR FROM sale_time) <12) THEN 'Morning'
		WHEN (EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17) THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift, 
	COUNT(*) as total_orders 
from hourly_sale 
GROUP BY 1;






