SELECT
 SUM(CASE WHEN sale_date IS NULL THEN 1 END) AS null_dates,
 SUM(CASE WHEN customer_name IS NULL THEN 1 END) AS null_names,
 SUM(CASE WHEN total_value <= 0 THEN 1 END) AS invalid_values
FROM staging_sales;

SELECT DISTINCT state FROM staging_sales;
