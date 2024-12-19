-- Generate a yearly report for Croma India customers with fiscal year and total gross sales.

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
    fiscal_year ASC;
