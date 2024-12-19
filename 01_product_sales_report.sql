-- Generate a report of individual product sales (aggregated on a monthly basis at the product code level) 
-- for Croma India customers for FY=2021.

SELECT 
    s.date,
    s.customer_code,
    p.product_code,
    p.product AS name,
    p.variant,
    s.sold_quantity,
    gp.gross_price AS gross_price_per_item,
    ROUND(gp.gross_price * s.sold_quantity, 2) AS gross_price_total
FROM 
    fact_sales_monthly s
JOIN 
    dim_product p ON s.product_code = p.product_code
JOIN 
    fact_gross_price gp 
    ON s.product_code = gp.product_code 
    AND gp.fiscal_year = get_fiscal_year(s.date)
WHERE 
    customer_code = 90002002 
    AND get_fiscal_year(s.date) = 2021
ORDER BY 
    date ASC
LIMIT 
    100000;	
