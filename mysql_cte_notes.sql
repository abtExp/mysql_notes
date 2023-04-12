/*

CTEs or Common Table Expressions are a way to write named subqueries that can be referenced multiple times.
They are basically subqueries wrapped inside a WITH clause and an alias.

Format for writing a CTE is : 

WITH cte_name_1 AS (sub_query_1),
cte_name_2 AS (sub_query_2),
.
.
.
SELECT
..
..

sample query : 

*/

WITH avg_salary_cte AS (
    SELECT 
        AVG(salary) as average_salary
    FROM salaries
),
female_salaries_cte AS (
    SELECT 
        s.emp_no,
        MAX(s.salary) as f_highest_salary
    FROM 
        salaries s
            JOIN
        employees e ON e.emp_no = s.emp_no AND e.gender = 'F'
    GROUP BY s.emp_no
)
SELECT
    SUM(
        CASE
            WHEN fe.f_highest_salary > ac.average_salary THEN 1
            ELSE 0
        END
    ) AS f_higer_than_avg_salary
FROM
    employees e
JOIN
    female_salaries_cte fe
ON fe.emp_no = e.emp_no
CROSS JOIN
    avg_salary_cte ac;

/*

CTEs can also be referenced within CTEs (only previously defined CTEs can be referenced)

sample query : 
*/

WITH hired_post_2000_cte AS (
    SELECT * FROM employees WHERE hire_date > '2000-01-01'
),

highest_salary_cte AS (
    SELECT e.emp_no, MAX(s.salary) FROM hired_post_2000_cte e JOIN salaries s ON e.emp_no = s.emp_no GROUP BY e.emp_no
)
SELECT * FROM highest_salary_cte;