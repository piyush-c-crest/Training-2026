--1. Create Schema

create schema sales;
create schema hr;

--2. Rename a Schema

alter schema sales rename to programming;

--3. Drop schema

drop schema hr;

--4. Select table from public schema

select * from postgres.public.actors;
select * from postgres.humanresources.employees;

alter table humanresources.orders set schema public;

--5. View current schema

select current_schema();

--6. View current search path

show search_path;

--7. Postres,public

select * from public.orders;

--8. Set search path to scheam name,public

Set search_path to '$user',humanresources,public;

select * from orders;
select * from humanresources.test1;

insert into public.test2 (id2) values (1)
select * from test2

--9. Alter schema schema_name owner to new_owner

alter schema humanresources owner to crest

--10. Lets create a sample database called 'test_schema'

create database test_schema;

--11. Create a table called "Songs"

create table test_schema.public.songs(
	song_id serial primary key,
	song_title varchar(100)
);

--12. Add some data to songs tables

insert into test_schema.public.songs (song_title) values
('Counting Stars'),
('Rolling on')

--13. Now duplicate the schema "public" with all data

pg_dump -d test_schema -h localhost -U postgres -n public > dump.sql

--14. Lets create a schema called 'private' on 'hr' database and give rights to postgres user

grant usage on schema private to crest;
grant select on all tables in schema private to crest