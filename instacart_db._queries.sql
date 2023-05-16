--Create temp table to hold denormalized data
CREATE TEMPORARY TABLE denormalized_instacart_db (
	product_id INT,	
	product_name TEXT,
	aisle_id INT,	
	department_id INT,
	aisle TEXT,	
	order_id INT,	
	user_id INT,	
	order_dow INT,	
	order_hour_of_day INT,
	days_since_prior_order INT,	
	department TEXT,	
	unit_price NUMERIC(10, 2), 	
	unit_cost NUMERIC(10, 2), 	
	quantity INT,	
	order_date DATE,
	order_status TEXT
);

--importing data to the temp table
COPY denormalized_instacart_db(product_id, product_name, aisle_id, department_id, aisle,
				order_id, user_id, order_dow, order_hour_of_day,
				days_since_prior_order, department, unit_price, unit_cost,
				quantity, order_date, order_status)
FROM 'C:/Users/Kola Ademola/Documents/Gits/InstaCart/instacart_db.csv'
DELIMITER ','
CSV HEADER;

--VIEW DENORMALIZED DATA
SELECT *
FROM denormalized_instacart_db
LIMIT 10;
sed
--DENORMALIZATION OF TABLE/DATA
--creating aisle table
CREATE TABLE aisle(
	aisle_id INT NOT NULL PRIMARY KEY,
	aisle VARCHAR(255)
);

--creating departments table
CREATE TABLE departments(
	department_id INT NOT NULL PRIMARY KEY,
	department VARCHAR(255)
);

--creating products table
CREATE TABLE products(
	product_id INT NOT NULL PRIMARY KEY,
	product_name TEXT,
	aisle_id INT REFERENCES aisle(aisle_id),
	department_id INT REFERENCES departments(department_id),
	unit_cost NUMERIC(10, 2),
	unit_price NUMERIC(10, 2)
);

--creating orders table
CREATE TABLE orders(
	order_id INT NOT NULL PRIMARY KEY,	
	user_id INT,
	product_id INT REFERENCES products(product_id),
	quantity INT,	
	order_date DATE,	
	order_dow INT,	
	order_hour_of_day INT,
	days_since_prior_order INT,	
	order_status VARCHAR(255)	
);

--POPULATE TABLES WITH DATA FROM THE DENORMALIZED TEMP TABLE
--populating aisle table
INSERT INTO aisle
SELECT DISTINCT aisle_id, aisle
FROM denormalized_instacart_db
ORDER BY aisle_id;

--populating departments table
INSERT INTO departments
SELECT DISTINCT department_id, department
FROM denormalized_instacart_db
ORDER BY department_id;		

--populating products table
INSERT INTO products
SELECT DISTINCT product_id, product_name,
				aisle_id, department_id,
				unit_cost, unit_price
FROM denormalized_instacart_db
ORDER BY product_id;

--ppopulating orders table
INSERT INTO orders
SELECT order_id, user_id, product_id,
		quantity, order_date, order_dow,
		order_hour_of_day, days_since_prior_order, order_status
FROM denormalized_instacart_db
ORDER BY order_date;

--Q1 how have the orders changed overtime monthly?
SELECT DATE_PART('YEAR', order_date) order_year,
		CASE DATE_PART('MONTH', order_date)
			WHEN 1 THEN 'January'
			WHEN 2 THEN 'February'
			WHEN 3 THEN 'March'
			WHEN 4 THEN 'April'
			WHEN 5 THEN 'May'
			WHEN 6 THEN 'June'
			WHEN 7 THEN 'July'
			WHEN 8 THEN 'August'
			WHEN 9 THEN 'September'
			WHEN 10 THEN 'October'
			WHEN 11 THEN 'November'
			WHEN 12 THEN 'December'
		END AS order_month,
		COUNT(order_id) total_orders
FROM orders
GROUP BY DATE_PART('YEAR', order_date), DATE_PART('MONTH', order_date)
--OR
SELECT CASE DATE_PART('MONTH', order_date)
			WHEN 1 THEN 'January'
			WHEN 2 THEN 'February'
			WHEN 3 THEN 'March'
			WHEN 4 THEN 'April'
			WHEN 5 THEN 'May'
			WHEN 6 THEN 'June'
			WHEN 7 THEN 'July'
			WHEN 8 THEN 'August'
			WHEN 9 THEN 'September'
			WHEN 10 THEN 'October'
			WHEN 11 THEN 'November'
			WHEN 12 THEN 'December'
		END AS order_month,
		COUNT(order_id) total_orders
FROM orders
GROUP BY DATE_PART('MONTH', order_date);

--Q2 are there any weekly fluctuations in the size of the orders?
SELECT DATE_PART('YEAR', order_date) order_year,
		CONCAT('Week ', DATE_PART('WEEK', order_date)) order_week,
		COUNT(order_id) total_orders
FROM orders
GROUP BY DATE_PART('YEAR', order_date),DATE_PART('WEEK', order_date);

--Q3 what is the average number of orders placed by day of week?
SELECT CASE order_dow
        	WHEN 0 THEN 'Sunday'
        	WHEN 1 THEN 'Monday'
        	WHEN 2 THEN 'Tuesday'
        	WHEN 3 THEN 'Wednesday'
        	WHEN 4 THEN 'Thursday'
        	WHEN 5 THEN 'Friday'
        	WHEN 6 THEN 'Saturday'
    	END AS order_day_of_week,
		 (SELECT COUNT(*) FROM orders) / COUNT(*) avg_weekly_orders
FROM orders
GROUP BY order_day_of_week
ORDER BY avg_weekly_orders;

--Q4 what is the hour of the day with thee highest number of orders
SELECT order_hour_of_day,
		COUNT(order_id) total_orders
FROM orders
GROUP BY order_hour_of_day
ORDER BY total_orders DESC
LIMIT 1;

--Q5 which dept has the highest average spend per customer?
SELECT d.department,
		ROUND(AVG(p.unit_price), 2) avg_spend
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN departments d ON o.department_id = d.department_id
GROUP BY d.department
ORDER BY avg_spend DESC
LIMIT 1;

--Q6 which product generated more profit?
SELECT p.product_name,
		SUM(p.unit_price - p.unit_cost) profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit DESC
LIMIT 1;

--Q7 what are the 3 ailes with the most order, and which dept do they belong to?
SELECT a.aisle,
		d.department,
		COUNT(o.order_id) total_orders
FROM orders o
JOIN aisle a ON o.aisle_id = a.aisle_id
JOIN departments d ON o.department_id = d.department_id
GROUP BY a.aisle, d.department
ORDER BY total_orders DESC
LIMIT 3;

--Q8 which 3 users generated the highest revenue, and how many aisle did they order from?
SELECT o.user_id,
		COUNT(DISTINCT o.aisle_id) number_of_aisle,
		SUM(p.unit_price) total_revenue
FROM orders o
JOIN aisle a ON o.aisle_id = a.aisle_id
JOIN products p ON o.product_id = p.product_id
GROUP BY o.user_id
ORDER BY total_revenue DESC
LIMIT 3;



--Q1 What are the top-selling products by revenue, and how much revenue have they generated?
SELECT p.product_name,
		CONCAT('$', SUM(p.unit_price * o.quantity)) total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name, p.unit_price
ORDER BY SUM(p.unit_price * o.quantity) DESC
LIMIT 10;
/*
INSIGHT:::The top-selling product is the "Vanilla, Tangerine & Shortbread Ice Cream"
		   with a total revenue of $11,184.00.
*/

--Q2 Which products have the highest profit margin, and how much profit have they generated?
SELECT p.product_name,
		CONCAT('$', SUM(o.quantity * (p.unit_price - p.unit_cost))) profit_margin
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY product_name
ORDER BY profit_margin;

/*

*/
--Q3 Which aisles have the highest sales volume, and how does this vary by department?


/*

*/
--Q4 What is the average order size (in terms of quantity and total cost) per day of the week?


/*

*/
--Q5 Which products are most commonly purchased together, and what is the frequency of these combinations?


/*

*/
--Q6 What is the average time between orders for each user, and how does this vary by product category?


/*

*/
--Q7 Which products have the highest rate of returns or customer complaints, and what are the common reasons?


/*

*/
--Q8 What is the average unit cost and unit price for each product category, and how does this compare to industry benchmarks?


/*

*/
--Q9 How have sales and revenue changed over time for each product category, and what factors have contributed to these changes?


/*

*/
--Q10 Which users have the highest lifetime value, and what are their common purchase patterns and preferences?


/*

*/