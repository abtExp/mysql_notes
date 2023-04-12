/* SELECT statement is the most important statement for the data extraction and analysis in mysql.

SELECT in it's most basic form is like
*/

# SELECT * FROM table_name;

/*
This statement selects all rows and columns from the table table_name and returns the data.
SELECT statement is most useful when paired with other techniques and add-ons.
Some of which are : 
WHERE, AND, OR, IN, NOT IN, LIKE, NOT LIKE, BETWEEN AND, IS NOT NULL, IS NULL, 
DISTINCT, functions, subqueries, aggregate functions, joins, ORDER BY, GROUP BY, HAVING, LIMIT etc.

------------------------------------------------------------------------------------

A standard format of a select statement looks like this : 

SELECT *|[DISTINCT] column_name(s)
FROM table_name|subquery|function call
WHERE condition(s)
GROUP BY column_name(s)
HAVING condition(s)
ORDER BY column_name(s)
LIMIT number;


Breaking down one by one : 

1. SELECT *|column_name(s)

Fetches the provided column names, * indicates fetch all, i.e., get all the columns from the table and all the rows (given no fetch limit is provided using LIMIT)
column_name(s) is a comma separated list of column names that are to be fetched from the below resulting table.

DISTINCT tells only to return rows with unique values for the column name mentioned after the DISTINCT keyword.

Some sample queries : 

*/

SELECT * FROM players; # Fetches all the players in the players table and all the properties per player and returns #

SELECT name, age, height, weight FROM players; # Fetches only the provided properties for each player and returns #

SELECT DISTINCT name, age FROM players; # Fetches only the unique player names and returns #

/*
2. FROM table_name|subquery|function call

Directs where to fetch the data from, it can be either a table name, or a subquery, where a subquery returns a table itself, or a function call.


3. WHERE condition(s)

used to fetch selective data based on conditions

Some sample queries : 
*/

# Fetches player names, ages and heights of players younger than 25 years of age
SELECT name, age, height
FROM players
WHERE age < 25;

# Multiple conditions
SELECT name, age, height
FROM players
WHERE age < 25 AND height > 170;

# Ranged condition using BETWEEN
SELECT name
FROM players
WHERE age BETWEEN 20 AND 25;

/*

4. GROUP BY column_name(s)

Used in case a single entity has multiple entries in the table, for example, a player has played for different teams, he might be registered
with different ids per team.

Unique columns, like salary, matches_played, etc. are to be aggregated when grouping, as unique values can't represent same entry in outputs,
thus an aggregated reference to that column is required. 

sample queries :
*/

# Grouping on one column
SELECT name, SUM(matches_played), AVG(salary)
FROM players
GROUP BY pid;

# Grouping on multiple columns
SELECT name, SUM(matches_played), AVG(salary)
FROM players
GROUP BY pid, contract_id;

/*

5. HAVING condition(s)

Used when the condition is to be applied on aggregate of a column, for example :

*/
SELECT name
FROM players
HAVING AVG(salary) > 10000;

/*

WHERE doesn't work with aggregates.
WHERE is used to apply conditions before grouping. To filter further after obtaining the desired grouping, HAVING is used.

A sample showcasing difference between WHERE and HAVING :
*/


# This Does not Work !!
SELECT name, COUNT(name) as num_instances
FROM players
WHERE COUNT(name) > 2
GROUP BY name
ORDER BY name;


# This Does Work
SELECT name, COUNT(name) as num_instances
FROM players
GROUP BY name
HAVING COUNT(name) > 2
ORDER BY name;


/*

A sample with both WHERE and HAVING :

*/
SELECT name, age, AVG(salary) as avg_salary
FROM players
WHERE age < 25
GROUP BY name
HAVING AVG(salary) > 10000
ORDER BY age DESC
LIMIT 10;

/*

HAVING can't have both aggregated and non-aggregated conditions.

*/

# This does not work
SELECT name, age, AVG(salary) as avg_salary
FROM players
HAVING AVG(salary) > 10000 AND age < 25;

/*

6. LIMIT number

Limits the number of rows returned and returns only the number of rows passed as the argument number.
*/

SELECT name, age, AVG(salary) as avg_salary
FROM players
WHERE age < 25
GROUP BY name
HAVING AVG(salary) > 10000
ORDER BY age DESC
LIMIT 10;

/*

A complex SELECT statement looks somewhat like this : 


*/

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