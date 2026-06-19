-- SQL RETAIL SALES ANALYSIS
CREATE DATABASE sql_project_p2;

USE sql_project_p2;

-- CREATE TABLE

CREATE TABLE retail_sales (
transactions_id INT PRIMARY KEY,
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
)

SELECT * FROM retail_sales;

-- CHECK NULL VALUES 
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

-- CLEAN THE DATA
DELETE FROM retail_sales WHERE 
transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

-- DATA EXPLORATION
-- How many sales we have?
SELECT COUNT(*) as total_sales FROM retail_sales;

-- How many customers we have?
SELECT COUNT(DISTINCT customer_id) as total_customers from retail_sales ;

-- How man category we have?
SELECT COUNT(DISTINCT category) as total_category from retail_sales ;

SELECT DISTINCT category FROM retail_sales;


-- DATA Analysis $ Businesss KEY PROBLEMS and answers
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM 
retail_sales 
WHERE category = 'Clothing' AND date_format(sale_date, '%Y-%m') = '2022-11' AND quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,SUM(total_sale) as total_sales FROM retail_sales GROUP BY category; 

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2) as average_age FROM retail_sales WHERE category = "Beauty";

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender,category,COUNT(transactions_id) as total_no_of_transactions FROM retail_sales GROUP BY Gender,category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year,month,avg_total_sales
FROM (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_total_sales,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id,SUM(total_sale) as total_sales FROM retail_sales GROUP BY customer_id ORDER BY total_sales DESC LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id) as unq_customer_id
    FROM retail_sales
    GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sales
AS(
SELECT *,
	CASE 
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END as shift 
FROM retail_sales
) SELECT shift, COUNT(*) as total_orders
FROM hourly_sales 
group by shift; 

-- END OF PROJECT
    
    