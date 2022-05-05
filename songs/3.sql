/*
- Write a SQL query to list the names of the top 5 longest songs, in descending order of lenght.
- Your query should output a table with a single column for the name of each song.
- SELECT name column FROM songs table ORDER TABLE BY duration_ms column from songs table in descending order, LIMIT ROWS TO 5
*/
SELECT name FROM songs ORDER BY duration_ms DESC LIMIT 5;