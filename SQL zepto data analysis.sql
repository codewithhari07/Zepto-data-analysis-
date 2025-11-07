DROP table if exists zepto;

CREATE table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(130),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);


--Data exploration

--Count the rows
SELECT * FROM zepto;

--Sample data
SELECT * FROM zepto
LIMIT 10;

--Null values
SELECT * FROM zepto
WHERE name IS Null or category IS Null or mrp IS Null or
discountpercent IS Null or availablequantity IS Null or
discountedsellingprice IS Null or
weightingms IS Null 
or quantity IS Null or outofstock IS Null;

--Different Product Categories

SELECT DISTINCT category
FROM Zepto
ORDER BY category;

--Products in stock vs Out of Stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--Product names present multiple times
SELECT NAME, COUNT(sku_id) AS "number_of_SKUs"
FROM zepto 
GROUP BY name 
HAVING number_of_SKUs >1
ORDER BY number_of_SKUs DESC;

--DATA CLEANING--

--Product with price is zero

SELECT * FROM zepto 
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--Convert paise to rupees in MRP and Discount selling Price
UPDATE zepto
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0

--Q1. Find the top 10 best value products based on the discount percentage
SELECT DISTINCT name, mrp,discountpercent FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

--Q2. What are the top 5 products with High MRP but out of Stock

SELECT DISTINCT name, mrp FROM zepto
WHERE outofstock =True ORDER BY  mrp DESC
LIMIT 5;

--Q3. Identify the top 5 categories offering the highest average discount 

SELECT category, ROUND(AVG(discountpercent),3) AS "avgdiscount" FROM zepto 
GROUP BY category
ORDER BY avgdiscount DESC
LIMIT 5;

--Q4. Find the price per gram for products above 100g and sort by best value

SELECT DISTINCT name, discountedsellingprice, weightingms, 
ROUND((discountedsellingprice/weightingms),2) AS "price_per_gram" FROM zepto
WHERE weightingms > 100
ORDER BY price_per_gram;



--Q5. Calculate Estimated Revenue for each category

SELECT category, SUM(discountedsellingprice * availablequantity) AS "total_revenue" 
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q6. Find all the products where MRP is greater than 500 and discount is less than 10% 

SELECT DISTINCT name, mrp, discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent <10
ORDER BY mrp DESC;

--Q7. Group the products into categories like LOW, MEDIUM, BULK

SELECT DISTINCT name, weightingms,
CASE 
WHEN weightingms <1000 THEN 'Low' 
WHEN weightingms <5000 THEN 'Medium' 
ELSE 'Bulk'
END AS weight_category
FROM zepto;

--Q8. What is the total Inventory weight per category

SELECT category, SUM(weightingms * availablequantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;
