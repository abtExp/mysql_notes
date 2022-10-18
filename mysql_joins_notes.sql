/* 
Joins are an essential part of SQL, they put the relational in the relational database.
Joins are necessary to extract information that is divided into several tables because of sanity of data
and derive insights from it.
These are the joins : 	1. INNER JOIN (or JOIN)
						2. LEFT OUTER JOIN (or LEFT JOIN)
						3. RIGHT OUTER JOIN (or RIGHT JOIN)
						4. SELF JOIN
						5. CROSS JOIN
						6. UNION
                        

*/

# Let's create sample table duplicates to run the experiments on
CREATE TABLE IF NOT EXISTS departments_dup(
	dept_no CHAR(4),
    dept_name VARCHAR(40)
);

INSERT INTO departments_dup (dept_no, dept_name)
	(SELECT dept_no, dept_name FROM departments);
    
SELECT * FROM departments_dup;

INSERT INTO departments_dup (dept_name) VALUES ('Public Relations');

DELETE FROM departments_dup WHERE dept_no = 'd002';

DROP TABLE IF EXISTS dept_manager_dup;

CREATE TABLE dept_manager_dup (

  emp_no int(11) NOT NULL,

  dept_no char(4) NULL,

  from_date date NOT NULL,

  to_date date NULL

  );

 

INSERT INTO dept_manager_dup

select * from dept_manager;

 

INSERT INTO dept_manager_dup (emp_no, from_date)

VALUES                (999904, '2017-01-01'),

                                (999905, '2017-01-01'),

                               (999906, '2017-01-01'),

                               (999907, '2017-01-01');

 

DELETE FROM dept_manager_dup

WHERE

    dept_no = 'd001';
    

####### 1. INNER JOIN #######
/*
	INNER JOIN joins the tables at the intersection, that is only keeps those records from both tables, which have matching entries on the join
    column.
    INNER JOIN can be defined using two ways, either using INNER JOIN or just JOIN.
*/

# Let's join the departments_dup and dept_manager_dup on dept_no

SELECT 
    DM.dept_no, DM.emp_no, D.dept_name
FROM
    dept_manager_dup DM
        JOIN
    departments_dup D ON DM.dept_no = D.dept_no
ORDER BY DM.dept_no;

# Order doesn't matter in INNER JOIN.
# So the above is equivalent to
SELECT 
    DM.dept_no, DM.emp_no, D.dept_name
FROM
    departments_dup D
        INNER JOIN
    dept_manager_dup DM ON D.dept_no = DM.dept_no
ORDER BY DM.dept_no;


# Excercise on INNER JOIN
/*
	Extract list containing information about all managers
    emp_no, first_name, last_name, dept_no, hire_date
*/

# We'll need the dept_manager and the employees table to extract this information
# as the dept_manager table contains info about managers and their dept_nos
SELECT 
    E.emp_no, E.first_name, E.last_name, D.dept_no, E.hire_date
FROM
    employees E
        INNER JOIN
    dept_manager D ON E.emp_no = D.emp_no
ORDER BY E.emp_no;


####### 2. LEFT JOIN #######
/*
	LEFT JOIN returns all the values of the table at the left of the operator and the ones matching with the right on the ON column
    order of the table names matter in this.
    It can also be written as LEFT OUTER JOIN as it is a type of outer join.
*/

# Left join exercise
SELECT 
    E.emp_no, E.first_name, E.last_name, D.dept_no, D.from_date
FROM
    employees E
        LEFT JOIN
    dept_manager D ON E.emp_no = D.emp_no
WHERE
    E.last_name = 'Markovitch'
ORDER BY D.dept_no DESC , E.emp_no;

# We can see that only one employee has a from_date column, that means only one employee is 
# in dept_manager table that is also in employees table, so there is only one employee who is a
# manager with a last name Markovitch

####### 3. RIGHT JOIN #######
/*
	RIGHT JOIN is basically a LEFT JOIN with inverted order of table names and is seldom used.
    it can be also written as RIGHT JOIN or RIGHT OUTER JOIN
    All entries from the table on the right will be included and entries from the table on the left
    will only be included if they have a matching entry on the ON column with the right table.
*/

####### 4. CROSS JOIN #######
/* 
	CROSS JOIN is basically a cartesian product, that is, each entry from one table matched with each entry of other table
    there's no ON parameter here.
    It is same  as using INNER JOIN without an ON parameter or SELECTing from multiple tables
*/
# Example
SELECT 
    DM.*, D.*
FROM
	dept_manager_dup DM
    CROSS JOIN
    departments_dup D
ORDER BY D.dept_no , DM.emp_no;

# Is similar to
SELECT 
    DM.*, D.*
FROM
    dept_manager_dup DM
        INNER JOIN
    departments_dup D
ORDER BY D.dept_no , DM.emp_no;

#Is similar to
SELECT 
    DM.*, D.*
FROM
    dept_manager_dup DM,
    departments_dup D
ORDER BY D.dept_no , DM.emp_no;

# Excercise
/*
	Use a CROSS JOIN to return a list with all possible combinations between managers from the dept_manager table and department number 9.
*/
SELECT 
    DM.*, D.*
FROM
    dept_manager_dup DM
        CROSS JOIN
    departments_dup D
WHERE
    D.dept_no = 'd009'
ORDER BY DM.dept_no , DM.emp_no DESC;

/*
Return a list with the first 10 employees with all the departments they can be assigned to.

Hint: Don’t use LIMIT; use a WHERE clause.
*/
SELECT 
    e.*, d.*
FROM
    employees e
        CROSS JOIN
    departments d
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no , d.dept_name;

/*
	Select all managers’ first and last name, hire date, job title, start date, and department name.
*/
SELECT 
    E.emp_no,
    E.first_name,
    E.last_name,
    E.hire_date,
    T.title,
    DM.from_date,
    D.dept_name
FROM
    dept_manager DM
        JOIN
    departments D ON DM.dept_no = D.dept_no
        JOIN
    employees E ON E.emp_no = DM.emp_no
        JOIN
    titles T ON DM.emp_no = T.emp_no
WHERE T.title = 'Manager'
ORDER BY E.emp_no
;

/*
	Select department name and average salaries for all managers in those departments
*/
SELECT 
    D.dept_name, AVG(S.salary) AS avg_salary
FROM
    dept_manager DM
        JOIN
    departments D ON DM.dept_no = D.dept_no
        JOIN
    salaries S ON DM.emp_no = S.emp_no
GROUP BY dept_name
HAVING avg_salary > 60000
ORDER BY avg_salary DESC
;

/*
	How many males and how many female managers are there in employees database?
*/
SELECT 
    E.gender, COUNT(DM.emp_no) AS num_employees
FROM
    dept_manager DM
        JOIN
    employees E ON E.emp_no = DM.emp_no
GROUP BY E.gender
ORDER BY num_employees DESC;


####### 6. UNION and UNION ALL #######
/*
	UNION and UNION ALL are used to combine two tables with each having the same columns, of relative data types
    It's basically appending one table entries at the end of the other table.
	If one of the tables is missing any columns from the other table, NULL AS column_name is used to proxy null values
    in that column.
    UNION is same as UNION ALL just that UNION ALL returns duplicates from the table and UNION doesn't
*/
# Let's combine departments and department manager tables
SELECT 
    NULL AS emp_no,
    D.dept_no,
    D.dept_name,
    NULL AS from_date,
    NULL AS to_date
FROM
    departments D 
UNION ALL SELECT 
    DM.emp_no,
    DM.dept_no,
    NULL AS dept_name,
    DM.from_date,
    DM.to_date
FROM
    dept_manager DM;