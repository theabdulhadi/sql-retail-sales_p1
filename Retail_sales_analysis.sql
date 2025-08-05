-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
			transactions_id INT primary key,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(15),
			age INT,
			category VARCHAR(15),
			quantiy INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
	);


SELECT * FROM retail_sales
LIMIT 10

SELECT COUNT(*) FROM retail_sales


-- DATA CLEANING
SELECT * from retail_sales 
WHERE
	transactions_id IS NULL
	OR
	sale_time IS NULL
	OR
	sale_date IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL


--
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_time IS NULL
	OR
	sale_date IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL


-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE?
Select count (*) as total_sale from retail_sales

-- How many unique customers?
Select count(DISTINCT customer_id) as total_sale from retail_sales

-- How many unique categories?
Select DISTINCT category from retail_sales


-- Data Analysis & Business Key problems & Answers
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

Select * from retail_sales
Where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

Select * from retail_sales
WHERE category = 'Clothing' AND quantiy >= 4 AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
from retail_sales
Group by 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
Select
	ROUND(AVG(age), 2) as average_age
from retail_sales
WHERE category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
from retail_sales
WHERE total_sale > '1000'
ORDER BY transactions_id


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, count(*) as total_trans
from retail_sales
GROUP BY category, gender
ORDER BY 1


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	year,
	month,
	avg_sale

FROM(
	SELECT 
		EXTRACT(YEAR from sale_date) as year,
		EXTRACT(MONTH from sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR from sale_date) ORDER BY AVG(total_sale) DESC) as rank
	
	from retail_sales
	GROUP BY 1, 2
-- ORDER BY 1, 3
) as T1 
WHERE rank = 1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

Select 
	customer_id,
	SUM(total_sale) as sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC LIMIT 5


-- Q.9 Write a SQL query to find the number of unique customers who purchased items; from each category.

SELECT 
	category,
	COUNT(DISTINCT customer_id) as cnt_unique_customers
FROM retail_sales
GROUP BY 1


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH Hourly_sales
AS 
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
from retail_sales
)

SELECT 
	shift,
	COUNT(*) as total_orders
from Hourly_sales
Group by shift