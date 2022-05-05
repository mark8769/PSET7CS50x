/* In 6.sql, write a SQL query that lists the names of songs that are by Post Malone. */
/* Your query should output a table with a single column for the name of each song. */
/*
First I look at the shema of the tables
SELECT name,id FROM artists; to check artists table
Songs table has artist id column
Make connection to post malone by using artist id and
SELECT name, id FROM artists WHERE name = "Post Malone"; // to get post malone id (54 in this case)
SELECT name FROM songs WHERE artist_id = 54;
*/

SELECT name FROM songs WHERE artist_id = (SELECT id FROM artists WHERE name = "Post Malone");