SELECT SUM(CAST(REPLACE(product_price,'£','')AS DECIMAL)* "Product Quantity")AS Revenue,
       store_type
FROM dim_products AS P
JOIN orders_powerbi AS O
ON O.product_code=P.product_code
JOIN dim_stores as S
ON S."store code"=O."Store Code"
WHERE country_code='DE' AND EXTRACT(YEAR FROM TO_TIMESTAMP(O."Order Date", 'YYYY-MM-DD HH24:MI:SS')) = 2022
GROUP BY store_type
ORDER BY Revenue DESC
LIMIT 1;