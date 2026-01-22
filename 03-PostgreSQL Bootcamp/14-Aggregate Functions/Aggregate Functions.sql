-- Count function

-- 1. get total records
select count(*) from movies

-- 2. count on specific col
select count(movie_id) from movies

-- count with distinct
-- 3. count distinct lang
select  count( distinct movie_lang) from movies

-- 4. count all distinct movie directors
select count(distinct director_id) from movies

-- 5. count all english movies
select count(*) as total_english_movies from movies
where
	movie_lang = 'English'


-- count(*) will not include null
-- count (1) will
select count(1) from movies



-- SUM function
-- 1. get total domestic revenue
select sum(revenues_domestic) from movies_revenues 

-- 2. get total domestic revenue when revenue > 200
select sum(revenues_domestic) from movies_revenues 
where revenues_domestic > 200

-- 3. total movies length for eng movies
select sum(movie_length) as total_english_movies_length from movies
where
	movie_lang = 'English'

select sum(movie_name) from movies -- error ,only numbers allowed


-- MIN MAX
-- 1. longest, shortest length movie
select max(movie_length), min(movie_length) from  movies

-- 2. longest movie with english lang
select max(movie_length) from  movies
where movie_lang = 'English'

-- 3. latest release eng movie
select max(release_date) from  movies
where movie_lang = 'English'

-- min max works on characters
select max(movie_name) from movies


-- GREATEST AND LEAST	
select greatest (-10,20,40)

select least (-10,20,40)

select greatest ('a','c','b')

select least ('a','c','b')

-- 1. find greatest and least revenue per each movie
select 
	movie_id,
	revenues_domestic,
	revenues_international,
	greatest(revenues_domestic,revenues_international) as geatest,
	least(revenues_domestic,revenues_international) as least
from movies_revenues

-- AVG function ( will ignore all null values)
-- 1. get avg movie length from all movies
select avg(movie_length) from movies


-- can't run avg on text
select avg(movie_name) from movies

-- get total revenu
select 
	revenues_domestic + revenues_international
from movies_revenues

-- movies with highest revenues
select 
	(revenues_domestic + revenues_international) as total
from movies_revenues
order by total desc nulls last



