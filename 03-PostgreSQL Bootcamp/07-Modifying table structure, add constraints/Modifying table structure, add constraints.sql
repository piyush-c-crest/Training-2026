create table person(
	p_id serial primary key,
	f_name text not null,
	l_name text not null
);

alter table person
add column age int not null

select * from person


alter table person
add column nationality text not null,
add column email text unique

-- MODIFY Tabel Structure
-- rename table
alter table person
rename to users

alter table users
rename to person

-- rename column 
alter table person
rename column email to user_email


-- drop column
alter table person
drop column user_email

-- change datatype of column
alter table person
alter column age type text

alter table person
alter column age type integer
using age::integer

-- set default value of a col
alter table person
alter column age
set default 18
  
select * from person

insert into person(f_name,l_name,nationality)
values ('AB','XY','IN')


-- Add constraints to column

create table web_links(
	id serial primary key,
	url text not null,
	target text
);
insert into web_links(url,target)
values ('temp.com','_blank')

select * from web_links

alter table web_links
add constraint unique_url unique (url)

-- column can accept only defined values
alter table web_links
add column is_enable varchar(2)


alter table web_links
add check (is_enable in ('y','n'))

insert into web_links(url,target,is_enable)
values ('temp2.com','_blank','q') -- error

