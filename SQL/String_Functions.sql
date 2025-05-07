SELECT LENGTH("skyfall");

SELECT first_name, LENGTH(first_name) AS len_fn
FROM employee_demographics
ORDER BY len_fn;

SELECT UPPER('rafael');
SELECT LOWER('RaFAeL');

SELECT first_name, UPPER(first_name) AS f_name
FROM employee_demographics;

SELECT TRIM('       moon       ');
SELECT LTRIM('       moon       ');
SELECT RTRIM('       moon       ');

SELECT 
	first_name, 
    LEFT(first_name, 4), 
    RIGHT(first_name, 4),
    SUBSTRING(first_name, 3, 2),
    SUBSTRING(birth_date, 6, 2) AS birth_month
FROM employee_demographics;

SELECT first_name, REPLACE(first_name, 'a', 'z')
FROM employee_demographics;

SELECT LOCATE('r', 'Rafael');

SELECT first_name, LOCATE('An', first_name)
FROM employee_demographics;

SELECT 
	first_name, 
    last_name,
	CONCAT(first_name,' ', last_name) AS full_name
FROM employee_demographics;
