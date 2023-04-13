#1. Create the “Sales” database

CREATE DATABASE IF NOT EXISTS sales;

#2. Use sales;

USE sales;

/*3. Create the “customers” table in the “sales” database. 
Let it contain the following 5 columns: 
customer_id, first_name, last_name, email_address, and number_of_complaints. 
Let the data types of customer_id and number_of_complaints be integer, 
while the data types of all other columns be VARCHAR of 255.

*/

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT(8) NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email_address VARCHAR(255) NOT NULL,
    number_of_complaints INT(8),
    PRIMARY KEY (customer_id)
);


#4. Drop table

DROP TABLE customers;