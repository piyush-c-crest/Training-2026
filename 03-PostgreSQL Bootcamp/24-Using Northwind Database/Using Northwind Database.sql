-- orders shipping to usa or france
select * from orders
where ship_country in ('USA','France')
order by ship_country

-- count total numbers of orders shipping to usa or france
select ship_country, count(*) from orders
where ship_country in ('USA','France')
group by ship_country


-- order shipping to any countries within latin america
select * from orders
where ship_country in ('Brazil','Mexico', 'Argentina', 'Venezuela')
order by ship_country

-- show order total amount per each order line
total amt = (unit_price * quantity) - discount
select 
	order_id,
	product_id,
	unit_price,
	quantity,
	((unit_price * quantity) - discount) as total
from order_details 


-- find first and latest order date

select 
	min(order_date) as first_order,
	max(order_date) as latest_order
From orders


-- total produncts in each category
select 
	category_id, category_name,  count(*)
	-- *
from products 
inner join categories using (category_id)
group by category_id, category_name

select * from categories

-- list products that needs re-ordering
select 
	product_id, product_name,
	units_in_stock, reorder_level
from products
where units_in_stock <= reorder_level

-- list top 5 highest freight charges
select 
	ship_country,
	avg(freight)
from orders
group by ship_country
order by 2 desc
limit 5

-- list top 5 highest freight charges in year 1997
select 
	ship_country,
	avg(freight)
from orders
where order_date between '1997-1-1' and '1997-12-31'
group by ship_country
order by 2 desc
limit 5


-- list top 5 highest freight charges in last year 
select 
	ship_country,
	avg(freight)
from orders
where Extract('Y' from order_date) >=  Extract('Y' from (select max(order_date) from orders))
group by ship_country
order by 2 desc
limit 5

-- customers with no orders

select * 
from customers c
left join orders  o on o.customer_id = c.customer_id 
where order_id is null

-- top customers with their total orde amt spent

select 
	c.customer_id,
	sum((unit_price * quantity) - discount) as amt
from customers c 
join orders  o on o.customer_id = c.customer_id 
join order_details  od on od.order_id = o.order_id 
group by c.customer_id
order by 2 desc
limit 10


-- Order with many line of items

select * from order_details where order_id = 11077 order by order_id;

select order_id,count(*)
from order_details
group by order_id
order by 2 desc;

-- Orders with double entry line items

select order_id,quantity
from order_details
where quantity > 60
group by order_id,quantity
having count(*) > 1
order by order_id;

select * from order_details where order_id = 10395
 
-- Get the details of the items too
 
with duplicate_entries as
(
	select order_id,quantity
	from order_details
	where quantity > 60
	group by order_id,quantity
	having count(*) > 1
	order by order_id
)
select *
from order_details
where order_id in (select order_id from duplicate_entries)
order by order_id;
 
-- List all late shipped orders
 
select *
from orders
where shipped_date > required_date;

-- List employees with late shipped orders
 
with late_orders as
(
	select employee_id,count(*) as total_late_orders
	from orders
	where shipped_date > required_date
	group by employee_id
),all_orders as
(
	select employee_id,count(*) as total_orders
	from orders
	group by employee_id
)
select
	employees.employee_id,
	employees.first_name,
	all_orders.total_orders,
	late_orders.total_late_orders
from employees
join all_orders on all_orders.employee_id = employees.employee_id
join late_orders on late_orders.employee_id = employees.employee_id
order by late_orders.total_late_orders desc;

-- Countries with customers or suppliers
 
with countries_suppliers as (select distinct country from suppliers),
countries_customers as (select distinct country from customers)
select
	countries_suppliers.country as country_suppliers,
	countries_customers.country as country_customers
from countries_suppliers
full join countries_customers on countries_customers.country = countries_suppliers.country;
 
 
-- Customers with multiple orders
 
with next_order_date as
(
	select 
		customer_id,
		order_date,
		lead (order_date, 1) over (partition by customer_id order by customer_id, order_date) as next_order_date
	from orders
)
select
	customer_id,
	order_date,
	next_order_date,
	(next_order_date - order_date) as days_between_orders
from next_order_date
where (next_order_date - order_date) <= 4;
 
-- First order from each country
 
with orders_by_country as
(
	select
		ship_country,
		order_id,
		order_date,
		row_number() over (partition by ship_country order by ship_country, order_date) country_row_number
	from orders
)
select ship_country,order_id,order_date
from orders_by_country
where country_row_number = 1;