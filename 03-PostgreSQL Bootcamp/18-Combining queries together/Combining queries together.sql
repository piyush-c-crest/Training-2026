-- UNION 
-- combines result sets from 2 or more select statements
-- order and number of columns in  select list of all queries must be same
select c1, c2 from t1
union 
select c1,c2 from t2


select 
product_id,product_name
from right_product
union
select 
product_id,product_name
from left_product

-- union do no return duplicats
-- union all will return diplicate too
select 
product_id,product_name
from right_product
union all
select 
product_id,product_name
from left_product



-- union + orde by
select 
product_id,product_name
from right_product
union all
select 
product_id,product_name
from left_product
order by 1

-- comboine all dir with nationality american, chinese, japnese with all female actors
select first_name , nationality,'director'
from directors
where nationality in ( 'American', 'Chinese', 'Japanese')
 union
select first_name, gender,'actor'
from actors
where gender = 'F'


-- union table with diff number of columns
drop table if exists t1;
drop table if exists t2;
create table t1( c1 int, c2 int);
create table t2( c1 int);

select c1,c2 from t1
union
select null as col2 , c1 from t2


-- intersect 
-- returns rows that are in both result set
select 
product_id,product_name
from right_product
intersect
select 
product_id,product_name
from left_product

-- EXCEPT
-- return rows in the first query that do no appear in the output of second query
select 
product_id,product_name
from right_product
except
select 
product_id,product_name
from left_product
