/*
In 11.sql, write a SQL query to list the titles of the five highest rated movies (in order) that Chadwick Boseman starred in, starting with the highest rated.
Your query should output a table with a single column for the title of each movie.
You may assume that there is only one person in the database with the name Chadwick Boseman.

- we have to get the chadwick boseman movies
- get moie ids where person_id matches, so have to grab chadwick boseman id from people table

SELECT id FROM people WHERE name = "Chadwick Boseman"; //gets his id

Now use this id in the stars table, and get the movie_id where person_id matches

SELECT movie_id FROM stars WHERE person_id = (SELECT id FROM people WHERE name = "Chadwick Boseman");

// now we want the ratings for each movie he was in, which we now have the movie_ids for

//check in ratings table

SELECT title FROM movies WHERE id IN (SELECT movie_id FROM ratings WHERE movie_id IN (SELECT movie_id FROM stars WHERE person_id = (SELECT id FROM people WHERE name = "Chadwick Boseman")) ORDER BY rating LIMIT 5);


SELECT rating FROM ratings WHERE movie_id IN (SELECT movie_id FROM stars WHERE person_id = (SELECT id FROM people WHERE name = "Chadwick Boseman")) ORDER BY rating DESC  LIMIT 5;
*/

SELECT title
FROM movies
WHERE id IN
(SELECT movie_id FROM ratings WHERE movie_id IN
(SELECT movie_id FROM stars WHERE person_id = (SELECT id FROM people WHERE name = "Chadwick Boseman"))
ORDER BY rating DESC LIMIT 5);



