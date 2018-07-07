-- Use the sakila database --
USE sakila

-- 1a -- 
SELECT first_name, last_name
FROM actor;

-- 1b -- 
SELECT CONCAT(first_name," ", last_name) AS "Actor Name"
FROM actor;

-- 2a -- 
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = "Joe"

-- 2b -- 
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE "%GEN%";

-- 2c --
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name ASC, first_name ASC;

-- 2d -- 
SELECT country_id, country 
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3a --
ALTER TABLE actor
ADD middle_name VARCHAR(30);

-- 3b -- 
-- Completed by editing the table in the alter table tab 

-- 3c --
ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a --
SELECT DISTINCT last_name, COUNT(last_name) AS "Last name count"
FROM actor
GROUP BY last_name;

-- 4b --
SELECT DISTINCT last_name, COUNT(last_name) AS "Last name count"
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1; 

-- 4c -- 
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

-- 4d --
UPDATE actor
SET first_name = "GROUCHO MUCHO"
WHERE first_name = "HARPO" AND last_name = "WILLIAMS";

-- 5a -- 
SHOW CREATE TABLE address;

-- 6a --
SELECT last_name, first_name, address AS "Address"
FROM staff 
JOIN address
ON (staff.address_id = address.address_id);

-- 6b -- 
SELECT last_name, first_name, SUM(amount) AS "Total amount in August 2005"
FROM staff
JOIN payment
ON (staff.staff_id = payment.staff_id)
WHERE payment_date BETWEEN "2005-08-01 00:00:00" AND "2005-08-30 23:59:59"
GROUP BY last_name;

-- 6c --
SELECT title, COUNT(actor_id) AS "Number of actors"
FROM film
INNER JOIN film_actor
ON (film.film_id = film_actor.film_id)
GROUP BY title;

-- 6d -- 
SELECT title, COUNT(inventory_id) AS "Number of copies"
FROM film
JOIN inventory
ON (film.film_id = inventory.film_id)
WHERE film.title = "Hunchback Impossible";

-- 6e --
SELECT last_name, first_name, SUM(amount) AS "Amount paid"
FROM customer
JOIN payment
ON (customer.customer_id = payment.customer_id)
GROUP BY customer.last_name
ORDER BY customer.last_name ASC;

-- 7a --
SELECT title 
FROM film
WHERE title LIKE "K%" OR title LIKE "Q%"
AND language_id IN(
	SELECT language_id
    FROM language
    WHERE name = "English"
    );
    
-- 7b --
SELECT last_name, first_name
FROM actor
WHERE actor_id IN(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN(
		SELECT film_id
        FROM film
        WHERE title = "Alone Trip"
        )
	);
    
-- 7c --
SELECT customer.last_name,customer.first_name, customer.email
FROM customer 
JOIN address
ON (customer.address_id = address.address_id)
JOIN city
ON (address.city_id = city.city_id)
JOIN country
ON (country.country_id = city.country_id)
WHERE country = "Canada";

-- 7d --
SELECT title 
FROM film
WHERE film_id IN(
	SELECT film_id
    FROM film_category 
    WHERE category_id IN(
		SELECT category_id 
        FROM category
        WHERE name = "Family"
        )
	);
    
-- 7e -- 
SELECT film.title, COUNT(rental.rental_id) AS "Times rented"
FROM film
JOIN inventory
ON(film.film_id = inventory.film_id)
JOIN rental
ON(inventory.inventory_id = rental.inventory_id)
GROUP BY film.title
ORDER BY COUNT(rental.rental_id) DESC;

-- 7f -- 
SELECT store.store_id, SUM(payment.amount)
FROM store
JOIN inventory
ON(store.store_id = inventory.store_id)
JOIN rental
ON(rental.inventory_id = inventory.inventory_id)
JOIN payment
ON(payment.rental_id = rental.rental_id)
GROUP BY store.store_id;

-- 7g --
SELECT store.store_id, city.city, country.country
FROM store
JOIN address
ON(store.address_id = address.address_id)
JOIN city
ON(address.city_id = city.city_id)
JOIN country
ON(city.country_id = country.country_id)
GROUP BY store.store_id;

-- 7h --
SELECT category.name, SUM(payment.amount) AS "Gross revenue"
FROM category
JOIN film_category
ON (category.category_id = film_category.category_id)
JOIN film
ON (film_category.film_id = film.film_id)
JOIN inventory
ON (film.film_id = inventory.film_id)
JOIN rental
ON (inventory.inventory_id = rental.inventory_id)
JOIN payment
ON (rental.rental_id = payment.rental_id)
GROUP BY category.name
ORDER BY SUM(amount) DESC;

-- 8a --
CREATE VIEW top_five_genres AS
SELECT category.name, SUM(payment.amount) AS "Gross revenue"
FROM category
JOIN film_category
ON (category.category_id = film_category.category_id)
JOIN film
ON (film_category.film_id = film.film_id)
JOIN inventory
ON (film.film_id = inventory.film_id)
JOIN rental
ON (inventory.inventory_id = rental.inventory_id)
JOIN payment
ON (rental.rental_id = payment.rental_id)
GROUP BY category.name
ORDER BY SUM(amount) DESC;

-- 8b -- 
SHOW CREATE VIEW top_five_genres;

-- 8c --
DROP VIEW top_five_genres;
        