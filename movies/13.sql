/*
In 13.sql, write a SQL query to list the names of all people who starred in a movie in which Kevin Bacon also starred.
Your query should output a table with a single column for the name of each person.
There may be multiple people named Kevin Bacon in the database. Be sure to only select the Kevin Bacon born in 1958.
Kevin Bacon himself should not be included in the resulting list.


SELECT person_id, people.name
FROM stars
INNER JOIN people ON stars.person_id = people.id

SELECT DISTINCT person_id FROM stars WHERE person_id IN (SELECT id FROM people WHERE name = "Kevin Bacon" AND birth = 1958);

SELECT DISTINCT(name) FROM(
SELECT id, name, movie_id
FROM people
INNER JOIN stars
ON people.id = person_id
);


//get kevin bacon id
SELECT id FROM people WHERE name = "Kevin Bacon" and birth = 1958;

//get movies hes been in

SELECT movie_id,person_id FROM stars WHERE person_id = (SELECT id FROM people WHERE name = "Kevin Bacon" and birth = 1958);

// get person_id from those movie_id's

//CHECK COUNT OF ROWS MATCHES WHAT COURSE SAYS YOU SHOULD GET, = 185 ROWS
SELECT COUNT(DISTINCT(name)) FROM
(SELECT movie_id, name FROM stars INNER JOIN people ON stars.person_id = people.id)
WHERE movie_id IN
(SELECT movie_id FROM stars WHERE person_id = (SELECT id FROM people WHERE name = "Kevin Bacon" and birth = 1958)
) AND NOT name = "Kevin Bacon";

*/

SELECT DISTINCT(name) FROM
(SELECT movie_id, name FROM stars INNER JOIN people ON stars.person_id = people.id) /* table created from joins */

WHERE movie_id IN
(SELECT movie_id FROM stars WHERE person_id = (SELECT id FROM people WHERE name = "Kevin Bacon" and birth = 1958)
) AND NOT name = "Kevin Bacon";


