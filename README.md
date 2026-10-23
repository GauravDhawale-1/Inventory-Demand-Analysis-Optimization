# Inventory Demand Analysis & Optimization

An end-to-end data analytics project using **Python, SQL, MySQL, and Power BI** to clean historical inventory demand data, analyze product and warehouse demand patterns, and develop interactive dashboards for data-driven inventory planning.

## Project Overview

The objective of this project is to understand historical demand patterns across products, product categories, and warehouses. The project combines Python-based data cleaning, SQL analysis, and Power BI visualization to transform raw data into actionable business insights.

## Tools & Technologies

- **Python:** Data cleaning and preprocessing
- **Pandas:** Data manipulation and data quality checks
- **MySQL:** Data storage, querying, and analysis
- **SQL:** Aggregations, CTEs, subqueries, window functions, ranking, and trend analysis
- **Power BI:** Interactive dashboards and data visualization
- **DAX:** KPI calculations, demand contribution, and product ranking

## Project Workflow

1. **Data Cleaning with Python**

   - Loaded and inspected the historical product demand dataset using Pandas.
   - Cleaned and standardized data fields.
   - Processed date and numeric demand columns.
   - Checked data quality issues and prepared a cleaned CSV file for analysis.
   - Exported the cleaned dataset as `Cleaned_Inventory_Demand.csv`.

2. **Data Analysis with MySQL**

   - Imported the cleaned dataset into MySQL.
   - Analyzed product, product category, and warehouse demand.
   - Used CTEs, subqueries, aggregate functions, and window functions to answer business questions.
   - Calculated demand rankings, product contribution percentages, and demand trends over time.

3. **Dashboard Development with Power BI**

   - Created KPI cards to monitor total demand, distinct products, and warehouses.
   - Built interactive charts to compare product and warehouse demand.
   - Added product and warehouse slicers for dynamic filtering.
   - Created DAX measures for demand contribution and product demand ranking.
   - Developed dashboard pages for overview and advanced demand analysis.

## Key Business Questions

The project addresses the following analytical questions:

1. Which products have the highest total demand?
2. Which product categories contribute the most to overall demand?
3. Which warehouses experience the highest demand?
4. Which products have the highest and lowest average demand?
5. What is each product's percentage contribution to total demand?
6. How does demand change across months and years?
7. What is the year-over-year change in demand?
8. Which products rank highest within each warehouse?
9. Which products show high variability in demand?
10. How is demand distributed across product categories and warehouses?

## Power BI Dashboard Features

### Page 1 — Inventory Demand Overview

- **Total Demand:** Overall demand across the dataset.
- **Total Products:** Number of distinct products.
- **Total Warehouses:** Number of distinct warehouses.
- **Top 10 Products by Demand:** Identifies the products with the highest total demand.
- **Demand by Warehouse:** Compares demand across warehouses.
- **Average Demand by Product:** Compares average demand across products.
- **Interactive Slicers:** Filters the report by product and warehouse.
- **Product Analysis Table:** Displays product demand and demand contribution.

### Page 2 — Advanced Demand Analysis

- Product demand ranking using DAX.
- Demand contribution percentage analysis.
- Comparative analysis of product demand.
- Advanced product-level analysis to support inventory planning.

## SQL Concepts Applied

- `SELECT`, `WHERE`, `GROUP BY`, and `ORDER BY`
- Aggregate functions: `SUM()`, `AVG()`, `MIN()`, `MAX()`, and `COUNT()`
- Common Table Expressions (CTEs)
- Subqueries
- Window functions: `RANK()`, `DENSE_RANK()`, and `LAG()`
- Date-based aggregation and trend analysis
- Percentage contribution calculations
- Standard deviation and demand variability analysis
- Year-over-year demand comparisons

## DAX Measures

The following are examples of measures used in the Power BI dashboard.

**Total Demand**

```dax
Total_demand =
SUM('Cleaned_Inventory_Demand'[Order_Demand])
```

**Total Products**

```dax
Total Products =
DISTINCTCOUNT('Cleaned_Inventory_Demand'[Product_Code])
```

**Total Warehouses**

```dax
Total Warehouse =
DISTINCTCOUNT('Cleaned_Inventory_Demand'[Warehouse])
```

**Demand Contribution %**

This measure calculates each product's contribution to total demand while respecting relevant report filters.

```dax
Demand Contribution % =
DIVIDE(
    [Total_demand],
    CALCULATE(
        [Total_demand],
        REMOVEFILTERS(
            'Cleaned_Inventory_Demand'[Product_Code]
        )
    ),
    0
)
```

**Product Demand Rank**

```dax
Product Demand Rank =
RANKX(
    ALL('Cleaned_Inventory_Demand'[Product_Code]),
    [Total_demand],
    ,
    DESC,
    DENSE
)
```

*Note: Adjust table and column names in these examples to match your final Power BI model.*

## Key Outcomes

- Developed a repeatable data cleaning workflow using Python and Pandas.
- Applied SQL techniques to investigate historical demand across products, categories, warehouses, and time periods.
- Built interactive Power BI dashboards for demand monitoring and comparison.
- Used DAX to calculate KPIs, product demand contribution, and product rankings.
- Created a foundation for demand-based inventory planning and further optimisation analysis.

## Business Value

The analysis helps stakeholders identify high-demand products, compare warehouse demand, understand historical trends, and prioritize products for further inventory investigation.

**Important:** The dataset contains historical demand information. Actual reorder points, safety stock, and stockout risk require additional information such as stock on hand, supplier lead times, and replenishment policies.

## Repository Structure

```text
Inventory-Demand-Analysis/
│
│
├── python/
│   └── data_cleaning.ipynb
│
├── sql/
│   └── inventory_analysis.sql
│
├── powerbi/
│   └── Inventory_Demand_Analysis.pbix
│
├── screenshots/
│   ├── inventory_overview.png
│  
│
└── README.md
```

*Update the folder and file names to match your actual GitHub repository.*

## Conclusion

This project demonstrates practical data analytics skills across Python, SQL, MySQL, Power BI, and DAX. It showcases the process of preparing raw data, performing structured analysis, and presenting findings through interactive dashboards to support data-driven business decisions.
