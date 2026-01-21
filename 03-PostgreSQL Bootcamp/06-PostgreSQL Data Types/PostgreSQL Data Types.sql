--BOOLEAN
--1. Sample table

create table table_boolean(
	product_id serial primary key,
	is_available boolean not null
);

--2. Insert data in table_boolean

insert into table_boolean(is_available) 
values ('true'),('false'),('true'),('false'),('yes'),('1')

insert into table_boolean(is_available) values ('n') --false

--3. View Record

select * from table_boolean

--4. Insertmore variable of boolean data

select *
from table_boolean
where is_available = 'true'

--5. condition search

select *
from table_boolean
where is_available = 'y'

--Not for condition

select *
from table_boolean
where not is_available

--6. Set default values for boolean colunms

alter table table_boolean
alter column is_available
set default false

insert into table_boolean(product_id) values ('13')

--CHAR, VARCHAR, TEXT
--7. Char

select cast ('Adnan' as character (10)) as "Name"
select 'Adnan'::char(10) as "Name"

select 'This is a test string'::char(10)

--8.VARCHAR

select 'This is a test string'::varchar(10)
select 'Adnan'::varchar(10)
select 'ABCD 123 $4321'::varchar(10)

--9. Create table for characters

create table table_characters(
	col_char char(20),
	col_varchar varchar(10),
	col_text text
);

--10. Inset sample data into table

insert into table_characters(col_char,col_varchar,col_text) 
values ('ABC','ABC','ABC'),('xyz','xyz','xyz')

--11. View Table

select * from table_characters

--12. Create table with a serial data type

create table table_serial(
	product_id serial,
	product_name varchar(100)
);

--13. Inset sample data into table

insert into table_serial(product_name) 
values ('pen'),('pencil'),('pencil2')

--14. View Table

select * from table_serial

--NUMERIC, DECIMALS
--15. Create table for Numbers

create table table_numbers(
	col_numeric numeric(20,5),
	col_real real,
	col_double double precision
);

--16. Inset sample data into table

insert into table_numbers(col_numeric,col_real,col_double) 
values (.9,.9,.9),
	(3.13579,3.13579,3.13579),
	(4.1357987654,4.1357987654,4.1357987654)

--17. View Table

select * from table_numbers

--DATE
--18. Create table for Dates

create table table_dates(
	id serial primary key,
	employee_name varchar(100) not null,
	hire_date date not null,
	add_date date 
);

--19. Inset sample data into table

insert into table_dates (employee_name,hire_date) 
values ('Adam','2020-01-01'),
	('Linda','2020-02-01');

--20. View Table

select * from table_dates

--21. Current date and time

select now()

--22. Current date

select current_date

--23. Create table for time

create table table_time(
	id serial primary key,
	class_name varchar(100) not null,
	start_time time not null,
	end_time time not null 
);

--24.Inset sample data into table

insert into table_time (class_name,start_time,end_time) 
values ('Math','08:00:00','09:00:00'),
	('Chemistry','09:01:00','10:00:00');

--25. View Table

select * from table_time

--26. Current time

select current_time

--26. Current time with precision

select current_time(2)

--27. Local time

select current_time,localtime
select localtime,localtime*(2)

--28. Arithmetic operations

select time '10:00' - time '4:00' as result

--29. Using Interval

interval 'n type'

n = number
type = second, minute, hours, day, month, year....

select current_time,current_time + interval '2 hours' as result

--TIMESTAMP, TIMESTAMPTZ
--30. Create table for timestamp

create table table_time_tz(
	ts timestamp,
	tstz timestamptz
);

--31.Inset sample data into table

insert into table_time_tz (ts,tstz) 
values ('2020-02-22 10:10:10-07','2020-02-22 10:10:10-07')

--32. View Table

select * from table_time_tz
show timezone

--33. Change timezone

set timezone = 'America/New_York';

select current_timestamp

--34. Current time of day

select timeofday()

--35. Using timezone() function convert time based on a timezone

select timezone('Asia/Singapore','2020-01-01 00:00:00')
select timezone('America/New_York','2020-01-01 00:00:00')

--UUID - Universally Unique Identifier
--35. Enable third part UUID extensions first eg. uuid-ossp

create extension if not exists "uuid-ossp"

--36. Generate sample uuid value

select uuid_generate_v1()
-- 48019854-f5e1-11f0-9728-c7379e4314b0

select uuid_generate_v4()
-- 5f6eac5a-22e3-4f97-ac26-5381722b88db

--37. Create sample table

create table table_uuid(
	product_id uuid default uuid_generate_v1(),
	product_name varchar(100) not null
);

--38.Inset sample data into table

insert into table_uuid (product_name) 
values ('AB111')

--39. View Table

select * from table_uuid

--40. Chage uuid default value

alter table table_uuid
alter column product_id
set default uuid_generate_v4()	

--ARRAY
--41. Create sample table

create table table_array(
	id serial,
	name varchar(100),
	phones text []
);

--42.Inset sample data into table

insert into table_array (name,phones) values ('Adam',array['(801)-123-4567','(819)-555-2222'])
insert into table_array (name,phones) values ('Linda',array['(201)-123-4567','(214)-222-3333'])

--43. View Table

select * from table_array

--44. Query data

select name,phones[1]
from  table_array

select name,phones[1]
from  table_array
where phones[2] = '(214)-222-3333'

--hstore
--45. install hstore extensions 

create extension if not exists hstore

--46. Create sample table

create table table_hstore(
	book_id serial primary key,
	title varchar(100) not null,
	book_info hstore
);

--47.Inset sample data into table

insert into table_hstore(title,book_info) values 
(
	'Title 2',
	'
		"publisher" => "AB publisher2",
		"paper_cost" => "20.00",
		"e_cost" => "10.85 "
	'
)

--48. View Table

select * from table_hstore

--49. Query hstore value

select 
	book_info -> 'publisher' as "publisher",
	book_info -> 'e_cost' as "Electronic cost"
from table_hstore

--JSON
--50. create sample table
 
create table table_json(
	id SERIAL PRIMARY KEY,
	docs JSON
);

--51. Inset sample data into table

INSERT INTO table_json (docs) VALUES
('[1,2,3,4,5,6]'),
('[1,2,3,4,5,6]'),
('{"key":"value"}');

--52. View Table

select * from table_json;

--53. lets search data

select docs from table_json;

--54. Search specific data in JSON column
 
ALTER TABLE table_json
ALTER COLUMN docs
SET DATA TYPE JSONB
USING docs::jsonb;
 
SELECT * FROM table_json
WHERE docs @> '[2]'::jsonb;
 
ALTER TABLE table_json
ADD COLUMN publisher TEXT GENERATED ALWAYS AS (docs->>'Publisher') STORED;
 
CREATE INDEX idx_table_json_publisher ON table_json (publisher);
 
SELECT * FROM table_json WHERE publisher = 'Penguin';

--Network Addresses
--55. create sample table
 
create table table_netadder(
	id SERIAL PRIMARY KEY,
	ip inet
);

--56. Inset sample data into table

INSERT INTO table_netadder (ip) VALUES
('4.12.221.223'),
('4.233.21.233'),
('4.152.207.234'),
('4.248.111.132');

--57. View Table

select * from table_netadder;

--58. Analyze entry for /24 networks ip addresses

select ip,set_masklen(ip,24) as inet_24
from table_netadder

--59. convert inet to cidr type

select 
	ip,set_masklen(ip,24) as inet_24,
	set_masklen(ip::cidr,24) as cidr_24,
	set_masklen(ip::cidr,27) as cidr_27,
	set_masklen(ip::cidr,28) as cidr_28
from table_netadder	
