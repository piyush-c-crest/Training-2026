-- select specific column
select f_name from customers;

select f_name, l_name from customers;


-- alias for columns
/*
select col as alias_name from table
can not use single quates , double only
*/
select first_name as FirstName from actors
select first_name as "First Name" from actors

select movie_name as "Movie" , movie_lang as "Language" from movies;

-- as keyword is optional
select 
	movie_name "Movie" , 
	movie_lang "Language"
from movies;


-- expression in select
/*
Combine fname lname to make full name
we use || operator to concat
*/
select first_name || ' '|| last_name as "Full name" from actors

select 10 * 2


-- Order By to sort 
-- single col
select * from movies order by release_date ASC
select * from movies order by movie_length DESC

-- multiple col
-- release date -> desc , movie_name -> asc
select * from movies
order by
	release_date DESC,
	movie_name ASC;

-- order by with alias col

select 
	first_name ,
	last_name as surname
from actors
order by 
	last_name
	-- both works fine
select 
	first_name ,
	last_name as surname
from actors
order by 
	surname

-- calculate length of names
select 
	first_name,
	length(first_name) as "len"
from actors

-- sort rows based on len of actors name in descending order
select * from 
actors order by length(first_name) DESC

-- order by with column number
select first_name , last_name, date_of_birth
from actors
order by 
	1 ASC , 3 desc
-- 1 -> first_name, 3-> dob


-- ORDER by with null values
-- NULLS LAST / FIRST
-- NULL is marker that indicates 
-- either its a missing data or
-- unknow data

select date_of_birth as dob
from actors 
order by
	dob
	NULLs first


-- Selecting distinct values

select movie_lang from movies;

select distinct movie_lang from movies order by 1;

-- select all unique rows
select distinct * from movies















