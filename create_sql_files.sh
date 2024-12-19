#!/bin/bash

# File 1: Monthly Gross Sales
echo "-- Generate an aggregate monthly gross sales report for Croma India customers.

SELECT 
    s.date,
    SUM(ROUND(gp.gross_price * s.sold_quantity, 2)) AS gross_price_total
FROM 
    fact_sales_monthly s
JOIN 
    fact_gross_price gp 
    ON s.product_code = gp.product_code 
    AND gp.fiscal_year = get_fiscal_year(s.date)
WHERE 
    customer_code = 90002002
GROUP BY 
    s.date
ORDER BY 
    date ASC
LIMIT 
    100000;" > 02_monthly_gross_sales.sql

# File 2: Yearly Gross Sales
echo "-- Generate a yearly report for Croma India customers with fiscal year and total gross sales.

SELECT 
    get_fiscal_year(s.date) AS fiscal_year, 
    ROUND(SUM(gp.gross_price * s.sold_quantity), 2) AS total_gross_sales
FROM 
    fact_sales_monthly s
JOIN 
    fact_gross_price gp 
    ON s.product_code = gp.product_code 
    AND gp.fiscal_year = get_fiscal_year(s.date)
WHERE 
    s.customer_code = 90002002 -- Croma India customer code
GROUP BY 
    get_fiscal_year(s.date)
ORDER BY 
    fiscal_year ASC;" > 03_yearly_gross_sales.sql

# File 3: Market Badge Procedure
echo "-- Create a stored procedure to determine the market badge (Gold or Silver) based on total sold quantity.

DELIMITER $$

CREATE PROCEDURE MarketBadge(IN input_market VARCHAR(255), IN input_fiscal_year INT, OUT badge VARCHAR(50))
BEGIN
    DECLARE total_sold INT;

    SELECT 
        SUM(sold_quantity) 
    INTO 
        total_sold
    FROM 
        fact_sales_monthly
    WHERE 
        market = input_market
        AND fiscal_year = input_fiscal_year;

    IF total_sold > 5000000 THEN
        SET badge = 'Gold';
    ELSE
        SET badge = 'Silver';
    END IF;
END$$

DELIMITER ;" > 04_market_badge_procedure.sql

# File 4: Top 5 Markets
echo "-- Top 5 markets by net sales for fiscal year 2021.

SELECT 
    market,
    ROUND(SUM(net_sales / 1000000), 2) AS netsales
FROM 
    net_sales
WHERE 
    fiscal_year = 2021
GROUP BY 
    market
ORDER BY 
    netsales DESC
LIMIT 
    5;" > 05_top_markets.sql

# File 5: Top 5 Customers
echo "-- Top 5 customers by net sales.

SELECT 
    c.customer,
    ROUND(SUM(s.net_sales / 1000000), 2) AS netsales
FROM 
    net_sales s
JOIN 
    dim_customer c 
    ON s.customer_code = c.customer_code 
    AND s.market = c.market
GROUP BY 
    customer
ORDER BY 
    netsales DESC
LIMIT 
    5;" > 06_top_customers.sql

# File 6: Top N Products
echo "-- Get the top N products by net sales for a given year, excluding variants.

SELECT 
    p.product,
    ROUND(SUM(s.net_sales / 1000000), 2) AS netsales
FROM 
    net_sales s
JOIN 
    dim_product p 
    ON s.customer_code = p.customer_code
    AND s.variant = p.variant
GROUP BY 
    p.product
ORDER BY 
    netsales DESC
LIMIT 
    5;" > 07_top_products.sql
