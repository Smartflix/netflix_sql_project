-- NETFLIX PROJECT 
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
		show_id VARCHAR(5) PRIMARY KEY,
		type VARCHAR (10),
		title VARCHAR (150),
		director VARCHAR(210),
		castS VARCHAR (1000),
		country VARCHAR(150),
		date_added VARCHAR(50),
		release_year INT,
		rating VARCHAR(10),
		duration VARCHAR(15),
		listed_in VARCHAR(100),
		description VARCHAR (250)

);

SELECT * FROM netflix;

select count(*) as total_content 
from netflix;

-- Count the Number of Movies vs TV Shows
select 
	type,
	count(*) 
from netflix
group by type;

-- Find the Most Common Rating for Movies and TV Shows
SELECT
	type,
	rating
FROM
(
	SELECT 
	type,
	rating,
	count(*),
	rank()over(partition by type order by count(*) desc) as ranking
FROM netflix
group by 1,2

) as t1
where ranking = 1

--List All Movies Released in a Specific Year (e.g., 2020)
SELECT * FROM netflix
where 
	type = 'Movie'
and 
	release_year = 2020;
	
--Find the Top 5 Countries with the Most Content on Netflix
SELECT
	UNNEST (string_to_array(country,',')) as new_country,
	count(show_id) as total_count
FROM netflix
group by 1
ORDER BY 2 DESC
LIMIT 5;


select 
	UNNEST (string_to_array(country,',')) as new_country
from netflix;


-- Identify the Longest Movie

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	and 
	duration = (SELECT MAX(duration) FROM netflix)

	;


--Find Content Added in the Last 5 Years
SELECT 
	*
	FROM netflix
where 
	TO_DATE(date_added,'Month DD,YYYY')>= CURRENT_DATE - INTERVAL '5 years' ;


SELECT CURRENT_DATE - INTERVAL '5 years'

--Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT * FROM netflix
WHERE 
	director ILIKE '%Rajiv Chilaka%';

--List All TV Shows with More Than 5 Seasons

SELECT 
	*,
	SPLIT_PART(duration,' ',1)
FROM netflix
WHERE 
	type = 'TV Show'
	AND
	SPLIT_PART(duration,' ',1)::numeric> 5;


-- Count the Number of Content Items in Each Genre
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in ,',')) AS genre,
	count(listed_in) AS total_content
FROM netflix
group by 1
order by 2 desc;

-- find each year and the average numbers of content release in India on netflix.

SELECT 
	EXTRACT(YEAR FROM TO_date(date_added,'Month DD,YYYY')) AS year,
	COUNT(*)AS yearly_content,
	ROUND(COUNT(*):: numeric/(SELECT COUNT(*) FROM netflix where country ='India')::numeric * 100,2) AS averge_content_per_year
FROM netflix
where country = 'India'
GROUP BY 1;

--  List All Movies that are Documentaries
select * from netflix
where listed_in ILIKE '%Documentaries%';

-- Find All Content Without a Director
SELECT * FROM netflix
where 
	director IS NULL;

--Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

SELECT * FROM netflix
WHERE 
	type = 'Movie'
AND
	casts ILIKE '%Salman Khan%'
AND 
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

--Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) as Actors,
	COUNT(*)
FROM netflix
where country ILIKE 'India'
group by 1
ORDER BY 2 desc
limit 10;

-- Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
WITH new_table AS
(
SELECT 
*,
	CASE
	WHEN 
		description ILIKE '%Kill%' OR 
		description ILIKE '%Violence%' THEN 'Bad_Content'
	ELSE 'Good_Content'
	END category
FROM netflix
)
SELECT 
	category,
	count(*) as total_content
FROM new_table
GROUP BY category;





