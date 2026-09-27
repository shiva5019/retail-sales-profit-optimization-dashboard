USE retail_analytics;

-- 1. Overall KPIs
SELECT SUM(sales) total_sales, SUM(profit) total_profit,
       COUNT(DISTINCT order_id) total_orders, SUM(quantity) total_quantity,
       SUM(profit)/NULLIF(SUM(sales),0) profit_margin,
       SUM(sales)/NULLIF(COUNT(DISTINCT order_id),0) average_order_value
FROM fact_sales;

-- 2. Sales and profit by region
SELECT region, SUM(sales) sales, SUM(profit) profit,
       COUNT(DISTINCT order_id) orders,
       SUM(profit)/NULLIF(SUM(sales),0) profit_margin
FROM fact_sales GROUP BY region ORDER BY sales DESC;

-- 3. Sales and profit by category
SELECT category, SUM(sales) sales, SUM(profit) profit,
       COUNT(DISTINCT order_id) orders,
       SUM(profit)/NULLIF(SUM(sales),0) profit_margin
FROM fact_sales GROUP BY category ORDER BY sales DESC;

-- 4. Sales and profit by customer segment
SELECT segment, SUM(sales) sales, SUM(profit) profit,
       COUNT(DISTINCT order_id) orders,
       SUM(profit)/NULLIF(SUM(sales),0) profit_margin
FROM fact_sales GROUP BY segment ORDER BY sales DESC;

-- 5. Top 10 products by sales
SELECT product_id, product_name, category, sub_category,
       SUM(sales) sales, SUM(profit) profit
FROM fact_sales GROUP BY product_id, product_name, category, sub_category
ORDER BY sales DESC LIMIT 10;

-- 6. Top 10 products by profit
SELECT product_id, product_name, category, sub_category,
       SUM(sales) sales, SUM(profit) profit
FROM fact_sales GROUP BY product_id, product_name, category, sub_category
ORDER BY profit DESC LIMIT 10;

-- 7. Bottom 10 products by profit
SELECT product_id, product_name, category, sub_category,
       SUM(sales) sales, SUM(profit) profit
FROM fact_sales GROUP BY product_id, product_name, category, sub_category
ORDER BY profit LIMIT 10;

-- 8. States with negative profit
SELECT state_province, SUM(sales) sales, SUM(profit) profit,
       SUM(profit)/NULLIF(SUM(sales),0) profit_margin
FROM fact_sales GROUP BY state_province HAVING SUM(profit) < 0
ORDER BY profit;

-- 9. Cities with negative profit
SELECT city, state_province, region, SUM(sales) sales, SUM(profit) profit
FROM fact_sales GROUP BY city, state_province, region
HAVING SUM(profit) < 0 ORDER BY profit;

-- 10. Profit margin by category
SELECT category, SUM(profit)/NULLIF(SUM(sales),0) profit_margin
FROM fact_sales GROUP BY category ORDER BY profit_margin DESC;

-- 11. Profit margin by region
SELECT region, SUM(profit)/NULLIF(SUM(sales),0) profit_margin
FROM fact_sales GROUP BY region ORDER BY profit_margin DESC;

-- 12. Average order value by segment
SELECT segment,
       SUM(sales)/NULLIF(COUNT(DISTINCT order_id),0) average_order_value
FROM fact_sales GROUP BY segment ORDER BY average_order_value DESC;

-- 13. Average shipping time by ship mode
SELECT ship_mode, AVG(shipping_days) avg_shipping_days,
       COUNT(DISTINCT order_id) orders
FROM fact_sales GROUP BY ship_mode ORDER BY avg_shipping_days;

-- 14. Monthly sales and profit
SELECT order_year, order_month_number, order_month,
       SUM(sales) sales, SUM(profit) profit
FROM fact_sales
GROUP BY order_year, order_month_number, order_month
ORDER BY order_year, order_month_number;
