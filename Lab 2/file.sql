use sakila;
select * from sakila.actor;

select first_name, last_name, count(*) films 
from actor as a
join film_actor as fa using (actor_id)
group by actor_id, first_name, last_name
order by films desc
limit 5;

select payment_date, amount, SUM(amount) over (order by payment_date)
from (
	select CAST(payment_date as DATE) as payment_date, SUM(amount) as amount
	from payment
	group by CAST(payment_date as DATE)
) p 
order by payment_date
limit 5;

select * from sakila.actor
where first_name = 'nick';

update sakila.actor
set first_name = 'nicky'
where actor_id = 2;

select * from sakila.actor
order by actor_id
limit 5;

SELECT * from sakila.actor
ORDER BY actor_id ASC;

SELECT * from sakila.actor
ORDER BY actor_id DESC;

SELECT * from sakila.actor
WHERE first_name LIKE 'An%'
ORDER BY first_name, last_name DESC;

SELECT last_name 
FROM sakila.actor
GROUP BY last_name;

select last_name, count(*) 
from sakila.actor
group by last_name
limit 5;

select last_name, count(*) 
from sakila.actor
group by last_name
having count(*) > 3;

SELECT first_name 
FROM sakila.actor
WHERE first_name LIKE 'An%';

SELECT DISTINCT first_name
FROM sakila.actor
WHERE first_name LIKE 'An%';

SELECT COUNT(DISTINCT first_name) 
FROM sakila.actor
WHERE first_name LIKE 'An%';

SELECT COUNT(first_name)
FROM sakila.actor
WHERE first_name LIKE 'An%';

SELECT * from sakila.actor
where first_name = "DAN" AND actor_id = 116;

SELECT * from sakila.actor
where first_name = "DAN" OR actor_id = 115;

SELECT * from sakila.actor
where NOT actor_id = 116;

select * from sakila.actor
where first_name like "S%" or first_name like "M%"
and actor_id >=100;

select * from sakila.actor
where (first_name like "S%" or first_name like "M%")
and actor_id >=100;

SELECT * from sakila.actor
where actor_id between 100 and 105;

select * from sakila.actor
where actor_id IN (100, 110, 120);

select * from sakila.actor
where actor_id NOT IN (100, 110, 120);

select * from sakila.address
where address2 = null;

select * from sakila.address
where address2 IS NULL;

-- SELECT products.productID,
--     products.productCode,
--     products.name,
--     products.quantity,
--     products.price ,
--     CASE products.quantity
--     WHEN 2000 THEN "NOT GOOD"
--     WHEN 8000 THEN "AVERAGE"
--     WHEN 10000 THEN "GOOD"
--     ELSE "UNKNOWN"
--     END AS STATUS
-- FROM sakila.products;

