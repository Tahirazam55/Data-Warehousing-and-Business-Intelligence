--create database 
create database sales_db;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    phone_number VARCHAR(20),
    city VARCHAR(50)
);
-- Items Table
CREATE TABLE items (
    item_id SERIAL PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    item_type VARCHAR(50),
    item_price NUMERIC(10,2) NOT NULL,
    amount_in_stock INT NOT NULL CHECK (amount_in_stock >= 0)
);

-- Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    shipping_date DATE,
    item_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE
);


select * from customers;
select * from items;
select * from orders;


-- Single-Row Subquery
-- subquery will return a single value
-- ----------------------------------------------------------------------------

-- 1. Select or display all items with the minimum price
SELECT *
FROM items
WHERE item_price = (
    SELECT MIN(item_price)
    FROM items
);

SELECT order_id,
       customer_id,
       order_date,
       shipping_date,
       item_id,
       item_name,
       item_price
FROM orders
JOIN items USING (item_id)
WHERE item_price = (
    SELECT MIN(item_price)
    FROM items
);


-- 3. Retrieve the details of customer who placed the most recent order.
SELECT customer_id,
       first_name,
       phone_number,
       city,
       order_id,
       order_date,
       shipping_date,
       item_id
FROM customers
JOIN orders USING (customer_id)
WHERE order_date = (
    SELECT MAX(order_date)
    FROM orders
);

SELECT customer_id,
       first_name,
       last_name,
       date_of_birth,
       phone_number,
       city
FROM customers
WHERE date_of_birth = (
    SELECT Min(date_of_birth)
    FROM customers
);

-- 5. In items, label amount_in_stock as 'High' if above the average stock, else 'Low'.
SELECT item_id,
       item_name,
       item_type,
       item_price,
       amount_in_stock,
       CASE
           WHEN amount_in_stock > (SELECT AVG(amount_in_stock) FROM items) THEN 'High'
           ELSE 'Low'
       END AS stock_label
FROM items;





-- ----------------------------------------------------------------------------
-- MultiRow Subquery
-- subquery will return multiple rows and 1 column
-- ----------------------------------------------------------------------------

-- 1. Retrieves all customer details who placed an order IN FEB.
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE EXTRACT(MONTH FROM order_date) = 2
);


-- 2. Find the detail of customers who have ordered item with the minimum price
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    JOIN items USING (item_id)
    WHERE item_price = (SELECT MIN(item_price) FROM items)
);


-- 3. Find all customers who have placed an order for items that have a stock of 50.

SELECT *
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    JOIN items USING (item_id)
    WHERE amount_in_stock = 50
);


-- 4.List all items that were ordered by customers living in Lahore.
SELECT 
    c.first_name,
    c.last_name,
    c.city,
    i.item_name,
    i.item_type,
    i.item_price,
    o.order_date,
    o.shipping_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN items i ON o.item_id = i.item_id
WHERE c.city = 'Lahore';



-- ----------------------------------------------------------------------------
-- MultiColumn sub query
-- Returns multiple columns, useful for comparisons involving multiple values.
-- ----------------------------------------------------------------------------

-- 1. Retrieves orders where the same customer has ordered the same item more than once.

SELECT 
    customer_id,
    item_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id, item_id
HAVING COUNT(*) > 1;




-- ----------------------------------------------------------------------------
-- Correlated Subquery
-- A correlated subquery is a type of subquery in SQL where the inner query (subquery) is dependent on the outer query (main query). 
-- In other words, the inner query references columns from the outer query and is evaluated for each row processed by the outer query.
-- ----------------------------------------------------------------------------

-- 1. Retrieves the first order (earliest order date) for each customer.
SELECT customer_id, MIN(order_date) AS first_order_date
FROM orders
GROUP BY customer_id;
----OR----------





-- 1. Label each item's stock level
-- low stock if amount_in_stock is below 30
-- high stock if amount_in_stock is >= 30

SELECT 
    item_id,
    item_name,
    amount_in_stock,
    CASE 
        WHEN amount_in_stock < 30 THEN 'Low Stock'
        ELSE 'High Stock'
    END AS stock_level
FROM items;




-- ----------------------------------------------------------------------------------------------------
-- CASE STATEMENTS
-- ----------------------------------------------------------------------------------------------------

-- 1. Label each item's stock level
-- low stock if amount_in_stock is below 25
-- medium stock if between 25 and 50
-- high stock if greater than 50

SELECT 
    item_id,
    item_name,
    amount_in_stock,
    CASE 
        WHEN amount_in_stock < 25 THEN 'Low Stock'
        WHEN amount_in_stock BETWEEN 25 AND 50 THEN 'Medium Stock'
        ELSE 'High Stock'
    END AS stock_level
FROM items;




-- 2. You wish to find out the age demographics of your customer base. 
-- For this, you want to convert age to categorical data
-- Label each customer's age category

-- below 20 years - teen
-- between 20 and 30 - young adult
-- between 31 and 40 - adult
-- greater than 40 - middle-aged
alter table customers
add column age int;
update customers
set age =((date(now())-date_of_birth)/365);
select *,
case
when age < 20 then 'Teen'
when age between 20 and 30 then 'young adult'
when age between 31 and 40 then 'adult'
else 'middle age'
end as age_category
from customers;




-- ----------------------------------------------------------------------------------------------------
-- CASE WITH GROUP BY AND AGGREGATE FUNCTIONS
-- You can easily use a column that you have created using case in the group by clause and apply different aggregate functions
-- ----------------------------------------------------------------------------------------------------

-- 1. Find out the customer_count in each age_category

select *,
case
when age < 20 then 'Teen'
when age between 20 and 30 then 'young adult'
when age between 31 and 40 then 'adult'
else 'middle age'
end as age_category,
count(*) as customer_count
from customers
group by 1;



-- 2. Find out the number of low stock, medium stock and high stock items in the inventory (same conditions as in previous section)




-- 3. Label the average price (rounded off to two decimal places) of each item_type as:
-- avg_price less than 12 - low
-- avg_price between 12 and 32 - medium
-- avg_price greater than 32 - high



-- ----------------------------------------------------------------------------------------------------
-- UPDATING WITH CASE
-- ----------------------------------------------------------------------------------------------------

-- 1. Add a column called age_category and fill it with appropriate age category for each customer.






-- ----------------------------------------------------------------------------------------------------
-- CASE With SUBQUERY
-- ----------------------------------------------------------------------------------------------------
-- In items, label amount_in_stock as 'High' if above the average stock, else 'Low'.




-- ----------------------------------------------------------------------------------------------------
-- CASE INSIDE AGGREGATE FUNCTIONS
-- ----------------------------------------------------------------------------------------------------

-- 1. Write an SQL query to count the number of customers in each age category 
-- (young_adult, Adult, middle-aged) in each city from the customers table. 


