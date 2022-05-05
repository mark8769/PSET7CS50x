/* In 7.sql, write a SQL query that returns the average energy of songs that are by Drake. */
/* Your query should output a table with a single column and a single row containing the average energy. */

/*
 SELECT energy column in songs table, and take the average
 Return the value, and place it inside AverageEnergy column that we define.
 WHERE artist_id = (id from artist table where name matches drake)

*/

SELECT AVG(energy) AS AverageEnergy FROM songs WHERE artist_id = (SELECT id FROM artists WHERE name = "Drake");