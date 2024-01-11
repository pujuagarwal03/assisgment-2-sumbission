use mavenmovies;

-- basic aggregate functions:

-- q.1 = retrieve the total num of rentals made in sakila database
select count(rental_id)  from rental;

select * from rental;

-- q.2 = find the average rental duration (in days) of movies rented from the sakila database
select avg(datediff(return_date,rental_date))  from rental;

 -- string functions:

-- q.3 = display the first name and last name of customers in uppercase
select upper(first_name) , upper(last_name)  from actor;

-- q.4 = extract the month from the rental date and display it alongside the rental id 
select rental_id, month(rental_date)  from rental;

-- group by
use mavenmovies;

-- q.5 = retrive the count of rentals for each customer (display customer id and the count of rentals:
select customer_id, count(rental_id) from rental group by customer_id;

-- q.6 = find the total revenue genrated by each store
select store.store_id,  sum(payment.amount) from payment
inner join staff on staff.staff_id = payment.staff_id 
inner join store on store.store_id = staff.store_id group by store_id;

-- joins

-- q.7 = display the tittle of the movie,customer s first name and last name who rented it
select title,first_name,last_name
 from film inner join inventory on film.film_id = inventory.film_id
 inner join rental on rental.inventory_id = inventory.inventory_id
 inner join customer on customer.customer_id = rental.customer_id;


-- q. 8 = retrive the names of all actors who have appeared in the film "gone with the wind"
select first_name from actor 
inner join film_actor on actor.actor_id = film_actor.actor_id 
inner join film on film.film_id = film_actor.film_id
 where title = 'gone with the wind';
 
 -- group by
 -- q.9 = Determine the total number of rentals for each category of movies. 
-- hint: JOIN film_category, film, and rental tables, then use cOUNT () and GROUP BY. 
select film_category.category_id , count(rental.rental_id) from rental
inner join inventory on inventory.inventory_id = rental.inventory_id
inner join film on film.film_id = inventory.film_id
inner join film_category on film_category.film_id = film.film_id 
group by category_id;


--  q.10 = Find the average rental rate of movies in each language. 
-- Hint: JOIN film and language tables, then use AVG () and GROUP BY. 
select name, avg(rental_rate) from language inner join film 
on language.language_id = film.language_id group by name;

-- joins
-- q.11 = Retrieve the customer names along with the total amount they've spent on rentals. 
 -- Hint: JOIN customer, payment, and rental tables, then use SUM() and GROUP BY. 
select concat(first_name, ' ', last_name) as Names, sum(amount) as toatal_amount from customer 
inner join payment on customer.customer_id = payment.payment_id inner join rental 
on rental.rental_id = payment.rental_id group by customer.customer_id;


 -- q.12 = List the titles of movies rented by each customer in a particular city (e.g., 'London'). 
 -- Hint: JOIN customer, address, city, rental, inventory, and film tables, then use GROUP BY. 
 select f.title, c.customer_id, concat(first_name, " ", last_name) as name, city from film f 
inner join inventory iv on iv.film_id = f.film_id 
inner join rental r on r.inventory_id = iv.inventory_id 
inner join customer c on c.customer_id = r.customer_id 
inner join address ad on ad.address_id = c.address_id
inner join city ct on ct.city_id = ad.city_id
where ct.city = 'London'
 group by c.customer_id, f.title;
 
 
 
 -- adavnce joins and group
 -- q.13 = Display the top 5 rented movies along with the number of times they've been rented.
-- Hint: JOIN film, inventory, and rental tables, then use cOUNT() and GROUP BY, and limit the results. 
select f.title, count(r.rental_id) as total_rentals from film f 
inner join inventory iv on iv.film_id = f.film_id 
inner join rental r on r.inventory_id = iv.inventory_id 
group by f.title order by total_rentals desc limit 5;


 
 -- q.14 =  Determine the customers who have rented movies from both stores (store ID 1 and store ID 2). 
 -- Hint: Use JOINS with rental, inventory, and customer tables and consider COUNT() and GROUP BY. 
 SELECT c.customer_id, c.first_name, c.last_name, s.store_id
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
WHERE s.store_id IN (1, 2)
GROUP BY c.customer_id, c.first_name, c.last_name, s.store_id
HAVING COUNT(DISTINCT s.store_id);