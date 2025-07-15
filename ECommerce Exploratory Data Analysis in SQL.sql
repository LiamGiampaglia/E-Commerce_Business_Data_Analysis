-- We previously created and cleaned the Ecommerce dataset, let's select that database for this Exploratory Data Analysis
Use ecommerce_report;

-- Let's begin by analysing the data for User and Subscription Behaviour

SELECT * 
FROM fulldata;


-- Lets see how many people signed up in each year

SELECT EXTRACT(YEAR FROM signupdate) AS signup_year, COUNT(DISTINCT customerid) AS customer_count
FROM customers
GROUP BY EXTRACT(YEAR FROM signupdate)
ORDER BY signup_year;

-- 2024 had the most sign ups with 79, followed by 2022 with 64 and finally 2023 with 56


-- let's check which 3 months had largest sign ups

SELECT EXTRACT(YEAR FROM signupdate) AS signup_year, EXTRACT(MONTH FROM signupdate) AS signup_month, COUNT(DISTINCT customerid) AS customer_count
FROM customers
GROUP BY EXTRACT(YEAR FROM signupdate), EXTRACT(MONTH FROM signupdate)
ORDER BY customer_count desc
Limit 3;

-- November and September 2024 had the highest sign up amounts with 11, followed by April 2024 with 10


-- let's check which 3 months had the lowest sign ups

SELECT EXTRACT(YEAR FROM signupdate) AS signup_year, EXTRACT(MONTH FROM signupdate) AS signup_month, COUNT(DISTINCT customerid) AS customer_count
FROM customers
GROUP BY EXTRACT(YEAR FROM signupdate), EXTRACT(MONTH FROM signupdate)
ORDER BY customer_count asc
Limit 3;

-- January 2022 and December 2024 had the lowest with 1 sign up, followed by August 2023 with 2 sign ups

-- Let's look at total revenue

SELECT ROUND(SUM(totalvalue), 2) AS total_revenue
FROM transactions;

-- Total revenue was $661,150.23


-- Lets look at the revenue by top 3 months

SELECT DATE_FORMAT(transactiondate, '%Y-%m') AS month, ROUND(SUM(totalvalue), 2) AS total_revenue
FROM transactions
GROUP BY month
ORDER BY total_revenue DESC
LIMIT 3;

-- The 3 highest revenue month in order were July 2024 with $69,276.41, Followed by September 2024 with $66,275.17 and in 3rd was January 2024 with $63,648.95


SELECT DATE_FORMAT(transactiondate, '%Y') AS Year, ROUND(SUM(totalvalue), 2) AS total_revenue
FROM transactions
GROUP BY Year
ORDER BY total_revenue DESC;

-- 2024 had the highest revenue with $657,380.71 followed by 2023 with $3,769.52 and 2022 apears to have no reveune. Let's see check the monthly amounts again

SELECT DATE_FORMAT(transactiondate, '%Y-%m') AS month, ROUND(SUM(totalvalue), 2) AS total_revenue
FROM transactions
GROUP BY month
ORDER BY month ASC;

-- When viewing the monthly amounts, 2024 has values in every month, whereas 2023 only have revenue for December


-- Let's check total revenue by region

SELECT ROUND(SUM(totalvalue), 2) AS total_revenue, region
FROM transactions AS t
JOIN customers AS c
ON t.customerID = c.customerID
GROUP BY region
ORDER BY total_revenue DESC;

-- South america has the highest revenue with $211,871.70 and Asia has the lowest with $143,212.43


-- Let's check total revenue by Product

SELECT ROUND(SUM(totalvalue), 2) AS total_revenue, t.ProductID, ProductName, SUM(Quantity) AS total_sold
FROM transactions AS t
JOIN products AS p
ON t.productID = p.productID
GROUP BY ProductID, ProductName
ORDER BY total_revenue DESC
LIMIT 3;

-- ProductID P029, which is TechPro Headphones had the highest revenue with $19,513.80, followed by P079 (ActiveWear Rug) with $17,946.91 and in 3rd was P048 (TechPro Cookbook) with $17,905.20


-- Let's check the lowest 3 products by revenue

SELECT ROUND(SUM(totalvalue), 2) AS total_revenue, t.ProductID, ProductName, SUM(Quantity) AS total_sold
FROM transactions AS t
JOIN products AS p
ON t.productID = p.productID
GROUP BY ProductID, ProductName
ORDER BY total_revenue ASC
LIMIT 3;

-- Lowest product was P044 (ActiveWear Running Shoes) with $244.66, followed by P056 (SoundWave Smartwatch) with $337.68, followed by P014 (ActiveWear Jacket) with $367.64


-- Most sold product

SELECT SUM(Quantity) AS total_sold, t.ProductID, ProductName, t.price
FROM transactions AS t
JOIN products AS p
ON t.productID = p.productID
GROUP BY ProductID, ProductName, t.price
ORDER BY total_sold DESC
LIMIT 3;

-- The most sold products were P059 and P054 (SoundWave Jeans and SoundWave Cookbook) both with 46 sold, followed by P029 (TechPro Headphones) with 45 sold

-- Least sold product

SELECT SUM(Quantity) AS total_sold, t.ProductID, ProductName, t.price
FROM transactions AS t
JOIN products AS p
ON t.productID = p.productID
GROUP BY ProductID, ProductName, t.price
ORDER BY total_sold ASC
LIMIT 3;

-- the least sold products were P026(SoundWave Bluetooth Speaker) with 8 sold, followed by P031(SoundWave Headphones) with 9 sold and P099 with(SoundWave Mystery Book) 11 sold

-- Highest Revenue from a Customer
SELECT SUM(totalvalue) AS total_revenue, CustomerID
FROM transactions
GROUP BY CustomerID
ORDER BY total_revenue DESC
LIMIT 3;

-- Customers were most revenue were generated from are CustomerID C0141 with $10,673.87, followed by C0065 with $7,663.70, followed by C0156 with $7,643.45


-- Highest revenue by category

SELECT ROUND(SUM(totalvalue), 2) AS total_revenue, Category
FROM transactions AS t
JOIN products AS p
ON t.productID = p.productID
GROUP BY Category
ORDER BY total_revenue DESC
LIMIT 3;

-- Best category for highest revenue came from Books with $192,147.47, followed by Electronics with $168,663.75, followed by Home Decor with $150,893.93