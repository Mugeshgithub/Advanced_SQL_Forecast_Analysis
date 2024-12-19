-- Create a stored procedure to determine the market badge (Gold or Silver) based on total sold quantity.

DELIMITER 74965

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
END74965

DELIMITER ;
