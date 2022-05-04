-- importing database IMBD
USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
    table_name AS Table_name, table_rows AS Number_of_rows
FROM
    information_schema.tables
WHERE
    TABLE_schema = 'IMDB';

-- maximum nuber of rows were observed in names table

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
    SUM(id IS NULL) AS Null_id,
    SUM(title IS NULL) AS Null_title,
    SUM(year IS NULL) AS Null_year,
    SUM(date_published IS NULL) AS Null_date_published,
    SUM(duration IS NULL) AS Null_duration,
    SUM(country IS NULL) AS Null_country,
    SUM(worlwide_gross_income IS NULL) AS Null_worlwide_gross_income,
    SUM(languages IS NULL) AS Null_languages,
    SUM(production_company IS NULL) AS Null_production_company
FROM
    movie;

/* we observed from the output that country , worlwide_gross_income , language & production company has null values 
with worlwide having maximum no. of null values. */

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- yearly
SELECT 
    year, COUNT(year) AS number_of_movies
FROM
    movie
GROUP BY year;

-- maximum number of movies were released 2017

-- monthly
SELECT 
    MONTH(date_published) AS month_num,
    COUNT(MONTH(date_published)) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY month_num; 


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    year, COUNT(year) AS total
FROM
    movie
WHERE
    country = 'USA'
        OR country = 'INDIA' AND year = 2019;

-- A total of 2555 movies were produced in 2019 by India & USA together

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    (genre) AS GENRES
FROM
    genre;

-- There are a total of 13 differet genres

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


SELECT 
    genre, COUNT(movie_id) AS no_of_movies
FROM
    genre
GROUP BY genre
ORDER BY no_of_movies DESC
LIMIT 1;



-- Maximum number of movies belongs to Drama genre


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH count_1_genre as
(SELECT 
	 movie_id, COUNT(genre) AS genre_count
FROM
    genre
GROUP BY movie_id
HAVING genre_count = 1)

SELECT Count(*) AS movie_count_genre_1
FROM   count_1_genre; 

-- there are a total 3289 movie movies belonging to 1 genre.



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT genre,
       ROUND(Avg(duration),2) AS avg_duration
FROM   genre AS g
       INNER JOIN movie AS m
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY avg_duration DESC; 


-- action movie has the maximum average duration among all genres

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH movie_rank
     AS (SELECT genre,
                Count(genre)                       AS movie_count,
                Dense_rank()
                  OVER (
                    ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   genre AS g
                INNER JOIN movie AS m
                        ON g.movie_id = m.id
         WHERE  year = 2019
         GROUP  BY genre)
SELECT *
FROM   movie_rank
WHERE  genre = "thriller"; 


-- DRAMA,COMEDY and THRILLER are the top among all genre based on number of movies produced.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings; 

    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_rank_table
     AS (SELECT title,
                avg_rating
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         ORDER  BY avg_rating DESC)
SELECT *,
       Rank()
         OVER (
           ORDER BY avg_rating DESC) AS movie_rank
FROM   movie_rank_table; 


-- Kirket & Love in Kilnerry both as average rating of 10 , having rank 1


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT Round(median_rating) AS median_rating,
       Count(movie_id)      AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating; 

-- 7997
-- maximum number of movies have median rating between 6 to 8 i.e 65.7%
-- & there are only 94 movies i.e. 1.1% movies with median rating of 1.


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_house
     AS (SELECT production_company,
                Count(id) AS movie_count
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         WHERE  r.avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,
      DENSE_RANK ()
         OVER (
           ORDER BY movie_count DESC ) AS prod_company_rank
FROM   prod_house; 



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT genre,
       Count(g.movie_id) AS movie_count
FROM   genre g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  m.year = 2017
       AND Month(m.date_published) = 3
       AND r.total_votes > 1000
       AND m.country = 'USA'
GROUP  BY genre
ORDER  BY movie_count DESC; 




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   genre g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  r.avg_rating > 8
       AND m.title LIKE "the%";



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(m.id) AS movie_count
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  r.median_rating = 8
       AND m.date_published BETWEEN '2018-04-01' AND '2019-04-01'; 


-- Only  361 OUT OF 2794 have median rating =8 i.e 12.9%  are released between 1 April 2018 and 1 April 2019
-- there are only 20 movies with avergae rating =8



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country,
       Sum(total_votes) AS total_vote_count
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  country = "germany"
        OR country = "italy"
GROUP  BY country; 





-- Answer is Yes
-- german movies have 28745 votes more than italian movies
 
/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/



-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT Sum(NAME IS NULL)             AS name_nulls,
       Sum(height IS NULL)           AS height_nulls,
       Sum(date_of_birth IS NULL)    AS date_of_birth_nulls,
       Sum(known_for_movies IS NULL) AS know_for_movies_nulls
FROM   names; 





/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH genre_3 AS
(
           SELECT     genre,
                      Count(movie_id) AS movie_count
           FROM       genre           AS g
           INNER JOIN ratings         AS r
           using      (movie_id)
           WHERE avg_rating > 8
           GROUP BY   genre
           ORDER BY   movie_count DESC limit 3 )
SELECT     n.NAME AS director_name,
           Count(m.id)      AS movie_count
FROM       names            AS n
INNER JOIN director_mapping AS d
ON         n.id=d.name_id
INNER JOIN movie AS m
ON         d.movie_id=m.id
INNER JOIN ratings AS r
ON         m.id=r.movie_id
INNER JOIN genre AS g
ON         r.movie_id=g.movie_id
WHERE      r.avg_rating>8
AND        g.genre IN
           (
                  SELECT genre
                  FROM   genre_3)
GROUP BY   director_name
ORDER BY   movie_count DESC
limit 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT name               AS actor_name,
       Count(ro.movie_id) AS movie_count
FROM   names AS n
       INNER JOIN role_mapping AS ro
               ON n.id = ro.name_id
       INNER JOIN ratings AS r
               ON ro.movie_id = r.movie_id
WHERE  median_rating >= 8
       AND category = "actor"
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 


-- Mammoothy & Mohanlal are the 2 actors with median rating > 8



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     production_company,
           Sum(total_votes)                             AS vote_count,
           Rank() OVER (ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM       movie                                        AS m
INNER JOIN ratings                                      AS r
ON         m.id=r.movie_id
WHERE      production_company IS NOT NULL
GROUP BY   production_company limit 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.NAME                                                          AS
       actor_name,
       Sum(r.total_votes)                                              AS
       total_votes,
       Count(m.id)                                                     AS
       movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)      AS
       actor_avg_rating,
       Rank()
         OVER (
           ORDER BY Sum(avg_rating*total_votes)/Sum(total_votes) DESC) AS
       actor_rank
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
       INNER JOIN role_mapping AS ro
               ON r.movie_id = ro.movie_id
       INNER JOIN names AS n
               ON ro.name_id = n.id
WHERE  category = "actor"
       AND country = "india"
GROUP  BY NAME
HAVING movie_count > 4; 







-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.NAME                                                          AS
       actress_name,
       Sum(r.total_votes)                                              AS
       total_votes,
       Count(m.id)                                                     AS
       movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)      AS
       actress_avg_rating,
       Rank()
         OVER (
           ORDER BY Sum(avg_rating*total_votes)/Sum(total_votes) DESC) AS
       actress_rank
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
       INNER JOIN role_mapping AS ro
               ON r.movie_id = ro.movie_id
       INNER JOIN names AS n
               ON ro.name_id = n.id
WHERE  category = "actress"
       AND country = "india"
       AND languages = "hindi"
GROUP  BY NAME
HAVING Count(ro.movie_id) > 2; 







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT title,
       r.avg_rating,
       CASE
         WHEN avg_rating > 8 THEN "superhit movies"
         WHEN avg_rating BETWEEN 7 AND 8 THEN "hit movies"
         WHEN avg_rating BETWEEN 5 AND 7 THEN "one-time-watch movies"
         ELSE "flop movies"
       END AS movie_category
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  genre = 'Thriller'
GROUP  BY r.movie_id; 



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT genre,
       Round(Avg(duration), 2)       AS avg_duration,
       Sum(duration)
         OVER (
           ORDER BY genre)           AS running_total_duration,
       Round(Avg(Avg(duration))
               OVER (
                 ORDER BY genre), 2) AS moving_avg_duration
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
GROUP  BY genre; 



-- we observed moving_avg_duration was approx same for last few genres

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH genre_3 AS
(
         SELECT   genre,
                  Count(movie_id) AS movie_count
         FROM     genre           AS g
         GROUP BY genre
         ORDER BY movie_count DESC limit 3 )
SELECT     genre,
           year,
           title                                                               AS
           movie_name,
           worlwide_gross_income,
           Rank() OVER (partition BY year ORDER BY worlwide_gross_income DESC ) AS movie_rank
FROM       genre                                                               AS g
INNER JOIN movie                                                               AS m
ON         g.movie_id=m.id
WHERE      g.genre IN
           (
                  SELECT genre
                  FROM   genre_3)
                 
AND        worlwide_gross_income LIKE "$%"
GROUP BY   title 
order by movie_rank
limit 15;






-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT     production_company,
           Count(id)                             AS movie_count,
           Rank() OVER (ORDER BY Count(id) DESC) AS prod_comp_rank
FROM       movie                                 AS m
INNER JOIN ratings                               AS r
ON         m.id=r.movie_id
WHERE      median_rating>7
AND        position(',' IN languages)>0
AND        production_company IS NOT NULL
GROUP BY   production_company limit 2;



-- Star Cinema has the highest number of movie hits among multilingual movies

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT     n.NAME                                 AS actress_name,
           Sum(r.total_votes)                     AS total_votes,
           Count(m.id)                            AS movie_count,
           avg_rating                             AS actress_avg_rating,
           Rank() OVER (ORDER BY avg_rating DESC) AS actress_rank
FROM       movie                                  AS m
INNER JOIN ratings                                AS r
ON         m.id=r.movie_id
INNER JOIN genre AS g
ON         r.movie_id=g.movie_id
INNER JOIN role_mapping AS ro
ON         g.movie_id=ro.movie_id
INNER JOIN names AS n
ON         ro.name_id=n.id
WHERE      category="actress"
AND        g.genre="Drama"
AND        avg_rating>8
GROUP BY   NAME limit 3;


-- Sangeetha Bhat, Fatmire Sahiti and Adriana Matoshi are the top three actress of Drama genre with average rating greater than 8




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH next_dir AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      avg_rating,
                      total_votes,
                      duration,
                      date_published,
                      Lead(date_published,1) OVER (partition BY d.name_id ORDER BY date_published, movie_id) AS next_date
           FROM       director_mapping                                                                       AS d
           INNER JOIN names                                                                                  AS n
           ON         d.name_id=n.id
           INNER JOIN movie AS m
           ON         d.movie_id=m.id
           INNER JOIN ratings AS r
           ON         r.movie_id=m.id )
SELECT   name_id                                           AS director_id,
         NAME                                              AS director_name,
         Count(movie_id)                                   AS number_of_movies,
         Round(Avg(Datediff(next_date, date_published)),2) AS avg_inter_movie_days,
         Avg(avg_rating)                                   AS avg_rating,
         Sum(total_votes)                                  AS total_votes,
         Min(avg_rating)                                   AS min_rating,
         Max(avg_rating)                                   AS max_rating,
         Sum(duration)                                     AS total_duration
FROM     next_dir
GROUP BY name_id
ORDER BY number_of_movies DESC limit 9;

-- A.L. Vijay and Andrew Jones have made maximum movies.


