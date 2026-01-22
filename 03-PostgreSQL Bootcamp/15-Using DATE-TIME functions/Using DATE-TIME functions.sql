--1.Datestyle

show datestyle;

-- change date style

-- set datestyle = 'type, format'

-- type : ISO, Postgres, SQL, 
-- format : MDY, DMY, YDM 


-- String to YYYY-MM-DD format from ISO Format

select to_date('2020-01-01','YYYY-MM-DD');
select to_date('20200101','YYYYMMDD');
select to_date('December 1,2020','Month DD,YYYY');
select to_date('Dec 1,2020','Mon DD,YYYY');
 
--3. using to_timestamp function

select to_timestamp('2020-01-01 10:20:30','YYYY-MM-DD HH:MI:SS');
select to_timestamp('2020-01-01 10:20:30','YYYY-MM-DD HH:MI');
select to_timestamp('2020-01-01 10:20:30','YYYY-MM-DD HH');
select to_timestamp('01-01-2020 10:4','DD-MM-YYYY SS:MS');

--4. Formatting dates
 
select current_timestamp;
select current_timestamp,to_char('2020-01-01 10:00:00'::timestamp, 'yyyy month dd');
 
select 
    current_timestamp,
    to_char('2020-01-01 10:00:00'::timestamp, 'yyyy month dd'),
    to_char('2020-01-01 10:00:00'::timestamptz, 'yyyy month dd');
 
select 
    current_timestamp,
    to_char('2020-01-01 10:00:00'::timestamp, 'yyyy month dd'),
    to_char('2020-01-01 10:00:00'::timestamptz, 'yyyy month dd'),
    to_char('2020-01-01 10:00:00'::timestamptz, 'yyyy month dd hh:mi:ss tz');
 
select 
    current_timestamp,
    to_char('2020-01-01 10:00:00'::timestamp, 'yyyy month dd'),
    to_char('2020-01-01 10:00:00'::timestamptz, 'yyyy month dd'),
    to_char('2020-01-01 10:00:00'::timestamptz, 'yyyy month dd hh:mi:ss tz'),
    to_char('2020-01-01 10:00:00'::timestamptz, 'fmmonth ddth yyyy hh:mi:ss tz');
 
select 
    movie_name,
    release_date,
    to_char(release_date, 'fmmonth ddth, yyyy')
from movies;
 
select 
    movie_name,
    release_date,
    to_char(release_date, 'fmmonth ddth, yyyy hh:mi:ss tz')
from movies;
 
--5. Date & Time construction function
 
select make_date(1999, 3, 23);
select make_time(2, 3, 45.05);
select make_timestamp(2020, 3, 22, 2, 3, 4.5);
 
select 
    make_interval(2020, 03, 1, 1, 1, 1, 1),
    make_interval(2020, 03, 2, 1, 1, 1, 1),
    make_interval(2020, 03, 3, 1, 1, 1, 1),
    make_interval(2020, 03, 4, 1, 1, 1, 1),
    make_interval(2020, 03, 5, 1, 1, 1, 1);
 
select make_interval(days => 10);
select make_interval(months => 3, days => 20);
select pg_typeof(make_timestamptz(2000, 2, 2, 10, 00, 30));
select * from pg_timezone_names;

select make_timestamptz(2000, 2, 2, 10, 00, 30, 'gmt');
select make_timestamptz(2000, 2, 2, 10, 00, 30, 'nz');
select make_timestamp(2000, 2, 2, 10, 00, 30);
select pg_typeof(make_timestamp(2000, 2, 2, 10, 00, 30));
 
--6. Date value extraction function
 
select 
    extract('day' from current_timestamp),
    extract('month' from current_timestamp),
    extract('year' from current_timestamp);
 
select extract('century' from interval '500 years');
 
--7. Using math operation on date
 
select '2020-01-01'::date + 4;
select time '10:01:30' + interval '2 hours';
select time '10:01:30' + '15:2:2';
select current_timestamp, current_timestamp + '10:10:10';
select date '2020-01-01' + time '12:30:00';
select timestamp '2020-01-01 01:01:00' + time '12:30:00';
select interval '30 minutes' + interval '30 minutes';
select interval '2:00' / 2;
 
--8. Overlaps
 
select (date '2000-01-01', date '2005-12-31') overlaps (date '2006-01-01', date '2008-12-31');
select (date '2000-02-02', interval '30 days') overlaps (date '2000-02-15', date '2000-03-31');
 
--9. Date time functions
 
select 
    current_date,
    current_time,
    current_time(2),
    current_timestamp,
    localtime,
    localtime(3),
    localtimestamp,
    localtimestamp(3);
 
--10. Postgre date time functions
 
select 
    now(),
    transaction_timestamp(),
    statement_timestamp(),
    clock_timestamp();
 
select timeofday();
 
--11. Age
 
select age('2025-08-05','2005-03-25');
select age(timestamp '2005-03-25');
select age(current_date , timestamp '2005-03-25');
select age(timestamp '2005-03-25', current_date); 
select current_date; 
select current_date - 1;

--12. Create Sample table

create table time_update (
    id serial not null,
    update_on_date date default current_date,
    add_time time default current_time,
    entry text
);

--13. Insert data into table

insert into time_update (entry)
values ('abc'), ('xyz');
 
select * from time_update;
 
--14. Epoch --> age is good for subtracting dates but epoch is far better
 
select 
    (extract(epoch from timestamptz '2020-02-01') - extract(epoch from timestamptz '2020-01-01')) / 60 / 60 / 24,
    timestamp '2020-02-01' - timestamp '2020-01-01',
    age(timestamp '2020-02-01', timestamp '2020-01-01');
 
insert into time_update (update_on_date, add_time, entry)
values ('epoch','allballs','abc');
 
insert into time_update (update_on_date, add_time, entry)
values ('-infinity','allballs','abc');
 
select * from time_update;
 
--15. Setting up timezone
 
select * from pg_timezone_names;
select * from pg_timezone_abbrevs; 
show time zone;
 
set time zone 'america/new_york';
 
alter table time_update add column end_timestamp timestamp with time zone; 
alter table time_update add column end_time time with time zone;
 
insert into time_update (end_timestamp, end_time) 
values ('2020-01-20 11:30:00 us/pacific', '11:30:00+6');
 
select * from time_update;
 
select 
    date_part('year', timestamp '2017-01-01'),
    date_part('month', timestamp '2017-05-01'),
    date_part('quarter', timestamp '2017-12-01'),
    date_part('decade', timestamp '2017-01-01'),
    date_part('century', timestamp '2017-01-01');
 
select 
    date_part('week', timestamp '2017-01-01'),
    date_part('dow', timestamp '2017-05-01'),
    date_part('doy', timestamp '2017-12-01'),
    date_part('day', timestamp '2017-01-01'),
    date_part('hour', timestamp '2017-01-01 10:20:30'),
    date_part('min', timestamp '2017-01-01 10:20:30'),
    date_part('sec', timestamp '2017-01-01 10:20:30');
 
--16. Date trunc
 
select 
    date_trunc('hour', timestamp '2017-01-01 10:20:30'),
    date_trunc('min', timestamp '2017-01-01 10:20:30'),
    date_trunc('sec', timestamp '2017-01-01 10:20:30');
 
select 
    date_trunc('month', release_date) as "release month",
    count(movie_id)
from 
    movies
group by 
    "release month"
order by 
    2 desc;