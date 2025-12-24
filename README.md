# Advanced SQL Data Analytics — Data Engineering + BI Project

Este é um projeto completo de SQL nível profissional, demonstrando:

✔️ ETL (Raw → Staging → Data Warehouse)
✔️ Limpeza e Tratamento de Dados
✔️ Data Quality
✔️ Modelagem Dimensional (Star Schema)
✔️ Analytics Avançado (KPI, RFM, Cohort, Window Functions)
✔️ Performance (Índices)

Banco sugerido: PostgreSQL

------------------------------------

## ▶️ Como Rodar

1️⃣ Criar banco:
psql -U postgres -c "CREATE DATABASE advanced_sql;"

2️⃣ Criar tabelas RAW
psql -d advanced_sql -f database/schema_raw.sql

3️⃣ Inserir dados
psql -d advanced_sql -f database/insert_raw.sql

4️⃣ Criar STAGING
psql -d advanced_sql -f database/schema_staging.sql

5️⃣ Executar limpeza
psql -d advanced_sql -f etl/cleaning.sql

6️⃣ Data Quality Checks
psql -d advanced_sql -f etl/data_quality_checks.sql

7️⃣ Criar Data Warehouse
psql -d advanced_sql -f database/schema_dw.sql

8️⃣ Carregar DW
psql -d advanced_sql -f etl/dw_load.sql

9️⃣ Criar índices
psql -d advanced_sql -f database/indexes.sql

🔟 Rodar análises
psql -d advanced_sql -f analytics/kpis.sql

------------------------------------

## 🎯 Objetivo
Simular um pipeline real de dados de vendas, tratando dados sujos,
garantindo qualidade e gerando insights de negócio avançados.

------------------------------------

## Tecnologias
- PostgreSQL
- SQL Avançado
- Data Engineering
- Business Intelligence

------------------------------------

## Estrutura de Dados
Raw → Staging → Data Warehouse → Analytics
