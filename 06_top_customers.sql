-- Top 5 customers by net sales.

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
    5;
