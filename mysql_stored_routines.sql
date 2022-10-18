-/*
	Stored routines allow for defining functions and procedures that allow for code reusability
    there are two types of routines,
    stored procedures and functions
*/

####### Stored Procedures #######
/*
	A Stored procedure is basically an SQL query wrapped in a function identifier.
    we can also provide parameters to the stored procedure.
    here's an example;
*/

# Firstly define the database on which this procedure will be stored.
USE employees;

# Drop the procedure if already exists, safety measure
DROP PROCEDURE IF EXISTS avg_salary;

# Define a temporary delimiter
/*
	MySQL has a default delimiter ';', but if we use that in the stored procedure, rest of our procedures won't be executed
    as mysql will break on first instance of the ';' delimiter. Thus we define a custom temporary delimiter to mark the end of our procedure
*/

DELIMITER $$
CREATE PROCEDURE avg_salary()
	-- BEGIN is used to let SQL know where the body of the procedure begins, just like {} in C++ or indentation in python
	BEGIN
		SELECT AVG(salary)
        -- As this is an SQL query, use the default delimiter to mark the end of the sql query.
		FROM salaries;
	-- END marks the end of the body of the procedure
	END$$

# Reset the delimiter to the default
DELIMITER ;

# Calling the stored procedure
CALL employees.avg_salary();

# If already used the USE database statement, it can be called directly
CALL avg_salary();

# It can also be called without the parantheses
CALL avg_salary;

####### DEFINING PROCEDURES WITH PARAMETERS #######
/*
	Procedures with parameters can be defined as follows
    in the parantheses
    procedure_name(IN param_name param_dtype, IN param_name_2 param_dtype_2)
    we can also define output parameters to which the output of the procedure can be stored
    procedure_name(IN param_name param_dtype, OUT param_name_out param_out_dtype)
    procedures can have multiple in and  multiple out parameters.
*/

# Let's define a procedure to fetch the name and salary of an employee given employee number
USE employees;
DROP PROCEDURE IF EXISTS employee_salary;

DELIMITER $$
CREATE PROCEDURE employee_salary(IN emp_no INT)
BEGIN
	SELECT E.emp_no, E.first_name, E.last_name, S.salary, S.from_date, S.to_date
	FROM employees E
    INNER JOIN
    salaries S
    ON E.emp_no = S.emp_no
    WHERE E.emp_no = emp_no;
END$$
DELIMITER ;

# Let's check the result by calling the procedure
CALL employee_salary(10001);

# Let's define one with an output parameter name
USE employees;
DROP PROCEDURE IF EXISTS emp_avg_salary;

DELIMITER $$
CREATE PROCEDURE emp_avg_salary(IN emp_no INT, OUT salary_info DECIMAL(10, 2))
BEGIN
	SELECT AVG(S.salary)
    INTO salary_info FROM
    employees E
    INNER JOIN
    salaries S
    ON E.emp_no = S.emp_no
    WHERE E.emp_no = emp_no;
END$$

DELIMITER ;

####### Variables #######
/*
	Variables are defined using SET statement and are to be prefixed with an @ symbol
    Example with calling the above procedure with an out parameter
*/
# CALLING the out parameterized procedure
USE employees;
SET @avg_salary = 0;
CALL emp_avg_salary(10001, @avg_salary);
SELECT @avg_salary AS avg_salary;


####### Functions #######
/*
	Functions are defined using CREATE FUNCTION statement, there's no output variable, instead it defines a return type
    and has a return statement at the end, (or inside conditionals).
    this is similar to functions and methods in any other programming language.
    local variables can be defined using the DECLARE command.
    Rest of the function is similar to stored procedures.
    DETERMINISTIC NO SQL READS SQL DATA are some keywords defined to ensure compatibility.
    FUNCTIONS are called using the select statement instead of the CALL statement;
    Functions can only return a single value, thus to return multiple values, concat and form a string output.
*/

# Example

DROP FUNCTION IF EXISTS get_employee_avg_salary;

USE employees;

DELIMITER $$
CREATE FUNCTION get_employee_avg_salary(emp_no INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC NO SQL READS SQL DATA
	BEGIN
		DECLARE avg_salary DECIMAL(10, 2);
		SELECT 
			AVG(S.salary)
		INTO avg_salary
		FROM
			employees E
				INNER JOIN
			salaries S ON E.emp_no = S.emp_no
		WHERE
			E.emp_no = emp_no;
        
		RETURN avg_salary;
	END$$
DELIMITER ;

# CALLING the function
SELECT get_employee_avg_salary(10001) AS emp_avg_salary;


/*
	So procedures and functions are kinda mostly similar with a few differences, and these differences define the 
    places where one is preffered over the other
    
    |########## Procedure ##########|########## Function ##########|
    | 1. Can have multiple output   | 1. Can only have one output  |
    |    variables.                 |    variable in the return    |
    |_______________________________|______________________________|
    | 2. Does Not return or         | 2. Must always return a      |
    |    have an output.            |    value.                    |
    |_______________________________|______________________________|
    | 3. Can be used for INSERT,    | 3. Can only be used with     |
	|    DELETE and UPDATE          |    SELECT statement          |
    |    statements as well because |							   |
    |    of the above reason        |							   |
	|_______________________________|______________________________|
    | 4. Called using CALL keyword  | 4. Called using a SELECT     |
    |                               |    keyword.                  |
    |_______________________________|______________________________|
    | 5. Can't be used in queries   | 5. Can be used inside        |
    |    because of the above.      |    queries.                  |
    |_______________________________|______________________________|
*/