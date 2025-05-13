WITH CTE_Example (Gender, AVG_Sal, MAX_Sal, MIN_Sal, COUNT_Sal) AS (
	SELECT gender, AVG(salary) avg_salary, MAX(salary) max_salary, MIN(salary) min_salary, COUNT(salary) salary_count
    FROM employee_demographics dem
    JOIN employee_salary sal
		ON dem.employee_id = sal.employee_id
	GROUP BY gender
)
SELECT 
	AVG(AVG_Sal)
FROM CTE_Example;

WITH CTE_A AS (
	SELECT employee_id, gender, birth_date
    FROM employee_demographics
    WHERE birth_date > '1985-01-01'
),
CTE_B AS (
	SELECT employee_id, salary
    FROM employee_salary
    WHERE salary > 50000
)
SELECT *
FROM CTE_A 
JOIN CTE_B 
	ON CTE_A.employee_id = CTE_B.employee_id;