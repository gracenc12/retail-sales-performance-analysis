# ----------------------------  Walmart Sales Analysis with SQL ---------------------------
# --- Dataset: https://www.kaggle.com/datasets/najir0123/walmart-10k-sales-datasets ---

USE walmart_db;

SELECT 
    COUNT(*)
FROM
    walmart;

SELECT 
    *
FROM
    walmart;

SELECT 
    payment_method,
    COUNT(invoice_id) AS transaction_counts,
    SUM(quantity) AS qty_sold
FROM
    walmart
GROUP BY payment_method
ORDER BY transaction_counts DESC , qty_sold DESC;

# Credit card is the most used and popular payment method, the second is Ewallet and third is cash.
# The customer prefers cashless payment for transactions in the Walmart

# --- Question 2: What is the most frequently used payment method in each brach

SELECT * 
FROM
(SELECT 
branch,
payment_method,
count(invoice_id) as total_transactions,
RANK() OVER (PARTITION BY branch ORDER BY count(invoice_id) DESC) as ranking
FROM walmart
GROUP BY branch, payment_method) as payment_rank
WHERE ranking = 1;

# Different Branch has different payment method preference.
# The most of frequent used payment method of the braches are Ewallet and Credit Card.

# --------------------------------------------------------------------------------

# B. PRODUCT CATEGORY PERFORMANCE, PROFITABILITY AND CUSTOMER SATISFACTION
# --- Question 3: What is the min, max and avg rating of each category in each branch?

SELECT * 
FROM
(SELECT 
    branch, 
    category, 
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating,
    RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS ranking
FROM
    walmart
GROUP BY branch, category) AS rating
WHERE ranking = 1;

# Each brach has different popular and highest average rating of product categories

# Question 4: What is the total profit of each categories? Which product categories generate the highest revenue and total profit?

SELECT 
    category,
    SUM(total_amount) AS revenue,
    SUM(total_amount * profit_margin) AS profit_category
FROM
    walmart
GROUP BY category
ORDER BY revenue DESC, profit_category DESC;

# Fashion accessories has the highest revenue and total profit

# -------------------------------------------------------------------------

# C. OPERATIONAL DEMAND & TIME BASED SALES PATTERN
# --- Question 5: What is the busiest day of the week for each branch based on transaction volume?

SELECT
*
FROM
(SELECT
	branch,
    DAYNAME(date) AS day_name,
    count(invoice_id) AS no_of_transactions,
    RANK() OVER (PARTITION BY branch ORDER BY count(invoice_id) DESC) AS day_rank
FROM walmart
GROUP BY branch, day_name) as busy_day
WHERE day_rank = 1;

# Different Brach has different busiest day

# --- Question 5: What is the busiest time of the week for each branch based on transaction volume?

SELECT 
* 
FROM
(SELECT
branch,
CASE WHEN HOUR(time) < 12 THEN 'Morning'
WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN HOUR(time) BETWEEN 17 AND 20 THEN 'Evening'
ELSE 'Night'
END AS time_period,
COUNT(invoice_id) AS total_transactions,
RANK() OVER(PARTITION BY branch ORDER BY COUNT(invoice_id) DESC) AS time_rank
FROM walmart
GROUP BY branch, time_period) busy_time
WHERE time_rank = 1;

# Different branch has the different busiest time and most of the branch is busiest at afternoon and evening.

# ------------------------------------------------------------------------------

# SALES PERFORMANCE ACROSS BRANCH AND CITIES
# ---  Question 6: Which cities and branch contribute the most to total revenue?

SELECT 
    city,
    SUM(total_amount) AS revenue
FROM
    walmart
GROUP BY city
ORDER BY revenue DESC;

# Weslaco is the city contribute the most to the revenue

SELECT 
    branch,
    SUM(total_amount) AS revenue
FROM
    walmart
GROUP BY branch
ORDER BY revenue DESC;

# WALM009 is the branch contribute the most to the revenue