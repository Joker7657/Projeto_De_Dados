SELECT
 c.name,
 SUM(total_value) AS total_spent,
 RANK() OVER (ORDER BY SUM(total_value) DESC) AS ranking
FROM fact_sales
JOIN dim_customers c USING(customer_id)
WHERE status='completed'
GROUP BY c.name;
