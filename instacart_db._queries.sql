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
WITH(
	FORMAT CSV,
	HEADER TRUE
);

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

select *
from orders