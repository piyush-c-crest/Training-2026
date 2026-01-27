--1. Create index

create index idx_orders_order_date on orders(order_date);
create index idx_orders_ship_city on orders(ship_city);
create index idx_orders_customer_id_order_id on orders(customer_id, order_id);
create unique index idx_u_products_product_id on products (product_id);
create unique index idx_u_employees_employee_id on employees (employee_id);
create unique index idx_u_orders_customer_id_order_id on orders(customer_id, order_id);
create unique index idx_u_employees_employee_id_hire_date on employees (employee_id, hire_date);
select * from employees;

--2. All indexes 

select * from pg_indexes;
select * from pg_indexes where schemaname = 'public';
select * from pg_indexes where tablename = 'orders';
select pg_size_pretty(pg_indexes_size('orders'));

--3. Applying indices on table will increase size of tables

select pg_size_pretty(pg_indexes_size('suppliers'));   --- 16 kb
create index idx_suppliers_region on suppliers(region);
select pg_size_pretty(pg_indexes_size('suppliers'));    --- 32 KB

--4. pg_stat_all_indexes

select * from pg_stat_all_indexes;
select * from pg_stat_all_indexes where schemaname = 'public';
select * from pg_stat_all_indexes where relname = 'orders';

--5. Drop indexes

drop index idx_suppliers_region;

select * from pg_am;

--6. Sequential scan, when no valuable alternative available

explain select * from orders;
explain select * from orders where order_id is not null;

--7. Join nodes

explain select * from orders natural  join customers;

--8. Hash index

create index idx_orders_order_date_on on orders using hash(order_date);

select * from orders order by order_date;
select * from orders where order_date = '2020-01-01';

explain select * from orders where order_date = '2020-01-01';

--9. Explain statement

explain select * from suppliers where supplier_id = 1;

explain select company_name from  suppliers order by company_name;

explain select company_name from suppliers where supplier_id = 1
order by company_name, city;
 
--10.  Explain 	output options
 
explain (format json) select * from orders where order_id = 1;
explain select * from orders where order_id = 1;
explain select * from orders where order_id = 1 order by order_id;
 
select count(*) from orders;
 
explain analyze select * from orders where order_id = 1 order by order_id;
explain (analyze) select * from orders where order_id = 1 order by order_id;
 
create table t_big (id serial, name text);

insert into t_big (name) select 'Adam' from generate_series(1,2000000);
insert into t_big (name) select 'Linda' from generate_series(1,2000000);

select * from t_big where id = 12345;
 
explain select * from t_big where id = 12345;
 
show max_parallel_workers_per_gather;

set max_parallel_workers_per_gather to 0;
 
select pg_relation_size('t_big') / 8192.0;
 
show seq_page_cost;
show cpu_tuple_cost;
show cpu_operator_cost;

select pg_size_pretty(pg_total_relation_size('t_big'));
select pg_size_pretty(pg_indexes_size('t_big'));
 
explain analyze select * from t_big where id = 123456;
 
create index idx_t_big_id on t_big(id);

explain select * from orders where order_id = 1
 
--11. Indexes for second output
 
explain select * from t_big order by id limit 20;
explain select * from t_big order by name limit 20;
 
explain select min(id),max(id) from t_big;
 
--12. Using multiple indexes on a single query
 
explain select * from t_big
where id = 20 or id = 40;

--13. Execution plans depends on input values
 
create index idx_t_big_name on t_big (name);
 
explain select * from t_big where name = 'Adam'
limit 10;
 
explain select * from t_big
where name = 'Adam' or name = 'Linda';
 
explain select * from t_big
where name = 'Adam1' or name = 'Linda1';
 
--14. Using organized vs random data
 
select * from t_big order by id limit 10;

explain (analyze true, buffers true, timing true)
select * from t_big where id < 10000;
 
--15. order by random()
 
create table t_big_random as select * from t_big order by random();
 
create index idx_t_big_random_id on t_big_random (id);
 
select * from t_big_random limit 10;
 
vacuum analyze t_big_random;
 
explain (analyze true, buffers true, timing true)
select * from t_big_random where id < 10000;
 
select 
	tablename,
	attname,
	correlation
from pg_stats
where 
	tablename in ('t_big', 't_big_random')
order by 1, 2;

explain analyze select id from t_big where id = 123456;  --0.179 

create index idx_p_t_big_name on t_big(name)
where name not in('Adam','Linda');

select * from customers;

update customers
set is_active = 'N'
where customer_id in ('ALFKI','ANATR');

explain analyze select * from customers
where is_active = 'N';

create index idx_p_customers_inactive on customers(is_active)
where is_active = 'N';

select count(*) from customers;

create table t_dates as select d, repeat(md5(d::text),10) as padding
from generate_series(timestamp '1800-01-01',timestamp '2100-01-01',interval '1 day')s(d);

vacuum analyze t_dates;

select count(*) from t_dates;

explain select * from t_dates
where d between '2001-01-01' and '2001-01-31';

create index idx_t_dates on t_dates(d);

explain analyze select * from t_dates
where d between '2001-01-01' and '2001-01-31';

create index idx_expr_t_dates on t_dates(extract(day from d));

analyze t_dates;

explain analyze select * from t_dates
where extract(day from d) = 1;

--16. Adding Data while indexing

create index concurrently  idx_t_big_name2 on t_big(name);

select 
	oid,relname,relpages,reltuples,
	i.indisunique,i.indisclustered,i.indisvalid,
	pg_catalog.pg_get_indexdef(i.indexrelid,0,true)
	from pg_class c join pg_index i on c.oid = i.indrelid
	where c.relname = 't_big';

select 
	oid,relname,relpages,reltuples,
	i.indisunique,i.indisclustered,i.indisvalid,
	pg_catalog.pg_get_indexdef(i.indexrelid,0,true)
	from pg_class c join pg_index i on c.oid = i.indrelid
	where c.relname = 'orders';
select * from orders;
 
explain select * from orders where ship_country = 'USA';
 
--17. Disallow the query optimizer

update pg_index 
set indisvalid = false
where indexrelid = (select oid from pg_class
					where relkind = 'i'
					and relname = 'idx_orders_ship_country');
 
update pg_index 
set indisvalid = true
where indexrelid = (select oid from pg_class
					where relkind = 'i'
					and relname = 'idx_orders_ship_country');
 
--18. Rebuilding an index
 
reindex  index idx_orders_customer_id_order_id;
reindex (verbose) database postgres;
reindex (verbose) table concurrently orders;