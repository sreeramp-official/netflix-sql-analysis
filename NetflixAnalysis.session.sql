/* 
  Project: Netflix Dataset Analysis

  Description:
  This SQL file contains queries to analyze the Netflix dataset, which includes movies and TV shows. 
  The queries address various questions, such as identifying trends in content production, 
  finding the most common genres, analyzing country-specific content, and evaluating actor appearances.

  Each query is structured and commented to ensure ease of understanding, 
  even for those new to SQL. 

  Database Table: MoviesAndTVShows
  Columns Include:
  - title: Title of the content.
  - type: 'Movie' or 'TV Show'.
  - director: Director's name.
  - cast: Names of the cast members.
  - country: Country of production.
  - date_added: Date the content was added to Netflix.
  - release_year: Year the content was released.
  - rating: Content rating (e.g., PG-13, TV-MA).
  - duration: Duration of the content.
  - listed_in: Genres/categories the content belongs to.
  - description: Description of the content.
*/

/* Query 1: Display the entire dataset to understand its structure and content */
SELECT * 
FROM MoviesAndTVShows;

/* Query 2: Count the total number of content items in the dataset */
SELECT COUNT(*) AS total_content
FROM MoviesAndTVShows;

/* Query 3: Retrieve all distinct types of content available in the dataset */
SELECT DISTINCT type
FROM MoviesAndTVShows;

/* Query 4: Analyze yearly trends in content production, including movies and TV shows */
SELECT 
    release_year AS Year,
    COUNT(*) AS TotalContent,
    SUM(CASE WHEN type = 'Movie' THEN 1 ELSE 0 END) AS TotalMovies,
    SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) AS TotalTVShows
FROM 
    MoviesAndTVShows
GROUP BY 
    release_year
ORDER BY 
    release_year;

/* Query 5: Find the most common genre in each country */
SELECT 
    country AS Country,
    listed_in AS Genre,
    COUNT(*) AS GenreCount
FROM 
    MoviesAndTVShows
WHERE 
    country IS NOT NULL
GROUP BY 
    country, listed_in
HAVING 
    COUNT(*) = (
        SELECT MAX(GenreCount)
        FROM (
            SELECT 
                country, 
                listed_in, 
                COUNT(*) AS GenreCount
            FROM 
                MoviesAndTVShows
            WHERE 
                country IS NOT NULL
            GROUP BY 
                country, listed_in
        ) AS SubQuery
        WHERE SubQuery.country = MoviesAndTVShows.country
    )
ORDER BY 
    Country, GenreCount DESC;

/* Query 6: List the top 10 most prolific directors based on the number of content items */
SELECT 
    director AS Director,
    COUNT(*) AS TotalContent
FROM 
    MoviesAndTVShows
WHERE 
    director IS NOT NULL
GROUP BY 
    director
ORDER BY 
    TotalContent DESC
LIMIT 10;

/* Query 7: Identify the month in which the most content was added */
SELECT 
    MONTH(date_added) AS Month,
    COUNT(*) AS ContentAdded
FROM 
    MoviesAndTVShows
WHERE 
    date_added IS NOT NULL
GROUP BY 
    MONTH(date_added)
ORDER BY 
    ContentAdded DESC;

/* Query 8: Find the TV show with the longest duration (number of seasons) */
SELECT 
    title AS TVShow,
    MAX(duration) AS LongestSeasons,
    (MAX(duration) / 12) AS DurationInYears
FROM 
    MoviesAndTVShows
WHERE 
    type = 'TV Show' AND duration IS NOT NULL
GROUP BY 
    title
ORDER BY 
    LongestSeasons DESC
LIMIT 1;

/* Query 9: Find the most common genre for content rated 'PG-13' */
SELECT 
    listed_in AS Genre,
    COUNT(*) AS GenreCount
FROM 
    MoviesAndTVShows
WHERE 
    rating = 'PG-13' AND listed_in IS NOT NULL
GROUP BY 
    listed_in
ORDER BY 
    GenreCount DESC;

/* Query 10: List content without a director, grouped by release year */
SELECT 
    title AS ContentTitle,
    type AS ContentType,
    release_year AS ReleaseYear
FROM 
    MoviesAndTVShows
WHERE 
    director IS NULL OR director = ''
ORDER BY 
    release_year DESC;

/* Query 11: Find the top 5 countries with the most content */
SELECT 
    country AS Country,
    COUNT(*) AS ContentCount
FROM 
    MoviesAndTVShows
WHERE 
    country IS NOT NULL
GROUP BY 
    country
ORDER BY 
    ContentCount DESC
LIMIT 5;

/* Query 12: Find the top 5 most common genres */
SELECT 
    listed_in AS Genre,
    COUNT(*) AS ContentCount
FROM 
    MoviesAndTVShows
WHERE 
    listed_in IS NOT NULL
GROUP BY 
    listed_in
ORDER BY 
    ContentCount DESC
LIMIT 5;

/* Query 13: List movies longer than 120 minutes or TV shows with more than 10 episodes */
SELECT 
    title AS ContentTitle,
    type AS ContentType,
    duration AS Duration
FROM 
    MoviesAndTVShows
WHERE 
    (type = 'Movie' AND duration > 120) 
    OR 
    (type = 'TV Show' AND duration > 10)
ORDER BY 
    duration DESC;

/* Query 14: Count content by rating */
SELECT 
    rating AS Rating,
    COUNT(*) AS ContentCount
FROM 
    MoviesAndTVShows
WHERE 
    rating IS NOT NULL
GROUP BY 
    rating
ORDER BY 
    ContentCount DESC;

/* Query 15: Categorize content as 'Violent' or 'Non-violent' based on description */
SELECT 
    title AS ContentTitle,
    type AS ContentType,
    description AS Description,
    CASE
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Violent'
        ELSE 'Non-violent'
    END AS ContentCategory
FROM 
    MoviesAndTVShows
WHERE 
    description IS NOT NULL
ORDER BY 
    ContentCategory DESC;

/* Query 16: Find movies that are documentaries */
SELECT 
    title AS ContentTitle,
    type AS ContentType
FROM 
    MoviesAndTVShows
WHERE 
    type = 'Movie' AND listed_in LIKE '%Documentaries%'
ORDER BY 
    title ASC;

/* Query 17: Find movies with Salman Khan */
SELECT 
    title AS ContentTitle,
    type AS ContentType,
    cast AS Cast,
    release_year AS ReleaseYear
FROM 
    MoviesAndTVShows
WHERE 
    cast LIKE '%Salman Khan%'
ORDER BY 
    release_year DESC;

/* Query 18: Find the number of movies acted by actors from India in 2020 */
SELECT 
    cast AS Actor,
    COUNT(*) AS MovieCount
FROM 
    MoviesAndTVShows
WHERE 
    country = 'India' AND type = 'Movie' AND release_year = 2020
GROUP BY 
    cast
ORDER BY 
    MovieCount DESC;
