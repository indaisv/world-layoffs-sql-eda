-- =============================================================
-- WORLD TECH LAYOFFS 2020-2023 | EXPLORATORY DATA ANALYSIS
-- Tool: MySQL | Dataset: 2,361 records across 33 industries
-- Author: Viraj Indais
-- =============================================================

-- =============================================================
-- SECTION 1: BASIC EXPLORATION
-- =============================================================

-- Q1: What is the total and average layoffs across all companies?
-- MAX/MIN/AVG gives us a quick snapshot of the scale
SELECT 
    MAX(total_laid_off) AS highest_single_layoff,
    MIN(total_laid_off) AS lowest_single_layoff,
    ROUND(AVG(total_laid_off), 0) AS avg_layoffs_per_event,
    SUM(total_laid_off) AS total_people_laid_off
FROM layoffs;
-- tells us the overall damage at a glance

-- Q2: Which companies went completely under? (100% layoff)
-- percentage_laid_off = 1 means entire company was laid off
SELECT 
    company, 
    country,
    industry,
    funds_raised_millions,
    date
FROM layoffs
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- ORDER BY funds shows which big-money companies still failed

-- Q3: What is the date range of this dataset?
-- Always important to know your data boundaries
SELECT 
    MIN(date) AS earliest_record,
    MAX(date) AS latest_record
FROM layoffs
WHERE date IS NOT NULL;

-- Q4: Which countries are represented and how many events each?
-- COUNT(*) counts number of layoff events per country
SELECT 
    country,
    COUNT(*) AS layoff_events,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs
WHERE total_laid_off IS NOT NULL
GROUP BY country
ORDER BY total_laid_off DESC;

-- Q5: India specific - which companies laid off in India?
-- Personal market focus - relevant since Proof-of-Skill is Bengaluru based
SELECT 
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    stage,
    date
FROM layoffs
WHERE country = 'India'
ORDER BY total_laid_off DESC;

-- =============================================================
-- SECTION 2: INTERMEDIATE ANALYSIS
-- =============================================================

-- Q6: Which industries were hit the hardest overall?
-- GROUP BY lets us aggregate by category
SELECT 
    industry,
    COUNT(*) AS number_of_layoff_events,
    SUM(total_laid_off) AS total_laid_off,
    ROUND(AVG(percentage_laid_off) * 100, 1) AS avg_percent_laid_off
FROM layoffs
WHERE industry IS NOT NULL AND industry != 'NULL'
AND total_laid_off IS NOT NULL
GROUP BY industry
ORDER BY total_laid_off DESC;

-- Q7: Which companies had the most total layoffs across all events?
-- One company can have multiple layoff rounds - SUM captures that
SELECT 
    company,
    SUM(total_laid_off) AS total_laid_off,
    COUNT(*) AS number_of_rounds
FROM layoffs
WHERE total_laid_off IS NOT NULL
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;

-- Q8: Which funding stage got hit hardest?
-- Seed/Series A vs Post-IPO - who suffered more?
SELECT 
    stage,
    COUNT(*) AS number_of_companies,
    SUM(total_laid_off) AS total_laid_off,
    ROUND(AVG(percentage_laid_off) * 100, 1) AS avg_percent_laid_off
FROM layoffs
WHERE stage IS NOT NULL 
AND stage NOT IN ('NULL', 'Unknown')
AND total_laid_off IS NOT NULL
GROUP BY stage
ORDER BY total_laid_off DESC;

-- Q9: Layoffs by year - which year was the worst?
-- YEAR() extracts the year from a date column
SELECT 
    YEAR(date) AS year,
    COUNT(*) AS layoff_events,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs
WHERE date IS NOT NULL AND date != 'NULL'
AND total_laid_off IS NOT NULL
GROUP BY YEAR(date)
ORDER BY year ASC;

-- Q10: HR and Recruiting industry deep dive
-- Directly relevant - applying to a hiring tech company
SELECT 
    company,
    country,
    total_laid_off,
    percentage_laid_off,
    funds_raised_millions,
    stage,
    date
FROM layoffs
WHERE industry IN ('HR', 'Recruiting')
AND total_laid_off IS NOT NULL
ORDER BY total_laid_off DESC;

-- =============================================================
-- SECTION 3: ADVANCED ANALYSIS
-- =============================================================

-- Q11: Top 3 companies with most layoffs per year
-- CTE + DENSE_RANK window function - most advanced query
-- CTE (WITH clause) = a temporary table we can query from
-- DENSE_RANK() OVER (PARTITION BY years) = rank within each year
WITH Company_Year AS (
    SELECT 
        company, 
        YEAR(date) AS year, 
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs
    WHERE date IS NOT NULL AND date != 'NULL'
    AND total_laid_off IS NOT NULL
    GROUP BY company, YEAR(date)
),
Company_Year_Rank AS (
    SELECT 
        company, 
        year, 
        total_laid_off,
        DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS ranking
    FROM Company_Year
)
SELECT company, year, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND year IS NOT NULL
ORDER BY year ASC, total_laid_off DESC;

-- Q12: Rolling monthly total of layoffs (cumulative)
-- Shows the compounding effect month by month
-- SUM() OVER (ORDER BY) = running total window function
WITH Monthly_Layoffs AS (
    SELECT 
        SUBSTRING(date, 1, 7) AS month,
        SUM(total_laid_off) AS monthly_total
    FROM layoffs
    WHERE date IS NOT NULL AND date != 'NULL'
    AND total_laid_off IS NOT NULL
    GROUP BY month
    ORDER BY month ASC
)
SELECT 
    month,
    monthly_total,
    SUM(monthly_total) OVER (ORDER BY month ASC) AS rolling_total
FROM Monthly_Layoffs;

-- Q13: Funding efficiency - most money raised but still laid off heavily
-- funds_raised_millions / total_laid_off = how much $ was spent per person laid off
-- High number = company burned massive cash before collapse
SELECT 
    company,
    industry,
    country,
    funds_raised_millions,
    total_laid_off,
    ROUND(funds_raised_millions / total_laid_off, 2) AS million_spent_per_layoff
FROM layoffs
WHERE funds_raised_millions IS NOT NULL
AND total_laid_off IS NOT NULL
AND total_laid_off > 0
ORDER BY million_spent_per_layoff DESC
LIMIT 10;

-- Q14: Early stage vs Late stage layoff comparison using CASE WHEN
-- CASE WHEN = SQL's version of IF/ELSE
-- Bucketing companies into Early/Late/Public stage
SELECT 
    CASE 
        WHEN stage IN ('Seed', 'Series A', 'Series B', 'Series C') THEN 'Early Stage'
        WHEN stage IN ('Series D', 'Series E', 'Series F', 'Series G', 'Series H', 'Series I', 'Series J') THEN 'Late Stage'
        WHEN stage IN ('Post-IPO', 'Private Equity', 'Acquired', 'Subsidiary') THEN 'Mature/Public'
        ELSE 'Unknown'
    END AS company_stage_group,
    COUNT(*) AS number_of_companies,
    SUM(total_laid_off) AS total_laid_off,
    ROUND(AVG(percentage_laid_off) * 100, 1) AS avg_percent_laid_off
FROM layoffs
WHERE total_laid_off IS NOT NULL
GROUP BY company_stage_group
ORDER BY total_laid_off DESC;

-- Q15: Which month historically has the most layoffs?
-- Regardless of year - pure month pattern
-- Useful for predicting future layoff seasons
SELECT 
    MONTH(date) AS month_number,
    MONTHNAME(date) AS month_name,
    COUNT(*) AS layoff_events,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs
WHERE date IS NOT NULL AND date != 'NULL'
AND total_laid_off IS NOT NULL
GROUP BY month_number, month_name
ORDER BY total_laid_off DESC;