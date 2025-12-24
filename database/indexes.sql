CREATE INDEX idx_sales_date ON fact_sales(sale_date);
CREATE INDEX idx_sales_customer ON fact_sales(customer_id);
CREATE INDEX idx_sales_status ON fact_sales(status);
