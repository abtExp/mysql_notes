####### MySQL Triggers #######
/*
	Triggers are form of stored procedures associated with a table that are called automatically either before or after
    INSERT, UPDATE or DELETE events on a table.
    These are associated with a table to form some sort of validation or preprocessing required before performing any of the INSERT
    , UPDATE or DELETE operation to ensure data integrity.
    
    The general structure to define a trigger is
    
    DELIMITER $$
    CREATE TRIGGER trigger_name
    trigger_type operation_type ON table_name
    optional_other_flags_or_iterators
    BEGIN
    trigger_definition
    END$$
    
    Where trigger_type is either BEFORE or AFTER
    operation_type is one of INSERT, UPDATE or DELETE
*/

# Example trigger

/*
	This will check if the entered salary is >= 0, if not, set to 0 to prevent negative salary to be entered
    this will check each row which is being inserted.
*/
DELIMITER $$

CREATE TRIGGER before_inserting_salary
BEFORE INSERT ON salaries
FOR EACH ROW
BEGIN
	IF NEW.salary < 0 THEN
		SET NEW.salary = 0;
	END IF;
END$$

/*
	Triggers are useful and can be implemented to ensure data integrity and perform checks on data and even perform operations before deleting.
*/

/*
	Excercise : Create a trigger that checks if the hire date of an employee is higher than the current date.
    If true, set this date to be the current date. Format the output appropriately (YY-MM-DD).
*/


DELIMITER $$
CREATE TRIGGER corr_hire_date
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
	DECLARE curr_date DATE;
	SET curr_date = DATE_FORMAT(SYSDATE(), '%y-%m-%d');
    IF NEW.hire_date > curr_date THEN
		SET NEW.hire_date = curr_date;
	END IF;
END$$

INSERT INTO employees VALUES(999999, '1997-05-01', 'Anubhav', 'Tiwari', 'M', '22-05-01');