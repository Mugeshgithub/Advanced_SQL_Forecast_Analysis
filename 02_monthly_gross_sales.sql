-- Generate an aggregate monthly gross sales report for Croma India customers.

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
    100000;
