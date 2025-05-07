SELECT 
	first_name,
    last_name,
    CASE
		WHEN age <= 30 THEN 'Young'
        WHEN age BETWEEN 31 AND 50 THEN 'Old'
        WHEN age >= 51 THEN "Too Old"
	END AS age_description
FROM employee_demographics;

SELECT 
	first_name,
    last_name,
    salary,
    CASE
		WHEN salary < 50000 THEN salary * 1.05
        WHEN salary >= 50000 THEN salary * 1.07
	END AS new_salary,
    CASE
		WHEN dept_id = 6 THEN salary * 0.1
        WHEN dept_id <> 6 THEN 0
	END AS bonus
FROM employee_salary;