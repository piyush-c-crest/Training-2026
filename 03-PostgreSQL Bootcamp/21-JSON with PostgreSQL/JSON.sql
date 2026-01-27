 -- json
 -- name : value pair
 /*
 - {} holds objects, obj can have multiple name:value pairs
 {"name" : "a", "city" : "x"}
 
 - [] holds array, contains objects
 [
	{OBJECT}
 ]


	"contacts" : [
		{"fname" :"f1", "lname" : "l1"},
		{"fname" :"f2", "lname" : "l2"},
		{"fname" :"f3", "lname" : "l3"}
	]

	
		string "key" : "kjfs"
		number "num" : 100
		boolean "is" : true
		null "fk" : null


both array and objects can be nested
{
  "userId": "user789",
  "name": "Bob K.",
  "contact": {
    "email": "bob.k@example.com",
    "address": {
      "street": "123 Wonderland Ave",
      "city": "Anystate",
      "zipCode": "12345"
    }
  },
  "phoneNumbers": [
    {
      "type": "home",
      "number": "555-0201"
    },
    {
      "type": "mobile",
      "number": "555-0202"
    }
  ]
}

 */

select '{"title" : "got"}' :: json

select '{
	"title" : "got"
}' :: json


-- remove white spaces
select '{
	"title" : "got"
}' :: jsonb


create table books(
	id serial primary key,
	info jsonb
)


insert into books(info) values
('{
	"title" : "b10",
	"author" : "a10"
}')


select * from books


insert into books(info) values
('{
	"title" : "b2",
	"author" : "a2"
}'),
('{
	"title" : "b3",
	"author" : "a3"
}'),('{
	"title" : "b4",
	"author" : "a4"
}'),('{
	"title" : "b5",
	"author" : "a5"
}')



-- use selectors (-> , ->>)
-- -> operator returns json obj field as field in double quotes
-- --> operator returns json obj field as TEXT


select 
	info->'title'
from books

select 
	info->>'title'
from books

-- WITH where clause
select 
	info->>'title'
from books
where
	info->>'author' = 'a1' 

-- 2. update a record
-- use || , which will
	-- add field or
	-- replace existing field

update books
set info = info || '{"author" : "author_x"}'
where info->>'author' = 'a1'

-- 3. add new field like 'best_seller' with boolean value

update books
set info = info || '{"best seller" : true}'
where info->>'author' = 'a3'
returning *

-- 4. delete best seller
-- to delete use - operator
update books
set info = info - 'best seller'
where info->>'author' = 'a3'
returning *

-- 5. add nested array data in json
update books
set info = info || '{"available location" : ["a","b"]}'
where info->>'author' = 'a3'
returning *

-- 6. deleting from arrays via path '#-'
update books
set info = info #- '{"available location",1}'
where info->>'author' = 'a3'
returning *


-- 1. create director table into json format

select row_to_json(directors) from directors

-- 2. specific columns
select row_to_json(t) from 
(
	select 
		director_id,
		first_name
	from directors

) as t



-- use json_agg() to aggrigate data
-- 1. list movies from each director


select *, (
	select json_agg(x) as all_movies from(
		select movie_name
		from movies
		where director_id = directors.director_id
	) as x
) from directors


-- build JSON array

-- 1. numbers
select json_build_array(1,2,3)

-- 2. with string
select json_build_array(1,2,3,'hui','h')


-- 3. build object
select json_build_object(1,2,3,4) -- -> (key,val, key, val.....)


-- creating documnet from json

create table directors_doc(
	id serial primary key,
	body jsonb
)

-- get all moives by each director in json array format
insert into directors_doc(body)
select row_to_json(a) ::jsonb from (
	select 
		director_id, first_name, last_name,date_of_birth,nationality,
		(
			select json_agg(x) as all_movies from(
				select movie_name
				from movies 
				where director_id = directors.director_id
			) as x
		) from directors
) as a

select * from directors_doc


-- NULLS in json

-- inserting movies counts instead of nameas
delete from  directors_doc
insert into directors_doc(body)
select row_to_json(a) ::jsonb from (
	select 
		director_id, first_name, last_name,date_of_birth,nationality,
		(
			select count(x) as total_movies from(
				select movie_name
				from movies 
				where director_id = directors.director_id
			) as x
		) from directors
) as a

select * from directors_doc

delete from  directors_doc;
insert into directors_doc(body)
select row_to_json(a) ::jsonb from (
	select 
		director_id, first_name, last_name,date_of_birth,nationality,
		(
			select case count(x) when 0 then '[]' else json_agg(x) end as all_movies from(
				select movie_name
				from movies 
				where director_id = directors.director_id
			) as x
		) from directors
) as a;

select * from directors_doc


-- getting info from json docs
-- 1. count total movies for each dir
select *, jsonb_array_length(body->'all_movies')
from directors_doc

-- 2. list all keys within each json row
select distinct jsonb_object_keys(body)
from directors_doc

-- 2. list all keys:value within each json row
select distinct jsonb_each(body)
from directors_doc

-- existing operator ?
--  1. find all first name = john
select * from directors_doc
where body->>'first_name' = 'John'

-- 2. find record with id = 1
select * from directors_doc
where body @> '{"director_id" : 1}'

select * from contacts_docs


--1. Find all first name equal to 'John'
 
select *
from contacts_docs
where body->'first_name' ? 'John';

--2. Execution time to run this query

explain analyze select *
from contacts_docs
where body->'first_name' ? 'John';

--3. Create gin index

create index idx_gin_contacts_docs_body on contacts_docs using gin(body);
select pg_size_pretty(pg_relation_size('idx_gin_contacts_docs_body'::regclass)) as index_name;

create index idx_gin_contacts_docs_body_cool on contacts_docs using gin(body jsonb_path_ops);
select pg_size_pretty(pg_relation_size('idx_gin_contacts_docs_body_cool'::regclass)) as index_name;
