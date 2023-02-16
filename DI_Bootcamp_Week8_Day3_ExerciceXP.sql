--EXERCICE 1 DAY3

-- 1/ Get a list of all film languages.
select name from language;

--2 / Get a list of all films joined with their languages – select the following details : film title, description, and language name. Try your query with different joins: 
--1 / Get all films, even if they don’t have languages.
SELECT film.title, film.description, language.name  FROM film LEFT JOIN language ON film.language_id  = language.language_id;

--2 -2/Get all languages, even if there are no films in those languages.
select film.title, film.description, language.name from film right join language on  film.language_id  = language.language_id ;

--3 / Create a new table called new_film with the following columns : id, name. Add some new films to the table.
CREATE TABLE new_film (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(100)
);

insert into new_film (name)
values('rambo'),
('Avengers'),
('Jack baeur');

select * from new_film;

--4 /Create a new table called customer_review, which will contain film reviews that customers will make.
-- Think about the DELETE constraint: if a film is deleted, its review should be automatically deleted.
-- It should have the following columns:
-- review_id – a primary key, non null, auto-increment.
-- film_id – references the new_film table. The film that is being reviewed.
-- language_id – references the language table. What language the review is in.
-- title – the title of the review.
-- score – the rating of the review (1-10).
-- review_text – the text of the review. No limit on the length.
-- last_update – when the review was last updated.


CREATE TABLE customer_review (
    review_id  SERIAL PRIMARY KEY NOT NULL,
     id  INTEGER REFERENCES new_film (id) ON DELETE CASCADE,
     language_id INTEGER REFERENCES language (language_id) ON DELETE CASCADE,
    title  VARCHAR(100),
    score  INT CHECK (score <= 10),
    review_text TEXT, 
    last_update  TIMESTAMP 
    
);

--5 /
insert into customer_review(title, score, review_text,last_update,id,language_id)
values('critique vivien',9,' le film nest pas mal',current_timestamp,1, 1),
('critique vivien2',3,' le film est cool',current_timestamp,2,2);

--6/Add 2 movie reviews. Make sure you link them to valid objects in the other tables.
select * from customer_review;

--7/Delete a film that has a review from the new_film table, what happens to the customer_review table?
delete from customer_review where customer_review.review_id =4;

-- Exercise 2 : DVD Rental

-- 1/ Use UPDATE to change the language of some films. Make sure that you use valid languages.
UPDATE film
set language_id=2
where film_id IN (133,1,2,3,4);

select * from film WHERE film_id IN (133,1,2,3,4);

--2/ Which foreign keys (references) are defined for the customer table? How does this affect the way in which we INSERT into the customer table?
-- la clée etrangere est address_id
-- la modification du champ address_id dans une table externe affecte la clée address_id dans la table
-- customer par contre il n'est possible de supprimer que lorsque tous les parents ont été supprimés.

--3/We created a new table called customer_review. Drop this table. Is this an easy step, or does it need extra checking?
DROP table customer_review;

--4/Find out how many rentals are still outstanding (ie. have not been returned to the store yet).
select * from rental where rental.return_date is null;

--5/Find the 30 most expensive movies which are outstanding (ie. have not been returned to the store yet)
select title, rental_rate,rental.return_date ret from rental
inner join inventory on rental.inventory_id = inventory.inventory_id
inner join film on inventory.film_id = film.film_id
where rental.return_date is null 
ORDER BY film.rental_rate DESC limit 30;

-- 6 Your friend is at the store, and decides to rent a movie. He knows he wants to see 4 movies, but he can’t remember their names.

--Can you help him find which movies he wants to rent?
select * from actor
--1 The 1st film : The film is about a sumo wrestler, and one of the actors is Penelope Monroe.
select film.title,film.description, first_name||' '||last_name AS full_name from film 
INNER JOIN film_actor USING(film_id) 
INNER JOIN actor USING( actor_id)
WHERE description ILIKE '%sumo%' AND actor.first_name ILIKE '%penelope%' AND actor.last_name ILIKE '%Monroe%' ;

-- 2-The 2nd film : A short documentary (less than 1 hour long), rated “R”.
select * from category
select film.title, film.length,category.name, film.rating from film
INNER JOIN film_category using (film_id)
INNER JOIN category using (category_id)
WHERE  film.rating IN('R') AND category.name ILIKE '%documentary%';

