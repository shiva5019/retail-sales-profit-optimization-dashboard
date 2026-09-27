USE retail_analytics;

-- Option A: import data/superstore_cleaned.csv using MySQL Workbench's Table Data Import Wizard.
-- Option B: after placing the CSV on a MySQL-accessible path, use LOAD DATA LOCAL INFILE.
-- Update the path for your machine.

LOAD DATA LOCAL INFILE 'PATH_TO/superstore_cleaned.csv'
INTO TABLE fact_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
row_id, order_id, @order_date, @ship_date, ship_mode, customer_id, customer_name,
segment, country_region, city, state_province, @postal_code, region, product_id,
category, sub_category, product_name, sales, quantity, discount, profit,
shipping_days, order_year, order_month_number, order_month, order_quarter,
profit_margin, sales_per_unit, profit_per_unit, discount_band, order_count, order_aov
)
SET order_date = STR_TO_DATE(@order_date, '%Y-%m-%d'),
    ship_date = STR_TO_DATE(@ship_date, '%Y-%m-%d'),
    postal_code = NULLIF(@postal_code,'');
