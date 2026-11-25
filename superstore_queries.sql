-- Superstore retail project: SQL (MySQL)
-- Table: superstore  (9,977 rows after cleaning)

-- 0) Create the table and load the cleaned CSV
CREATE TABLE superstore (
  row_id INT PRIMARY KEY,
  ship_mode VARCHAR(30), segment VARCHAR(30), country VARCHAR(30),
  city VARCHAR(60), state VARCHAR(40), postal_code CHAR(5), region VARCHAR(20),
  category VARCHAR(30), sub_category VARCHAR(30),
  sales DECIMAL(12,4), quantity INT, discount DECIMAL(4,2), profit DECIMAL(12,4),
  discount_band VARCHAR(20), is_loss TINYINT
);
-- LOAD DATA LOCAL INFILE 'superstore_clean.csv' INTO TABLE superstore
--   FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Q1) Overall KPIs
SELECT COUNT(*) AS order_lines,
       ROUND(SUM(sales),2) AS total_sales,
       ROUND(SUM(profit),2) AS total_profit,
       ROUND(100*SUM(profit)/SUM(sales),2) AS profit_margin_pct
FROM superstore;

-- Q2) Which categories make money, and at what margin?
SELECT category,
       ROUND(SUM(sales),0) AS sales,
       ROUND(SUM(profit),0) AS profit,
       ROUND(100*SUM(profit)/SUM(sales),1) AS margin_pct
FROM superstore
GROUP BY category
ORDER BY profit DESC;

-- Q3) Which sub-categories lose money?
SELECT sub_category,
       ROUND(SUM(sales),0) AS sales,
       ROUND(SUM(profit),0) AS profit,
       ROUND(100*SUM(profit)/SUM(sales),1) AS margin_pct
FROM superstore
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY profit;

-- Q4) Which regions perform best and worst?
SELECT region,
       ROUND(SUM(sales),0) AS sales,
       ROUND(SUM(profit),0) AS profit,
       ROUND(100*SUM(profit)/SUM(sales),1) AS margin_pct
FROM superstore
GROUP BY region
ORDER BY profit DESC;

-- Q5) The 5 states with the lowest profit
SELECT state,
       ROUND(SUM(sales),0) AS sales,
       ROUND(SUM(profit),0) AS profit
FROM superstore
GROUP BY state
ORDER BY SUM(profit)
LIMIT 5;

-- Q6) How does discounting affect profit?
SELECT discount_band,
       COUNT(*) AS order_lines,
       SUM(is_loss) AS loss_making_lines,
       ROUND(SUM(sales),0) AS sales,
       ROUND(SUM(profit),0) AS profit
FROM superstore
GROUP BY discount_band
ORDER BY MIN(discount);
