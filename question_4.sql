

CREATE OR REPLACE VIEW sales_summary_by_store_type AS
WITH total_sales_cte AS
(SELECT SUM(CAST(REPLACE(product_price,'£','') AS DECIMAL)* "Product Quantity") AS total_sales
 FROM dim_products AS P2
 JOIN orders_powerbi AS O2
 ON P2.product_code=O2.product_code)
SELECT store_type,
       SUM(CAST(REPLACE(product_price,'£','')AS DECIMAL)*"Product Quantity") AS SALES,
       COUNT(*) AS total_orders,
       (SUM(CAST(REPLACE(product_price,'£','')AS DECIMAL)* "Product Quantity")/(SELECT total_sales FROM total_sales_cte))*100 AS sales_percentage
FROM dim_stores AS S
JOIN orders_powerbi AS O
ON S."store code"=O."Store Code"
JOIN dim_products AS P
ON P.product_code=O.product_code
GROUP BY store_type;

SELECT * FROM sales_summary_by_store_type;





