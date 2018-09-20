-- 1a. Display the first and last names of all actors from the table actor.
USE sakila;
SELECT first_name, last_name 
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
#Name the column Actor Name.
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name'
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, 
#"Joe." What is 1 query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = 'JOE';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
#This time, order the rows by last name and first name, in that order:
SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: 
#Afghanistan, Bangladesh, and China:
SELECT country_id,  country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description,
#so create a column in the table actor named description and use the data type BLOB 
#(Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor 
ADD COLUMN `description` BLOB NULL AFTER `last_update`;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
#Delete the description column.
ALTER TABLE actor 
DROP COLUMN `description`;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS `Count`
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
#but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS `Count`
FROM actor
GROUP BY last_name
HAVING Count > 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
#Write a query to fix the record.
UPDATE actor 
SET first_name= 'HARPO'
WHERE first_name='GROUCHO' AND last_name='WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
#In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor 
SET first_name= 'GROUCHO'
WHERE first_name='HARPO' AND last_name='WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
#Hint: dev.mysql.com/doc/refman/5.7/en/show-create-table.html
SHOW CREATE TABLE ADDRESS;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
#Use the tables staff and address
SELECT s.first_name, s.last_name, a.address
FROM staff s LEFT JOIN address a ON s.address_id = a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
#Use tables staff and payment.
SELECT s.first_name, s.last_name, SUM(p.amount) AS 'TOTAL'
FROM staff s LEFT JOIN payment p  ON s.staff_id = p.staff_id
GROUP BY s.first_name, s.last_name;

-- 6c. List each film and the number of actors who are listed for that film. 
#Use tables film_actor and film. Use inner join.
SELECT f.title, COUNT(a.actor_id) AS 'TOTAL'
FROM film f LEFT JOIN film_actor  a ON f.film_id = a.film_id
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(INVENTORY_ID) AS COPIES FROM INVENTORY
WHERE FILM_ID = (SELECT FILM_ID FROM FILM WHERE TITLE = 'Hunchback Impossible');

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
#List the customers alphabetically by last name: ![Total amount paid](Images/total_payment.png)
SELECT c.first_name, c.last_name, SUM(p.amount) AS 'TOTAL'
FROM customer c LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name

-- 7a.The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
USE SAKILA
SELECT TITLE FROM FILM
WHERE (TITLE LIKE 'K%' OR TITLE LIKE 'Q%') 
AND LANGUAGE_ID=(SELECT LANGUAGE_ID FROM LANGUAGE WHERE NAME='ENGLISH')

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
		IN (SELECT film_id from film where title='ALONE TRIP'))

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
#of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email from customer
JOIN ADDRESS ON CUSTOMER.ADDRESS_ID = ADDRESS.ADDRESS_ID
JOIN CITY ON ADDRESS.CITY_ID = CITY.CITY_ID
JOIN COUNTRY ON CITY.COUNTRY_ID = COUNTRY.COUNTRY_ID
WHERE COUNTRY = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
SELECT TITLE FROM FILM F
JOIN FILM_CATEGORY F_C ON F.FILM_ID = F_C.FILM_ID
JOIN CATEGORY C ON F_C.CATEGORY_ID = C.CATEGORY_ID
WHERE C.NAME = "Family";

-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(f.film_id) AS 'Count_of_Rented_Movies'
FROM  film f
JOIN inventory i ON (f.film_id= i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
GROUP BY title ORDER BY Count_of_Rented_Movies DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT S.STORE_ID, concat('$', format(SUM(AMOUNT), 2)) AS REVENUE FROM STORE S
JOIN INVENTORY I ON S.STORE_ID = I.STORE_ID
JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
JOIN PAYMENT P ON R.RENTAL_ID = P.RENTAL_ID
GROUP BY S.STORE_ID;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT STORE_ID, CITY, COUNTRY FROM STORE S
JOIN ADDRESS A ON S.ADDRESS_ID = A.ADDRESS_ID
JOIN CITY C ON A.CITY_ID = C.CITY_ID
JOIN COUNTRY COU ON C.COUNTRY_ID = COU.COUNTRY_ID;

-- 7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT NAME, concat('$', format(SUM(AMOUNT), 2)) AS REVENUE FROM CATEGORY C
JOIN FILM_CATEGORY FC ON C.CATEGORY_ID = FC.CATEGORY_ID
JOIN INVENTORY I ON FC.FILM_ID = I.FILM_ID
JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
JOIN PAYMENT P ON R.RENTAL_ID = P.RENTAL_ID
GROUP BY NAME
ORDER BY REVENUE DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW TOP_FIVE_GENRES_VW AS
SELECT NAME, concat('$', format(SUM(AMOUNT), 2)) AS REVENUE FROM CATEGORY C
JOIN FILM_CATEGORY FC ON C.CATEGORY_ID = FC.CATEGORY_ID
JOIN INVENTORY I ON FC.FILM_ID = I.FILM_ID
JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
JOIN PAYMENT P ON R.RENTAL_ID = P.RENTAL_ID
GROUP BY NAME
ORDER BY REVENUE DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM TOP_FIVE_GENRES_VW;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW TOP_FIVE_GENRES_VW;