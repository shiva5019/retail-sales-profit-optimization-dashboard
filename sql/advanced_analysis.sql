USE retail_analytics;

-- 15. Rank regions by profit
WITH region_profit AS (
    SELECT region, SUM(profit) profit
    FROM fact_sales GROUP BY region
)
SELECT region, profit,
       RANK() OVER (ORDER BY profit DESC) profit_rank
FROM region_profit;

-- 16. Rank products within each category by sales
WITH product_sales AS (
    SELECT category, sub_category, product_id, product_name,
           SUM(sales) sales, SUM(profit) profit
    FROM fact_sales
    GROUP BY category, sub_category, product_id, product_name
)
SELECT *,
       DENSE_RANK() OVER (PARTITION BY category ORDER BY sales DESC) category_sales_rank
FROM product_sales;

-- 17. Month-over-month sales growth
WITH monthly AS (
    SELECT order_year, order_month_number,
           SUM(sales) sales
    FROM fact_sales
    GROUP BY order_year, order_month_number
)
SELECT order_year, order_month_number, sales,
       LAG(sales) OVER (ORDER BY order_year, order_month_number) previous_month_sales,
       (sales - LAG(sales) OVER (ORDER BY order_year, order_month_number))
       / NULLIF(LAG(sales) OVER (ORDER BY order_year, order_month_number),0) * 100 mom_growth_pct
FROM monthly
ORDER BY order_year, order_month_number;

-- 18. Running total sales
WITH monthly AS (
    SELECT order_year, order_month_number, SUM(sales) sales
    FROM fact_sales
    GROUP BY order_year, order_month_number
)
SELECT order_year, order_month_number, sales,
       SUM(sales) OVER (ORDER BY order_year, order_month_number
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_sales
FROM monthly;

-- 19. High-sales / low-profit products
WITH p AS (
    SELECT product_id, product_name, category, sub_category,
           SUM(sales) sales, SUM(profit) profit
    FROM fact_sales
    GROUP BY product_id, product_name, category, sub_category
),
t AS (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sales) OVER () AS median_sales,
           PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY profit) OVER () AS median_profit
    FROM p LIMIT 1
)
SELECT p.*,
       p.profit/NULLIF(p.sales,0) profit_margin
FROM p CROSS JOIN t
WHERE p.sales >= t.median_sales AND p.profit < t.median_profit
ORDER BY p.sales DESC;

-- 20. Performance classification by region
WITH r AS (
    SELECT region, SUM(sales) sales, SUM(profit) profit
    FROM fact_sales GROUP BY region
),
t AS (
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sales) OVER () median_sales,
           PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY profit) OVER () median_profit
    FROM r LIMIT 1
)
SELECT r.*,
CASE
 WHEN r.sales >= t.median_sales AND r.profit >= t.median_profit THEN 'High Sales + High Profit'
 WHEN r.sales >= t.median_sales AND r.profit < t.median_profit THEN 'High Sales + Low Profit'
 WHEN r.sales < t.median_sales AND r.profit >= t.median_profit THEN 'Low Sales + High Profit'
 ELSE 'Low Sales + Low Profit'
END performance_class
FROM r CROSS JOIN t;

-- 21. Discount band profitability
SELECT discount_band, COUNT(DISTINCT order_id) orders,
       SUM(sales) sales, SUM(profit) profit,
       AVG(discount) avg_discount,
       SUM(profit)/NULLIF(SUM(sales),0) profit_margin
FROM fact_sales
GROUP BY discount_band
ORDER BY avg_discount;

-- 22. Sub-category performance
SELECT sub_category, category, SUM(sales) sales, SUM(profit) profit,
       SUM(profit)/NULLIF(SUM(sales),0) profit_margin,
       AVG(discount) avg_discount
FROM fact_sales
GROUP BY sub_category, category
ORDER BY profit DESC;
