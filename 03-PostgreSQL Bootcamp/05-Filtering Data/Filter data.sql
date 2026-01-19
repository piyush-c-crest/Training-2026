-- types of operators

-- 1. Comparision OP :  > < >= <= = <>(not equal)
-- 2. Logical and, or, like, in , between
-- 3. Airthmetic : + - * 

-- 1. all english movies
-- use sibgle quates only , not double
select * from movies where movie_lang = 'English'

-- 2. all eng movies with age certificate to 18
select * from movies 
where 
	movie_lang = 'English' 
	and age_certificate = '18'

-- 3. get all eng chinies movies
select * from movies 
where 
	movie_lang = 'English' 
	or movie_lang = 'Chinese'
order by 
	movie_lang

-- 4. all eng chin movies with age certificate = 12
select * from movies 
where 
	( movie_lang = 'English'
	or movie_lang = 'Chinese' ) 
	and age_certificate = '12'

-- order of running where , order by, select and from 

-- from > where > select > order by


-- Logical Operators
-- 1. all movies where len > 100
select * from movies 
where movie_length > 100

-- 2. all movies wheregreater than or equal to 100
select * from movies 
where movie_length >= 100

-- 3. get all movies where release data > 2000












