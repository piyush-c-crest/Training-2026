-- TYPE CONVERSION
-- Implicit           done automaticaly
-- Exlpicit           done via cpnversion functions ex. cast or ::

select * from movies
where movie_id = 1  -- same data type so no conversion

select * from movies
where movie_id = '1'  -- implicit conversion

select * from movies
where movie_id = integer '1' -- Explicit 

cast (expression as target_data_type)

-- string to int conversion
select 
	cast ('10' as integer)

select 
	cast ('10afsv' as integer)

-- str to date
select 
	cast('2022-01-25' as date),
	cast('2022-jan-25' as date)

--str to boolean
select cast('true' as boolean),
	cast('false' as boolean),
	cast('T' as boolean),
	cast('F' as boolean)
select 
	cast('0' as boolean),
	cast('1' as boolean)

-- String to double Conversion

select 
	cast('14.788' as double precision),
	cast('12.74387463' as double precision)

expression :: type

select 
	'0' :: boolean,
	'1' :: boolean

	
-- Using integer as factorial

select factorial(5) as result;

-- Integer to bigint

select factorial(cast(5 as bigint)) as result


create table ratings(
	rating_id serial primary key,
	rating varchar(1) not null
);

insert into ratings(rating) 
values ('A'), ('B'),('C'), ('D')

insert into ratings (rating) values (1),(2),(3),(4);
 
select * from ratings;

select rating_id,
	case when rating~E'^\\d+$' then 
	cast (rating as integer)
	else 0
	end as rating
from ratings
