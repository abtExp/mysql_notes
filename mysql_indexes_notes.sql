/* 
	Indexes allow for faster searching through the database by searching using the indexes.
    Indexes are created on columns that are supposedly mostly used for searching for data.
    PRIMARY KEY and UNIQUE KEY are also indexes.
    The SQL optimizer stores the index information and uses the indexes to return results faster.
    Indexes can be created on a single column or on a number of coulumns using the format
    CREATE INDEX index_name ON table_name (column_name_1, column_name_2, ...);
*/

# Searching without index
SELECT * FROM employees
WHERE first_name = 'Anubhav'
AND last_name = 'Tiwari';

# It took about 0.109 seconds to run the above query.
# Let's now create an index on first and last name (composite index)

CREATE INDEX i_composite_name ON employees (first_name, last_name);

# Let's search again using the above
SELECT * FROM employees
WHERE first_name = 'Anubhav'
AND last_name = 'Tiwari';

# It took 0.000.. seconds, which is obviously much faster.

# Dropping the index
ALTER TABLE employees
DROP INDEX i_composite_name;

/* 
Excercise : Select all records from the ‘salaries’ table of people whose salary is higher than $89,000 per annum.
Then, create an index on the ‘salary’ column of that table, and check if it has sped up the search of the same SELECT statement.
*/

SELECT * FROM salaries WHERE salary > 89000;
# Took 0.016 seconds

# Creating index
CREATE INDEX salary ON salaries (salary);

# Searching again
SELECT * FROM salaries WHERE salary > 89000;