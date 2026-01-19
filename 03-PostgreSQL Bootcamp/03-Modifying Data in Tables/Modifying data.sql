-- Create Customer Table

create table customers (
	customer_id serial primary key,
	first_name varchar(50),
	last_name varchar(50),
	email varchar(150),
	age int
);

-- Display all the details

select * from customers;

-- Insert values in customers table

insert into customers (first_name,last_name,email,age) values ('Adnan','Waheed','a@b.com',40)
select * from customers;

insert into customers (first_name,last_name) 
values 
('Adnan','Waheed'),
('John','Adams'),
('Linda','Abe');

select * from customers;

insert into customers (first_name) values ('Bill''O Sullivan');
select * from customers;

insert into customers (first_name) values ('Adam');
insert into customers (first_name) values ('Joseph') returning *;
insert into customers (first_name) values ('Joseph1') returning customer_id;

select * from customers;

--Update selected rows 

Update customers
set email = 'a2@b.com'
where customer_id = 1

select * from customers;

update customers
set email = 'a4@b.com',age =30
where customer_id = 2

select * from customers;

Update customers
set email = 'a@b.com'
where customer_id = 3

update customers
set is_enable = 'Y'
where customer_id = 1

update customers
set is_enable = 'Y'
returning *

-- Delete 
delete from customers
where customer_id =9

select * from customers;

--create sample table

create table t_tags(
	id serial primary key,
	tag text unique,
	update_date timestamp default now()
);

-- Insert values in t_tags table

insert into t_tags (tag) values ('Pen'),('Pencil');
select * from t_tags;

insert into t_tags (tag) 
values ('Pen')
on conflict (tag)
do nothing;

select * from t_tags;

insert into t_tags (tag) 
values ('Pen')
on conflict (tag)
do update set
tag = excluded.tag,update_date  = now();

select * from t_tags;

insert into t_tags (tag) 
values ('Pen')
on conflict (tag)
do update set
tag = excluded.tag || '1',
update_date  = now();

select * from t_tags;