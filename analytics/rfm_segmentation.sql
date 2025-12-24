WITH base AS (
 SELECT
  customer_id,
  MAX(sale_date) AS last_purchase,
  COUNT(*) AS frequency,
  SUM(total_value) AS monetary
 FROM fact_sales
 WHERE status='completed'
 GROUP BY customer_id
)
SELECT *,
 NTILE(3) OVER (ORDER BY last_purchase DESC) AS R,
 NTILE(3) OVER (ORDER BY frequency DESC) AS F,
 NTILE(3) OVER (ORDER BY monetary DESC) AS M
FROM base;
