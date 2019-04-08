-- Start of SQL Homework for Omar Castillo

-- Ensure we are using the Sakila Database
USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT concat(first_name, " ", last_name) as "Actor Name"
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
# could also use wild card, WHERE first_name like "%Joe%;
WHERE first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name
FROM actor 
WHERE last_name like "%GEN%";

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name
FROM actor
WHERE last_name like "%LI%"
ORDER BY last_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description,
--  so create a column in the table actor named description and use the data type BLOB 
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD COLUMN Description TINYBLOB AFTER last_name;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor DROP Description;

-- 4a. List the last names of actors, as well as how many actors have that last name
#You need to use the group by otherwise, returns just one last name value with the total count of the table
SELECT  last_name, count(*) as 'Count'
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name,
--  but only for names that are shared by at least two actors
SELECT  last_name, count(*) as 'Count'
FROM actor
GROUP BY last_name
HAVING Count >= 2;

-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table  as `GROUCHO WILLIAMS`. Write a query to fix the record.
#Check specifc line item that needs to be updated
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'GROUCHO' and last_name = 'Williams';
#From the above call we see that the actor_id for item to be updated is 172
UPDATE actor
SET first_name = "HARPO"
WHERE actor_id = 172;
#Check that we updated row correctly
SELECT actor_id, first_name, last_name FROM actor WHERE actor_id = 172;

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all!
-- In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor SET first_name = "GROUCHO" WHERE actor_id = 172;
#Check if change was correct
SELECT * FROM actor WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
DESCRIBE address;

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT s.first_name, s.last_name, a.address
FROM address a
INNER JOIN staff s ON
a.address_id = s.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
#SELECT * FROM payment;
#Select the columns we want to pull up, including the sum of payment amounts as Total
SELECT p.staff_id, s.first_name, s.last_name, SUM(p.amount) as 'Total'
FROM payment p 
INNER JOIN staff s ON
s.staff_id = p.staff_id
WHERE p.payment_date like '%2005-08%'
GROUP BY p.staff_id;
#Check our totals with the sum of payment amount for 08-2005
SELECT SUM(amount) FROM payment WHERE payment_date like '%2005-08%';

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.




