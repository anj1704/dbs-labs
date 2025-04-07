use university1;

select avg(course.credits) as 'Avg Credit'
from university1.course;

select max(course.credits) as 'Max Credit',
min(course.credits) as 'Min Credits'
from university1.course;

select count(course.credits) as '# Course'
from university1.course;

select count(course.title) as 'NoCourse', count(distinct
course.dept_name) as 'NoDept'
from university1.course;

select course.dept_name, avg(course.credits) as 'Avg Credit'
from university1.course
group by dept_name;

select course.dept_name, count(distinct course.course_id) as 'NoCourse',
avg(course.credits) as 'AvgCredit'
from university1.course 
group by course.dept_name;

select course.dept_name, count(distinct course.course_id) as 'NoCourse',
avg(course.credits) as 'AvgCredit'
from university1.course
where course.dept_name = 'Math'
group by course.dept_name;

select course.dept_name, count(distinct course.course_id) as
'NoCourse',
avg(course.credits) as 'AvgCredit'
from university1.course
group by course.dept_name
order by course.dept_name;

select course.dept_name, count(distinct course.course_id) as
'NoCourse',
avg(course.credits) as 'AvgCredit'
from university1.course
group by course.dept_name
having avg(course.credits) >=3.5
order by course.dept_name;

use sakila;

SELECT
	a.customer_id,
	a.first_name,
	a.last_name,
	b.customer_id,
	b.first_name,
	b.last_name
FROM customer a
INNER JOIN customer b
on a.last_name = b.first_name;

SELECT city, country
FROM city
INNER JOIN country ON
city.country_id = country.country_id;

SELECT country, COUNT(city)
FROM country a
INNER JOIN city b
ON a.country_id = b.country_id
GROUP BY country;

SELECT
	c.customer_id,
    c.first_name,
	c.last_name,
	a.actor_id,
	a.first_name,
	a.last_name
FROM customer c
LEFT JOIN actor a
ON c.last_name = a.last_name
ORDER BY c.last_name;

SELECT
	c.customer_id,
    c.first_name,
	c.last_name,
	a.actor_id,
	a.first_name,
	a.last_name
FROM customer c
RIGHT JOIN actor a
ON c.last_name = a.last_name
ORDER BY c.last_name;

SELECT
	c.customer_id,
    c.first_name,
	c.last_name,
	a.actor_id,
	a.first_name,
	a.last_name
FROM customer c
RIGHT JOIN actor a
using (last_name)
ORDER BY c.last_name;

use university1;

select * from university1.course cross join university1.department;

select * from university1.course
natural join university1.department;

-- Exercise
use sakila;
-- 1a
select f.title, CONCAT(a.first_name,' ',a.last_name) as ful__name
from film as f
join film_actor as fa on fa.film_id = f.film_id
join actor as a on a.actor_id = fa.actor_id;

-- 1b
select c.customer_id, SUM(p.amount) 
from customer as c
join payment as p on c.customer_id = p.customer_id
group by c.customer_id;

-- 1c
select f.film_id, f.title
from film as f 
join inventory as i on i.film_id = f.film_id
join rental as r on r.inventory_id = i.inventory_id
where r.rental_date NOT LIKE "2005-01-%"
group by f.film_id;

SELECT f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.rental_date NOT BETWEEN '2005-01-01' AND '2005-01-31'
WHERE r.rental_id IS NULL
GROUP BY f.title;

-- 1d
select s.store_id, SUM(p.amount) as "total revenue"
from store as s
join staff as st on s.store_id = st.store_id
join payment as p on p.staff_id = st.staff_id
group by s.store_id;

-- 1e
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY c.customer_id;

SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_date BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY) AND CURRENT_DATE();

SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE datediff(current_date, r.rental_date) <= 30
GROUP BY c.customer_id;

-- additional

use university1;
-- 1a
select distinct name
from student as s
join takes as t on s.ID = t.ID
join course as c on c.course_id = t.course_id
where c.dept_name = "Comp. Sci.";

-- 1b correct this
select distinct s.ID, s.name 
from student as s
join takes as t on t.ID = s.ID
where t.year >= 2009;

SELECT s.ID, s.name
FROM student s
WHERE NOT EXISTS (
    SELECT *
    FROM takes t
    JOIN section sec ON t.course_id = sec.course_id AND t.sec_id = sec.sec_id
    WHERE t.ID = s.ID AND sec.semester < 'Spring 2009'
);

SELECT s.ID, s.name
FROM student s
WHERE NOT EXISTS (
    SELECT *
    FROM takes t
    WHERE t.ID = s.ID AND t.year * 10 + CASE 
        WHEN t.semester = 'Spring' THEN 1 
        WHEN t.semester = 'Fall' THEN 2 
        ELSE 3 
    END < 20091
);

-- 1c
SELECT MIN(sal) AS min_sal
FROM (
    SELECT d.dept_name, MAX(i.salary) AS sal
    FROM department d
    JOIN instructor i ON d.dept_name = i.dept_name
    GROUP BY d.dept_name
) s;

-- 1d
select MIN(s.salary) as third_highest from
(
	select salary 
	from instructor as i
	order by i.salary DESC
	limit 3
) s;

SELECT DISTINCT salary
FROM instructor
ORDER BY salary DESC
LIMIT 2, 1;
-- skips the first 2 values, picks the third one
