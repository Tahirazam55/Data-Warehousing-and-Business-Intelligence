-- Drop tables if they already exist
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;

-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    age INT
);

INSERT INTO Customers (customer_id, first_name, last_name, city, age) VALUES
(1, 'Ali', 'Khan', 'Lahore', 28),
(2, 'Sara', 'Ahmed', 'Karachi', 35),
(3, 'John', 'Smith', 'Islamabad', 42),
(4, 'Ayesha', 'Malik', 'Lahore', 30),
(5, 'Bilal', 'Hussain', 'Karachi', 25);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert sample data
INSERT INTO Orders (order_id, customer_id, product, quantity, price, order_date) VALUES
(101, 1, 'Laptop', 1, 800, '2023-05-01'),
(102, 2, 'Mouse', 2, 20, '2023-05-03'),
(103, 1, 'Keyboard', 1, 40, '2023-06-10'),
(104, 3, 'Laptop', 2, 1600, '2023-07-15'),
(105, 4, 'Monitor', 1, 300, '2023-07-20'),
(106, 5, 'Mouse', 3, 30, '2023-08-01'),
(107, 2, 'Laptop', 1, 900, '2023-08-12'),
(108, 3, 'Keyboard', 2, 80, '2023-08-15');

SELECT * 
FROM Customers;

SELECT first_name, city
FROM Customers
WHERE city = 'Karachi';

SELECT *
FROM Orders
WHERE price > 500;


SELECT *
FROM Orders
ORDER BY price DESC;


SELECT *
FROM Orders
ORDER BY order_date ASC
LIMIT 3;

SELECT customer_id, COUNT(order_id) AS total_orders
FROM Orders
GROUP BY customer_id;

SELECT customer_id, 
       SUM(quantity * price) AS total_sales
FROM Orders
GROUP BY customer_id;


SELECT product, 
       AVG(price) AS avg_price
FROM Orders
GROUP BY product;

SELECT customer_id, COUNT(order_id) AS total_orders
FROM Orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

SELECT *
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    WHERE product = 'Laptop'
);

SELECT *
FROM Orders
WHERE price > (
    SELECT AVG(price) 
    FROM Orders
);


SELECT *
FROM Customers
WHERE age > (
    SELECT AVG(age)
    FROM Customers
);




