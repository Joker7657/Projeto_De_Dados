WITH monthly AS (
 SELECT
  year,
  month,
  SUM(total_value) AS revenue
 FROM fact_sales
 JOIN dim_date ON sale_date = date
 WHERE status='completed'
 GROUP BY year,month
)
SELECT *,
 revenue - LAG(revenue) OVER (ORDER BY year,month) AS difference,
 ROUND((revenue / LAG(revenue) OVER (ORDER BY year,month) -1)*100,2) AS growth_percent
FROM monthly;
