DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (20, 'Rafael', 'Boeira', 'Developer', 25000, NULL);

SELECT *
FROM employee_salary;

SELECT *
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees
	ON SCHEDULE EVERY 30 SECOND
	DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%';