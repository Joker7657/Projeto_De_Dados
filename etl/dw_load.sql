INSERT INTO dim_customers(name,state)
SELECT DISTINCT customer_name,state
FROM staging_sales
WHERE customer_name IS NOT NULL;

INSERT INTO dim_products(name,category)
SELECT DISTINCT product_name,
CASE
 WHEN product_name IN ('Mouse','Teclado') THEN 'Acessórios'
 ELSE 'Eletrônicos'
END
FROM staging_sales;

INSERT INTO dim_date(date,year,month,quarter)
SELECT DISTINCT
 sale_date,
 EXTRACT(YEAR FROM sale_date),
 EXTRACT(MONTH FROM sale_date),
 EXTRACT(QUARTER FROM sale_date)
FROM staging_sales
WHERE sale_date IS NOT NULL;

INSERT INTO fact_sales
SELECT
 s.sale_id,
 c.customer_id,
 p.product_id,
 s.sale_date,
 s.quantity,
 s.total_value,
 s.status
FROM staging_sales s
JOIN dim_customers c ON c.name = s.customer_name
JOIN dim_products p ON p.name = s.product_name
WHERE s.sale_date IS NOT NULL;
