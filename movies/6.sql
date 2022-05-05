/*
In 6.sql, write a SQL query to determine the average rating of all movies released in 2012.
Your query should output a table with a single column and a single row (not including the header) containing the average rating.


get movies from 2012

SELECT title, id, year FROM movies WHERE year = 2012; check id and year

SELECT id FROM movies WHERE year = 2012;

check ratings table now that we have all movie ids for 2012

SELECT AVG(rating) FROM ratings WHERE movie_id = (SELECT id FROM movies WHERE year = 2012);
*/

SELECT AVG(rating) FROM ratings WHERE movie_id IN (SELECT id FROM movies WHERE year = 2012);