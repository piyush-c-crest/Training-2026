select to_char(100870,'9,99999');

-- change format of release date
select 
	release_date,
	to_char(release_date,'DD-MM-YYYY'),
	to_char(release_date,'Dy, MM, YYYY')
from movies


select * from movies_revenues
 
select movie_id,revenues_domestic,TO_CHAR(revenues_domestic, '$99999D99')
from movies_revenues;


-- TO_NUMBER
-- string to nunmber


select TO_NUMBER('1234.5678', '9999.99') 

select TO_NUMBER('1234.5678', '999') 

select TO_NUMBER('1456.76','9999.')

select TO_NUMBER('10,654.78-','99G999D99S')


-- TO_DATE()
select TO_DATE('2020/10/22','YYYY/MM/DD');
select TO_DATE('022199','MMDDYY');
SELECT TO_DATE('March 07, 1999','Month DD, YYYY');


-- Error Handling
 
select TO_DATE('2020/10/30','YYYY/MM/DD')
 
-- To timestamp
 
select to_timestamp('2020-10-28 10:30:23','YYYY-MM-DD HH:MI:SS')
 
-- It skip spaces
 
select to_timestamp('2020 may', 'YYYY MON');
 
-- minimal erro is checking!!
 
select to_timestamp('2020-01-01 22:8:00','YYYY-MM-DD HH24:MI:SS');
