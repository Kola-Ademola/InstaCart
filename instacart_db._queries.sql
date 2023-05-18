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
		COUNT(o.order_id) total_orders,
		CONCAT(ROUND((((p.unit_price - p.unit_cost) / p.unit_cost) * 100), 2), '%') profit_margin,
		CONCAT('$', SUM(o.quantity * (p.unit_price - p.unit_cost))) total_profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY product_name, 
		(((p.unit_price - p.unit_cost) / p.unit_cost) * 100)
ORDER BY (((p.unit_price - p.unit_cost) / p.unit_cost) * 100),
		 SUM(o.quantity * (p.unit_price - p.unit_cost)) DESC
LIMIT 10;
/*
INSIGHT:::The top products with the most generated profit all have the same profit margin
		   with "Vanilla, Tangerine & Shortbread Ice Cream" at the top of list with "$1,118.40" total profit.
*/
--Q3 Which aisles have the highest sales volume, and how does this vary by department?
SELECT a.aisle,
		d.department,
		SUM(o.quantity) total_sales_volume,
		CONCAT('$', SUM(o.quantity * p.unit_price)) total_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
JOIN aisle a ON p.aisle_id = a.aisle_id
JOIN departments d ON p.department_id = d.department_id
GROUP BY a.aisle, d.department
ORDER BY total_sales_volume DESC
LIMIT 10;
/*
INSIGHT:::The "missing" aisle has the highest overall sales volume with over 147,000 items sold
*/
--Q4 What is the average order size and value(in terms of quantity and total price) per day of the week?
SELECT CASE o.order_dow
        	WHEN 0 THEN 'Sunday'
        	WHEN 1 THEN 'Monday'
        	WHEN 2 THEN 'Tuesday'
        	WHEN 3 THEN 'Wednesday'
        	WHEN 4 THEN 'Thursday'
        	WHEN 5 THEN 'Friday'
        	WHEN 6 THEN 'Saturday'
    	END AS order_day_of_week,
		CONCAT(ROUND(AVG(quantity)), ' orders / day') average_order_size,
		CONCAT('$', ROUND(AVG(o.quantity * p.unit_price), 2)) average_order_value
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY o.order_dow, order_day_of_week
ORDER BY ROUND(AVG(quantity)) DESC,
		ROUND(AVG(o.quantity * p.unit_price), 2) DESC;
/*
INSIGHT:::The average order size & value is almost the same for most days of the week, but Fridays come out on top
			with "6 orders per day" and an AOV of "$151.36".
*/
--Q5 On average, during which time of the day do we receive the highest number of orders?
WITH total_orders AS(
    SELECT order_hour_of_day,
			COUNT(*) num_of_orders
    FROM orders
    GROUP BY order_hour_of_day
)
SELECT CASE 
		WHEN order_hour_of_day BETWEEN 0 AND 11 THEN CONCAT(order_hour_of_day, 'AM')
		WHEN order_hour_of_day BETWEEN 13 AND 23 THEN CONCAT(order_hour_of_day - 12, 'PM')
		ELSE CONCAT(order_hour_of_day, 'PM')
	   END time_of_day,
		CONCAT(ROUND(((SELECT SUM(num_of_orders) FROM total_orders) / num_of_orders)), ' orders') average_num_of_orders
FROM total_orders
GROUP BY time_of_day, num_of_orders
ORDER BY ROUND(((SELECT SUM(num_of_orders) FROM total_orders) / num_of_orders)) DESC;
/*
INSIGHT:::Surprisingly most orders are made in the middle of the night, with **3AM** having the most orders.
*/
--Q6 What is delivery success rate by order_status?
SELECT CONCAT(COUNT(*), ' orders') AS total_orders,
       CONCAT(ROUND(COUNT(CASE WHEN order_status = 'Delivered' THEN 1 END) * 100.0 / COUNT(*)), '% Delivered') AS delivery_success_rate
FROM orders;
/*
INSIGHT::: Only **22%** of the orders placed have been delivered to the customers.
*/
