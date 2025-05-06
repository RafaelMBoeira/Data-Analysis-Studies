SELECT emp_d.employee_id, age, occupation
FROM employee_demographics AS emp_d
INNER JOIN employee_salary AS emp_s
	ON emp_d.employee_id = emp_s.employee_id;
    
SELECT *
FROM employee_demographics AS emp_d
LEFT OUTER JOIN employee_salary AS emp_s
	ON emp_d.employee_id = emp_s.employee_id;

SELECT *
FROM employee_demographics AS emp_d
RIGHT OUTER JOIN employee_salary AS emp_s
	ON emp_d.employee_id = emp_s.employee_id;
    
SELECT *
FROM employee_salary AS emp_1
JOIN employee_salary AS emp_2
	ON emp_1.employee_id + 1 = emp_2.employee_id;
    
SELECT 
	emp_1.first_name AS first_name,
    emp_1.last_name AS last_name,
    emp_1.employee_id AS id,
    emp_2.first_name AS first_name_santa,
    emp_2.last_name AS last_name_santa,
    emp_2.employee_id AS id_santa
FROM employee_salary AS emp_1
JOIN employee_salary AS emp_2
	ON emp_1.employee_id + 1 = emp_2.employee_id;

SELECT *
FROM employee_demographics AS emp_d
INNER JOIN employee_salary AS emp_s
	ON emp_d.employee_id = emp_s.employee_id
INNER JOIN parks_departments AS pd
	ON emp_s.dept_id = pd.department_id;