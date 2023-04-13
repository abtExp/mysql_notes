/*
 insert information about employee number 999903. 
 State that he/she is a “Senior Engineer”, 
 who has started working in this position on October 1st, 1997
*/

INSERT INTO employees (emp_no, role, start_date)
VALUES (999903, 'Senior Engineer', '1997-10-01')

/*
Insert information about the individual with employee number 999903 into the “dept_emp” table. 
He/She is working for department number 5, and has started work on  October 1st, 1997; 
her/his contract is for an indefinite period of time.
*/

INSERT INTO dept_emp (emp_no, dept_no, start_date, end_date)
VALUES (999903, 5, '1997-10-01', '9999-01-01');


# Create a new department called “Business Analysis”. Register it under number ‘d010’.

INSERT INTO departments (dept_no, dept_no)
VALUES ('Business Analysis', 'd010');