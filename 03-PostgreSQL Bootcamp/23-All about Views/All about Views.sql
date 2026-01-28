-- creating a VIEW
-- create or replace view_name as query
/* query can be:
	select
		select with subquery
		select with join
		anything that we can run via select can be turned into a view
*/

-- 1. create view to inlcude all movies with directors fname, lname
CREATE or replace VIEW v_mv_dir as 
select 
	movie_name,
	first_name,
	last_name
from movies m
inner join directors using(director_id)

-- 3. use a vuew for query
select * from v_mv_dir


-- 1. rename a view
alter view v_mv_dir rename to v_mv_dirs

-- 2. delete a view
drop view v_mv_dirs

views with filter
-- 1. all movies release after 1997
create view v_mv_after_1997 as
select * from movies
where release_date >= '1997-1-1'
order by release_date DESC

-- 2. select all eng mv from view
select * from v_mv_after_1997
where movie_lang = 'English'


-- VIEW with select and union with multiple table
create view v_actors_dir as
select
	first_name, last_name, 'Actor'
from actors
UNION ALL
select
	first_name, last_name, 'Director'
from directors



-- connecting multiple tables with single view

create view v_movies_directors_revenues as
select
	mv.movie_id,
	mv.movie_name,
	mv.movie_length,
	mv.movie_lang,
	mv.age_certificate,
	mv.release_date,
	d.director_id,
	d.first_name,
	d.last_name,
	d.nationality,
	d.date_of_birth,
	r.revenue_id,
	r.revenues_domestic,
	r.revenues_international
from movies mv
inner join directors d on d.director_id = mv.director_id
inner join movies_revenues r on r.movie_id = mv.movie_id;
 
-- short query
select * from v_movies_directors_revenues
where age_certificate = '12'


-- view do not store data physically
-- always gives updated data
create view v_dir as 
select 
	d.first_name,
	d.last_name
from directors d

SELECT * FROM v_dir


insert into directors(first_name)
values ('test1')


SELECT * FROM directors


-- UPDATABLE VIEWS


/*

An updatable view in SQL is a virtual table that allows you to perform data
modification statements (INSERT, UPDATE, DELETE) on its underlying base 
table(s). Normally, views are used as read-only representations
of data, but updatable views offer a simplified interface for data management
,with changes in the view directly reflecting in the base tables. 

To make the provided text shorter, here are the core conditions for a view to be automatically updatable:

An automatically updatable view must adhere to several key restrictions, primarily to ensure that modifications can be unambiguously mapped back to the underlying base table:
 
Single Base Table: The view should be based on only one table (some RDBMS allow restricted single-table modifications on certain joins).

Direct Column References: The view must use simple, direct column names. Expressions, calculated columns, or constants are not allowed in the SELECT list.

No Aggregation/Grouping: DISTINCT, GROUP BY, or HAVING clauses are prohibited.

No Set Operations: The query cannot use UNION, INTERSECT, or EXCEPT.

Primary Key Inclusion: The primary key of the underlying table must be included in the view to uniquely identify rows.

Nullable or Default-Valued Excluded Columns: Any base table columns omitted from the view must allow NULL values or have a DEFAULT value defined.
*/


select * from v_dir 

-- INSERTING TO VIEW

insert into v_dir(first_name)
values ('temp3')

select * from directors

--1. Create a table for countries

create table countries(
	country_id serial primary key,
	country_code varchar(4),
	city_name varchar(100)
);

--2. Insert sample data into table

insert into countries (country_code,city_name) values 
('US','New York'),
('US','New Jersey'),
('UK','London');

select * from countries;

--3. Create a sample view called v_cities_us to list all us based cities

create or replace view v_cities_us as
select country_id,country_code,city_name
from countries
where country_code = 'US';

--4. View the content of v_cities_us

select * from v_cities_us;

--5. Inseret US based data

insert into v_cities_us (country_code,city_name) values 
('US','California');

--6. Update view v_cities_us using with check option

create or replace view v_cities_us as
select country_id,country_code,city_name
from countries 

where country_code = 'US'
with check option;

insert into v_cities_us (country_code,city_name) values 
('UK','Leeds');

--7. Lets try the update operations on view having with check option, can we add the data
 
select * from v_cities_us;
 
update v_cities_us
set country_code = 'uk'
where city_name = 'new york';
 
insert into v_cities_us (country_code, city_name) values ('us', 'chicago');

update v_cities_us
set country_code = 'uk';
 
--8. Using local and cascaded in with check option
 
create or replace view v_cities_c as
select country_id,country_code,city_name
from countries
where city_name like 'c%';
 
select * from v_cities_c;
 
create or replace view v_cities_c_us as
select country_id,country_code,city_name
from countries
where city_name like 'c%' and country_code = 'us'
with local check option;

insert into v_cities_c_us (country_code, city_name) values('us', 'connecticut');

select * from v_cities_c_us;

insert into v_cities_c_us (country_code, city_name)values ('us', 'los anglese');

select * from v_cities_c_us;
 
select * from countries;
 
--9. create a materialized view
 
create materialized view if not exists mv_directors as
select first_name,last_name
from directors
with data;
 
select * from mv_directors;

create materialized view if not exists mv_directors_nodata as
select first_name,last_name
from directors
with no data;
 
select * from mv_directors_nodata;
 
refresh materialized view mv_directors_nodata;
 
--30. Drop a materializrd view
 
drop materialized view mv_directors;
 
--31. Changing material view data
 
select * from mv_directors;
 
insert into mv_directors (first_name) values ('dir1'), ('dir2');

refresh materialized view mv_directors;
 
delete from mv_directors where first_time = 'dir1';

--32. Check if materialized view is populated or not

select relispopulated from pg_class where relname = 'mv_directors2';

create materialized view mv_directors2 as
select first_name
from directors
with no data;

select * from mv_directors2;

--33. Create materialized view of table directors called 'mv_directors_us'

create materialized view mv_directors_us as
select director_id,first_name,last_name,nationality,date_of_birth
from directors
where nationality = 'American'
with no data;

select * from mv_directors_us;

--34. Refresh the data

refresh materialized view mv_directors_us;
refresh materialized view concurrently mv_directors_us;

--35. Create a unique index

create unique index idx_u_mv_directors_us_director_id on mv_directors_us (director_id);

--36. Create a table

create table page_clicks(
	rec_id serial primary key,
	page varchar(200),
	click_time timestamp,
	user_id bigint
);

--37. Populate sample data with 10,000 rows of fake data

insert into page_clicks (page,click_time,user_id) 
select 
(
	case(random()*2)::int
		when 0 then 'klickanalytics.com'
		when 1 then 'clickapis.com'
		when 2 then 'google.com'
	end
)as page,
now() as click_time,
(floor(random()* (111111111-1000000+1)+1000000))::int as user_id
from generate_series(1,10000) seq;

select * from page_clicks;

--38. Analyze daily trend

create materialized view mv_page_clicks as
select date_trunc('day',click_time) as day,page,count(*) as total_clicks
from page_clicks
group by day,page;

--39. Refresh the data

refresh materialized view mv_page_clicks;

select * from mv_page_clicks;

create materialized view mv_page_clicks_daily as
select click_time as day,page,count(*) as cnt
from page_clicks
where click_time >= date_trunc('day',now()) and click_time < timestamp 'tomorrow'
group by day,page;

--40. Create a unique index

create unique index idx_mv_page_clicks_daily_day_page on mv_page_clicks_daily (day,page);

refresh materialized view concurrently mv_page_clicks_daily;

select * from mv_page_clicks_daily

--41. List all materialized view

select oid::regclass::text
from pg_class
where relkind = 'm'
order by 1;

with matviews_with_no_unique_keys as
(
	select c.oid, c.relname, c2.relname as idx_name
	from pg_catalog.pg_class c, pg_catalog.pg_class c2, pg_catalog.pg_index i
	left join pg_catalog.pg_contraint con
	on (conrelid = i.indrelid and conindin = i.indexrelid and contype in ('p', 'u'))
	where c.relkind = 'm' and c.oid = i.indrelid and i.indexrelid = c2.oid and indisunique
)
select c.relname as materialized_view_name
from pg_class c
where c.relkind = 'm'
except
select nwk.relname
from matviews_with_no_unique_keys as mwk;

--42. Query whether a materialized view exists

select count(*) > 0 from pg_catalog.pg_class c
join pg_namespace n on n.oid = c.relnamespace
where c.relkind = 'm' and n.nspname = 'some_schema' and c.relname = 'some_mat_view';

--43. Query whether a materialized view exists

select view_definition
from information_schema.views
where table_schema = 'information_schema' and table_name = 'views';

--44. To list all materialized views

select * from pg_matviews;
select * from pg_matviews where matviewname = 'view_name';
