CREATE TABLE dim_customers (
    customer_id SERIAL PRIMARY KEY,
    name TEXT,
    state CHAR(2)
);

CREATE TABLE dim_products (
    product_id SERIAL PRIMARY KEY,
    name TEXT,
    category TEXT
);

CREATE TABLE dim_date (
    date DATE PRIMARY KEY,
    year INT,
    month INT,
    quarter INT
);

CREATE TABLE fact_sales (
    sale_id INT PRIMARY KEY,
    customer_id INT REFERENCES dim_customers(customer_id),
    product_id INT REFERENCES dim_products(product_id),
    sale_date DATE REFERENCES dim_date(date),
    quantity INT,
    total_value NUMERIC(10,2),
    status TEXT
);
