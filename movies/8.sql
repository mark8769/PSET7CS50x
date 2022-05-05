/*
In 8.sql, write a SQL query to list the names of all people who starred in Toy Story.
Your query should output a table with a single column for the name of each person.
You may assume that there is only one movie in the database with the title Toy Story.

// get id of the movie:

SELECT id FROM movies WHERE title = "Toy Story";

// get the starts using id from movies table in starts table and comparing it to movie_id
// SELECT person_id column to get all the stars in that movie


SELECT person_id FROM stars WHERE movie_id = (SELECT id FROM movies WHERE title = "Toy Story");


// now use people table to get the names of each person_id and compare to id in people table

SELECT name FROM people WHERE id IN (SELECT person_id FROM stars WHERE movie_id = (SELECT id FROM movies WHERE title = "Toy Story"));
*/


SELECT name FROM people WHERE id IN (SELECT person_id FROM stars WHERE movie_id = (SELECT id FROM movies WHERE title = "Toy Story"));
