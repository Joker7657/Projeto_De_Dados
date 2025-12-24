SELECT
 SUM(total_value) AS revenue,
 AVG(total_value) AS avg_ticket,
 COUNT(DISTINCT customer_id) AS active_customers,
 COUNT(*) FILTER (WHERE status='canceled')::float / COUNT(*) AS cancel_rate
FROM fact_sales;
