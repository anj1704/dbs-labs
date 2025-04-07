use university1;
show tables;

create view stview as
select student.ID, student.name, student.tot_cred
from university1.student
where student.tot_cred>50;

select * from stview
order by stview.tot_cred;

select student.ID, student.name, student.tot_cred 
from university1.student 
where student.tot_cred>50 
order by student.tot_cred;

update university1.student
set student.tot_cred = 100
where student.ID = 11126;

select * from stview
order by stview.tot_cred;

create view instrview as
select instructor.ID, instructor.salary
from university1.instructor;

select * from instrview;

update university1.instructor
set instructor.salary = 0.1
where instructor.salary = null
and instructor.id > 25000;

select * from instrview;

create view stu_info as
select student.ID, student.name, student.tot_cred, takes.grade
from university1.student left join
university1.takes
on student.ID = takes.ID
where student.tot_cred > 30
order by student.tot_cred;

select * from stu_info;

select name, grade from stu_info;

alter view stu_info as
select student.name, student.ID, student.tot_cred, takes.grade, takes.year
from university1.student left join 
university1.takes
on student.ID = takes.ID
where student.tot_cred>30
order by student.tot_cred;

select * from stu_info;

select dept_name, name, AVG(salary) OVER (partition by dept_name) as
total_salary from instructor;

select dept_name, COUNT(ID) OVER (partition by dept_name) as 
total_instructors from instructor;

select dept_name, budget, RANK() over (order by budget desc) as
budget_rank from department;

SELECT i.ID, i.name, s.semester, s.year,
COUNT(t.course_id) OVER (PARTITION BY i.ID, s.semester, s.year)
AS courses_taught,
COUNT(t.course_id) OVER (PARTITION BY s.semester, s.year) 
AS total_courses 
FROM instructor i 
JOIN teaches t ON i.ID = t.ID 
JOIN section s ON t.course_id = s.course_id 
AND t.sec_id = s.sec_id 
AND t.semester = s.semester 
AND t.year = s.year
order by i.ID;

-- same thing using group by instead
SELECT i.ID, i.name, s.semester, s.year,
       COUNT(t.course_id) AS courses_taught,
       (SELECT COUNT(DISTINCT course_id)
        FROM section s2
        WHERE s2.semester = s.semester AND s2.year = s.year) AS total_courses
FROM instructor i
JOIN teaches t ON i.ID = t.ID
JOIN section s ON t.course_id = s.course_id
  AND t.sec_id = s.sec_id
  AND t.semester = s.semester
  AND t.year = s.year
GROUP BY i.ID, s.semester, s.year
ORDER BY i.ID;

use sakila;
 
select customer_id, payment_id,payment_date,
ROW_NUMBER() OVER 
(partition by customer_id order by payment_date) 
as num 
from payment;

use university1;

select course_id, title, dept_name, credits,
ROW_NUMBER() over (ORDER by credits desc) row_no,
RANK() over (order by credits desc) as rnk,
DENSE_RANK() over (order by credits desc) as dense_rnk
FROM course
ORDER BY credits DESC;
# check for difference between rank and dense rank

select *
from (select c.course_id, c.title as course_name,
st.name as student_name, tk.grade,
ROW_NUMBER() over (partition by tk.course_id order by tk.grade) 
as rank_in_course
from student st
join takes tk on st.ID = tk.ID
join course c on tk.course_id = c.course_id
) as ranked_students
where ranked_students.rank_in_course <= 3
order by course_id, rank_in_course;

use sakila;
show tables;
desc film_list;

SELECT rating, title, rental_rate, 
RANK() OVER (PARTITION BY rating ORDER BY rental_rate DESC) as rnk 
FROM film;

select customer_id, SUM(amount) as total_spend, 
RANK() over (order by SUM(amount) desc) as spend_rank
from payment
group by customer_id;
# when ordering on an aggregate function MUST use group by

select rating, title, length,
DENSE_RANK() OVER (PARTITION BY rating ORDER BY length DESC) AS dnsrank 
FROM film; 

select customer_id, SUM(amount) as total_spent,
dense_rank() over (order by sum(amount) desc) as spend_dense_rank
from payment group by customer_id;

select title, length,
NTILE(4) over (order by length) as quartile
from film;

select film_id, title,
lead(title) over (order by film_id) as next_film_title
from film;

select customer_id, rental_id, rental_date,
LAG(rental_date, 1, '2000-01-01')
over (partition by customer_id order by rental_date)
as previous_rental_date,
DATEDIFF(rental_date, LAG(rental_date, 1, '2000-01-01')
over (partition by customer_id order by rental_date))
as days_since_last_rental
from rental
order by days_since_last_rental desc, customer_id, rental_date;

use university1;

select name, tot_cred, tot_cred/150*100 as percent
from student
where tot_cred >= 40;

use sakila;

select CONCAT(
	address.address, 
    ' Dist. ',
    address.district,
    ' PIN: ',
    address.postal_code) 
as mail
from sakila.address;

select CONCAT('My','S','SL');

select "HI",23,"BYE";

select concat(substring(actor.first_name,    1,    1),'.   ',
actor.last_name) as Actor_Name from sakila.actor limit 10;

select ' Singh ';
select ltrim(' Singh ') as l_trim;
select rtrim(' Singh ') as r_trim;
select trim(' Singh ') as trim;
SELECT TRIM(LEADING 'x' FROM 'xxxbarxxx') as trim_exam;
SELECT TRIM(BOTH 'x' FROM 'xxxbarxxx') as trim_exam;
SELECT TRIM(TRAILING 'xyz' FROM 'barxxyz') as trim_exam;

select UPPER(CONCAT(address.address,' Dist.
',address.district,' PIN: ',address.postal_code)) as mail
from sakila.address;

select LOWER(CONCAT(address.address,' Dist.
',address.district,' PIN: ',address.postal_code)) as mail
from sakila.address;

select char_length(last_name) from sakila.actor limit 10;

SELECT REPLACE('www.mysql.com', 'w', 'Ww');

SELECT CURDATE();

SELECT DATE_FORMAT(CURDATE(),'%W %D %M %Y');

SELECT ADDDATE(CURDATE(),30);
SELECT SUBDATE(CURDATE(),30);
SELECT ADDTIME(CURTIME(),'02:00:00');
SELECT SUBTIME(CURTIME(),'02:00:00');

SELECT EXTRACT(YEAR_MONTH FROM '2019-07-02 01:02:03');
SELECT EXTRACT(DAY_MINUTE FROM '2019-07-02 01:02:03');
SELECT EXTRACT(MICROSECOND FROM '2003-01-02 10:30:00.000123');
SELECT EXTRACT(YEAR from '2019-07-02 01:02:03');

-- questions
use university1;
-- 1
-- CREATE VIEW tot_credits AS
-- SELECT t.ID, t.year, SUM(c.credits) AS num_credits
-- FROM takes t
-- JOIN course c ON t.course_id = c.course_id
-- GROUP BY t.year, t.ID;
CREATE VIEW tot_credits AS
SELECT t.year, SUM(c.credits) AS num_credits
FROM takes t
JOIN course c ON t.course_id = c.course_id
GROUP BY t.year;

select * from tot_credits;

create view test as select * from tot_credits;
select * from test;

-- 2a
SELECT
    c.dept_name,
    c.course_id,
    DENSE_RANK() OVER (PARTITION BY dept_name ORDER BY COUNT(*) DESC) AS dense
FROM
    section as s
JOIN 
	course as c
ON 
	c.course_id = s.course_id
group by
	c.course_id
order by dept_name, course_id;

select c.dept_name, t.course_id, count(t.sec_id) as num_sec,
dense_rank() over(order by count(t.sec_id) desc) as d_rank
from teaches t inner join course c on t.course_id = c.course_id
group by  t.course_id;

-- 2b
select i.ID, i.name, i.dept_name, i.salary, 
percent_rank() over (partition by dept_name order by salary DESC) as prnk
from instructor as i;

use sakila;
-- 2c
SELECT
    rental_id,
    rental_date,
    payment_id,
    amount AS payment_amount,
    SUM(amount) OVER (ORDER BY rental_id) AS running_total
FROM
    payment
JOIN
    rental USING (rental_id)
ORDER BY
    rental_id;

select payment_id, payment_date, amount,
sum(amount)over(order by payment_date) as running_amount
from payment; 

-- 2d
SELECT
    rental_id,
    rental_date,
    amount AS payment_amount,
    SUM(amount) OVER (ORDER BY amount)/count(*)  OVER (ORDER BY amount) AS running_average
FROM
    payment
JOIN
    rental USING (rental_id)
GROUP BY
	rental_id
ORDER BY
    rental_id;

SELECT
    rental_id,
    rental_date,
    amount AS payment_amount,
    AVG(amount) OVER (ORDER BY rental_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_average
FROM
    payment
JOIN
    rental USING (rental_id)
ORDER BY
    rental_id;

select payment_id, payment_date, amount,
sum(amount)over(order by payment_date) as running_amount,
sum(amount)over(order by payment_date) / row_number() over(order by payment_date) as avg_amt
from payment; 

-- 2e
use university1;
SELECT
    dept_name,
    total_courses,
    RANK() OVER (ORDER BY total_courses DESC) AS department_rank
FROM (
    SELECT
        dept_name,
        COUNT(*) AS total_courses
    FROM
        course
    GROUP BY
        dept_name
) AS course_counts;

select dept_name, count(course_id),
rank() over(order by count(course_id) desc) as r
from course
group by dept_name;
