/*

A db has CRUD operations defined over it, to Create data, i.e., INSERT data in table, 
Read data, i.e., to SELECT or fetch data from the table,
Update data, i.e., to UPDATE data that already exists in the table with new information or remove unnecessary data, 
and Delete data, i.e., to DELETE data that isn't valid or useful anymore.

Read or SELECT is defined in the mysql_select_notes file, here, let's define the Create(INSERT|CREATE), Update(UPDATE), and Delete(DELETE)


Create is defined in mysql in 2 ways, firstly creating a table, or database, and secondly to insert data into those tables and datasets.

1. CREATE

Follows the format : 
CREATE TABLE|DATABASE [IF NOT EXISTS] table_name|database_name

1.1 Database : Used to create a database.

*/

CREATE DATABASE IF NOT EXISTS fifa_db;

# to use the created database above, use the statement

USE fifa_db;

/*

1.2 Table : Used to create a table or schema within the active database.

*/

CREATE TABLE IF NOT EXISTS man_utd(
    player_id INT(8) PRIMARY KEY AUTO INCREMENT,
    player_name VARCHAR(128) NOT NULL,
    player_role ENUM("GK","LB", "RB", "CB", "CDM")
    player_age INT(8) NOT NULL
);

/* 

Let's also add a constraint to the player name to keep it unique (although that's not realistic;))

*/

ALTER TABLE man_utd 
ADD UNIQUE KEY (player_name);

/*

Let's look into Update now.


UPDATE|ALTER is used to update existing data in the table

Format is :

UPDATE table_name
SET column_name_1 = value_1, column_name_2 = value_2, ....
WHERE conditions;

Let's add a new column to the table first then we'll update it
*/

ALTER TABLE man_utd
ADD age_criteria ENUM("too young", "fine", "old");

/*

Now let's update the values in the age_criteria column

*/

UPDATE TABLE man_utd
SET age_criteria = 
CASE
    WHEN player_age BETWEEN 16 AND 20 THEN "too young"
    WHEN player_age BETWEEN 21 AND 26 THEN "fine"
    ELSE "old"
END
WHERE name IS NOT NULL;

/*

Let's check Delete now

DELETE|DROP is used to delete existing data in the table or existing table or existing database

let's delete the row with age = 29

*/

DELETE FROM man_utd WHERE age = 29;

/*

Now let's delete a column

*/

ALTER TABLE man_utd
DROP COLUMN age_criteria;


# Now let us delete a TABLE

DROP TABLE man_utd;

# and finally the database

DROP DATABASE fifa_db;


# Other way by which we can remove all the data from the table without deleting it's schema is

TRUNCATE TABLE man_utd;