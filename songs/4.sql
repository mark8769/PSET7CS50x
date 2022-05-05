/* Select name column from songs table, where danceability > .75 AND ....*/
SELECT name FROM songs WHERE danceability > .75 AND valence > .75 AND energy > .75;