--Creating database of danny's_dinner
CREATE DATABASE DannyDinner;

--Creating Product Table
CREATE TABLE Menu(
 product_id INT PRIMARY KEY,
 product_name VARCHAR(50),
 price INT,
);

--Creating Members Table
CREATE TABLE Members(
customer_id CHAR PRIMARY KEY,
join_date DATE
);

--Creating Sales Table
CREATE TABLE Sales(
customer_id CHAR, 
order_date DATE,
product_id INT,
CONSTRAINT sales_cus_fk FOREIGN KEY (customer_id) REFERENCES Members(customer_id),
CONSTRAINT sales_pro_fk FOREIGN KEY (product_id) REFERENCES Menu(product_id)
);

--Inserting Menu Values
INSERT INTO Menu (product_id, product_name, price)
VALUES
  (1, 'sushi', 10),
  (2, 'curry', 15),
  (3, 'ramen', 12);

--Inserting Members Values
INSERT INTO Members (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09'),
  ('C', '2021-01-10');


--Inserting Sales Values
INSERT INTO Sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', 1),
  ('A', '2021-01-01', 2),
  ('A', '2021-01-07', 2),
  ('A', '2021-01-10', 3),
  ('A', '2021-01-11', 3),
  ('A', '2021-01-11', 3),
  ('B', '2021-01-01', 2),
  ('B', '2021-01-02', 2),
  ('B', '2021-01-04', 1),
  ('B', '2021-01-11', 1),
  ('B', '2021-01-16', 3),
  ('B', '2021-02-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-07', 3);


--First Question: What is the total amount each customer spent at the restaurant ?
SELECT Sales.customer_id AS 'Customer', SUM(Menu.price) AS 'Total Amount'
FROM Sales JOIN Menu
ON Sales.product_id = Menu.product_id
GROUP BY Sales.customer_id
ORDER BY SUM(Menu.price) DESC;

/*
Key Insight From The First Question:
Customer A has the most consumption according to total amount he spent in this restaurant
by a value of  $76 and Customer C has the least amount of the total amount by a value of 
$36
*/


--Second Question: How many days has each customer visited the restaurant ?
SELECT customer_id AS 'Customer', COUNT(DISTINCT(order_date)) AS 'Total Days Spent'
FROM Sales
GROUP BY customer_id
ORDER BY COUNT(DISTINCT(order_date)) DESC;
/*
Key Insight From The Second Question:
Customer B has the most total day spent in the restaurant and this may due to his
severe wonder to the place, products and, may be, the good prices in this restaurant
and the Customer C has the least total day spent in this restaurant
*/

--Third Question: What was the first item from the menu purchased by each customer?
WITH First_Items AS (
SELECT Sales.customer_id AS 'Customer' ,Menu.product_name AS 'Product', DENSE_RANK() OVER(PARTITION BY Sales.customer_id ORDER BY Sales.order_date) AS 'Ranking'  
FROM Sales JOIN Menu
ON Sales.product_id = Menu.product_id
)
SELECT DISTINCT Customer, Product
FROM First_Items
WHERE Ranking = 1;
/*
Key Insight From The Third Question:
From the result, we concluded that the curry was the most first item delivered 
because most people may want to try this first in the restaurant.
*/

--Fourth Question: What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT TOP 1 Menu.product_name AS 'Product', COUNT(Sales.customer_id) AS 'Purchases'
FROM Menu JOIN Sales
ON Menu.product_id = Sales.product_id
GROUP BY Menu.product_name
ORDER BY COUNT(Sales.customer_id) DESC;
/*
Key Insight From The Fourth Question:
Ramen is the best seller item in the restaurant and purchased 8 times
and because this restaurant has a great experience with this item and 
the item got a high wonders from customers.
*/

--Fifth Question: Which item was the most popular for each customer?
WITH Most_Popular AS (
    SELECT 
        Sales.customer_id AS Customer, 
        Menu.product_name AS Item, 
        DENSE_RANK() OVER (
            PARTITION BY Sales.customer_id 
            ORDER BY COUNT(Sales.product_id) DESC
        ) AS Ranking
    FROM Sales 
    JOIN Menu
      ON Sales.product_id = Menu.product_id
    GROUP BY Sales.customer_id, Menu.product_name
)
SELECT DISTINCT Customer, Item
FROM Most_Popular
WHERE Ranking = 1;
/*
Key Insight From The Fifth Question:
To answer this question, we will break answers into 2 sections:
First: Customer A and C love ordering ramen and this is the favourite dish for them in this restaurant
Second: The customer B loves ordering all the dishes in this restaurant
So, we concluded that the ramen dish is the most popular dish in this restaurant
*/

--Sixth Question: Which item was purchased first by the customer after they became a member?
WITH First_Member_Purchase AS (
    SELECT 
        s.customer_id AS customer, m.product_name AS item, s.order_date,DENSE_RANK() OVER ( PARTITION BY s.customer_id ORDER BY s.order_date ASC) AS ranking
        FROM sales AS s
        JOIN menu AS m 
        ON s.product_id = m.product_id
        JOIN members AS mem 
        ON s.customer_id = mem.customer_id
        WHERE s.order_date > mem.join_date
)
SELECT 
    customer, 
    item, 
    order_date
FROM First_Member_Purchase
WHERE ranking = 1;
/*
Key Insight From The Sixth Question:
Customer A ordered ramen after he/she became a member and customer B ordered sushi after he/she became a member
*/

--Seventh Question: Which item was purchased just before the customer became a member?
WITH Before_Items AS (
    SELECT 
        s.customer_id AS customer, m.product_name AS item, s.order_date,DENSE_RANK() OVER ( PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS ranking
        FROM sales AS s
        JOIN menu AS m 
        ON s.product_id = m.product_id
        JOIN members AS mem 
        ON s.customer_id = mem.customer_id
        WHERE s.order_date < mem.join_date
)
SELECT 
    customer, 
    item, 
    order_date
FROM Before_Items
WHERE ranking = 1;
/*
Key Insight From The Seventh Question:
Customer A  ordered curry and sushi just before he/she became a member, customer B ordered sushi just before he/she became a member
and customer C ordered a ramen just before he/she became a member
*/

--Eighth Question: What is the total items and amount spent for each member before they became a member?
SELECT Sales.customer_id AS 'Customer', COUNT(Sales.product_id) AS 'Total Items', SUM(Menu.price) AS 'Total Amount'
FROM Sales JOIN Menu
ON Sales.product_id = Menu.product_id
JOIN Members ON Sales.customer_id = Members.customer_id
WHERE Sales.order_date < Members.join_date
GROUP BY Sales.customer_id;
/*
Key Insight From The Eighth Question:
From this answer, we conclude that Customer B is the most customer spent on items and total prices which we conclude that 
customer B is the most person who wanted to explore this restaurant before he/she became a member.
*/

--Ninth Question: If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT Sales.customer_id AS 'Customer', 
      SUM(CASE WHEN Menu.product_name = 'sushi' THEN Menu.price * 20 ELSE Menu.price * 10 END) AS 'Total Points'
FROM Sales JOIN Menu
ON Sales.product_id = Menu.product_id
GROUP BY Sales.customer_id;
/*
Key Insight From The Ninth Question:
Customer B has the highest points in this restaurant according to his spendings.
*/

--Tenth Question: In the first week after a customer joins the program 
--(including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT Sales.customer_id AS 'Customer', SUM(
CASE WHEN 
   Sales.order_date >= Members.join_date AND Sales.order_date < DATEADD(day, 7, Members.join_date) THEN Menu.price * 20
   WHEN Menu.product_name = 'sushi' THEN Menu.price * 20 ELSE Menu.price * 10 END) AS 'Total Points'
FROM Sales JOIN Menu
ON Sales.product_id = Menu.product_id
JOIN Members ON Sales.customer_id = Members.customer_id
WHERE Sales.order_date <= '2021-01-31' AND Sales.customer_id IN ('A', 'B')
GROUP BY Sales.customer_id;
/*
Key Insight From The Tenth Question:
In this section, customer A earned more than customer B after the feature of 2x points in the first week after join date (including it)
and including the rest of points at the end of January
*/

