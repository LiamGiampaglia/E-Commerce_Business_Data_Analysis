-- Create the database, import data via 'Table Data Import Wizard'

CREATE DATABASE ECommerce_Report;

Use ECommerce_Report;

-- check if the tables imported correctly

SELECT * 
FROM customers;

SELECT * 
FROM products;

SELECT * 
FROM transactions;

-- CustomerID in Customers table imported faulty so we will correct it

ALTER TABLE `ecommerce_report`.`customers` 
CHANGE COLUMN `ï»¿CustomerID` `CustomerID` TEXT NULL DEFAULT NULL;

-- ProductID in products table imported faulty so we will correct it

ALTER TABLE `ecommerce_report`.`products` 
CHANGE COLUMN `ï»¿ProductID` `ProductID` TEXT NULL DEFAULT NULL;

-- TransactionID in Transactions table imported faulty so we will correct it

ALTER TABLE `ecommerce_report`.`transactions` 
CHANGE COLUMN `ï»¿TransactionID` `TransactionID` TEXT NULL DEFAULT NULL;


-- join all tables together and select unique columns

SELECT 
	c.CustomerId, 
    CustomerName, 
    Region, 
    SignupDate, 
    ProductName, 
    Category, 
    TransactionId, 
    p.ProductId, 
    TransactionDate, 
    Quantity, 
    TotalValue, 
    p.Price
FROM 
	transactions AS t
JOIN customers AS c 
	on t.customerid = c.customerid
JOIN products AS p
	on p.productid = t.productid;
    
-- create new table and insert the joined tables    
    
CREATE TABLE `FullData` (
  `CustomerID` TEXT,
  `CustomerName` TEXT,
  `Region` TEXT,
  `SignupDate` TEXT,
  `ProductName` TEXT,
  `Category` TEXT,
  `TransactionID` TEXT,
  `ProductID` TEXT,
  `TransactionDate` TEXT,
  `Quantity` INT,
  `TotalValue` DOUBLE,
  `Price` DOUBLE
);


-- insert the joined tables into one big table

INSERT INTO FullData (
  CustomerID,
  CustomerName,
  Region,
  SignupDate,
  ProductName,
  Category,
  TransactionID,
  ProductID,
  TransactionDate,
  Quantity,
  TotalValue,
  Price)
SELECT 
	c.CustomerId, 
    CustomerName, 
    Region, 
    SignupDate, 
    ProductName, 
    Category, 
    TransactionId, 
    p.ProductId, 
    TransactionDate, 
    Quantity, 
    TotalValue, 
    p.Price
FROM 
	transactions AS t
JOIN customers AS c 
	on t.customerid = c.customerid
JOIN products AS p
	on p.productid = t.productid;
    
    
-- Let's check if it worked

SELECT *
FROM fulldata;


-- Let begin the cleaning process in the following order
-- 1. Remove Any Duplicates
-- 2. Standarise the Data
-- 3. Deal with any Null Values or Blanks
-- 4. Remove any unnecessary columns

-- 1. Remove Any Duplicates
-- To check for duplicates I will use row numbers to find help duplicate values


SELECT *, 
ROW_NUMBER() OVER(PARTITION BY
  CustomerID,
  CustomerName,
  Region,
  SignupDate,
  ProductName,
  Category,
  TransactionID,
  ProductID,
  TransactionDate,
  Quantity,
  TotalValue,
  Price) AS row_num 
FROM FullData;


-- Using a CTE I will locate the specific duplicates

WITH duplicate_cte AS (SELECT *, 
ROW_NUMBER() OVER(PARTITION BY
  CustomerID,
  CustomerName,
  Region,
  SignupDate,
  ProductName,
  Category,
  TransactionID,
  ProductID,
  TransactionDate,
  Quantity,
  TotalValue,
  Price) AS row_num 
FROM FullData)
SELECT * FROM duplicate_cte WHERE row_num > 1;


-- There are 0 duplicates

-- Now that we have identified 0 duplicates, it's time to move on next stage of data cleaning which is...
-- 2. Standardise the Data
-- Signup Date column was a text, so we need to change to DATE format
-- Transaction Date column was a text, so we need to change to DATETIME format

UPDATE fulldata
SET 
	signupdate = CAST(signupdate AS DATE), 
    transactiondate = CAST(transactiondate AS DATETIME) 
WHERE 
	signupdate IS NOT NULL 
    OR transactiondate IS NOT NULL;
    
    
    
ALTER TABLE fulldata
MODIFY COLUMN `signupdate` DATE,
MODIFY COLUMN `transactiondate` DATETIME;

-- we will also alter the table so that the TotalValue and Price columns are decimal data types

ALTER TABLE fulldata
MODIFY COLUMN TotalValue DECIMAL(10, 2),
MODIFY COLUMN Price DECIMAL(10, 2);

-- Now the data has been standaised, let's move on next stage of data cleaning which is...
-- 3. Deal with any Null Values or Blanks
-- Let's check if we have any NULLs or blank values


-- First I will check the null values

SELECT *
FROM fulldata
WHERE CustomerID IS NULL
	OR CustomerName IS NULL
	OR Region IS NULL
	OR SignupDate IS NULL
	OR ProductName IS NULL
	OR Category IS NULL
	OR TransactionID IS NULL
	OR ProductID IS NULL
	OR TransactionDate IS NULL
	OR Quantity IS NULL
	OR TotalValue IS NULL
	OR Price IS NULL;

-- There are no null values in this table


-- Now I will check the blank values

SELECT *
FROM fulldata
WHERE TRIM(CustomerID) = ''
	OR TRIM(CustomerName) = ''
	OR TRIM(Region) = ''
	OR TRIM(SignupDate) = ''
	OR TRIM(ProductName) = ''
	OR TRIM(Category) = ''
	OR TRIM(TransactionID) = ''
	OR TRIM(ProductID) = ''
	OR TRIM(TransactionDate) = ''
	OR TRIM(Quantity) = ''
	OR TRIM(TotalValue) = ''
	OR TRIM(Price) = '';


-- There are no blank values in this table

-- Now the data has been checked for NULLs and Blanks, let's move on next stage of data cleaning which is...
-- 4. Remove any unnecessary columns

-- Let's check our table again to see if any columns are irrelevant for data analysis

SELECT *
FROM fulldata;

-- There is 1 irrelevant columns, the Customer Name column so let's remove it

ALTER TABLE fulldata
DROP COLUMN CustomerName;


-- Now let's check the table one last time

SELECT *
FROM fulldata;

-- The column has now been dropped

-- All the data has now been cleaned