CREATE TEMPORARY TABLE temp_table(
	first_name VARCHAR(50),
    last_name VARCHAR(50),
    favorite_movie VARCHAR(100)
);

INSERT INTO temp_table
VALUES ('Rafael', 'Boeira', 'Cloud Atlas');

SELECT * 
FROM temp_table;

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k