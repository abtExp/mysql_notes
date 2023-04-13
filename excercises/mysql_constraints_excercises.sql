/*
1. create the “items” table  

(columns - data types:  

item_code – VARCHAR of 255,  

item – VARCHAR of 255,  

unit_price – NUMERIC of 10 and 2,  

company­_id – VARCHAR of 255),  

and the “companies” table  

(company_id – VARCHAR of 255,  

company_name – VARCHAR of 255,  

headquarters_phone_number – integer of 12). 

*/

CREATE TABLE IF NOT EXISTS items (
    item_code VARCHAR(255) NOT NULL,
    item VARCHAR(255) NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,
    company_id VARCHAR(255) NOT NULL
);

CREATE TABLE companies (
    company_id VARCHAR(255) NOT NULL,
    company_name VARCHAR(255) NOT NULL,
    headquarters_phone_number INT(12) NOT NULL
);

/*
add a “gender” column in the “customers” table, and will then insert a new record in it.
*/

ALTER TABLE customers
ADD COLUMN gender ENUM('M', 'F') AFTER last_name;

INSERT INTO customers (
    first_name, 
    last_name, 
    gender, 
    email_address, 
    number_of_complaints
)
VALUES (
'John', 
'Mackinley', 
'M', 
'john.mckinley@365careers.com',
0
);


/*
Recreate the “companies” table

(company_id – VARCHAR of 255,  

company_name – VARCHAR of 255,  

headquarters_phone_number – VARCHAR of 255),    

This time setting the “headquarters phone number” to be the unique key, and default value of the company's name to be “X”. 

*/

DROP TABLE companies;

CREATE TABLE companies (
    company_id VARCHAR(255) NOT NULL,
    company_name VARCHAR(255) NOT NULL DEFAULT 'X',
    headquarters_phone_number INT(12) NOT NULL,
    PRIMARY KEY (company_id),
    UNIQUE KEY(headquarters_phone_number)
);

# OR
# ALTER TABLE companies
# ADD UNIQUE KEY (headquarters_phone_number);


/*
Using ALTER TABLE, first add the NULL constraint to the headquarters_phone_number 
field in the “companies” table, and then drop that same constraint.
*/

ALTER TABLE companies
MODIFY COLUMN headquarters_phone_number INT(12) NULL;


ALTER TABLE companies
CHANGE COLUMN headquarters_phone_number 
headquarters_phone_number INT(12) NOT NULL;