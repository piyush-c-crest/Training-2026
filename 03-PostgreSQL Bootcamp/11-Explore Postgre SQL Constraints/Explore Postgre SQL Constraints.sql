-- Constraints
/*

 two level 
		column level->  applied to single col
 		table level -> applied to whole table
Not null - field must have val
unique - only unique val allowed
default - set default
primary key - uniquely identify each col
foreign key - constaints data based on other table
check - checks all value meets specific requirement

*/


-- not null
create table t_nn(
	name text not null
)
insert into t_nn values(null)

-- '' empty string is not a null val 
insert into t_nn values('')
select * from t_nn 

-- add not null constrint to existing table
create table t2(
	name text
)

alter table t2
alter column name set not null


-- UNIQUE
-- every time we add new val , it checks if already exits 


create table emails(
	email text unique
)

insert into emails values('a.com')

select * from emails


insert into emails values('a.com') -- error




-- multiple unique col

create table t3(
	col1 text,
	col2 text
)

alter table t3
add constraint unique_col unique(col1,col2)


-- DEFAULT

create table t4(
	id serial,
	is_enable varchar(2) default 'y'
)

insert into t4(id) values(1)

select * from t4


-- update default
alter table t4
alter column is_enable set default 'n'


-- drop default value
alter table t4
alter column is_enable drop default


-- PRIMARY KEY (table level) unique + not null

create table items(
	item_id int primary key,
	name text not null
)

-- add p key to existing table
-- drop then add
alter table items
drop constraint items_pkey

alter table items
add constraint p_key primary key (item_id)



-- primary key constrint on multiple column = composite primary key

drop table students
create table students(
	course_id text not null,
	stu_id text not null,
	grade int not null,
	primary key (course_id,stu_id) 
-- c_id + s_id = composite key
)

insert into students (course_id,stu_id,grade) values ('Math','S2',70),('Chemistry','S1',70),('English','S2',70),('Physics','S1',80)

-- drop primary key
alter table students
drop constraint students_pkey



-- foreign key
-- is columno/columns in table that referece the primary key of another table 

-- WITHOUT FOREIGN KEY
create table t_products(
	p_id int primary key,
	p_name text,
	supplier_id int not null
)

create table suppliers(
	supplier_id int primary key,
	supplier_name text not null
)


insert into suppliers
values(1,'sup 1'), (2,'sup 2')


insert into t_products
values (1,'pen',1), (2,'pencil',2)

insert into t_products
values (3,'paper',10)


-- ADD FOREIGN KEY
create table name(
	col type primary key,
	.......
	.......
	foreign key (col3, col4,..) references other_table (col_name)
)

drop table t_products
drop table suppliers


create table suppliers(
	supplier_id int primary key,
	supplier_name text not null
)

create table t_products(
	p_id int primary key,
	p_name text,
	supplier_id int not null,
	foreign key (supplier_id) references suppliers (supplier_id)
)



insert into suppliers
values(1,'sup 1'), (2,'sup 2')


insert into t_products
values (1,'pen',1), (2,'pencil',2)

insert into t_products
values (3,'paper',10) -- Key (supplier_id)=(10) is not present in table "suppliers". 

insert into suppliers
values(10,'sup 10'),


delete from suppliers where supplier_id = 10 -- cant do it
delete from t_products where p_id = 3
delete from suppliers where supplier_id = 10 -- no error now , bcs no connection is there


-- drop a constraint
alter table t_name
drop constraint cname;

alter table t_products
drop constraint t_products_supplier_id_fkey

-- add f key to existing table
alter table t_name
add constraint cname foreign key (col) references t2_name (cols)

alter table t_products
add constraint f_key foreign key (supplier_id) references suppliers (supplier_id)

-- CHECK Constraint
-- inserted value must meet specific requirement
drop table staff
create table staff(
	s_id int,
	name text,
	dob date check (dob >= '2000-01-01'),
	join_date date check (join_date > dob),
	salary int check (salary > 0)
)


insert into staff 
values (1,'a','2005-03-25','2026-01-05',15000)


insert into staff 
values (1,'a','1995-03-25','2026-01-05',15000)

select * from staff

-- check constraint for exixting table

create table prices(
	price_id serial primary key,
	product_id int not null,
	price numeric not null,
	discount numeric not null,
	valid_from date not null
)

-- price > 0 and discount >=0 and price >= discount

alter table prices
add constraint price_check
check (
	price > 0 and discount >= 0 and price > discount
)

insert into prices 
values(1,1,100,20,'2020-10-01')

select * from prices

insert into prices 
values(1,1,100,20,'2020-10-01')

















