--  STRING FUNCIONS

-- upper lower initcap

select upper('hi')

select 
	upper(first_name), upper(last_name)
from directors

select 
	lower(first_name), lower(last_name)
from directors

select initcap('this is initcap')

select 
	concat_ws(' ',initcap(first_name), initcap(last_name))
from directors


-- LEFT RIGHT
--     left() returns first n char from str
select left('abcd',2)

-- if n == -2 returns all except last 2
select left('abcdeffgd',-2)


-- get inital char form directors
select
	left(first_name,1) as initial,
	count(*) as total
from directors
group by initial
order by 2

-- right() returns last n characters
select right('abcd',2)
select right('abcd',-3)


-- reverse()

select reverse('hello world')


-- split_part() aplits str on specific delimiter and returns nth sub string
select split_part('1,2,3',',',2)

select split_part('a\b\c\d','\',3)

-- get release year of all movies
select 
	movie_name,
	release_date,
	split_part(release_date::text,'-',1)
from movies

/*
TRIM		removes longest string that contains a specific char from a string 
LTRIM 		removes all char , spaces by default from beginning of str
RTRIM 		removes all char , spaces by default from end of str
BTRIM 		both ltrim and rtrim

*/

select 
	trim(leading from '  amazing postgresql'),
	trim(trailing from 'amazing postgresql  '),
	trim('  amazing postgresql  ');



select trim(leading '0' from 00001234 :: text);


select 
	ltrim('yummy','y'),
	rtrim('yummy','y'),
	btrim('yummy','y');

-- LPAD

select lpad('Data',10,'*');  
select lpad('1111',8,'*');

-- RPAD

select rpad('Data',10,'*');
select rpad('1111',8,'*');


-- LENGTH 
select length('amazing postgresql');
select length(cast(100122 as text));

select char_length(' ');
select char_length(null);

-- total length of all directors full name
select 
	first_name ||' '||last_name as full_name,
	length (first_name ||' '||last_name) as full_name_length
from directors
order by 2 desc;


-- position 
-- returns first location of substring in string 

select position('world'  in 'hello world')


-- strpos same as position
-- display fname, lname and pos of specific substring 'on',
-- which must exists within last name of directors

select
	first_name, last_name
from directors
where strpos(last_name,'on') > 0


-- substring(string from  start_pos for length)

select substring ('what a wonderful world' from 1 for 8)
select substring ('what a wonderful world' from 5 for 10)

-- repeat
-- repeats str for specific number
select repeat('AB',10)


-- REPLACE 
-- replaces all occurence of specific str

select replace('abc xyz', 'x','1')

select replace ('111222333222', '2','x')

