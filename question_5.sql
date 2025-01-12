SELECT SUM(CAST(REPLACE(product_price,'£','')AS DECIMAL)*"Product Quantity") AS profit,
       category
FROM dim_products AS P
JOIN orders_powerbi AS O
ON P.product_code=O.product_code
JOIN dim_stores as S
ON S."store code"=O."Store Code"
WHERE country_region='Wiltshire' AND EXTRACT(YEAR FROM TO_TIMESTAMP(O."Order Date", 'YYYY-MM-DD HH24:MI:SS')) = 2021
GROUP BY category
ORDER BY profit DESC
LIMIT 1;