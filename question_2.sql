

SELECT SUM(CAST(REPLACE(product_price,'£','')AS DECIMAL)* "Product Quantity") AS Revenue,
       EXTRACT(MONTH FROM TO_TIMESTAMP(O."Order Date", 'YYYY-MM-DD HH24:MI:SS'))
FROM dim_products AS P
JOIN orders_powerbi AS O
ON O.product_code=P.product_code
WHERE EXTRACT(YEAR FROM TO_TIMESTAMP(O."Order Date", 'YYYY-MM-DD HH24:MI:SS')) = 2021
GROUP BY EXTRACT(MONTH FROM TO_TIMESTAMP(O."Order Date", 'YYYY-MM-DD HH24:MI:SS'))
ORDER BY Revenue DESC
LIMIT 1;


