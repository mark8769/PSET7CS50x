/*
In 10.sql, write a SQL query to list the names of all people who have directed a movie that received a rating of at least 9.0.
Your query should output a table with a single column for the name of each person.
If a person directed more than one movie that received a rating of at least 9.0, they should only appear in your results once.

check .schema again, make a habit

we need to get the id for all movies from movies table where rating > 9.0

use this id to connect to ratings table to find all greater than 9.0

then connect this table to our directors table when id has been filtered down

SELECT id FROM movies; //get all the movie ids to check ratings

//selects the movie id's where rating is greater than 9.0

SELECT movie_id FROM ratings WHERE movie_id IN (SELECT id FROM movies) AND rating >= 9.0

// use those filtered down movie ids for the directors table and get DISTINCT person_id from stars table

SELECT person_id FROM directors WHERE movie_id IN (SELECT movie_id FROM ratings WHERE movie_id IN (SELECT id FROM movies) AND rating >= 9.0);

//now use the person_id from directors table to connect to people table, and grab the name column and we should have our answer

SELECT DISTINCT(name) FROM people WHERE id IN (SELECT person_id FROM directors WHERE movie_id IN (SELECT movie_id FROM ratings WHERE movie_id IN (SELECT id FROM movies) AND rating >= 9.0));

*/

SELECT DISTINCT(name)
FROM people
WHERE id IN
(SELECT person_id FROM directors WHERE movie_id IN
(SELECT movie_id FROM ratings WHERE movie_id IN
(SELECT id FROM movies) AND rating >= 9.0));