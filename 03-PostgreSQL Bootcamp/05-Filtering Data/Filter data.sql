-- types of operators

-- 1. Comparision OP :  > < >= <= = <>(not equal)
-- 2. Logical and, or, like, in , between
-- 3. Airthmetic : + - * 

-- 1. all english movies
-- use sibgle quates only , not double
select * from movies where movie_lang = 'English'

-- 2. all eng movies with age certificate to 18
select * from movies 
where 
	movie_lang = 'English' 
	and age_certificate = '18'

-- 3. get all eng chinies movies
select * from movies 
where 
	movie_lang = 'English' 
	or movie_lang = 'Chinese'
order by 
	movie_lang

-- 4. all eng chin movies with age certificate = 12
select * from movies 
where 
	( movie_lang = 'English'
	or movie_lang = 'Chinese' ) 
	and age_certificate = '12'

-- order of running where , order by, select and from 

-- from > where > select > order by


-- Logical Operators
-- 1. all movies where len > 100
select * from movies 
where movie_length > 100

-- 2. all movies wheregreater than or equal to 100
select * from movies 
where movie_length >= 100

-- 3. get all movies where release date > year 2000

select * from movies
where
	release_date > '1999-12-31'

-- 4. all movies which not in english language
-- use <> or != operator
select * from movies
where
	movie_lang != 'English'

select * from movies
where
	movie_lang <> 'English'


-- Limit operator
-- 1. get top 5 biggest movies by length
select * from movies
order by
	movie_length desc
limit 5

-- 2. get top 5 oldest American direcotrs
select * from directors
where 
	nationality = 'American'
order by
	date_of_birth
limit 5

-- 3. top 10 youngest female actors
select * from actors
where gender = 'F'
order by date_of_birth DESC
LIMIT 10

-- 4. top 10 domestic profetible movies
select * from movies_revenues
order by movies_revenues.revenues_domestic DESC NULLS last
LIMIT 10
	
-- 5. top 10 domestic least profetible movies
select * from movies_revenues
order by movies_revenues.revenues_domestic NULLS last
LIMIT 10

-- using OFFSET
/*
- LIMIT specifies the maximum number of rows to return.
- OFFSET specifies the number of rows to skip from the beginning of the result
	set before starting to count the LIMIT rows. 
-> Key Concepts
Pagination: The primary use case for combining LIMIT and OFFSET 
is to divide large results into manageable "pages". 
For example, to show the third page of results with 20 items per page,
you would LIMIT 20 OFFSET 40 (skipping the first two pages of 20 items each).
ORDER BY is essential
*/

-- 1. list 5 films staring from the forth one order by movie_id
select * from movies
order by movie_id
limit 5 offset 4

-- 2. top 5 movies after top 5 highest domestic profits movies
select * from movies_revenues
order by revenues_domestic DESC NULLS last
LIMIT 5 offset 5


-- Using FETCH
-- FETCH {first | next} {row count} {row | rows} only

-- 1. get first row of table
select * from movies
fetch first 1 row only

-- 2. get top 5 biggst movies by movies length
select  * from movies
order by movie_length DESC
fetch first 5 row only

-- 3. get top 5 oldest american directors
select * from directors
where nationality = 'American'
order by date_of_birth
fetch first 5 row only

-- 4. get first 5 movies from 5th record order by long movie length
select * from movies
order by movie_length desc
offset 5
fetch first 5 row only


-- Using in and not in 
-- 1. get all movies which are in eng, chin, jap
select * from movies
where movie_lang in ('English', 'Chinese', 'Japanese')

-- 2. select all movies where age certi is 12 and pg type
select * from movies
where age_certificate in ('PG', '12')
order by age_certificate

-- 3. all movies where dir id is not 13 or 10
select * from movies
where director_id not in (13,10)
order by director_id

-- BETWEEN and NOT BETWEEN
-- 1. get all actors birthdate bwteen 1991 to 1995
select * from actors
where date_of_birth between '1991-1-1' and '1995-12-31'

-- 2. all movies where domestic revenues are between 100 to 300
select * from movies_revenues
where revenues_domestic between 100 and 300
order by revenues_domestic

-- 3. all movies where domestic revenues are not between 100 to 300
select * from movies_revenues
where revenues_domestic not between 100 and 300
order by revenues_domestic


-- Using LIKE and ILIKE
-- used for pattern matching
-- return true or false

--  %   matches any sequence of zero or more character
--  -   matches single character

-- value like pattern
-- value ilike pattern

-- full character search
select 'hii' like 'hii'

-- partial character search using '%'
select 'hello' like 'he%'
select 'hello' like '%e%'

-- single char using '_'
select 'hello' like '_ello'
select 'hello' like '_e%'

-- 1. all actors name start from 'A'
select * from actors
where first_name like 'A%'

-- 2. last name ends with 'a'

select * from actors
where last_name like '%a'

-- 3. first name with 5 characters
select * from actors
where first_name like '_____'

-- 4. first name containing 'l' on second palce
select * from actors
where first_name like '_l%'

-- LIKE is CASE-SENSITIVE
select * from actors
where first_name like '%Tim'

select * from actors
where first_name like '%tim'

-- ILIKE in NOT
select * from actors
where first_name ilike '%Tim'

select * from actors
where first_name ilike '%tim'

-- is null, is not null
-- to check null

-- 1. actors with missing dob
select * from actors 
where
	date_of_birth is null

-- 2. actors with missing dob or f name
select * from actors 
where
	date_of_birth is null
	or first_name is null

-- 3. either domestic revenue is null or international is null
select * from movies_revenues
where
	revenues_domestic is null
	or revenues_international is null

-- 4. domestic revenue is null and international is null
select * from movies_revenues
where
	revenues_domestic is null
	and revenues_international is null

-- 5. domestic revenue is not null
select * from movies_revenues
where
	revenues_domestic is not null

-- Concationation
-- used to combine strings by '||' OP -> slelct 's1' || 's2'
-- combine column by concat() -> select concat(col1,col2) as new_col
-- combine column by concat_ws() , with separator-> select concat_ws(',',col1,col2) as new_col

select 'hello ' || 'World'
select first_name || ' '|| last_name as full_name from actors
select CONCAT(first_name, ' ', last_name) as full_name from actors

-- print fname, lname, dob separated by coma

select CONCAT_WS(',',first_name, last_name,date_of_birth) as full_name from actors


-- diff btwn concat and concat_ws
select 
	concat(revenues_domestic, ' | ' ,revenues_international) 
from movies_revenues; -- even if null, prints '|' too

select 
	concat_ws( ' | ', revenues_domestic ,revenues_international) 
from movies_revenues;