-- =====================================================
-- PROJECT: Global Layoffs 2020–2023
-- AUTHOR: [Leon Miller]
-- PURPOSE: Clean data for effective analysis
-- =====================================================

SELECT * FROM layoffs;

-- Firstly, create a staging table. This is the one I will work in and clean the data. I want a table with the raw data in case something happens

CREATE TABLE world_layoffs.layoffs_staging 

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT  layoffs_staging
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;

-- =====================================================
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what can be done with them
-- 4. remove any columns and rows that are not necessary - few ways
-- =====================================================

-- 1. Remove Duplicates

# FIrst I will check for duplicates

SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging
)

SELECT * 
FROM duplicate_cte
WHERE ROW_NUM >1;

-- I will look at the individual companies for clarity

SELECT * 
FROM layoffs_staging
WHERE company = 'Oda';

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';


-- it looks like there are legitimate entries and shouldn't be deleted. Will need to partition by every column to be accuarate

WITH duplicate_cte2 AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)

SELECT * 
FROM duplicate_cte2
WHERE ROW_NUM >1;

-- My solutution is to create a new column and add those row numbers in. Then delete where row numbers are over 2, then delete that column

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;


-- New table created. Now I can delete rows were row_num is greater than 1

DELETE FROM layoffs_staging2
WHERE row_num >1;

-- Confirm duplicates have been removed

SELECT * 
FROM layoffs_staging2
WHERE row_num >1;

-- =====================================================
-- 2. Standardize Data

-- I can see some white space around company names. So I will trim.

SELECT 
	company,
	TRIM(company) 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);


-- Check over errors industry column - 

SELECT DISTINCT industry  FROM layoffs_staging2
ORDER BY 1;

-- There are a few industries that are actually one industry but they are spelt differently. I will ammend.

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'cryp%';

-- check over location and country

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- Incorrect formatting of country. I will ammend.

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


-- change date from text to datetime series and apply format

#  I can use str to date to update this field

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

-- Can now convert the data type properly

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT 
	`date` 
FROM layoffs_staging2;


-- =====================================================
-- 3. NULL and BLANK values


# Looking at industry it looks like theresome null and empty rows, let's take a look at these
SELECT * FROM layoffs_staging2
WHERE industry is NULL
OR industry = '';

-- For example. Airbnb is travel industry but some rows are different., 
SELECT * FROM layoffs_staging2
WHERE company = 'Airbnb';

-- I will write a query that if there is another row with the same company name, it will update it to the non-null industry values
-- makes it easy so if there were thousands we wouldn't have to manually check them all

-- set the blanks to nulls since those are typically easier to work with

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Use a self join to see if there are companies that have an industry but are missing indiustry

SELECT t1.industry, t2.industry FROM layoffs_staging t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- I can confirm there are three companies that have records with and without an industry so will set null values to their correct industry using self join

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1. industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT * 
FROM layoffs_staging2
WHERE industry is NULL
OR industry = '';

-- It looks like Bally's was the only one without a populated row to populate this null values but does't have information on total_laid_off so not particularly helpful

SELECT * 
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- 4. Remove columns/rows:

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete Useless data I can't really use

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2;

-- Finally delete row_num column as it is no longer needed

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- =====================================================