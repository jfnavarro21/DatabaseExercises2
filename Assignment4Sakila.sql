/*********************************************** ** File: Assignment4.sql ** Desc: Assignment 4 ** Author: ** Date: ************************************************/
# Using the Sakila database, provide both the SQL queries you used and the output of the following queries ( screen shot )
#################################### QUESTION 1 ################################

# a) Show the list of databases.
SHOW DATABASES;
# b) Select sakila database.
USE sakila;
# c) Show all tables in the sakila database.
SHOW TABLES;
# d) Show each of the columns along with their data types for the actor table.
DESCRIBE actor;
# e) Show the total number of records in the actor table.
SELECT COUNT(*) FROM actor;
# f) What is the first name and last name of all the actors in the actor table ?
SELECT
	first_name,
    last_name
FROM
	actor;
# g) Insert your first name and middle initial ( in the last name column ) into the actors table.
INSERT into `actor`
	(`actor_id`,`first_name`,`last_name`, `last_update`)
VALUES
	('201', 'John', 'Navarro', '2006-02-15 04:34:33');

SELECT 
	*
FROM
	actor
WHERE
	actor_id = 201;
# h) Update your middle initial with your last name in the actors table.

UPDATE
	actor
SET
	last_name = 'F'
WHERE
	last_name = 'Navarro';
# i) Delete the record from the actor table where the first name matches your first name.
SET SQL_SAFE_UPDATES=0;
DELETE FROM
	actor
WHERE
	first_name = 'John';

# j) Create a table payment_type with the following specifications and appropriate data types
# Table Name : “Payment_type”
# Primary Key: "payment_type_id”
# Column: “Type”

DROP TABLE IF EXISTS `Payment_type`;
CREATE TABLE `Payment_type` (
	`Payment_type_id` INT(10) NOT NULL,
	`Type` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`Payment_type_id`)
	)ENGINE=INNODB DEFAULT CHARSET=LATIN1;
select * from Payment_type;    
# Insert following rows in to the table: 1, “Credit Card” ; 2, “Cash”; 3, “Paypal” ; 4 , “Cheque”    
INSERT INTO `Payment_type`
	(`Payment_type_id`, `Type`)
VALUES
	('1','Credit Card'),
    ('2','Cash'),
    ('3','Paypal'),
    ('4','Cheque');
    
# k) Rename table payment_type to payment_types.
RENAME TABLE Payment_type TO payment_types;
DESCRIBE payment_types;
# l) Drop the table payment_types.
DROP TABLE payment_types;

################################## QUESTION 2 ################################
# a) List all the movies ( title & description ) that are rated PG-13 ?
DESCRIBE film;
SELECT 
	title,
    description,
    rating
FROM
	film
WHERE
	rating = 'PG-13';
# b) List all movies that are either PG OR PG-13 using IN operator ?
SELECT 
	title,
    description,
    rating
FROM
	film
WHERE
	rating IN ('PG' , 'PG-13');
# c) Report all payments greater than and equal to 2$ and Less than equal to 7$ ? # Note : write 2 separate queries conditional operator and BETWEEN keyword
SELECT * FROM payment;

select 
	payment_id,
    amount,
    payment_date
from
	payment

WHERE
	amount >=2 AND amount<= 7;
select 
	payment_id,
    amount,
    payment_date
from
	payment

WHERE
    amount BETWEEN 2 AND 7;
# d) List all addresses that have phone number that contain digits 589, start with 140 or end with 589 # Note : write 3 different queries
select * from address;

SELECT
	address_id,
    address,
    address2,
    district,
    phone
FROM 
	address
WHERE 
	phone LIKE '%589%';
    
SELECT
	address_id,
    address,
    address2,
    district,
    phone
FROM 
	address
WHERE 
	phone LIKE '140%';
    
SELECT
	address_id,
    address,
    address2,
    district,
    phone
FROM 
	address
WHERE 
	phone LIKE '%589';
# e) List all staff members ( first name, last name, email ) whose password is NULL ?
DESCRIBE staff;

select
	staff_id,
    first_name,
    last_name,
    password
from
	staff
WHERE
	password IS NULL;
# f) Select all films that have title names like ZOO and rental duration greater than or equal to 4
describe film;

select
	film_id,
    title,
    rental_duration
from
	film
where
	title like '%ZOO%' AND rental_duration>=4;
# g) Display addresses as N/A when the address2 field is NULL # Note : use IF and CASE statements
SELECT * FROM address;

SELECT
	IF(address2 is NULL, 'N/A', address) address,
    address2
from
	address;
    
select
	address_id,
    address2,
    (CASE WHEN address2 is NULL
		THEN 'N/A' ELSE address END)
	AS address
from 
	address;
# h) What is the cost of renting the movie ACADEMY DINOSAUR for 2 weeks ? # Note : use of column alias
select * from film;
SELECT
	title,
    (rental_rate * 14)/rental_duration as rental_cost
from
	film
WHERE
	title = 'ACADEMY DINOSAUR';
    
# i) List all unique districts where the customers, staff, and stores are located # Note : check for NOT NULL values
select * from address;

select distinct
	district
from
	address
where
	address is NOT NULL;
# j) List the top 10 newest customers across all stores

select * from customer;

select 
	customer_id,
	first_name,
    last_name,
    create_date
from
	customer
order by
	create_date desc
limit 10;
################################## QUESTION 3 ################################
# a) Show total number of movies
select count(*) from film;
# b) What is the minimum payment received and max payment received across all transactions ?
select* from payment;
select
	MIN(amount) min_pay,
    MAX(amount) max_pay
from
	payment;
# c) Number of customers that rented movies between Feb-2005 and May-2005 ( based on payment date ).
select
	count(distinct
		(customer_id)) AS totalcust
from 
	payment
where
	payment_date >= '2005-01-31' AND
    payment_date <= '2005-06-01';
# d) List all movies where replacement_cost is greater than 15$ or rental_duration is between 6 and 10 days
select* from film;

select 
	title
from
	film
where replacement_cost>15 OR (rental_duration >6 AND rental_duration<10);
# e) What is the total amount spent by customers for movies in the year 2005 ?
select * from payment;
select
	SUM(amount) AS total_spent
from
	payment
where
	payment_date like '2005%';
    
# f) What is the average replacement cost across all movies ?
select * from film;
select
	avg(replacement_cost) as avgReplaceCost
from
	film
where
	replacement_cost is NOT NULL;
# g) What is the standard deviation of rental rate across all movies ?
select
	std(rental_rate) as sdRentalRate
from
	film
where
	rental_rate IS NOT NULL;
    
# h) What is the midrange of the rental duration for all movies
SELECT 
    (MAX(rental_duration) + MIN(rental_duration)) / 2 AS midRange
FROM
    film;
################################## QUESTION 4 ################################
# a) Customers sorted by first Name and last name in ascending order.
select * from customer;

select
	first_name,
    last_name
from
	customer
order by
	last_name;
# b) Group distinct addresses by district.
select distinct
	address,
    district
from
	address
order by
	district;
# c) Count of movies that are either G/NC-17/PG-13/PG/R grouped by rating.
select * from film;
select
	count(film_id) as numMovies,
    rating
from 
	film
where 
	rating IN ('G', 'NC-17','PG-13','PG','R')
group by
	rating;
# d) Number of addresses in each district.
select
	count(distinct (address)),
    district
from 
	address
group by 
	district;
# e) Find the movies where rental rate is greater than 1$ and order result set by descending order.
select * from film;
select
	title,
    rental_rate
from
	film
where
	rental_rate > 1
order by 
	rental_rate DESC;
# f) Top 2 movies that are rated R with the highest replacement cost ?
select
	title,
    rating,
    replacement_cost
from
	film
where
	rating = 'R'
order by
	replacement_cost
LIMIT 2;
# g) Find the most frequently occurring (mode) rental rate across products.
SELECT * FROM film;
SELECT 
	COUNT(title) AS filmCount,
    rental_rate
FROM
	film
GROUP BY rental_rate
ORDER BY filmCount DESC
LIMIT 1;
# h) Find the top 2 movies with movie length greater than 50mins and which has commentaries as a special features.
select
	title,
    length,
    special_features
from
	film
where
	length > 50 AND
		special_features like '%Commentaries%'
LIMIT 2;

# i) List the years with more than 2 movies released.
select * from film;
SELECT
	COUNT(title) AS movieCount,
    release_year
FROM
	film
GROUP BY 
	release_year
HAVING movieCount > 2;