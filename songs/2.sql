/*
- Write a SQL quiery to list the names of all songs in increasing order of tempo
- Query should ouput a table with a single column for the name of each song in increasing tempo
- Select name column from songs table, and order by tempo column in same songs table
- Alternatively SELECT name,tempo FROM songs ORDER BY tempo; to view column name with tempo to check answer
*/
SELECT name FROM songs ORDER BY tempo;