
# select database
USE classicmodels;

################### TRANSACTIONS ###################
# START TRANSACTION, COMMIT,and ROLLBACK

# start a new transaction
START TRANSACTION;

# force MySQL not to commit changes automatically
SET AUTOCOMMIT = 0;

# list all offices
SELECT * FROM offices;

# insert data relating to new offices into offices table
INSERT INTO `offices`(`officeCode`,`city`,`phone`,`addressLine1`,`addressLine2`,`state`,`country`,`postalcode`, `territory`) values 
('8', 'Chicago', '+1 312 219 4782', '100 clinton Street', 'Suite 300', 'IL', 'USA', '60661', 'NA'),
('9', 'Austin', '+1 512 974 9315', '500 Rutherford Lane', 'Suite 100', 'TX', 'USA', '78754', 'NA');

# list the offices and make sure the additional entries are reflected
SELECT * FROM offices;

# rollback the updates
ROLLBACK;

# notice that on ROLLBACK additional offices are not reflected in the offices table
SELECT * FROM offices;

# insert data again relating to new offices into offices table
INSERT INTO `offices`(`officeCode`,`city`,`phone`,`addressLine1`,`addressLine2`,`state`,`country`,`postalcode`, `territory`) values 
('8', 'Chicago', '+1 312 219 4782', '100 clinton Street', 'Suite 300', 'IL', 'USA', '60661', 'NA'),
('9', 'Austin', '+1 512 974 9315', '500 Rutherford Lane', 'Suite 100', 'TX', 'USA', '78754', 'NA');

# commit the above transaction
COMMIT;

# notice that once committed the transaction takes place and we have additional offices reflected
SELECT * FROM offices;

# delete the records that were added
SET SQL_SAFE_UPDATES=0;
DELETE FROM offices 
WHERE
    officecode IN (8 , 9);
    
# enable the default autocommit
SET autocommit = 1;

################### EXPLAIN ###################
# describes how a SELECT will be processed.
EXPLAIN SELECT * FROM orders WHERE orderNUmber=10104;


################### single table/data backups ######################
CREATE TABLE classicmodels.offices_bkup LIKE classicmodels.offices;
INSERT INTO classicmodels.offices_bkup SELECT * FROM classicmodels.offices;

# alternatively
CREATE TABLE IF NOT EXISTS offices_bkup SELECT * FROM
    offices;

# compare 2 tables to make sure the backup and the original tables are the same
SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        offices UNION ALL SELECT 
        *
    FROM
        offices_bkup) tbl
GROUP BY officeCode, city
HAVING COUNT(*) = 1
ORDER BY officeCode;

# Insert additional data into the original table
INSERT INTO 
OFFICES 
(officeCode, city, phone, addressLine1, addressLine2, state, country, postalCode, territory ) 
VALUES 
('11', 'Paris', '+33 14 723 5555', '43 Rue Jouffroy D\'abbans', NULL, NULL, 'France', '75017', 'EMEA' );

# compare 2 tables to make sure the new record is reflected.
SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        offices UNION ALL SELECT 
        *
    FROM
        offices_bkup) tbl
GROUP BY officeCode, city
HAVING COUNT(*) = 1
ORDER BY officeCode;

# delete the data inserted.
SET SQL_SAFE_UPDATES=0;
DELETE FROM offices 
WHERE
    officecode=11;

# drop the backup table    
DROP table offices_bkup;

################### DB ADMINISTRATION ###################
# DBA - managing user accounts, roles, privileges, and profiles 

# A consultant is hired and he/she needs access to the Orders table to solve a business problem. Access can be given based on the requirements and once the work is complete the access rights to the table can be revoked.
CREATE USER 'manager'@'localhost' IDENTIFIED BY 'manager';
CREATE USER 'salesrep'@'localhost' IDENTIFIED BY 'sales';

# grant user shree all privileges to the orders tables */
GRANT ALL ON orders TO 'salesrep'@'localhost';

# grant execute the SELECT, INSERT and UPDATE statements against the classicmodels database
GRANT SELECT, UPDATE, DELETE ON  classicmodels.* TO 'manager'@'localhost';

# update password for user salesrep
SET PASSWORD FOR 'salesrep'@'localhost' = PASSWORD('salesrep');

# now login as 'salesrep'@'localhost' and manager'@'localhost
# run the below insert statement and make sure it succeeds for manager and not for salesrep user.
INSERT INTO 
OFFICES 
(officeCode, city, phone, addressLine1, addressLine2, state, country, postalCode, territory ) 
VALUES 
('11', 'Paris', '+33 14 723 5555', '43 Rue Jouffroy D\'abbans', NULL, NULL, 'France', '75017', 'EMEA' );


# revoke all privileges from the orders table for user manager & salesrep 
REVOKE ALL ON orders FROM 'manager'@'localhost';
REVOKE SELECT, UPDATE, DELETE ON classicmodels.* FROM 'salesrep'@'localhost';

DROP USER 'manager'@'localhost';
DROP USER 'salesrep'@'localhost';


# LOCK / UNLOCK
# client session to acquire a table lock explicitly for preventing other sessions from accessing the table offices during a specific period.
LOCK TABLE offices READ;

# try inserting data into the offices table
INSERT INTO 
OFFICES 
(officeCode, city, phone, addressLine1, addressLine2, state, country, postalCode, territory ) 
VALUES 
('11', 'Paris', '+33 14 723 5555', '43 Rue Jouffroy D\'abbans', NULL, NULL, 'France', '75017', 'EMEA' );

# will get an error. unlock all tables.
UNLOCK TABLES;

# try insert a record after the unlock.
INSERT INTO 
OFFICES 
(officeCode, city, phone, addressLine1, addressLine2, state, country, postalCode, territory ) 
VALUES 
('11', 'Paris', '+33 14 723 5555', '43 Rue Jouffroy D\'abbans', NULL, NULL, 'France', '75017', 'EMEA' );

# check to see if the data is inserted in the office table
select * from offices;

# delete the data inserted.
SET SQL_SAFE_UPDATES=0;
DELETE FROM offices 
WHERE
    officecode=11;
