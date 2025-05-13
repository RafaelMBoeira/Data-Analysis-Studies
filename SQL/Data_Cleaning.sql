SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;

-- Removing Duplicates

WITH duplicate_cte AS (
	SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
	) AS row_num
	FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `no_duplicates` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO no_duplicates
SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
	) AS row_num
FROM layoffs_staging;

SELECT * 
FROM no_duplicates 
WHERE row_num > 1;

DELETE 
FROM no_duplicates
WHERE row_num > 1;

-- Standardizing Data

SELECT company, TRIM(company)
FROM no_duplicates;

UPDATE no_duplicates
SET company = TRIM(company);

SELECT DISTINCT industry
FROM no_duplicates
ORDER BY industry;

UPDATE no_duplicates
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM no_duplicates
ORDER BY country;

UPDATE no_duplicates
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM no_duplicates;

UPDATE no_duplicates
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE no_duplicates
MODIFY COLUMN `date` DATE;

-- Removing Null and Blank Data

SELECT *
FROM no_duplicates
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT *
FROM no_duplicates
WHERE industry IS NULL OR industry = '';

UPDATE no_duplicates
SET industry = NULL
WHERE industry = '';

SELECT *
FROM no_duplicates
WHERE company = 'Airbnb';

SELECT *
FROM no_duplicates nd_a
JOIN no_duplicates nd_b
	ON nd_a.company = nd_b.company
WHERE nd_a.industry IS NULL AND nd_b.industry IS NOT NULL;

UPDATE no_duplicates nd_a
JOIN no_duplicates nd_b
	ON nd_a.company = nd_b.company
SET nd_a.industry = nd_b.industry
WHERE nd_a.industry IS NULL AND nd_b.industry IS NOT NULL;

DELETE 
FROM no_duplicates
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

ALTER TABLE no_duplicates
DROP COLUMN row_num;