/*
	Final 10 practice questions for practice.
*/

/*
	Question 1 : Find the average salary of the male and female employees in each department.
*/

####### Answer #######
# Will need 4 tables for this, namely, departments for department name, joined with dept_emp joined with dept_no, 
# joined with salary for avg salary and employee for gender.
SELECT 
    EMPD.dept_name, AVG(salary) AS avg_salary, gender
FROM
    (SELECT 
        E.emp_no, E.gender, AVG(S.salary) AS salary
    FROM
        employees E
    JOIN salaries S ON E.emp_no = S.emp_no
    GROUP BY E.emp_no
    ORDER BY E.emp_no) EMPS
        JOIN
    (SELECT 
        DE.emp_no, DE.dept_no, D.dept_name
    FROM
        dept_emp DE
    LEFT JOIN departments D ON DE.dept_no = D.dept_no
    ORDER BY DE.emp_no) EMPD ON EMPS.emp_no = EMPD.emp_no
GROUP BY EMPD.dept_no , EMPS.gender
ORDER BY EMPD.dept_no;

####### ______ #######



/*
	Question 2 : Find the lowest department number encountered in the 'dept_emp' table. Then, find the highest department number.
*/

####### Answer ####### 
/*
	Question isn't clear, if it is asking for number of occurences of a department in the table, below code works fine,
    otherwise if it's simply asking for the smallest department number in the table, it can be simply done
    using
    SELECT MIN(dept_no) FROM dept_emp;
    SELECT MAX(dept_no) FROM dept_emp;
*/
SELECT * FROM
(
	SELECT dept_no, COUNT(dept_no) AS num_occurences 
	FROM
	dept_emp
	GROUP BY dept_no
	ORDER BY num_occurences
	LIMIT 1
)LOWEST
UNION ALL
SELECT * FROM
(
	SELECT dept_no, COUNT(dept_no) AS num_occurences 
	FROM
	dept_emp
	GROUP BY dept_no
	ORDER BY num_occurences DESC
	LIMIT 1
)HIGHEST;
####### ______ #######



/*
	Question 3 : 
	Obtain a table containing the following three fields for all individuals whose employee number is not greater than 10040:
	- employee number
	- the lowest department number among the departments where the employee has worked in 
		(Hint: use a subquery to retrieve this value from the 'dept_emp' table)
	- assign '110022' as 'manager' to all individuals whose employee number is lower than or equal to 10020, 
		and '110039' to those whose number is between 10021 and 10040 inclusive.
	Use a CASE statement to create the third field.
	If you've worked correctly, you should obtain an output containing 40 rows.
	Here’s the top part of the output. Does it remind you of an output you’ve obtained earlier in the course?
*/

####### Answer #######
SELECT 
    emp_no,
    (SELECT 
            MIN(dept_no) AS dept_no
        FROM
            dept_emp DE
        WHERE
            E.emp_no = DE.emp_no) dept_no,
    CASE
        WHEN emp_no <= '10020' THEN '110022'
        ELSE '110039'
    END AS manager
FROM
    employees E
WHERE
    emp_no <= 10040;


####### ______ #######



/*
	Question 4 : Retrieve a list of all employees that have been hired in 2000.
*/

####### Answer #######
SELECT 
    *
FROM
    employees
WHERE
    YEAR(hire_date) = 2000;
####### ______ #######



/*
	Question 5 : Retrieve a list of all employees from the ‘titles’ table who are engineers.
	Repeat the exercise, this time retrieving a list of all employees from the ‘titles’ table who are senior engineers.
	After LIKE, you could indicate what you are looking for with or without using parentheses. 
    Both options are correct and will deliver the same output. 
	We think using parentheses is better for legibility and that’s why it is the first option we’ve suggested.
*/

####### Answer #######
SELECT 
    *
FROM
    employees E
        JOIN
    titles T ON E.emp_no = T.emp_no
WHERE
    T.title LIKE 'Engineer';
####### ______ #######



/*
	Question 6 : 
    Create a procedure that asks you to insert an employee number and that will obtain an output containing the same number,
    as well as the number and name of the last department the employee has worked in.
	Finally, call the procedure for employee number 10010.
	If you've worked correctly, you should see that employee number 10010 has worked for department number 6 - "Quality Management".
*/

####### Answer #######
DROP PROCEDURE IF EXISTS emp_info;

DELIMITER $$
CREATE PROCEDURE emp_info(IN empno INT)
BEGIN
SELECT 
    DE.emp_no, DE.dept_no, D.dept_name
FROM
    dept_emp DE
        JOIN
    departments D ON DE.dept_no = D.dept_no
WHERE
    DE.emp_no = empno
    AND DE.from_date = (
		SELECT MAX(from_date) FROM dept_emp
		WHERE emp_no = empno
	);
END$$
DELIMITER ;

CALL emp_info(10010); 
####### ______ #######



/*
	Question 7 : 
    How many contracts have been registered in the ‘salaries’ table with duration of more than one year and of value 
    higher than or equal to $100,000?
	Hint: You may wish to compare the difference between the start and end date of the salaries contracts.
*/

####### Answer #######
SELECT 
    COUNT(*) AS num_contracts
FROM
    salaries
WHERE
    DATEDIFF(to_date, from_date) > 365
        AND salary >= 100000;
####### ______ #######



/*
	Question 8 : 
    Create a trigger that checks if the hire date of an employee is higher than the current date. 
    If true, set the hire date to equal the current date. Format the output appropriately (YY-mm-dd).
	Extra challenge: You can try to declare a new variable called 'today' which stores today's data, and then use it in your trigger!
	After creating the trigger, execute the following code to see if it's working properly.
*/

####### Answer #######
DROP TRIGGER IF EXISTS check_hire_date

DELIMITER $$
CREATE TRIGGER check_hire_date
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
	DECLARE today DATE;
	SET today = DATE_FORMAT(SYSDATE(), '%y-%m-%d');
    IF NEW.hire_date > today THEN
		SET NEW.hire_date = today;
	END IF;
END$$

DELIMITER ;

INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');
SELECT * FROM employees ORDER BY emp_no DESC;
####### ______ #######



/*
	Question 9 : 
    Define a function that retrieves the largest contract salary value of an employee. 
    Apply it to employee number 11356.
	In addition, what is the lowest contract salary value of the same employee? 
    You may want to create a new function that to obtain the result.
*/

####### Answer #######
DROP FUNCTION IF EXISTS largest_contract;

DELIMITER $$
CREATE FUNCTION largest_contract(empno INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC NO SQL READS SQL DATA
BEGIN
	DECLARE max_salary DECIMAL(10, 2);
    -- For min salary, use MIN(salary)
	SELECT MAX(salary) INTO max_salary FROM salaries  WHERE emp_no = empno;
    RETURN max_salary;
END$$

DELIMITER ;

SELECT largest_contract(11356) AS largest_salary; 
####### ______ #######



/*
	Question 10 : 
    Based on the previous exercise, you can now try to create a third function that also accepts a second parameter. 
    Let this parameter be a character sequence. 
    Evaluate if its value is 'min' or 'max' and based on that retrieve either the lowest or the highest salary, 
    respectively (using the same logic and code structure from Exercise 9). 
    If the inserted value is any string value different from ‘min’ or ‘max’, 
    let the function return the difference between the highest and the lowest salary of that employee.
*/

####### Answer #######
DROP FUNCTION IF EXISTS find_contract;

DELIMITER $$
CREATE FUNCTION find_contract(empno INT, minmax CHAR(3)) RETURNS DECIMAL(10, 2)
DETERMINISTIC NO SQL READS SQL DATA
BEGIN
	DECLARE contract_salary DECIMAL(10, 2);
    ## Using IF
	-- IF LOWER(minmax) = 'min' THEN
-- 		SELECT MIN(salary) INTO contract_salary FROM salaries WHERE emp_no = empno;
-- 	ELSEIF LOWER(minmax) = 'max' THEN
-- 		SELECT MAX(salary) INTO contract_salary FROM salaries WHERE emp_no = empno;
-- 	ELSE
-- 		SELECT (MAX(salary) - MIN(salary)) INTO contract_salary FROM salaries WHERE emp_no = empno;
-- 	END IF;
--     
    ## Using CASE
    SELECT 
		CASE
        WHEN minmax = 'min' THEN MIN(salary)
        WHEN minmax = 'max' THEN MAX(salary)
        ELSE MAX(salary) - MIN(salary)
        END AS salary_info
        INTO contract_salary
	FROM salaries
    WHERE emp_no = empno;
    RETURN contract_salary;
END$$

DELIMITER ;

SELECT find_contract(11356, 'max') AS max_salary;
####### ______ #######