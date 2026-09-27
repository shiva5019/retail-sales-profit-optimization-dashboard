CREATE DATABASE IF NOT EXISTS retail_analytics;
USE retail_analytics;

DROP TABLE IF EXISTS fact_sales;
CREATE TABLE fact_sales (
    row_id INT,
    order_id VARCHAR(30),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(30),
    customer_id VARCHAR(30),
    customer_name VARCHAR(150),
    segment VARCHAR(30),
    country_region VARCHAR(100),
    city VARCHAR(100),
    state_province VARCHAR(100),
    postal_code INT NULL,
    region VARCHAR(30),
    product_id VARCHAR(40),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(14,4),
    quantity INT,
    discount DECIMAL(8,4),
    profit DECIMAL(14,4),
    shipping_days INT NULL,
    order_year INT,
    order_month_number INT,
    order_month VARCHAR(10),
    order_quarter VARCHAR(5),
    profit_margin DECIMAL(12,6),
    sales_per_unit DECIMAL(14,6),
    profit_per_unit DECIMAL(14,6),
    discount_band VARCHAR(20),
    order_count INT,
    order_aov DECIMAL(14,4),
    PRIMARY KEY (row_id)
);
