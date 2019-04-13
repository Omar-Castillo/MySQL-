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
SELECT f.title as "Movie Title", COUNT(fa.film_id) as "Number of Actors"
FROM film_actor as fa
INNER JOIN film as f ON
 fa.film_id = f.film_id
GROUP BY fa.film_id;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system? There is (6) copies of Hunchback Impossible.
SELECT f.title as "Movie Title",  COUNT(i.film_id) as "Movie Inventory"
FROM inventory as i 
INNER JOIN film as f on
f.film_id = i.film_id
#at this stage shows all movie inventory
#now search for "Hunchback Impossible"
GROUP BY i.film_id
HAVING f.title = "Hunchback Impossible";

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
#SELECT * FROM payment;
#SELECT * FROM customer;
SELECT c.first_name, c.last_name, SUM(p.amount) as "Total Amount Paid"
FROM payment as p
INNER JOIN customer as c ON
c.customer_id = p.customer_id
GROUP BY p.customer_id
ORDER BY c.last_name; # ascending is the default #

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the 
-- letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
#SELECT * FROM  film;
#SELECT * FROM language;

SELECT title, language_id FROM film WHERE title like "K%" or title like "Q%" AND language_id IN(
	SELECT language_id FROM language WHERE name = "English");
    
-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
#SELECT * FROM film;
#SELECT * FROM actor;
#SELECT * FROM film_actor;

SELECT actor_id, first_name, last_name FROM actor WHERE actor_id IN(
	SELECT actor_id FROM film_actor WHERE film_id IN(
		SELECT film_id FROM film WHERE title = "Alone Trip")
        );
        
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
#SELECT * FROM customer;
#SELECT * FROM country where country = "Canada";
#SELECT * FROM address;
#SELECT * from city where country_id = 20;
SELECT c.first_name, c.last_name, c.email, co.country_id
FROM customer c
JOIN address a ON a.address_id = c.address_id 
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id WHERE co.country = "Canada"; # here we finally include our filter for Canada on last join

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
#Select * FROM film;
#SELECT * FROM category WHERE name = "Family";
#Select * FROM film_category WHERE category_id = 8;

SELECT f.title FROM film f WHERE  f.film_id IN (
	SELECT fc.film_id FROM film_category fc  WHERE fc.category_id IN(
		SELECT c.category_id FROM category c WHERE c.name = "Family")
        );
--  7e. Display the most frequently rented movies in descending order.
#SELECT * FROM rental;
#SELECT * FROM inventory;
#SELECT * FROM film;

SELECT f.title, COUNT(r.rental_id) as "Total Rentals"
FROM rental r
JOIN inventory i on r.inventory_id = i.inventory_id
JOIN film f on i.film_id = f.film_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id)  DESC;

--  7f. Write a query to display how much business, in dollars, each store brought in.
#SELECT * FROM store;
#SELECT * FROM payment;
#SELECT * FROM staff;

SELECT s.store_id, SUM(p.amount) as "Total Sales"
FROM payment p 
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
#select * from store;
#select * from address;
#select * from  city;
#select * from country;

SELECT s.store_id, c.city, co.country
FROM store s 
JOIN address a ON s.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
#SELECT * FROM category;
#SELECT * FROM film_category;
#SELECT * FROM inventory;
#SELECT * FROM payment;
#SELECT * FROM rental;

SELECT c.name, SUM(p.amount) as "Gross"
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_grossing_categories AS
SELECT c.name, SUM(p.amount) as "Gross"
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_grossing_categories;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP view top_grossing_categories;
