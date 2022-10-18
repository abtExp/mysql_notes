/*
	Subqueries are SQL queries nested within an outer query encapsulated in paranthesis,
    returning either a single element, a row, or a whole table.
    There can be multiple subqueries within an outer query and even inside a subquery.
    Subqueries are executed inner most to outer most.
    They allow for writing more complex queries.
*/

/*
Excercise 1 : Extract the information about all department managers who were hired between the 1st of January 1990 and the 1st of January 1995.
*/
# We need dept_manager table as it contains all the managers info, we also need the employees table as it contains the hiring date info
# This can be achieved using two ways, either using joins, or using subqueries.
# First let's try with subqueries

# METHOD 1 : USING dept_manager as a subquery
SELECT 
    E.emp_no,
    E.first_name,
    E.last_name,
    E.birth_date,
    E.hire_date,
    E.gender
FROM
    employees E
WHERE
    E.emp_no IN (SELECT 
            DM.emp_no
        FROM
            dept_manager DM)
        AND E.hire_date BETWEEN '1990-01-01' AND '1995-01-01';
        
# METHOD 2 : USING employees in subquery
SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT 
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');
            
# Using joins
SELECT 
    *
FROM
    employees E
        JOIN
    dept_manager DM ON E.emp_no = DM.emp_no
WHERE E.hire_date BETWEEN '1990-01-01' AND '1995-01-01';

/*
	EXISTS and NOT EXISTS is another way of replacing IN
    EXISTS and NOT EXISTS return a BOOL and perform check row by row
    whereas IN checks within the values, thus EXISTS and NOT EXISTS
    are faster on large datasets while IN is faster on smaller datasets.
    ORDER BY can be applied either in the subquery or the outer query, but
    as a best practice, should be applied on the outer query.
    
    some subqueries can be replaced using joins which are particularly faster, 
    but it isn't always possible to get the same results using joins, thus subqueries
    are also important.
    subqueries are performantly more compute intensive than joins, but they offer great code
    readability and isolated structuring of different aspects of the query thus are also useful.
*/

# Using EXISTS and NOT EXISTS
/*
	Excercise : Select all info of employees whose title is Assistant Engineer
*/
SELECT 
    *
FROM
    employees E
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles T
        WHERE
            title = 'Assistant Engineer'
                AND E.emp_no = T.emp_no); 
                
/* Excercise 3 : 
Fill emp_manager with data about employees, the number of the department they are working in, and their managers.
Assign employee number 110022 as a manager to all employees from 10001 to 10020 (this must be subset A), 
and employee number 110039 as a manager to all employees from 10021 to 10040 (this must be subset B).
Use the structure of subset A to create subset C, where you must assign employee number 110039 as a manager to employee 110022.
Following the same logic, create subset D. Here you must do the opposite - assign employee 110022 as a manager to employee 110039.
Your output must contain 42 rows.
*/

# Creating Table
DROP TABLE IF EXISTS emp_manager;
CREATE TABLE IF NOT EXISTS emp_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4),
    manager_no INT(11) NOT NULL
);


# Filling Data
# This is going to be a big one.
INSERT INTO emp_manager
SELECT 
    U.*
FROM
    (SELECT 
        A.*
    FROM
        (SELECT 
        E.emp_no,
            MIN(DE.dept_no) AS dept_no,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = '110022') AS manager_no
    FROM
        employees E
    JOIN dept_emp DE ON E.emp_no = DE.emp_no
    WHERE
        E.emp_no <= '10020'
    GROUP BY E.emp_no
    ORDER BY E.emp_no) A UNION SELECT 
        B.*
    FROM
        (SELECT 
        E.emp_no,
            MIN(DE.dept_no) AS dept_no,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = '110039') AS manager_no
    FROM
        employees E
    JOIN dept_emp DE ON E.emp_no = DE.emp_no
    WHERE
        E.emp_no BETWEEN '10021' AND '10040'
    GROUP BY E.emp_no
    ORDER BY E.emp_no) B UNION SELECT 
        C.*
    FROM
        (SELECT 
        E.emp_no,
            MIN(DE.dept_no) AS dept_no,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = '110022') AS manager_no
    FROM
        employees E
    JOIN dept_emp DE ON E.emp_no = DE.emp_no
    WHERE
        E.emp_no = '110039'
    GROUP BY E.emp_no) C UNION SELECT 
        D.*
    FROM
        (SELECT 
        E.emp_no,
            MIN(DE.dept_no) AS dept_no,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = '110039') AS manager_no
    FROM
        employees E
    JOIN dept_emp DE ON E.emp_no = DE.emp_no
    WHERE
        E.emp_no = '110022'
    GROUP BY E.emp_no) D) U;
    
SELECT * FROM emp_manager;