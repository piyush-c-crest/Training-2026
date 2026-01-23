-- grouping recrods by group by

/*
select 
	col1 
	agg_fun(col2)
from table_name
group by col1

*/



-- 1.  get total count of all movies group by movie_lang
select movie_lang, count(movie_lang) from movies
group by movie_lang

-- 2.  get avg movie len group by movie_lang
select movie_lang, avg(movie_length) from movies
group by movie_lang


-- 3. get sum total movie len per age certificate
select age_certificate, sum(movie_length)
from movies
group by age_certificate
order by age_certificate


-- 4. list min , max movie length grp by movie lang

select 
	movie_lang,
	min(movie_length),
	max(movie_length)
from movies
group by movie_lang

-- 5. grp by without agg fun
select movie_lang
from movies
group by movie_lang



-- using morte than 1 columns in select
-- get avg movie len grop by kang and certificate
select 
	movie_lang,
	age_certificate,
	avg(movie_length)
from movies
group by movie_lang, age_certificate
order by movie_lang, age_certificate


-- get avg movie length grp by lang , age certi where length > 100

select 
	movie_lang,
	age_certificate,
	avg(movie_length)
from movies
where movie_length > 100
group by movie_lang, age_certificate
order by movie_lang, age_certificate


-- get avg movie legth grp by age certi where age certi = 12
select 
	age_certificate,
	avg(movie_length)
from movies
where age_certificate = '12'
group by  age_certificate

-- 1. how many directors are there per each nationality
select nationality, count(*) as cnt from directors
group by nationality
order by 2 desc


-- 2. total sum movie length for each age certi and lang combination
select movie_lang, age_certificate, sum(movie_length)
from movies
group by movie_lang, age_certificate

-- cant run group by on agg function


-- HAVING CLAUSE
-- we use having clause to search condition for a group or an aggregate
-- having calculates on aggregate function not on actual select column

select
	col1
	agg_fun(col2)
from t_name
group by col1
having condition

-- 1.list movies lang where sum total length is > 200
select 
	movie_lang,
	sum(movie_length)
from movies
group by movie_lang
having sum(movie_length) > 200
order by 2

-- 2. list directors where their sum total movie legth > 200
select 
	director_id,
	sum(movie_length)
from movies
group by director_id
having sum(movie_length) > 200
order by 2

-- from > where  > grp by > having > select > distinct > order by > limit

-- HAVING VS WHERE
-- HAVING works on result group
-- where works on select column not on grp data

-- get movies lang where thier sum total movie length is greater than 200
select movie_lang , sum(movie_length) 
from movies
group by movie_lang
having sum(movie_length) > 200



-- Handling null values with group by

create table emp_test(
	id int,
	name text,
	dept text,
	salary int
)

select * from emp_test

insert into emp_test values
(1,'a','d1',2500),
(2,'b',null,3000),
(3,'c',null,4500),
(4,'d','d1',4500),
(5,'a1','d2',2500),
(6,'a2','d2',2500)

-- all departments
select distinct dept from emp_test

-- total emp in each grp
select dept, count(*)
from emp_test
group by dept

-- handling null values
select coalesce(dept,'UNKNOWN'), count(*)
from emp_test
group by dept

