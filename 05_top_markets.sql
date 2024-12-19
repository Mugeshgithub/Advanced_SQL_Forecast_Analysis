-- Top 5 markets by net sales for fiscal year 2021.

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
    5;
