/*

In 7.sql, write a SQL query to list all movies released in 2010 and their ratings, in descending order by rating. For movies with the same rating,
order them alphabetically by title.
Your query should output a table with two columns, one for the title of each movie and one for the rating of each movie.
Movies that do not have ratings should not be included in the result.

SELECT id FROM movies WHERE year =  2010;

SELECT ratings

SELECT title, rating FROM movies, ratings WHERE movies.year = 2010;

SELECT movies.title ratings.rating FROM movies INNER JOIN ratings ON movies.id = ratings.movie_id;

innner join syntax: https://www.techonthenet.com/sqlite/joins.php
SELECT columns
FROM table1
INNER JOIN table2
ON table1.column = table2.column;

SELECT title from movies, rating from ratings

// when using innner join, want to compare columns that reference each other. In our case movies table id is references in ratings table as movie_id
INNER JOIN where movies.id = ratings.movie_id --> Returns columns from our select statement

ONLY want to join columns where rows year is equal to 2010

ORDER BY ratings.rating, in the case they share the same rating order by title name https://www.w3schools.com/sql/sql_orderby.asp

ADDING AND ratings.rating > 0.0; NOT NULL IN .schema enforces that there has to be some input, but doest not guarantee it wont be 0.0 which is same as no rating

*/

SELECT title, rating
FROM movies
INNER JOIN ratings WHERE movies.id = ratings.movie_id
AND movies.year = 2010
AND ratings.rating > 0
/* Didnt know you could pick how to ORDER BY each variable passed */
ORDER BY ratings.rating DESC, movies.title; /* I guess at some point download movies.db and upload answers */