-- INNER JOINS
-- used to combine columns from one or more table based on the value of the 
-- common columns between tables
-- these common col are generaly
-- primary key of first table and foreign key column of second table

select * 
from t_a
join t_b
on t_1.col1 = t_b.col2

-- combine table movies and directors
select movie_name, first_name
from movies 
join directors
on movies.director_id = directors.director_id

-- english movies only
select
	m.movie_id,
	m.movie_name,
	m.movie_lang,
	m.director_id,
	d.first_name
from movies m
inner join directors d
on m.director_id = d.director_id
where movie_lang = 'English';

-- INNER JOIN
-- we use only when tables have same column names , rather than on

select 
	m.movie_name,
	d.first_name
from movies m inner join directors d using (director_id)


-- connect movies and mv revenues
select * from movies_revenues
select * 
from movies inner join movies_revenues using (movie_id)



-- more than 2 tables

-- connect movies , directors, movies revenues

select * 
from movies
inner join directors using (director_id)
inner join movies_revenues using (movie_id)


-- inner join withj filter data
-- 1. select mv name, dir name, dir revenue for all japanese movies
select 
	m.movie_name, first_name || ' '|| last_name, revenues_domestic , revenues_international
from movies m
inner join directors d using (director_id)
inner join movies_revenues r using (movie_id)
where movie_lang = 'Japanese'

-- 2. movie name, dir name, for all eng, chinese,jap mv where domestic rev > 100
select 
	m.movie_name, first_name || ' '|| last_name, revenues_domestic , revenues_international
from movies m
inner join directors d using (director_id)
inner join movies_revenues r using (movie_id)
where movie_lang in ('Japanese', 'English', 'Chinese') and revenues_domestic > 100
order by 3 desc

-- 3. select m name, d name, m lang , total revenue for all top 5 movies
select 
	m.movie_name, 
	first_name || ' '|| last_name as fullname, 
	COALESCE(revenues_domestic,0) , 
	COALESCE(revenues_international,0),
	COALESCE(revenues_domestic,0) + COALESCE(revenues_international,0)
from movies m
inner join directors d using (director_id)
inner join movies_revenues r using (movie_id)
order by 5 desc nulls last
limit 5


-- what were top 10 most profitable movies btween yeat 2005 and 2008
-- print mv name, dir, lang, total revenue

select 
	movie_name,
	first_name,
	last_name,
	coalesce(revenues_domestic+revenues_international, 0) as total_profit
from movies
inner join directors using(director_id)
inner join movies_revenues using (movie_id)
where release_date between '2005-01-01' and '2008-12-31'
order by 4 desc
limit 10



-- inner join tables with diff column data type

create table t1 (test int)


create table t2 (test varchar(10))

select * from t1 inner join t2 using (test) -- error

-- use type cast
select * from t1 join t2 on t1.test = t2.test :: int -- error


-- LEFT JOIN
-- return every col of left table + rows that match values in joined column from right table



create table left_product(
	product_id serial primary key,
	product_name varchar(100)
);

create table right_product(
	product_id serial primary key,
	product_name varchar(100)
);

insert into left_product (product_id,product_name) values 
(1,'Computers'),
(2,'Laptops'),
(3,'Monitors'),
(5,'Mics');

insert into right_product (product_id,product_name) values 
(1,'Computers'),
(2,'Laptops'),
(3,'Monitors'),
(4,'Pen'),
(7,'Papers');

select * 
from left_product l
left join right_product r on l.product_id = r.product_id

-- 1. list all movies with dir f, l name and movies name

-- total records -> 54
select 
first_name, last_name, movie_name
from directors d
left join movies m on d.director_id = m.director_id
order by 1 -- -> shows all 54 with james , david null

-- reverse
select 
first_name, last_name, movie_name
from movies m 
left join directors d on d.director_id = m.director_id
order by 1  -- -> shows only 53 , no record of james david

 -- Add records in directors table

insert into directors (first_name,last_name,date_of_birth,nationality) VALUES
('James','David','2010-01-01','American');

-- get eng chinese movies only
select 
first_name, last_name, movie_name,movie_lang
from directors d
left join movies m on d.director_id = m.director_id
where movie_lang in('English','Chinese')
order by 4

-- count movies for each director
select 
d.director_id, count(*)
from directors d
left join movies m on d.director_id = m.director_id
group by d.director_id
order by 2

select 
	first_name, last_name, count(*)
from directors d
left join movies m on d.director_id = m.director_id
group by first_name, last_name
order by 2


-- get all movies with age certificate for all directors where nationality
-- is 'American', 'Chinese', 'Japanese'
select * 
from directors d
left join movies m
on d.director_id = m.director_id
where d.nationality in ('American', 'Chinese', 'Japanese')

-- get all total revenues done by each film for each director
select 
	movie_name,
	first_name,
	last_name,
	coalesce(revenues_domestic+revenues_international, 0) as total_profit
from movies
left join directors using(director_id)
left join movies_revenues using (movie_id)
-- where release_date between '2005-01-01' and '2008-12-31'
order by 4 desc
-- limit 10


-- RIGHT JOINS
-- return every col of RIGTH table + rows that match values in joined column from LEFT table

select * 
from left_product l
RIGHT join right_product r on l.product_id = r.product_id


-- 1. where condition with join
select
	first_name, last_name,
	movie_name, movie_lang
from directors d
right join movies m on m.director_id = d.director_id
where
	movie_lang in ('English', 'Chinese')


select 
	first_name || ' '|| last_name as fullname, 
	sum(COALESCE(revenues_domestic,0) + COALESCE(revenues_international,0))
from directors d 
RIGHT join movies m on m.director_id = d.director_id
left join movies_revenues r r.movie_id = m.movie_id
group by first_name , last_name
order by 3 desc nulls last

-- FULL JOIN
-- Return every row from all tables

select * 
from left_product l
full join right_product r on l.product_id = r.product_id


-- total records -> 54
select 
first_name, last_name, movie_name
from directors d
full join movies m on d.director_id = m.director_id
order by 1


-- eng and chinese only
select 
first_name, last_name, movie_name
from directors d
full join movies m on d.director_id = m.director_id
where movie_lang in ('English','Chinese')
order by 1


-- joining multiple tables (order does not matter)

select 
	*
from directors d 
join movies m on m.director_id = d.director_id
join movies_revenues r on  r.movie_id = m.movie_id

-- join mvoies actors, directors, revenues together
select * 
from movies mv
join movies_actors ma on mv.movie_id = ma.movie_id
join actors a on a.actor_id = ma.actor_id
join directors d on d.director_id = mv.director_id
join movies_revenues r on mv.movie_id = r.movie_id

-- join = inner join

-- SELF JOIN
-- allows to compare rows with same table

select * from 
left_product t1
inner join left_product t2 on t1.product_id = t2.product_id

-- self join all movies which have same movie length
select 
	t1.movie_name,
	t2.movie_name,
	t1.movie_length
from movies t1
inner join movies t2 on t1.movie_length = t2.movie_length
and t1.movie_name <> t2.movie_name


-- CROSS JOIN
-- all possible combinations
-- if t1 has 100 rows t2 has 100 rows
-- result will be 100*100 = 10000 rows
--  no need to specify on
select * from t1 cross join t2

-- 4*5 = 20 rows
select * from left_product cross join right_product

-- different methods for cross join
-- method 1
select * from left_product, right_product

-- method 2
select * 
from left_product 
inner join right_product on true


-- NATURAL JOIN
-- creates an implicit join based on the same col names in joined tables
-- select col_list
-- form tabl1
-- natural [inner, left, right] join on table2


select * 
from right_product
natural right join left_product


-- natural join on movies and directors
select * from 
movies natural join directors


