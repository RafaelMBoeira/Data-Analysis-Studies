SELECT
	company,
    SUM(total_laid_off)
FROM no_duplicates
GROUP BY company
ORDER BY 2 DESC;

SELECT
	MIN(`date`),
    MAX(`date`)
FROM no_duplicates;

SELECT
	industry,
    SUM(total_laid_off)
FROM no_duplicates
GROUP BY industry
ORDER BY 2 DESC;

SELECT
	country,
    SUM(total_laid_off)
FROM no_duplicates
GROUP BY country
ORDER BY 2 DESC;

SELECT
	YEAR(`date`),
    SUM(total_laid_off)
FROM no_duplicates
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT
	stage,
    SUM(total_laid_off)
FROM no_duplicates
GROUP BY stage
ORDER BY 2 DESC;

-- Rolling total of layoffs per month

WITH rolling_total AS (
	SELECT
		SUBSTRING(`date`, 1, 7) AS `Month`,
		SUM(total_laid_off) AS total_off
	FROM no_duplicates
	WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
	GROUP BY `Month`
	ORDER BY 1 ASC
)
SELECT
	`Month`,
    total_off,
    SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM rolling_total;

-- Top 5 companies with the most layoffs by year

SELECT
	company,
    YEAR(`date`),
    SUM(total_laid_off)
FROM no_duplicates
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH company_year AS(
	SELECT
		company,
		YEAR(`date`) AS years,
		SUM(total_laid_off) AS total_laid_off
	FROM no_duplicates
	GROUP BY company, YEAR(`date`)
	ORDER BY 3 DESC
), company_rank_by_year AS (
	SELECT 
		*,
		DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
	FROM company_year
	WHERE years IS NOT NULL 
	ORDER BY ranking
)
SELECT *
FROM company_rank_by_year
WHERE ranking <= 5
ORDER BY years;