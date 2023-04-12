/*
Window functions are functions that operate on a window or range or subset of data.

                            Window Functions
                            /               \
                           /                 \
                          /                   \
                    Aggregate               Non Aggregate
                                            /           \
                                           /             \
                                          /               \
                                       Ranking          Value


General Syntax of using window function is

SELECT *|column_name(s)
window_function OVER window_name AS resulting_column_name
FROM table_name|subquery
WINDOW window_name AS (PARTITION BY clause);

Sample Query : 

*/  

SELECT 
    emp_no, 
    salary,
    ROW_NUMBER() OVER wd AS row_number
FROM
    employees
WINDOW wd AS (PARTITION BY emp_no ORDER BY salary DESC);

/*

1. Ranking Window Functions

1.1. ROW_NUMBER
Assigns a row number to each partition row. Partition is how the data is divided when assigning row numbers.
For example, in the employees table, emp_id denotes an employee id of a unique employee, however there are multiple 
entries for the same emp_id in the table, so we can assign row numbers to each employee entry from 1 to the number of entries
for that emp_id in the table.

A partition is defined as the window clause, which can either be defined right after the OVER keyword, or defined later
after defining the data source in the FROM table_name|subquery statement.


sample row number queries :
*/

# Using window clause after OVER keyword
SELECT 
    emp_no, 
    salary,
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_number
FROM
    employees;


# Using WINDOW clause after the data source
SELECT 
    emp_no, 
    salary,
    ROW_NUMBER() OVER wd AS row_number
FROM
    employees
WINDOW wd AS (PARTITION BY emp_no ORDER BY salary DESC);

/*

PARTITION BY vs GROUP BY
 ___________________________________________________________________________
|                                     |                                     |
|           PARTITION BY              |             GROUP BY                |
|_____________________________________|_____________________________________|
|                                     |                                     |
|   Doesn't change the number of      |     Changes the number of output    |
|   output rows, only does internal   |     rows by aggregating the info    |
|   grouping/partitioning to perform  |     about each common entry.        |
|   logic/assignment.                 |                                     |
|_____________________________________|_____________________________________|
|                                     |                                     |
|   Can only be applied in context    |     Can be applied in the query     |
|   of window functions.              |     itself and not constrained to   |
|                                     |     window functions.               |
|_____________________________________|_____________________________________|

Obtaining same results using GROUP BY and PARTITION BY :

*/

# This query
SELECT 
    emp_no, 
    MAX(salary) as max_salary
FROM employees
GROUP BY emp_no;

# Returns the same results as this query (without using GROUP BY clause or MAX aggregating function)
SELECT 
    a.emp_no,
    a.salary AS max_salary
FROM
    (
        SELECT emp_no,
        ROW_NUMBER() OVER wd AS row_number
        FROM employees
        WINDOW wd AS (PARTITION BY emp_no ORDER BY salary DESC)
    ) a
WHERE a.row_number = 1;

/*

1.2. RANK & DENSE_RANK

ROW_NUMBER assigns unique row numbers based on partition to each entry, so for example, for a dataset
 _______________________________________
|                   |                   |
|     emp_no        |       salary      |
|___________________|___________________|
|                   |                   |
|       1001        |       75000       |
|___________________|___________________|
|                   |                   |
|       1001        |       75000       |
|___________________|___________________|
|                   |                   |
|       1001        |       80000       |
|___________________|___________________|
|                   |                   |
|       1001        |       95000       |
|___________________|___________________|


if we apply ROW_NUMBER ranking window function, we'll obtain

*/

SELECT 
    emp_no, 
    salary, 
    ROW_NUMBER() OVER wd AS row_number
FROM
    employees
WHERE emp_no = 1001
WINDOW wd AS (PARTITION BY emp_no ORDER BY salary DESC);

/*

 _______________________________________________________________
|                   |                   |                       |
|     emp_no        |       salary      |       row_number      |
|___________________|___________________|_______________________|
|                   |                   |                       |
|       1001        |       75000       |           1           |
|___________________|___________________|_______________________|
|                   |                   |                       |
|       1001        |       75000       |           2           |
|___________________|___________________|_______________________|
|                   |                   |                       |
|       1001        |       80000       |           3           |
|___________________|___________________|_______________________|
|                   |                   |                       |
|       1001        |       95000       |           4           |
|___________________|___________________|_______________________|

, but as we can see, that the salary for first and the second entry for this employee is same,
and in some cases, we'd rather have the result from the window function represent that, 

thus comes in RANK

RANK ranks the rows based on the values in the ORDER BY clause column and assigns unique numbers to unique entries and same rank to 
same entries while still incrementing with 1, thus if 2 entries are same, the next unique entry after the 
same entries will have a rank incremented by 2.

So calling RANK window function as follows :
*/

SELECT 
    emp_no, 
    salary, 
    RANK() OVER wd AS rank_number
FROM
    employees
WHERE emp_no = 1001
WINDOW wd AS (PARTITION BY emp_no ORDER BY salary DESC);

/*
will result in the following

 _______________________________________________________________
|                   |                   |                       |
|     emp_no        |       salary      |       row_number      |
|___________________|___________________|_______________________|
|                   |                   |                       |
|       1001        |       75000       |           1           |
|___________________|___________________|_______________________|
|                   |                   |                       |
|       1001        |       75000       |           1           |
|___________________|___________________|_______________________|
|                   |                   |                       |
|       1001        |       80000       |           3           |
|___________________|___________________|_______________________|
|                   |                   |                       |
|       1001        |       95000       |           4           |
|___________________|___________________|_______________________|

, but in some cases, we'd like to have the immediate next rank to be assigned to the next unique row, so we'd like for 
row 3 to have rank of 2, to do so, we use DENSE_RANK

so calling DENSE_RANK as follows :
*/


SELECT 
    emp_no, 
    salary, 
    DENSE_RANK() OVER wd AS rank_number
FROM
    employees
WHERE emp_no = 1001
WINDOW wd AS (PARTITION BY emp_no ORDER BY salary DESC);

/*
will result in the following

 _______________________________________________________________
|                   |                   |                       |
|     emp_no        |       salary      |       row_number      |
|___________________|___________________|_______________________|
|                   |                   |                       |
|       1001        |       75000       |           1           |
|___________________|___________________|_______________________|
|                   |                   |                       |
|       1001        |       75000       |           1           |
|___________________|___________________|_______________________|
|                   |                   |                       |
|       1001        |       80000       |           2           |
|___________________|___________________|_______________________|
|                   |                   |                       |
|       1001        |       95000       |           3           |
|___________________|___________________|_______________________|


Conclusively for ranking non-aggregating window functions, 
1. Ranking window functions all require OVER clause
2. Rank values generated by them are sequential starting from 1.
3. The subsequent ranks are incremented by 1 or by how the ranking function handles the increment.
4. RANK and DENSE_RANK are only useful on ordered records(Where partition is defined with an ORDER BY clause).
5. ROW_NUMBER can be used without ORDER BY clause as it doesn't depend on the order of the partitions.

*/


/*

2. Value window functions

These window functions return a value that exists in the database rather than ranking rows.

2.1 LAG & LEAD

LAG returns the previous row value from the current row of a column passed as the argument
LEAD returns the next row value from the current row of a column passed as the argument

sample query : 

*/

SELECT
    emp_no,
    salary,
    LAG(salary) OVER wd AS previous_salary,
    LEAD(salary) OVER wd AS next_salary,
    salary - LAG(salary) OVER wd AS diff_curr_prev_salary,
    LEAD(salary) OVER wd - salary AS diff_next_curr_salary
FROM
    salaries
WHERE emp_no = 10001
WINDOW wd AS (ORDER BY salary DESC);

/*

3. Aggregate window functions


*/