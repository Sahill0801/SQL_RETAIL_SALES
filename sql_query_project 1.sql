-- create table
create table retail_sales
   (
    transactions_id INT,
	sale_date	DATE,
	sale_time	TIME,
	customer_id INT,
	gender	VARCHAR(15),
	age   INT,
	category	VARCHAR(15),
	quantiy	 INT,
	price_per_unit  FLOAT,
	cogs	FLOAT,
	total_sale  FLOAT
    );

SELECT * FROM retail_sales
limit 10;

SELECT count(*) FROM retail_sales;

-- DATA CLEANING
SELECT * FROM retail_sales
where transactions_id is null;

SELECT * FROM retail_sales
where sale_date is null;

SELECT * FROM retail_sales
where sale_time is null;


SELECT * FROM retail_sales
where 
   transactions_id is null
   or
   sale_date is null
   or 
   sale_time is null
   or
   gender is null
   or  
   category is null
   or 
   quantiy is null
   or 
   price_per_unit is null
   or 
   cogs is null
   or 
   total_sale is null;

--
delete from retail_sales
where 
   transactions_id is null
   or
   sale_date is null
   or 
   sale_time is null
   or
   gender is null
   or  
   category is null
   or 
   quantiy is null
   or 
   price_per_unit is null
   or 
   cogs is null
   or 
   total_sale is null;

-- DATA EXPLORATION

-- How many sales we have?
select count(*) as total_sale from retail_sales; 

-- How many unique customers we have?
select count(distinct customer_id) as total_customer from retail_sales;

-- How many unique category we have?
select distinct category from public.retail_sales;

--- Data Analysis &Business Key Problem & Answers

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * 
from retail_sales
where sale_date = '2022-11-05';

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
	FROM retail_sales
where category = 'Clothing'
and
To_Char(sale_date,'YYYY-MM')='2022-11'
And
quantiy >= 4 

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT 
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
FROM retail_sales 
group by 1

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select 
	Round(AVG(age)) as avg_age
from retail_sales
where category = 'Beauty';

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM retail_sales
where total_sale > 1000 ;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
	category,
	gender,
	count(*) as total_trans
from retail_sales
group 
	by
	category,
	gender
order by 1

-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select * from
(
select 
	Extract(year from sale_date) AS Year,
	Extract(month from sale_date) as Month,
	avg(total_sale) as avg_sales,
	rank() over(partition by Extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1,2
) as t1
where rank = '1';

-- Q8.Write a SQL query to find the top 5 customers based on the highest total sales :
select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5

-- Q9.Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
	category,
	count(distinct customer_id ) as cnt_unqiue_cst
from retail_sales
group by category

-- Q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
with hourly_sales
as
(
select *,
	CASE
	WHEN Extract(Hour from sale_time)<12 THEN 'Morning'
	WHEN Extract(Hour from sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END as shift
from retail_sales
)
select 
	shift,
	count(*) as total_sales
from hourly_sales
group by shift;

--END 