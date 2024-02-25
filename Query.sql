CREATE SCHEMA Wallmart_sales;

USE Wallmart_sales;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date VARCHAR(30) NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

ALTER TABLE sales
MODIFY date DATE NOT NULL;


SELECT * 
FROM sales;


-- Add the time_of_day column

ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(20);


-- Cross checking


SELECT * 
FROM sales;

-- Adding values 

UPDATE sales
SET time_of_day = (CASE WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
WHEN time BETWEEN '12:01:00' AND '17:00:00' THEN 'Afternoon' ELSE 'Evening' END);

-- Cross checking


SELECT * 
FROM sales;


-- Add day_name column

ALTER TABLE sales
ADD COLUMN day_name VARCHAR(20);

-- Add values

UPDATE sales
SET day_name = DAYNAME(date);

-- Cross checking

SELECT * 
FROM sales;



-- Add month_name column

ALTER TABLE sales
ADD COLUMN month_name VARCHAR(20);

-- Add values

UPDATE sales
SET month_name = MONTHNAME(date);


-- Cross checking

SELECT * 
FROM sales;



-- Generic Question

/* Q1. How many unique cities does the data have? */

SELECT DISTINCT city
FROM sales;


/* Q2.Which city has which branch present? */

SELECT DISTINCT city, branch
FROM sales;

-- Product

/* Q1.How many unique product lines does the data have? */

SELECT DISTINCT product_line
FROM sales;

/* Q2.What is the most common payment method? */

SELECT MAX(payment) AS most_commom_method
FROM sales;


/* Q3.What is the most selling product line? */

SELECT product_line, SUM(quantity) AS qty
FROM sales
GROUP BY product_line
ORDER BY qty DESC;


/* Q4.What is the total revenue by month? */

SELECT month_name, ROUND((SUM(total)),2) AS total_sales
FROM sales
GROUP BY month_name;

/* Q5.What month had the largest COGS? */

SELECT month_name, SUM(cogs) AS total_COGS
FROM sales
GROUP BY month_name	
ORDER BY total_COGS DESC;

/*Q6.What product line had the largest revenue? */

SELECT product_line, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

/*Q7.What is the city with the largest revenue? */

SELECT city, SUM(total) AS total_income
FROM sales
GROUP BY city
ORDER BY total_income DESC;


/*Q8.What product line had the largest tax? */

SELECT product_line, AVG(tax_pct) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;


/*Q9.Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales */

SELECT  invoice_id, product_line, CASE WHEN quantity > (SELECT AVG(quantity) FROM sales) THEN 'GOOD' ELSE 'BAD' END AS Remark
FROM sales ;

/*Q10.Which branch sold more products than average product sold? */

SELECT branch, SUM(quantity) AS Total_quantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


/*Q11.What is the most common product line by gender? */


SELECT gender, product_line, COUNT(product_line) AS Count
FROM sales
GROUP BY gender, product_line
ORDER BY gender, COUNT(product_line) DESC;

/*Q12.What is the average rating of each product line? */


SELECT product_line, AVG(rating) Avg_rating
FROM sales
GROUP BY product_line;



-- Sales
/*Q1.Number of sales made in each time of the day per weekday */


SELECT time_of_day, COUNT(invoice_id) AS total_sales
FROM sales
WHERE day_name != 'Sunday'
GROUP BY time_of_day;

/*Q2.Which of the customer types brings the most revenue? */


SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;


/*Q3.Which city has the largest tax percent/ VAT (Value Added Tax)?? */


SELECT city, AVG(tax_pct) AS Avg_tax
FROM sales
GROUP BY city
ORDER BY AVG(tax_pct) DESC;


/*Q4.Which customer type pays the most in VAT? */


SELECT customer_type, AVG(tax_pct) AS Avg_tax
FROM sales
GROUP BY customer_type
ORDER BY AVG(tax_pct) DESC;


-- Customer
/*Q1.How many unique customer types does the data have? */

SELECT DISTINCT customer_type 
FROM sales;


/*Q2.How many unique payment methods does the data have? */


SELECT DISTINCT payment
FROM sales;


/*Q3.What is the most common customer type? */


SELECT customer_type, count(customer_type) AS Cust_count
FROM sales
GROUP BY customer_type
ORDER BY Cust_count DESC;

/*Q4.Which customer type buys the most? */

SELECT customer_type, count(invoice_id) AS Sales_count
FROM sales
GROUP BY customer_type
ORDER BY Sales_count DESC;

/*Q5.What is the gender of most of the customers? */

SELECT gender, COUNT(gender) Cust_count
FROM sales
GROUP BY gender;


/*Q6.What is the gender distribution per branch? */


SELECT branch, gender, COUNT(gender) Gender_count
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender ASC;


/*Q7.Which time of the day do customers give most ratings? */

SELECT time_of_day, AVG(rating) AS rating_given
FROM sales
GROUP BY time_of_day
ORDER BY time_of_day DESC;


/*Q8.Which time of the day do customers give most ratings per branch? */

SELECT branch, time_of_day, AVG(rating) AS rating_given
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch, rating_given DESC;


/*Q9.Which day fo the week has the best avg ratings? */


SELECT day_name, AVG(rating) rating
FROM sales
GROUP BY day_name
ORDER BY rating DESC;


/*Q10.Which day of the week has the best average ratings per branch? */


SELECT branch, day_name, AVG(rating) rating
FROM sales
GROUP BY branch, day_name
ORDER BY branch, rating DESC;