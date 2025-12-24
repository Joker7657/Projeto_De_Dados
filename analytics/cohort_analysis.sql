WITH first_purchase AS (
 SELECT customer_id, MIN(sale_date) AS cohort
 FROM fact_sales
 WHERE status='completed'
 GROUP BY customer_id
),
activity AS (
 SELECT
  f.customer_id,
  DATE_TRUNC('month', fp.cohort) AS cohort_month,
  DATE_TRUNC('month', f.sale_date) AS purchase_month
 FROM fact_sales f
 JOIN first_purchase fp USING(customer_id)
)
SELECT
 cohort_month,
 purchase_month,
 COUNT(DISTINCT customer_id)
FROM activity
GROUP BY cohort_month,purchase_month
ORDER BY cohort_month,purchase_month;
