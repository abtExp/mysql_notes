/* 

Temporary tables are used to store intermediate results and persist those results for later use in a single session,
without having to refer to the original tables in the database each time you need those results.

Suppose you need some information from 2 different tables and you write a query with joins to obtain those results,
If those results are needed later in the session, rather than obtaining from dataset again by querrying again, 
we can store the results in a temporary table and use that temporary table as a full fledged table for later use.

the temporary tables are lost as soon as the session closes (i.e., a connection to the database is closed).

To create a temporary table, simply write

CREATE TEMPORARY TABLE temporary_table_name

above the select statements.

sample :
*/

CREATE TEMPORARY TABLE highest_salaries
WITH hired_post_2000_cte AS (
    SELECT * FROM employees WHERE hire_date > '2000-01-01'
),

highest_salary_cte AS (
    SELECT e.emp_no, MAX(s.salary) FROM hired_post_2000_cte e JOIN salaries s ON e.emp_no = s.emp_no GROUP BY e.emp_no
)
SELECT * FROM highest_salary_cte;


/*

In a select statement, a temporary table can only be accessed once, that is, it cannot be used for joins or unions with itself.

But using CTEs we can workaround this issue

*/

# This doesn't work

SELECT *
FROM highest_salaries h1
JOIN
highest_salaries h2;

# This does work
WITH hired_post_2000_cte AS (
    SELECT * FROM employees WHERE hire_date > '2000-01-01'
),

highest_salary_cte AS (
    SELECT e.emp_no, MAX(s.salary) FROM hired_post_2000_cte e JOIN salaries s ON e.emp_no = s.emp_no GROUP BY e.emp_no
)
SELECT * 
FROM highest_salaries h
JOIN
highest_salary_cte hs;