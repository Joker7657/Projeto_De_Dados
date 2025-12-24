## 🎯 Sobre o Projeto

Este projeto implementa um **pipeline completo de Data Engineering**, simulando um ambiente real de análise de dados de vendas. Demonstra competências essenciais para profissionais de dados:

- **ETL Pipeline**: Extract, Transform, Load com tratamento de dados sujos
- **Data Quality**: Validações e garantia de qualidade dos dados
- **Data Warehouse**: Modelagem dimensional (Star Schema)
- **Advanced Analytics**: KPIs, RFM, Cohort Analysis, Window Functions
- **Performance**: Otimização com índices estratégicos

**Caso de Uso**: Sistema de análise de vendas com dados provenientes de múltiplas fontes (APIs, Excel, sistemas legados) que precisam ser consolidados, limpos e estruturados para análise.

---

---

## 🏗️ Arquitetura

O projeto segue uma arquitetura em camadas moderna para processamento de dados:

```
┌─────────────────┐     ┌─────────────────┐     ┌──────────────────┐     ┌──────────────┐
│   LAYER 1       │     │   LAYER 2       │     │   LAYER 3        │     │   LAYER 4    │
│   RAW DATA      │ --> │   STAGING       │ --> │ DATA WAREHOUSE   │ --> │  ANALYTICS   │
├─────────────────┤     ├─────────────────┤     ├──────────────────┤     ├──────────────┤
│ • Dados brutos  │     │ • Limpeza       │     │ • Star Schema    │     │ • KPIs       │
│ • Sem tipagem   │     │ • Validação     │     │ • Dimensões      │     │ • RFM        │
│ • Inconsistente │     │ • Padronização  │     │ • Fatos          │     │ • Cohorts    │
│ • Duplicados    │     │ • Conversão     │     │ • Otimizado      │     │ • Growth     │
└─────────────────┘     └─────────────────┘     └──────────────────┘     └──────────────┘
```

### Fluxo de Dados

1. **RAW**: Ingestão de dados "sujos" em formato TEXT
2. **STAGING**: Limpeza, padronização e validação
3. **DATA WAREHOUSE**: Modelagem dimensional (Star Schema)
4. **ANALYTICS**: Consultas analíticas e geração de insights

---

## 💻 Tecnologias

| Tecnologia | Versão | Uso |
|------------|--------|-----|
| **PostgreSQL** | 15+ | Database principal |
| **SQL** | ANSI SQL | Queries e transformações |
| **Docker** | Latest | Containerização (opcional) |

**Conceitos Aplicados:**
- ETL (Extract, Transform, Load)
- Star Schema / Dimensional Modeling
- Window Functions & CTEs
- Data Quality & Governance
- Performance Optimization

---

## 🚀 Instalação e Execução

### Pré-requisitos

- PostgreSQL 12+ instalado
- Acesso ao usuário `postgres`

### Opção 1: PostgreSQL Local

```bash
# 1. Criar banco de dados
psql -U postgres -c "CREATE DATABASE advanced_sql;"

# 2. Executar pipeline completo
cd /path/to/project

# Layer 1: RAW
psql -d advanced_sql -f database/schema_raw.sql
psql -d advanced_sql -f database/insert_raw.sql

# Layer 2: STAGING
psql -d advanced_sql -f database/schema_staging.sql
psql -d advanced_sql -f etl/cleaning.sql
psql -d advanced_sql -f etl/data_quality_checks.sql

# Layer 3: DATA WAREHOUSE
psql -d advanced_sql -f database/schema_dw.sql
psql -d advanced_sql -f etl/dw_load.sql
psql -d advanced_sql -f database/indexes.sql

# Layer 4: ANALYTICS
psql -d advanced_sql -f analytics/kpis.sql
psql -d advanced_sql -f analytics/rfm_segmentation.sql
psql -d advanced_sql -f analytics/cohort_analysis.sql
psql -d advanced_sql -f analytics/revenue_growth.sql
psql -d advanced_sql -f analytics/window_functions.sql
```

### Opção 2: Docker

```bash
# Iniciar container PostgreSQL
docker run --name postgres-analytics \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 -d postgres:latest

# Executar scripts
docker exec -i postgres-analytics psql -U postgres -c "CREATE DATABASE advanced_sql;"
docker exec -i postgres-analytics psql -U postgres -d advanced_sql < database/schema_raw.sql
# ... (continuar com demais scripts)
```

---

## 📁 Estrutura do Projeto

```
.
├── database/
│   ├── schema_raw.sql          # Tabela de dados brutos
│   ├── insert_raw.sql          # Dados de exemplo com problemas
│   ├── schema_staging.sql      # Tabela intermediária
│   ├── schema_dw.sql           # Data Warehouse (Star Schema)
│   └── indexes.sql             # Índices de performance
│
├── etl/
│   ├── cleaning.sql            # Limpeza e transformação
│   ├── data_quality_checks.sql # Validações de qualidade
│   └── dw_load.sql             # Carga no DW
│
├── analytics/
│   ├── kpis.sql                # Indicadores-chave
│   ├── rfm_segmentation.sql    # Segmentação RFM
│   ├── cohort_analysis.sql     # Análise de cohorts
│   ├── revenue_growth.sql      # Crescimento de receita
│   └── window_functions.sql    # Rankings e análises
│
└── README.md
```

---

## 📊 Detalhamento das Camadas

### Layer 1: RAW Data

**Objetivo**: Receber dados brutos sem transformação

**Características:**
- Todos os campos são `TEXT`
- Dados propositalmente "sujos" para simular cenário real
- Problemas inclusos: duplicatas, formatos inconsistentes, valores nulos

**Exemplo de problemas:**
```sql
-- Datas em múltiplos formatos
'10-01-2024', '15/02/2024', '2024/02/20', '2024-03-01'

-- Inconsistências
'Completed' vs 'completed'  -- Case mismatch
'rn' vs 'RN' vs 'Sp'        -- Padronização de estados
NULL em campos obrigatórios
Registros duplicados (ID 4)
```

---

### Layer 2: STAGING

**Objetivo**: Limpar, validar e padronizar dados

**Transformações:**

1. **Remoção de Duplicatas**
   ```sql
   DELETE FROM raw_sales WHERE ctid NOT IN (
     SELECT MIN(ctid) FROM raw_sales 
     GROUP BY sale_id, customer_name, product_name, sale_date
   );
   ```

2. **Padronização**
   - Status: `LOWER(status)` → 'completed', 'canceled'
   - Estados: `UPPER(state)` → 'RN', 'CE', 'RJ'

3. **Conversão de Tipos**
   - TEXT → INT, DATE, NUMERIC
   - Tratamento de múltiplos formatos de data com REGEX

4. **Validação**
   - Remove registros com campos críticos NULL
   - Garante integridade referencial

---

### Layer 3: DATA WAREHOUSE

**Objetivo**: Modelagem dimensional otimizada para analytics

**Modelagem Star Schema:**

```
                    dim_date
                      ↓
dim_customers → fact_sales ← dim_products
```

**Tabelas:**

- **dim_customers**: Dimensão de clientes (ID, nome, estado)
- **dim_products**: Dimensão de produtos (ID, nome, categoria)
- **dim_date**: Dimensão temporal (data, ano, mês, trimestre)
- **fact_sales**: Tabela fato com métricas (quantidade, valor, status)

**Benefícios:**
- ⚡ Performance otimizada para queries analíticas
- 📊 Agregações multidimensionais simplificadas
- 🔄 Fácil manutenção e evolução
- 📈 Compatível com ferramentas de BI (Power BI, Tableau)

---

### Layer 4: ANALYTICS

**Objetivo**: Gerar insights de negócio

#### 1. KPIs (Key Performance Indicators)
```sql
-- Métricas essenciais de negócio
• Receita Total: SUM(total_value)
• Ticket Médio: AVG(total_value)
• Clientes Ativos: COUNT(DISTINCT customer_id)
• Taxa de Cancelamento: % de vendas canceladas
```

#### 2. Segmentação RFM
Análise avançada de marketing baseada em:
- **Recency**: Dias desde última compra
- **Frequency**: Número de compras
- **Monetary**: Valor total gasto

Usa `NTILE()` para criar quintis (1-5), permitindo segmentação precisa de clientes.

#### 3. Window Functions
```sql
-- Ranking de clientes por gasto
DENSE_RANK() OVER (ORDER BY total_spent DESC)

-- Comparação com período anterior
LAG(revenue) OVER (ORDER BY year, month)
```

#### 4. Cohort Analysis
Agrupa clientes pelo mês da primeira compra e rastreia comportamento ao longo do tempo.

#### 5. Revenue Growth
Análise de crescimento mês a mês com cálculo de diferença absoluta e percentual.

---

## 🎯 Conceitos Aplicados

## 🎯 Conceitos Aplicados

| Conceito | Implementação | Arquivo |
|----------|---------------|---------|
| **ETL Pipeline** | Extract (RAW) → Transform (STAGING) → Load (DW) | `etl/*` |
| **Data Quality** | Validações, detecção de anomalias | `etl/data_quality_checks.sql` |
| **Star Schema** | Modelagem dimensional com fatos e dimensões | `database/schema_dw.sql` |
| **Window Functions** | RANK, LAG, NTILE para análises avançadas | `analytics/window_functions.sql` |
| **Indexação** | B-tree indexes em foreign keys e filtros | `database/indexes.sql` |
| **CTEs** | Common Table Expressions para legibilidade | `analytics/rfm_segmentation.sql` |
| **Data Normalization** | Remoção de duplicatas e padronização | `etl/cleaning.sql` |

---

## 🎓 Skills Demonstradas

Este projeto serve como **portfólio profissional** demonstrando:

```
✓ PostgreSQL Avançado          ✓ Star Schema Modeling
✓ Pipeline ETL Completo        ✓ Data Quality & Governance  
✓ SQL Analytics Avançado       ✓ Performance Optimization
✓ Window Functions & CTEs      ✓ Business Intelligence
✓ Data Transformation          ✓ Best Practices
```

---

## 📈 Resultados Esperados

Após executar o pipeline completo, você terá:

- ✅ **6 tabelas** criadas (raw, staging, dim_*, fact_*)
- ✅ **Dados limpos** sem duplicatas ou inconsistências
- ✅ **5 análises** prontas para uso
- ✅ **Índices** otimizados para performance
- ✅ **Métricas** de qualidade validadas

**Exemplo de output:**
```sql
-- KPIs
Receita Total: R$ 3.660,00
Ticket Médio: R$ 1.830,00
Clientes Ativos: 1
Taxa de Cancelamento: 0%

-- Revenue Growth
Crescimento mês a mês: +2087.5%
```
