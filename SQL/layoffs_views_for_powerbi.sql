-- =====================================================
-- PROJECT: Global Layoffs 2020–2023
-- AUTHOR: [Leon Miller]
-- PURPOSE: Create Views for Power BI Dashboard
-- =====================================================

-- 1️. Layoffs Over Time (for Line Chart)
-- =====================================================
CREATE OR REPLACE VIEW layoffs_over_time AS
SELECT 
    DATE(CONCAT(YEAR(date), '-', LPAD(MONTH(date),2,'0'), '-01')) AS month_start,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE date IS NOT NULL
GROUP BY month_start
ORDER BY month_start;

-- =====================================================
-- 2️. Layoffs by Industry (for Bar Chart)
-- =====================================================
CREATE OR REPLACE VIEW layoffs_by_industry AS
SELECT 
    industry,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY total_layoffs DESC;


-- =====================================================
-- 3️. Layoffs by Country (for Map)
-- =====================================================
CREATE OR REPLACE VIEW layoffs_by_country AS
SELECT 
    country,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY country
ORDER BY total_layoffs DESC;

-- =====================================================
-- 4️. Cumulative Layoffs Over Time (for Area Chart)
-- =====================================================
CREATE OR REPLACE VIEW cumulative_layoffs AS
WITH monthly_layoffs AS (
    SELECT 
        DATE(CONCAT(YEAR(date), '-', LPAD(MONTH(date),2,'0'), '-01')) AS month_start,
        SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE date IS NOT NULL
    GROUP BY month_start
)
SELECT 
    month_start,
    total_off,
    SUM(total_off) OVER (ORDER BY month_start) AS cumulative_layoffs
FROM monthly_layoffs;

-- =====================================================
-- 5️. Top 5 Companies by Year (for Leaderboard/Bar Chart)
-- =====================================================
CREATE OR REPLACE VIEW top_5_companies_by_year AS
WITH company_year AS (
    SELECT 
        company,
        YEAR(date) AS year,
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(date)
),
company_ranking AS (
    SELECT 
        *,
        DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS ranking
    FROM company_year
)
SELECT * 
FROM company_ranking
WHERE ranking <= 5
AND `year` IS NOT NULL;


-- =====================================================
-- 6. Create SQL View for KPI Cards in Power BI
-- =====================================================

CREATE OR REPLACE VIEW layoffs_kpis AS
SELECT
    SUM(total_laid_off) AS total_layoffs,
    MAX(total_laid_off) AS max_monthly_layoffs,
    AVG(total_laid_off) AS avg_monthly_layoffs
FROM (
    -- Subquery to get monthly totals
    SELECT 
        DATE(CONCAT(YEAR(date), '-', LPAD(MONTH(date),2,'0'), '-01')) AS month_start,
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    WHERE date IS NOT NULL
    GROUP BY month_start
) AS monthly_totals;
