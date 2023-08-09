/*Case Study - RSVP movies - May 2022
Group member 1 - Abhijit Bhavsar - abhijit@madpixels.in
Group member 2 - Renuka Kulkarni - kulkarnirenuka427@gmail.com
Batch - DSC 41 */

USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- -----------------------------------------------------------------------------------------------------------------
-- 'COUNT' function used to calculate number of rows in each column

SELECT Count(*)
FROM   director_mapping; 
-- Director mapping - 3,867

SELECT Count(*)
FROM   genre; 
-- Genre - 14,662

SELECT Count(*)
FROM   movie; 
-- Movies - 7,997

SELECT Count(*)
FROM   names; 
-- Names - 25,735

SELECT Count(*)
FROM   ratings; 
-- Ratings - 7,997

SELECT Count(*)
FROM   role_mapping; 
-- Ratings - 15,615
-- -----------------------------------------------------------------------------------------------------------------

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- 'IS NULL' is handy in counting the null values, similarly 'IS NOT NULL' can be used to perform operations on non-null values

-- -----------------------------------------------------------------------------------------------------------------
SELECT *
FROM   movie
WHERE  id IS NULL; 

SELECT *
FROM   movie
WHERE  title IS NULL; 

SELECT *
FROM   movie
WHERE  year IS NULL; 

SELECT *
FROM movie
where year is null;

SELECT *
FROM movie
WHERE date_published IS NULL;

SELECT *
FROM movie
WHERE duration IS NULL;

SELECT *
FROM movie
WHERE country IS NULL;

SELECT *
FROM movie
WHERE worlwide_gross_income IS NULL;

SELECT *
FROM movie
WHERE languages IS NULL;

SELECT *
FROM movie
WHERE production_company IS NULL;
-- -----------------------------------------------------------------------------------------------------------------

-- All column do have null values.


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


-- -----------------------------------------------------------------------------------------------------------------
-- 'COUNT' function is used to calculate the count of movies and then group it by year and the month to get the desired results for first and second part of the question respectively

SELECT year         AS Year,
       Count(title) AS number_of_movies
FROM   movie
GROUP  BY year;

SELECT Month(date_published) AS month_num,
       Count(title)          AS number_of_movies
FROM   movie
GROUP  BY Month(date_published)
ORDER  BY Month(date_published); 
-- -----------------------------------------------------------------------------------------------------------------


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- -----------------------------------------------------------------------------------------------------------------
-- WHERE clause used to define conditions as mentioned in the question

SELECT Count(title) AS 'India & USA movies in 2019'
FROM   movie
WHERE  country = 'India'
        OR 'USA'
           AND year = 2019;
-- -----------------------------------------------------------------------------------------------------------------        
           
-- 1007 movies were produced in the USA or India in the year 2019. 

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


-- -----------------------------------------------------------------------------------------------------------------
-- 'Distinct' function used in select statement to get the unique values (in this case genre)
SELECT DISTINCT genre
FROM   genre;
-- -----------------------------------------------------------------------------------------------------------------


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


-- -----------------------------------------------------------------------------------------------------------------
-- 'Joins' used to join two tables for getting the desired result table

SELECT genre,
       Count(DISTINCT id) AS genre_count
FROM   movie
       INNER JOIN genre
               ON movie.id = genre.movie_id
GROUP  BY genre
ORDER  BY Count(DISTINCT id) DESC;
-- -----------------------------------------------------------------------------------------------------------------

-- Answer : Drama


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- -----------------------------------------------------------------------------------------------------------------
-- Apart from joining the table, where condition necessary to define movies with only one genre

WITH genre_count
     AS (SELECT movie_id,
                Count(genre) AS count_of_genre
         FROM   genre
         GROUP  BY movie_id)
SELECT Count(movie_id) AS "Movies with single genre"
FROM   genre_count
WHERE  count_of_genre = 1; 
-- -----------------------------------------------------------------------------------------------------------------


-- Answer : 3289 movies belong to single genre

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

-- -----------------------------------------------------------------------------------------------------------------
-- Aggregate function of AVG (average) used to know the average duration

SELECT DISTINCT genre,
                Avg(duration) AS avg_duration
FROM   movie
       INNER JOIN genre
               ON movie.id = genre.movie_id
GROUP  BY genre;
-- -----------------------------------------------------------------------------------------------------------------

-- Answer : It varies between ~ 92 minutes and 113 minutes.


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

-- -----------------------------------------------------------------------------------------------------------------
-- 'Rank' function used to know the genre rank and this rank is based on movie count

SELECT genre,
       Count(DISTINCT id)                    AS movie_count,
       Rank ()
         OVER (
           ORDER BY Count(DISTINCT id) DESC) AS genre_rank
FROM   movie
       INNER JOIN genre
               ON movie.id = genre.movie_id
GROUP  BY genre;
-- -----------------------------------------------------------------------------------------------------------------
-- Answer : Rank of Thriller genre is 3.

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

-- -----------------------------------------------------------------------------------------------------------------
-- Aggregate functions have been used to find the min and max values which have been rounded to remove decimal points
SELECT Round(Min(avg_rating))    AS min_avg_rating,
       Round(Max(avg_rating))    AS max_avg_rating,
       Round(Min(total_votes))   AS min_total_votes,
       Round(Max(total_votes))   AS max_total_votes,
       Round(Min(median_rating)) AS min_median_rating,
       Round(Max(median_rating)) AS max_median_rating
FROM   ratings;
-- -----------------------------------------------------------------------------------------------------------------


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

-- -----------------------------------------------------------------------------------------------------------------
-- The movies are ranked based on the movie count using 'Rank' function and then 'limit' function is used to get top-10 results
SELECT DISTINCT title,
                avg_rating,
                Rank () OVER (ORDER BY Count(DISTINCT id) DESC) AS movie_rank
FROM            movie
INNER JOIN      ratings
ON              movie.id = ratings.movie_id
GROUP BY        avg_rating
ORDER BY        avg_rating DESC limit 10;
-- -----------------------------------------------------------------------------------------------------------------


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

-- -----------------------------------------------------------------------------------------------------------------
-- 'Group by' function is used to get movie count based on median ratings. 
-- While the table comes by default in the required order, order by clause is good to have if we want to see the table in specific median rating order or by movie_count
SELECT median_rating,
       Count(DISTINCT id) AS movie_count
FROM   movie
       INNER JOIN ratings
               ON movie.id = ratings.movie_id
GROUP  BY median_rating
ORDER  BY median_rating;
-- -----------------------------------------------------------------------------------------------------------------

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

-- -----------------------------------------------------------------------------------------------------------------
-- 'Dense rank' function used here as consecutive rank values will give better picture. 

SELECT production_company,
       Count(title)             AS movie_count,
       Dense_rank ()
         OVER(
           ORDER BY avg_rating) AS prod_company_rank
FROM   movie
       INNER JOIN ratings
               ON movie.id = ratings.movie_id
WHERE  avg_rating > 8
       AND production_company IS NOT NULL
GROUP  BY production_company
ORDER  BY Count(title) DESC;
-- -----------------------------------------------------------------------------------------------------------------


-- Answer : National Theatre Live and Dream Warrior Pictures

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

-- -----------------------------------------------------------------------------------------------------------------
-- 'Where' clause used to incorporate different conditions required to get the results
SELECT genre,
       Count(DISTINCT id) AS movie_count
FROM   movie
       INNER JOIN genre
               ON movie.id = genre.movie_id
       INNER JOIN ratings
               ON genre.movie_id = ratings.movie_id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country = 'USA'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY Count(DISTINCT id) DESC; 
-- -----------------------------------------------------------------------------------------------------------------


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
-- -----------------------------------------------------------------------------------------------------------------
-- 'Regexp' or regular expression function used to find the pattern of characters 'The' in the string values
SELECT title,
       avg_rating,
       genre
FROM   movie
       INNER JOIN genre
               ON movie.id = genre.movie_id
       INNER JOIN ratings
               ON genre.movie_id = ratings.movie_id
WHERE  title REGEXP '^The'
       AND avg_rating > 8
GROUP  BY title;
-- -----------------------------------------------------------------------------------------------------------------


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- -----------------------------------------------------------------------------------------------------------------
-- Conditions such as 'And', 'Or', and 'between' used for publishing the required table
SELECT Count(DISTINCT id) AS Number_of_movies,
       median_rating      AS 'Median Ratings is 8'
FROM   movie
       INNER JOIN ratings
               ON movie.id = ratings.movie_id
WHERE  median_rating = 8
       AND year = 2018
        OR 2019
           AND date_published BETWEEN 2018 - 04 - 01 AND 2019 - 04 - 01; 
 -- -----------------------------------------------------------------------------------------------------------------   
 
 
-- Answer : 369 movies were given median rating of 8 within that time/date frame.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian country movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

 -- ----------------------------------------------------------------------------------------------------------------- 
 -- 'IN' clause used in syntax, one can also use 'And', but using 'In' helps concised the query
SELECT country,
       total_votes AS votes
FROM   movie
       INNER JOIN ratings
               ON movie.id = ratings.movie_id
WHERE  country IN ( 'Germany', 'Italy' )
GROUP  BY country;
-- -------------------------------------------------------------------------------------------------------------------


-- Answer is Yes, Germany has 4695 votes whereas Italy only gets 1684 votes.

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

-- -------------------------------------------------------------------------------------------------------------------
-- Nested select clause used to optimise and concise the code, and to get the result as one table
SELECT (SELECT Count(*)
        FROM   names
        WHERE  NAME IS NULL)             AS name_nulls,
       (SELECT Count(*)
        FROM   names
        WHERE  height IS NULL)           AS height_nulls,
       (SELECT Count(*)
        FROM   names
        WHERE  date_of_birth IS NULL)    AS date_of_birth_nulls,
       (SELECT Count(*)
        FROM   names
        WHERE  known_for_movies IS NULL) AS known_for_movies_nulls; 
-- -------------------------------------------------------------------------------------------------------------------


-- Name column has no null values.

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

-- -------------------------------------------------------------------------------------------------------------------
-- Common Table Expression (CTE) created using 'With' clause to make a temporary table for top-3 genres, of which top-3 directors are idenfied

WITH top3_genre AS
(
           SELECT     genre,
                      Count(id)                               AS movie_count,
                      g.movie_id                              AS m_id,
                      Rank () OVER ( ORDER BY Count(id) DESC) AS genre_rank
           FROM       movie                                   AS m
           INNER JOIN genre                                   AS g
           ON         m.id = g.movie_id
           INNER JOIN ratings AS r
           using      (movie_id)
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
           
SELECT     n.NAME             AS director_name,
           Count(dm.movie_id) AS movie_count
FROM       director_mapping   AS dm
INNER JOIN genre              AS g
ON         dm.movie_id = g.movie_id
INNER JOIN names AS n
ON         n.id = dm.name_id
INNER JOIN top3_genre AS tg
ON         tg.genre = g.genre
INNER JOIN ratings AS r
ON         g.movie_id = r.movie_id
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3;
-- -------------------------------------------------------------------------------------------------------------------


-- Answer : 1. James Mangold, 2.Anthony Russo, 3.Soubin Shahir

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

-- ---------------------------------------------------------------------------------------------------------------------
-- 'Where' clause used to find top-2 actors whose movies have a median rating >= 8, we can remove limit clause to see more than two actors

SELECT NAME                     AS actor_name,
       Count(DISTINCT movie.id) AS movie_count
FROM   movie
       INNER JOIN ratings
               ON movie.id = ratings.movie_id
       INNER JOIN role_mapping
               ON ratings.movie_id = role_mapping.movie_id
       INNER JOIN names
               ON role_mapping.name_id = names.id
WHERE  median_rating >= 8
GROUP  BY NAME
ORDER  BY movie_count DESC
LIMIT 2; 
-- ---------------------------------------------------------------------------------------------------------------------


-- Answer : 1. Mammootty, 2. Mohanlal

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
-- ---------------------------------------------------------------------------------------------------------------------
-- 'Sum' function used to find vote count here which is then grouped on production company
SELECT     production_company,
           Sum(total_votes)                              AS vote_count,
           Rank () OVER (ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM       movie
INNER JOIN ratings
ON         movie.id = ratings.movie_id
GROUP BY   production_company limit 3;
-- ---------------------------------------------------------------------------------------------------------------------


-- Answer : 1. Marvel Studios, 2. Twentieth Century Fox, 3. Warner Bros.
 

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
-- ---------------------------------------------------------------------------------------------------------------------
-- Weighted average is calculated using sum product formula 
WITH list_top_actors AS
(
           SELECT     names.NAME                                                       AS actor_name,
                      Sum(r.total_votes)                                               AS total_votes,
                      Count(DISTINCT rm.movie_id)                                      AS movie_count,
                      Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actor_avg_rating
           FROM       names
           INNER JOIN role_mapping AS rm
           ON         names.id = rm.name_id
           INNER JOIN movie AS m
           ON         rm.movie_id = m.id
           INNER JOIN ratings AS r
           ON         m.id = r.movie_id
           WHERE      rm.category = 'actor'
           AND        m.country regexp '^INDIA$'
           GROUP BY   rm.name_id,
                      names.NAME
           HAVING     count(DISTINCT rm.movie_id) >= 5)
SELECT   *,
         rank() OVER ( ORDER BY actor_avg_rating DESC) AS actor_rank
FROM     list_top_actors;
-- ---------------------------------------------------------------------------------------------------------------------


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

-- ---------------------------------------------------------------------------------------------------------------------
-- CTE generated using 'With' clause with conditions based on regular expression to find movies which are Indian and are in Hindi

WITH list_top_actress AS
(
           SELECT     names.NAME                                                       AS actress_name,
                      Sum(r.total_votes)                                               AS total_votes,
                      Count(DISTINCT rm.movie_id)                                      AS movie_count,
                      Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actress_avg_rating
           FROM       names
           INNER JOIN role_mapping AS rm
           ON         names.id = rm.name_id
           INNER JOIN movie AS m
           ON         rm.movie_id = m.id
           INNER JOIN ratings AS r
           ON         m.id = r.movie_id
           WHERE      rm.category = 'actress'
           AND        m.country regexp '^INDIA$'
           AND        m.languages regexp '^Hindi$'
           GROUP BY   rm.name_id,
                      names.NAME
           HAVING     count(DISTINCT rm.movie_id) >= 3)
SELECT   *,
         rank() OVER ( ORDER BY actress_avg_rating DESC) AS actress_rank
FROM     list_top_actress;
-- ---------------------------------------------------------------------------------------------------------------------


-- Answer : Taapsee Pannu

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
-- ---------------------------------------------------------------------------------------------------------------------
-- 'Case when' clause which is similar to if-then-else is used to classify the movies in the required categories based on average rating

SELECT Count(movie.id) AS No_of_thriller_movies,
       ( CASE
           WHEN ( avg_rating > 8 ) THEN 'Superhit movies'
           WHEN ( avg_rating BETWEEN 7 AND 8 ) THEN 'Hit movies'
           WHEN ( avg_rating BETWEEN 5 AND 7 ) THEN 'One-time-watch movies'
           ELSE 'Flop movies'
         END )         AS Classification
FROM   ratings
       INNER JOIN genre using (movie_id)
       INNER JOIN movie
               ON genre.movie_id = movie.id
WHERE  genre = 'Thriller'
GROUP  BY classification
ORDER  BY no_of_thriller_movies DESC; 
-- ---------------------------------------------------------------------------------------------------------------------


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
-- ---------------------------------------------------------------------------------------------------------------------
-- 'Avg' and 'Sum' functions are used along with 'Order' clause to find the runnin total and moving average

SELECT genre,
       Avg(duration)          AS avg_duration,
       Sum(duration)
         OVER (
           ORDER BY movie_id) AS running_total_duration,
       Avg(duration)
         OVER (
           ORDER BY movie_id) AS moving_avg_duration
FROM   genre
       INNER JOIN movie
               ON genre.movie_id = movie.id
GROUP  BY genre;
-- ---------------------------------------------------------------------------------------------------------------------



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
-- ---------------------------------------------------------------------------------------------------------------------
-- CTE created using multiple 'With' clause to find the combination of top-3 genres and top-5 highest grossing movies.
-- There is no need to write 'With' multiple times in such cases

WITH select_movies
     AS (WITH top3_genre
              AS (SELECT genre,
                         Count(title)                    AS movie_count,
                         Rank()
                           OVER(
                             ORDER BY Count(title) DESC) AS genre_rank
                  FROM   movie AS m
                         INNER JOIN ratings AS r
                                 ON r.movie_id = m.id
                         INNER JOIN genre AS g
                                 ON g.movie_id = m.id
                  GROUP  BY genre)
         SELECT genre
          FROM   top3_genre
          WHERE  genre_rank < 4),
     top5_movies
     AS (SELECT genre,
                year,
                title                                    AS movie_name,
                worlwide_gross_income,
                Rank()
                  OVER (
                    partition BY year
                    ORDER BY worlwide_gross_income DESC) AS movie_rank
         FROM   movie AS m
                INNER JOIN genre AS g
                        ON m.id = g.movie_id
         WHERE  genre IN (SELECT genre
                          FROM   select_movies))
SELECT *
FROM   top5_movies
WHERE  movie_rank <= 5; 


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
-- ---------------------------------------------------------------------------------------------------------------------
-- Another alternative to 'With' is 'Create View'.
-- Although the created view is saved, and unlike CTE made using 'With', such views can come handy when same table is required in other queries 

CREATE VIEW prod_comp_view AS
SELECT     production_company,
           Count(id) AS movie_count
FROM       movie     AS m
INNER JOIN ratings   AS r
ON         m.id = r.movie_id
WHERE      median_rating >= 8
AND        production_company IS NOT NULL
AND        position("," IN languages) > 0
GROUP BY   production_company
ORDER BY   movie_count;

SELECT   *,
         Rank() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
FROM     prod_comp_view limit 2;
-- ---------------------------------------------------------------------------------------------------------------------


-- Answer : 1. Star Cinema, 2. Twentieth Century Fox.

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
-- ---------------------------------------------------------------------------------------------------------------------
-- 'With' clause used to create CTE for Super Hit movies with average rating >8

WITH super_hit_movies AS
(
           SELECT     names.NAME                                                       AS actress_name,
                      Sum(r.total_votes)                                               AS total_votes,
                      Count(rm.movie_id)                                               AS movie_count,
                      Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actress_avg_rating
           FROM       names
           INNER JOIN role_mapping AS rm
           ON         names.id = rm.name_id
           INNER JOIN movie AS m
           ON         rm.movie_id = m.id
           INNER JOIN ratings AS r
           ON         m.id = r.movie_id
           INNER JOIN genre AS g
           ON         r.movie_id = g.movie_id
           WHERE      rm.category = 'actress'
           AND        avg_rating > 8
           AND        genre = 'Drama'
           GROUP BY   names.NAME )
SELECT   *,
         Rank() OVER ( ORDER BY movie_count DESC) AS actress_rank
FROM     super_hit_movies limit 3;
-- ---------------------------------------------------------------------------------------------------------------------


-- Answer : 1. Parvathy Thiruvothu, 2. Susan Brown, 3. Amanda Lawrence


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
-- ---------------------------------------------------------------------------------------------------------------------
-- First table created using 'With' clause to generate a column of next date using 'Lead'. 
-- 'Lead' clause is used to accesses the value stored in rows below as per the offset which in this case in 1. ('Lag' is opposite where values before the rows are accessed.)
-- Second table generated includes column where the number of days between release of two movies is calculated to generate the final desired output. 

WITH day_diff_table1 AS
(
           SELECT     date_published,
                      dm.name_id,
                      Lead(date_published,1) OVER(partition BY dm.name_id ORDER BY date_published, movie_id ) AS next_date
           FROM       movie                                                                                   AS m
           INNER JOIN director_mapping                                                                        AS dm
           ON         m.id = dm.movie_id
           INNER JOIN names AS n
           ON         dm.name_id = n.id ), day_diff_table2 AS
(
       SELECT *,
              Datediff(next_date, date_published) AS day_diff
       FROM   day_diff_table1)
SELECT     dm.name_id                  AS director_id,
           NAME                        AS director_name,
           Count(DISTINCT dm.movie_id) AS number_of_movies,
           Round(Avg(day_diff))        AS avg_inter_movie_days,
           avg_rating,
           total_votes,
           Round(Min(avg_rating)) AS min_rating,
           Round(Max(avg_rating)) AS max_rating,
           Sum(duration)          AS total_duration
FROM       names
INNER JOIN day_diff_table2 AS df
ON         names.id = df.name_id
INNER JOIN director_mapping AS dm
ON         df.name_id = dm.name_id
INNER JOIN genre AS g
ON         dm.movie_id = g.movie_id
INNER JOIN ratings AS r
ON         g.movie_id = r.movie_id
INNER JOIN movie AS m
ON         r.movie_id = m.id
GROUP BY   NAME
ORDER BY   Count(DISTINCT dm.movie_id) DESC limit 9;
-- ---------------------------------------------------------------------------------------------------------------------

/*
Executive Summary

The IMDB data set throws some interesting insights which have been mentioned as data-backed recommendations that can aid RSVP movies to narrow down on parameters such as released month, genre, directors, actors/actresses to woo different sets of global audience as below:
1. Our ranking analysis shows that ‘Drama’ took the top spot it comes to genre, and a significant 4,285 number of movies belong to ‘Drama’ genre with average duration of ~107 minutes (1.47 hours). Following the lead were movies in ‘Action’ and ‘Thriller’ genre. The production house can focus on these genres for their first project.
2. Where the number of movies released each year show a downward trend, we see majority of movies being released in March.
3. When it comes to directors, the production house can hire top directors such as James Mangold, Anthony Russo, and Soubin Shahir.
4. RSVP movies can tie up with top three production houses with highest votes such as Marvel Studios, Twentieth Century Fox, and Warner Bros. to tap into the pool of already existing global audience of these companies.
5. Our analysis shows that South movies stars Mammootty and Mohanlal have the highest movies with median rating 8 or higher, which is also apparent from the global fame garnered by the southern movies in recent years. Apart from these, Vijay Sethupathi, is also a good choice based on the average ratings.
6. In case of actress, Taapsee Pannu can be roped into based on the average ratings, whereas for movies specific to ‘Drama’ genre, Parvathy Thiruvothu is a suitable choice.
*/
