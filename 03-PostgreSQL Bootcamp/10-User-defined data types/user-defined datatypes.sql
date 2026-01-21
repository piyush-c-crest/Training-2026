-- User - defined data type

-- 1. addr domain with varchar(100)
create domain addr varchar(100) not null

create table location(
	adress addr
);

insert into location values('mumbai')

select * from location


-- 2. 'positive_numeric' domain with a positive numeric > 0
create domain positive_numeric 
int not null check (value > 0)

create table demo(
	p_id serial,
	num positive_numeric
);

insert into demo(num) values (10)

select * from demo

insert into demo(num) values (-10)


-- 3. valid postal code

create domain us_postal_code text
check (value~'^\d(5)$' or value~'^\D[{5}-\d{4}$')

create table addresses(
	addresses_id serial primary key,
	postal_code us_postal_code
);

insert into addresses (postal_code) values ('10000')

select * from addresses


-- domain for valid email

create domain email text
check (value ~ '/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/')


create domain email_check  varchar(150) check (value ~* '^[A-Za-z0-9._%-]+[.][A-Za-z]+$')


create table sample(
	user_email email_check
)

insert into sample values('a@b.com')


-- enum domain to check valid values
create domain valid_colour varchar(10)
check (value in ('red','green','blue'))

create table colors(
	color valid_colour
)

insert into colors values ('red')

select * from colors

insert into colors values ('pink')


-- get all doain in schema
select typname
from pg_catalog.pg_type
join pg_catalog.pg_namespace
on pg_namespace.oid = pg_type.typnamespace
where typtype = 'd' and nspname = 'public'



-- how to drop domain
-- cascade mean drop all depending data too
drop domain email cascade

select * from demo2



-- composite data type

create type inventory_item as (
	product_name varchar(200),
	supplier_id int,
	price numeric
)

create table inventory(
	inventory_id serial primary key,
	item inventory_item
);

insert into inventory (item) values (row('paper',20,4.99))

select * from inventory

select (item).product_name from inventory where (item).price < 5.99


-- ENUM
create type currency as enum ('usd','inr')

select 'inr' :: currency

alter type currency add value 'eur' after 'usd'


create table cur(
	currency currency
)

insert into cur values('inr')

select * from cur

insert into cur values('inr2')


--  9 drop type

create type sample_type as enum ('ABC','123')

drop type sample_type


-- alter Enum
create type mycolours as enum ('green','red','blue')
alter type mycolours rename value 'red' to 'black'
select enum_range(null::mycolours)
alter type mycolours add value 'red' before 'green'
alter type mycolours add value 'yellow' after 'green'


-- Upadate ENUM
create type status_enum as enum ('queued','waiting','running','done')

create table jobs(
	job_id serial primary key,
	job_status status_enum
);

insert into jobs (job_status) values ('done')
select * from jobs

update jobs set job_status = 'running' where job_status = 'waiting'

alter type status_enum rename to status_enum_old

create type status_enum as enum ('queued','running','done')

alter table jobs alter column job_status type status_enum using job_status::text::status_enum

drop type status_enum_old

-- setting default in enum data type
create type status as enum ('pending','approved','declined')

create table cron_jobs(
	cron_jobs_id int,
	status status default 'pending'
);

insert into cron_jobs (cron_jobs_id) values(1)

select * from cron_jobs



do 
$$
begin 
	if not exists (select *
							from pg_type typ
								inner join pg_namespace nsp
											on nsp.oid = typ.typnamespace
							where nsp.nspname = current_schema()
									and typ.typname = 'a') then
		create type ai
					as (a text,
						i integer);
	end if;
end;
$$
language plpgsql;





