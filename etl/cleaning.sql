-- Remover duplicados
DELETE FROM raw_sales
WHERE ctid NOT IN (
 SELECT MIN(ctid)
 FROM raw_sales
 GROUP BY sale_id, customer_name, product_name, sale_date
);

-- Padronizar status
UPDATE raw_sales
SET status = LOWER(status);

-- Padronizar estados
UPDATE raw_sales
SET state = UPPER(state);

-- Inserir na staging já convertendo tipos e datas
INSERT INTO staging_sales
SELECT
 sale_id::INT,
 customer_name,
 product_name,

 CASE
   WHEN sale_date ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE(sale_date,'DD/MM/YYYY')
   WHEN sale_date ~ '^\d{4}/\d{2}/\d{2}$' THEN TO_DATE(sale_date,'YYYY/MM/DD')
   WHEN sale_date ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(sale_date,'YYYY-MM-DD')
   WHEN sale_date ~ '^\d{2}-\d{2}-\d{4}$' THEN TO_DATE(sale_date,'MM-DD-YYYY')
   ELSE NULL
 END as sale_date,

 NULLIF(quantity,'')::INT,
 NULLIF(total_value,'')::NUMERIC(10,2),
 status,
 state
FROM raw_sales;

-- Remover registros inválidos
DELETE FROM staging_sales
WHERE total_value IS NULL
OR quantity IS NULL;
