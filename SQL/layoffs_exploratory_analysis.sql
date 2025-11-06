-- =====================================================
-- PROJECT: Global Layoffs 2020–2023
-- AUTHOR: [Leon Miller]
-- PURPOSE: Exploratory Analysis 
-- =====================================================


SELECT * 
FROM layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
SELECT 
	MAX(total_laid_off), 
    MAX(percentage_laid_off) 
FROM layoffs_staging2;

-- Which companies laid off 100% of their staff
SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;
 
-- These companies to be mostly startups that went out of business

-- Using funds_raised_millions we can see how big some of these companies were
 SELECT * FROM 
 layoffs_staging2
 WHERE percentage_laid_off = 1
 ORDER BY funds_raised_millions DESC;
  -- Quibi-   raised around 2 billion dollars and went under!
 
 -- Companies with the biggest single Layoff
 SELECT 
	company, 
    SUM(total_laid_off) 
 FROM layoffs_staging2
 GROUP BY company
 ORDER BY 2 DESC;
 
 -- Check the earliers and most recent dates for context. Earliest records from start of covid 19 pandemic
 SELECT 
	MIN(`date`), 
	MAX(`date`)
 FROM layoffs_staging2;
 

-- Industries with the most lay offs
SELECT 
	industry, 
	SUM(total_laid_off) 
 FROM layoffs_staging2
 GROUP BY industry
 ORDER BY 2 DESC;
 

-- 	By location
 SELECT 
	country, 
	SUM(total_laid_off) 
 FROM layoffs_staging2
 GROUP BY country
 ORDER BY 2 DESC;
 
SELECT 
	YEAR(`date`), 
	SUM(total_laid_off) 
 FROM layoffs_staging2
 GROUP BY YEAR(`date`)
 ORDER BY 1 DESC;
 
 SELECT *
 FROM layoffs_staging2;
 
 -- Companies with the most Layoffs per year. use cte to query off and look at a rolling total of lay offs per month
 -- Use substring to use month and year
 
WITH rolling_total AS
( 
SELECT SUBSTRING(`date`, 1, 7 ) AS`MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7 ) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)

SELECT 
`Month`, 
total_off, 
SUM(total_off) OVER(ORDER BY `MONTH`)
FROM rolling_total;


-- Companies with the most lay offs by year - Can use this in a CTE to create ranking 
SELECT 
	company, 
	YEAR(`date`), 
	SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Another Cte to query off and use DENSE Rank to see the companies with the most lay offs, each year

WITH company_year (company, `year`, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), company_ranking AS
(SELECT *, 
DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_laid_off DESC) AS ranking
FROM company_year
WHERE `year` IS NOT NULL
)
SELECT * FROM company_ranking
WHERE ranking <=5;

-- =====================================================