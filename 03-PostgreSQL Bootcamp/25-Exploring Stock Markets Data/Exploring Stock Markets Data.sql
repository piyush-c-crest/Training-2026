-- first ot last 10 rows
select * from stocks_prices
order by price_date asc
limit 10

-- how to get first , last date for each grp
select 
	symbol_id,
	min(price_date),
	max(price_date)
from stocks_prices
group by symbol_id

-- cube root 
select
	cbrt(close_price)
from
	stocks_prices
