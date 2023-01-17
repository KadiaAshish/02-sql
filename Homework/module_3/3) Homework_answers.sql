-- AGGREGATE
/* 1. Write a query that determines how many times each vendor has rented a booth 
at the farmer’s market by counting the vendor booth assignments per vendor_id. */

SELECT
vendor_id,
count(*) AS count_of_booth_assignments
FROM vendor_booth_assignments
GROUP BY vendor_id

/* 2. Using your cherry pie query, show how much money each customer has spent on cherry pies. */

SELECT DISTINCT
customer_first_name,
customer_last_name,
product_name,
SUM(quantity * cost_to_customer_per_qty) AS cherry_pie_addiction

FROM customer_purchases cp 
JOIN customer c
	ON c.customer_id = cp.customer_id
JOIN product p 
	ON cp.product_id = p.product_id

WHERE p.product_id = 8
GROUP BY customer_first_name,
customer_last_name,
product_name
ORDER BY cherry_pie_addiction DESC

/* 3. The Farmer’s Market Customer Appreciation Committee wants to give a bumper 
sticker to everyone who has ever spent more than $50 at the market. Write a query that generates a list 
of customers for them to give stickers to, sorted by last name, then first name. 
(HINT: This query requires you to join two tables, use an aggregate function, and use the HAVING keyword.) */

SELECT
cp.customer_id,
c.customer_first_name,
c.customer_last_name,
SUM(quantity * cost_to_customer_per_qty) AS total_spent

FROM customer c
LEFT JOIN farmers_market.customer_purchases cp
    ON c.customer_id = cp.customer_id

GROUP BY
cp.customer_id,
c.customer_first_name,
c.customer_last_name

HAVING total_spent > 50

ORDER BY c.customer_last_name, c.customer_first_name

--Temp Table
/* 1. Insert the original vendor table into a temp.new_vendor and then add a 10th vendor: 
Thomass Superfood Store, a Fresh Focused store, owned by Thomas Rosenthal
HINT: This is two total queries -- first create the table from the original, then insert the new 10th vendor. 
When inserting the new vendor, you need to appropriately align the columns to be inserted 
(there are five columns to be inserted, I've given you the details, but not the syntax) */

CREATE TABLE temp.new_vendor AS
SELECT * FROM vendor

INSERT INTO temp.new_vendor
VALUES (10, "Thomass Superfood Store" , "Fresh Focused", "Thomas", "Rosenthal")


-- Date
/*1. Get the customer_id, month, and year (in separate columns) of every purchase in the customer_purchases table.
HINT: you might need to search for strfrtime modifers sqlite on the web to know what the modifers for month and year are! */

SELECT customer_id,
STRFTIME('%m',market_date) AS purchase_month,
STRFTIME('%Y', market_date) AS purchase_year

FROM customer_purchases

/* 2. What if we wanted to add each purchase month as another windowed group from previous our rolling totals query? */

SELECT
STRFTIME('%w', market_date),
STRFTIME('%H', transaction_time),
COUNT(customer_id)

FROM customer_purchases

GROUP BY STRFTIME('%w', market_date),  STRFTIME('%H', transaction_time)