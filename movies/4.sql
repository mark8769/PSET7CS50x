/*
In 4.sql, write a SQL query to determine the number of movies with an IMDb rating of 10.0.
Your query should output a table with a single column and a single row (not including the header) containing the number of movies with a 10.0 rating.

Need to count
Need to count all movies with rating greater than 10.0 from ratings table
No relationships needed for this, dont have to display titles
use COUNT function
*/

SELECT COUNT(rating) FROM ratings WHERE rating = 10.0;