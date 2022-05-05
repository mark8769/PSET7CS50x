/*


In 12.sql, write a SQL query to list the titles of all movies in which both Johnny Depp and Helena Bonham Carter starred.
Your query should output a table with a single column for the title of each movie.
You may assume that there is only one person in the database with the name Johnny Depp.
You may assume that there is only one person in the database with the name Helena Bonham Carter.


get the ids of johny depp and helena bonham carters

SELECT id FROM people WHERE name = "Johnny Depp" OR name = "Helena Bonham Carter"; // to get the id of both stars

SELECT movie_id, stars FROM stars WHERE person_id IN (SELECT id FROM people WHERE name = "Johnny Depp" OR name = "Helena Bonham Carter"); //we get all the movies titles for both actors

SELECT movie_id, person_id FROM stars WHERE person_id IN (SELECT id FROM people WHERE name = "Johnny Depp" OR name = "Helena Bonham Carter"); check movies are associated with person id


MAYBE USE SOME JOINS


// joins the table where person_id = id, gets all movie_id's
// can now grab all movie_id's where both Johnny Depp and Helena Bonham Carter are in

SELECT movie_id, name FROM (
SELECT movie_id,name FROM (SELECT movie_id, person_id, name
FROM stars
INNER JOIN people
ON stars.person_id = people.id) AS joined_table WHERE name = "Johnny Depp" AND id = "Helena Bonham Carter") WHERE not name = "Johnny Depp";



// USE THIS ONE TO WORK FROM
SELECT movie_id FROM(
SELECT movie_id, person_id, name
FROM stars
INNER JOIN people
ON stars.person_id = people.id) WHERE NOT name = "Johnny Depp";



AND people.id = (SELECT id FROM people WHERE id = "Johnny Depp");
AND people.id = (SELECT id FROM people WHERE id = "Helena Bonham Carter");

*/




/*
table from inside parantheses returns all the movies Johnny Depp and Helena Bonham Carter are in
The way the stars table is set up is that each row will only contain ONE star NOT a list of stars like I mistakenly thought
So when we use OR keyword we are grabbing any movies that both might appear in, not missing any because each row only has one person_id
So now we only have movies where Johnny and Helena are in, we can group our count by TITLE of a movie, example if we could two person_id for a TITLE of a movie
then we can for sure say that both actors appeared in the said movie
*/

SELECT title FROM
(
SELECT movies.title, stars.person_id FROM people
JOIN stars ON people.id = stars.person_id
JOIN movies ON stars.movie_id = movies.id
JOIN ratings ON movies.id = ratings.movie_id
WHERE people.name = "Johnny Depp" OR people.name = "Helena Bonham Carter"
)
GROUP BY title
HAVING COUNT(person_id) = 2;