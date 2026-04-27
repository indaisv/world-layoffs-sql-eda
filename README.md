# World Tech Layoffs 2020–2023 | SQL Exploratory Data Analysis

An exploratory data analysis project on global tech industry layoffs from 
2020 to 2023 using MySQL. The dataset covers 2,361 layoff events across 
33 industries and 50+ countries.

## Key Findings

| Metric | Value |
|--------|-------|
| Total People Laid Off | 386,379 |
| Largest Single Layoff Event | 12,000 |
| Companies That Shut Down Completely | 84 |
| Countries Represented | 50+ |

## Top 10 Companies by Total Layoffs

| Company | Total Laid Off |
|---------|---------------|
| Amazon | 18,150 |
| Google | 12,000 |
| Meta | 11,000 |
| Salesforce | 10,090 |
| Philips | 10,000 |
| Microsoft | 10,000 |
| Ericsson | 8,500 |
| Uber | 7,585 |
| Dell | 6,650 |
| Booking.com | 4,601 |

## Top Countries by Total Layoffs

| Country | Total Laid Off |
|---------|---------------|
| United States | 256,474 |
| India | 35,993 |
| Netherlands | 17,220 |
| Sweden | 11,264 |
| Brazil | 10,691 |
| Germany | 8,701 |
| United Kingdom | 7,148 |
| Canada | 6,319 |

## Companies That Raised the Most and Still Shut Down

These companies reached 100% layoff despite raising significant funding:

| Company | Funds Raised | Country |
|---------|-------------|---------|
| Quibi | $1.8B | United States |
| BritishVolt | $2.4B | United Kingdom |
| Katerra | $1.6B | United States |
| BlockFi | $1.0B | United States |

## HR and Recruiting Industry

Given the dataset was analyzed in the context of applying to a hiring-tech 
company, the HR and Recruiting segment was examined separately. Companies 
like Wavely, Limelight, and Ejento all recorded 100% layoffs — indicating 
that even companies operating within the hiring space were not insulated 
from the broader downturn.

## About the Project

The goal was to explore patterns in tech layoffs — identifying which 
companies, industries, countries, and funding stages were most affected 
between 2020 and 2023. Queries progress from basic aggregations to 
advanced window functions and CTEs.

## Tech Stack

- **Tool:** MySQL Workbench
- **Language:** SQL
- **Techniques:** Aggregations, GROUP BY, HAVING, CASE WHEN, 
  Subqueries, CTEs, Window Functions (DENSE_RANK, Rolling SUM)

## Dataset

- **Source:** World Layoffs Dataset
- **Records:** 2,361 rows
- **Period:** 2020 – 2023

| Column | Description |
|--------|-------------|
| company | Company name |
| location | City |
| industry | Industry sector |
| total_laid_off | Number of employees laid off |
| percentage_laid_off | Fraction of total workforce laid off |
| date | Date of layoff event |
| stage | Funding stage at time of layoff |
| country | Country |
| funds_raised_millions | Total funding raised in USD millions |

## Project Structure

```
world-layoffs-sql-eda/
|-- layoffs_eda.sql    — All 15 SQL queries with section comments
|-- README.md
```

## How to Run

```sql
-- 1. Create and select your database
CREATE DATABASE layoffs_db;
USE layoffs_db;

-- 2. Import the dataset (layoffs.csv) via MySQL Workbench
--    Table Data Import Wizard > select layoffs.csv

-- 3. Run layoffs_eda.sql query by query in MySQL Workbench
```

## Author

**Viraj Indais**
- indaisviraj@gmail.com
- [LinkedIn](https://linkedin.com/in/viraj-indais)
- [GitHub](https://github.com/indaisv)
