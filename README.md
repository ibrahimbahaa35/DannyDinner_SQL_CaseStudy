# 🍜 Case Study #1: Danny's Diner

## 📖 Introduction
Danny seriously loves Japanese food, so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his three favorite foods: sushi, curry, and ramen. 

Danny’s Diner is in need of your assistance to help the restaurant stay afloat. The restaurant has captured some very basic data from their few months of operation but has no idea how to use their data to help them run the business.

This project utilizes SQL to answer Danny's business questions about his customers' visiting patterns, how much money they’ve spent, and which menu items are their favorite.

---

## 📂 Repository Contents
* **`CaseStudy1_DannyDinner.sql`**: The complete SQL script containing the database creation, table setup, data insertion, and all queries used to answer the case study questions.

---

## 🗄️ Database Schema
The database (`DannyDinner`) consists of three key tables:

1. **`Menu`**: Maps the `product_id` to the actual `product_name` and `price` of each menu item.
2. **`Members`**: Captures the `join_date` when a `customer_id` joined the beta version of the Danny’s Diner loyalty program.
3. **`Sales`**: Captures all `customer_id` level purchases with a corresponding `order_date` and `product_id` information for when and what menu items were ordered.

---

## 💡 Key Questions & Insights

Below is a summary of the business questions answered in this case study, along with the key insights discovered from the data. For the exact SQL queries used, please refer to the `CaseStudy1_DannyDinner.sql` file.

### 1. What is the total amount each customer spent at the restaurant?
* **Insight:** Customer A is the top spender with a total of $76, while Customer C spent the least at $36.

### 2. How many days has each customer visited the restaurant?
* **Insight:** Customer B is the most frequent visitor. This suggests a strong affinity for the restaurant's atmosphere, products, or pricing. Customer C visited the least.

### 3. What was the first item from the menu purchased by each customer?
* **Insight:** Curry was the most common first item ordered, indicating it might be a popular introductory dish for new customers trying the restaurant.

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
* **Insight:** Ramen is the undisputed best-seller, purchased 8 times. It delivers a great customer experience and receives high praise from diners.

### 5. Which item was the most popular for each customer?
* **Insight:** Customers A and C heavily favor ramen, making it their absolute favorite dish. Customer B enjoys variety and orders all dishes equally. Overall, ramen remains the most popular dish.

### 6. Which item was purchased first by the customer after they became a member?
* **Insight:** Immediately after joining the loyalty program, Customer A ordered ramen, and Customer B ordered sushi.

### 7. Which item was purchased just before the customer became a member?
* **Insight:** Just prior to membership, Customer A ordered curry and sushi, Customer B ordered sushi, and Customer C ordered ramen.

### 8. What is the total items and amount spent for each member before they became a member?
* **Insight:** Customer B bought the most items and spent the most money prior to becoming a member, showing they thoroughly explored the menu before committing to the loyalty program.

### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
* **Insight:** Based on this points system, Customer B accumulated the highest total points due to their overall spending and item choices.

### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
* **Insight:** With the first-week 2x multiplier applied, Customer A overtook Customer B in total points by the end of January, maximizing their rewards during that promotional window.

---

## 🛠️ Tools & Technologies Used
* **SQL Dialect:** T-SQL (SQL Server) 
* **Key Techniques Used:** `JOIN` operations, Aggregate Functions (`SUM`, `COUNT`), Common Table Expressions (`WITH` CTEs), Window Functions (`DENSE_RANK()`), `CASE` statements, and Date Functions (`DATEADD`).
