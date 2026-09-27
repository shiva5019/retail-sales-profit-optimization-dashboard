# Superstore Sales Performance & Profit Optimization Dashboard

End-to-end retail analytics project using Python, MySQL, and Power BI — turning raw Superstore transaction data into actionable business insights.

## Workflow

Raw Superstore data → Python cleaning & EDA → MySQL business analysis → Power BI dashboard → business optimization insights.

## Project Structure

```
retail-sales-profit-optimization-dashboard-main/
├── Retail-Performance-Optimization.pbix   # Interactive Power BI dashboard
├── Screen shots/                          # Dashboard page previews
├── data/
│   ├── raw/                               # Original Superstore export
│   ├── processed/                         # Cleaned dataset (output of data_cleaning.py)
│   ├── powerbi/                           # Star-schema tables (customer, product, geography, dim_date)
│   └── sql_results/                       # Exported outputs of the SQL analysis queries
├── notebooks/
│   └── retail_analysis.ipynb              # Full EDA, KPI, profitability, and optimization analysis
├── python/
│   └── data_cleaning.py                   # Reusable data preparation pipeline
├── sql/
│   ├── schema.sql                         # Table definition
│   ├── data_loading.sql                   # CSV → MySQL load script
│   ├── business_analysis.sql              # Core business queries
│   └── advanced_analysis.sql              # Window-function / ranking queries
├── requirements.txt
└── README.md
```

## Core KPIs

| Metric | Value |
|---|---|
| Total Sales | ~$2.327M |
| Total Profit | ~$292.3K |
| Total Orders | 5,111 |
| Total Quantity | 38,654 |
| Profit Margin | 12.56% |
| Average Order Value | $455.20 |

## Project Components

- **`Retail-Performance-Optimization.pbix`** — completed interactive Power BI dashboard with 4 pages: Executive Overview, Regional & Market Performance, Product & Category Optimization, and Business Optimization.
- **`python/data_cleaning.py`** — reusable data preparation pipeline: renames columns, parses dates, coerces numeric fields, removes duplicates/nulls, and engineers derived fields (shipping days, year-month, profit margin, sales per unit).
- **`notebooks/retail_analysis.ipynb`** — full EDA covering data quality, KPI development, regional/state/city performance, category and product analysis, discount impact, monthly trends, segment and shipping analysis, and optimization opportunities.
- **`sql/`** — schema definition, data loading script, core business queries, and advanced queries using window functions (RANK, DENSE_RANK, LAG, running totals, percentile-based quadrant classification).
- **`data/`** — raw and processed data, Power BI star-schema supporting tables, and exported SQL result sets.

## Dashboard Pages

1. **Executive Overview** — headline KPIs, monthly sales & profit trend, sales vs profit by region, regional profitability map, category breakdown, top sub-categories by sales/profit.
2. **Regional & Market Performance** — state-level sales map, top states by sales, regional sales contribution, region-wise trend, category performance by region.
3. **Product & Category Optimization** — top products by sales/profit, category sales split, quantity vs profitability, category/sub-category profit margins.
4. **Business Optimization** — loss-making product count, high-discount order share, discount impact on profit, discount vs profitability, profitability quadrant, profit leakage by sub-category, business opportunity matrix.

## Key Business Findings

- West is the largest sales region and should be monitored alongside its profit contribution.
- Technology has the strongest profit margin among the three categories.
- A meaningful subset of products is loss-making, creating a direct product-level optimization opportunity.
- High-discount transactions (30%+) tend to erode profit margin significantly and should be reviewed alongside sales volume, not sales alone.
- Certain states and cities post negative profit despite decent sales, pointing to regional pricing/discounting issues.

## Tech Stack

Python, Pandas, NumPy, Matplotlib, MySQL, SQL, Power BI, DAX, Jupyter Notebook, Git/GitHub.

## How to Run

1. Clone this repository.
2. Install dependencies:
```bash
   pip install -r requirements.txt
```
3. Run the cleaning pipeline:
```bash
   python python/data_cleaning.py
```
4. Open `notebooks/retail_analysis.ipynb` to reproduce the full EDA.
5. Load `data/processed/superstore_cleaned.csv` into MySQL using `sql/schema.sql` and `sql/data_loading.sql` (update the file path in `data_loading.sql` first), then run `sql/business_analysis.sql` and `sql/advanced_analysis.sql`.
6. Open `Retail-Performance-Optimization.pbix` in Power BI Desktop to explore the dashboard.

## Author

Shiva — [GitHub](https://github.com/shiva5019)
