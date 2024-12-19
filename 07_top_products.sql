-- Get the top N products by net sales for a given year, excluding variants.

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
    5;
