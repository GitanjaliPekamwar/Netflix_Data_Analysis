-- Netflix project
drop table if exists netflix;
Create table netflix(
show_id Varchar(10),
type Varchar(10),	
title Varchar(150),
director Varchar(220),	
casts	varchar(1000),
country varchar(150),
date_added varchar(50),
release_year int,
rating	varchar(10),
duration varchar(15),	
listed_in	varchar(105),
description varchar(250)
);

select * from netflix;

select count(*) as total_content from netflix;

select distinct type 
   from netflix;

select distinct count(director) from netflix;

select distinct count(country) from netflix;

-- BUsiness Problems

-- 1. Count the number of Movies vs TV Shows

select type, count(*) as total_count
from netflix 
group by type;

-- 2. Find the most common rating for movies and TV shows
select type ,rating
from
(
select type, 
rating,
count(*),
Rank() over (partition by type order by count(*) DESC) as "ranking"
from netflix
group by type, rating
order by 1,3 desc
) as t1
where ranking = 1;

-- 3. List all movies released in a specific year (e.g., 2020)
select *
from netflix
where type = 'Movie' and
release_year = '2020';

-- 4. Find the top 5 countries with the most content on Netflix
select UNNEST(string_to_array(country, ',')) as new_country, 
   count(show_id) as total_content 
from netflix
  group by country
  order by 2 desc
limit 5;

 select UNNEST(string_to_array(country, ',')) as new_country
 from netflix;

-- 5. Identify the longest movie
select title,type, duration 
  from netflix
where type ='Movie'
and 
duration = (select max(duration) from netflix);

-- 6. Find content added in the last 5 years
select * 
	   from netflix
where 
     date_added
	 To_DATE(date_added, 'Month, DD, YYYY')>= DATE_Sub(Current_date(),  Interval '5 years');



-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * 
    from netflix
where director ILike '%Rajiv Chilaka%'

-- 8 List all TV shows with more than 5 seasons

SELECT * 
FROM netflix
WHERE type = 'TV Show'
AND SPLIT_PART(duration, ' ', 1)::NUMERIC > 5;


-- 9. Count the number of content items in each genre
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;


-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

 SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

11. List all movies that are documentaries

select *
from
(SELECT title,
     UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
FROM netflix)
   where  genre = 'Documentaries' ;

   select * from netflix
   where listed_in ILike '%Documentaries%';




-- 12. Find all content without a director
select * from netflix
where director Is null


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from netflix
where 
        casts ILIKE '%Salman Khan%'
and release_year > Extract(year from current_date) - 10

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
UNNEST(STRING_TO_ARRAY(casts, ','))  as actors,
count(*) as total_content
from netflix
where
 country ILIKE '%India%'
group by 1
order by 2 desc
limit 10 ;



15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;




