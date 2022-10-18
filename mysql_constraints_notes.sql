# MySQL Constraint Notes

# Let's First Begin With Primary Keys;
######## 1. PRIMARY KEYS ########
/*
	Primary keys are unique values that should exist for each entry and can define each entry uniquely thus primary keys
    are non null unique values.
    Primary keys can be set in two ways, either at the inline level when defining a column, or as a separate statement.
    but primary keys should be defined at the time of table creation.
    Auto increment can only be applied to primary keys, unique keys or indexes with int type as it adds one to the previous value.
    No need to define NOT NULL for primary keys as it is the default behaviour.
*/

# Let's Define a table using method 1 (inline)
CREATE TABLE IF NOT EXISTS sales(
	purchase_number INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    date_of_purchase DATETIME NOT NULL,
    customer_id INT,
    item_code VARCHAR(255) NOT NULL
);

# Using method 2 (separate statement), let's define another table
CREATE TABLE IF NOT EXISTS customers(
	customer_id INT AUTO_INCREMENT,
    customer_name VARCHAR(255),
    gender ENUM('M', 'F'),
    customer_email VARCHAR(255),
    PRIMARY KEY (customer_id)
);

######## 2. FOREIGN KEYS ########
/* 
	Foreign keys allows to establish relation between two tables with one table referencing primary key of another table
    There can be multiple references to the same entry using the foreign key.
    Foreign keys can be applied using either a statement during the table creation or later using ALTER TABLE statement.
    ON DELETE CASCADE is a special clause that can be added, to delete all the values in the referencing table (which is using the primary key as foreign key)
    in case of deletion of that entry from the primary key table.
*/

# Method 1 (using statement during creation)
DROP TABLE IF EXISTS sales;
CREATE TABLE IF NOT EXISTS sales(
	purchase_number INT NOT NULL AUTO_INCREMENT,
    date_of_purchase DATETIME NOT NULL,
    customer_id INT,
    item_code VARCHAR(255) NOT NULL,
    PRIMARY KEY (purchase_number),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

# Method 2 (using alter table statement)
DROP TABLE IF EXISTS sales;
CREATE TABLE IF NOT EXISTS sales(
	purchase_number INT NOT NULL AUTO_INCREMENT,
    date_of_purchase DATETIME NOT NULL,
    customer_id INT,
    item_code VARCHAR(255) NOT NULL,
    PRIMARY KEY (purchase_number)
);

ALTER TABLE sales
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE;

# Cool, now we've defined the methods to add primary and foreign keys, let's take a look at unique keys now
######## 3. UNIQUE KEYS ########
/*
	UNIQUE Keys constraints on any column that tells that each entry in that column should be unique,
    for example in customers table, email of each user should be unique.
    Unique key can also be added either as a separate statement or as part of the ALTER TABLE
*/

# Method 1 (as separate statement)
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS customers(
	customer_id INT AUTO_INCREMENT,
    customer_name VARCHAR(255),
    gender ENUM('M', 'F'),
    customer_email VARCHAR(255),
    PRIMARY KEY (customer_id),
    UNIQUE KEY (customer_email)
);

# Method 2 (as ALTER statement)
DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS customers(
	customer_id INT AUTO_INCREMENT,
    customer_name VARCHAR(255),
    gender ENUM('M', 'F'),
    customer_email VARCHAR(255),
    PRIMARY KEY (customer_id)
);

ALTER TABLE customers
ADD UNIQUE KEY (customer_email);

# Dropping unique key
ALTER TABLE customers
DROP INDEX customer_email;

######## 4. DEFAULT CONSTRAINT ########
/*
	Default constraint allows to set a default value for each entry and will assign that default value to a new entry if
    the value for that column is not provided at the time of inserting.
    Default can be added at the time of creation when defining a column or by using alter statement
*/

# Method 1 (at time of definition)
DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS customers(
	customer_id INT AUTO_INCREMENT,
    customer_name VARCHAR(255),
    gender ENUM('M', 'F'),
    customer_email VARCHAR(255),
    number_of_complaints INT DEFAULT 0,
    PRIMARY KEY (customer_id),
    UNIQUE KEY (customer_email)
);

# Method 2 (Using alter statement)
DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS customers(
	customer_id INT AUTO_INCREMENT,
    customer_name VARCHAR(255),
    gender ENUM('M', 'F'),
    customer_email VARCHAR(255),
    number_of_complaints INT,
    PRIMARY KEY (customer_id),
    UNIQUE KEY (customer_email)
);

ALTER TABLE customers
CHANGE COLUMN number_of_complaints number_of_complaints INT DEFAULT 0;

# Removing Default
ALTER TABLE customers
ALTER COLUMN number_of_complaints DROP DEFAULT;

######## 5. NOT NULL CONSTRAINT ########
/*
	NOT NULL is used to constraint a column to be requiring a value when entering the data
    and during insertion, the value must be passed and can't be left as null.
    NOT NULL constraint can be defined during column definition as well as using ALTER TABLE statement
    MODIFY column_name is special statement to remove NOT NULL constraint using ALTER TABLE
*/

# Method 1 (during definition)
CREATE TABLE IF NOT EXISTS sales(
	purchase_number INT NOT NULL AUTO_INCREMENT,
    date_of_purchase DATETIME NOT NULL,
    customer_id INT,
    item_code VARCHAR(255) NOT NULL,
    PRIMARY KEY (purchase_number)
);

# Method 2 (using alter statement)
DROP TABLE IF EXISTS sales;
CREATE TABLE IF NOT EXISTS sales (
    purchase_number INT AUTO_INCREMENT,
    date_of_purchase DATETIME NOT NULL,
    customer_id INT,
    item_code VARCHAR(255),
    PRIMARY KEY (purchase_number)
);

ALTER TABLE sales
CHANGE COLUMN item_code item_code VARCHAR(255) NOT NULL;

# Dropping NOT NULL constraint
ALTER TABLE sales
MODIFY item_code VARCHAR(255);

# AND THERE WE HAVE IT, ALL CONSTRAINTS AND METHODS TO ADD AND REMOVE THEM.