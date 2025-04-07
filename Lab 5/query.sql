use sakila;

select concat(address.address,', Dist. - ',address.district,' PIN - ', address.postal_code) 
as address
from sakila.address 
where 
address.address_id = 
(select store.address_id 
from sakila.store 
where store.manager_staff_id=2);

select concat(customer.first_name,' ',customer.last_name) as 
CustName
from sakila.customer
where customer.customer_id in 
(select payment.customer_id from sakila.payment
where payment.staff_id = 2);

use university1;

select student.name from university1.student
where student.ID in
(select takes.id from university1.takes
where takes.semester = 'Fall');

select student.name from university1.student 
where student.ID NOT IN 
(select takes.id from university1.takes 
where takes.semester = 'Fall');

select instructor.ID, instructor.name 
from university1.instructor 
where instructor.salary 
between (select avg(instructor.salary)-5000 from university1.instructor) and (select avg(instructor.salary)+5000 from university1.instructor);

select student.name 
from university1.student 
where student.ID = 
(select takes.id 
from university1.takes 
where takes.semester = 'No Semester');

select student.name 
from university1.student 
where student.ID in 
(select takes.id 
from university1.takes 
where takes.semester = 'No Semester');

select student.name 
from university1.student 
where student.ID not in
(select takes.id 
from university1.takes 
where takes.semester = 'No Semester');

select course.course_id, course.title, course.credits 
from university1.course 
where course.course_id in 
(
	select teaches.course_id 
	from university1.teaches, university1.instructor 
	where teaches.ID in 
	(
		select avgsal.id from 
		(
            select instructor.id, instructor.salary 
			from university1.instructor 
			having instructor.salary > 
			(
				select avg(instructor.salary) from university1.instructor
			)
		) avgsal
	)
);

select instructor.name, instructor.dept_name, instructor.salary, 
teaches.sec_id, teaches.semester, course.title, course.credits 
from instructor 
natural join teaches 
natural join course 
having instructor.salary > 
(select avg(instructor.salary) from university1.instructor);

use restaurant;
SELECT name FROM items 
WHERE price > 
ANY (SELECT price FROM items WHERE name LIKE '%Salad');

SELECT name 
FROM ingredients 
WHERE ingredientid 
NOT IN 
(SELECT ingredientid 
FROM ingredients 
WHERE vendorid = 
ANY 
(SELECT vendorid 
FROM vendors 
WHERE companyname = 'Veggies_R_Us' 
OR companyname = 'Spring Water Supply'));

select name
from ingredients
where unitprice >= ALL
(SELECT unitprice
from ingredients ing join madewith mw
on mw.ingredientid = ing.ingredientid JOIN
items i on mw.itemid = i.itemid
where i.name LIKE '%Salad');

SELECT name FROM ingredients 
WHERE ingredientid NOT IN 
(SELECT ingredientid 
FROM ingredients 
WHERE vendorid = ANY 
(SELECT vendorid 
FROM vendors 
WHERE companyname = 'Veggies_R_Us' 
OR companyname = 'Spring Water Supply'));

# wrong query
SELECT * FROM items
WHERE price >= ALL
(SELECT price FROM items);
#correction
select * from items
where price >= ALL
(select price from items where price is not NULL);

# check
select * from items
where price >= ALL
(select max(price) from items);

select * from items
where price >=
(select max(price) from items);

use sakila;

select * from customer
where not exists
(select * from payment
where payment.customer_id = customer.customer_id);

select * from customer
where exists
(select * from payment
where payment.customer_id = customer.customer_id);

SELECT i.name, companyname 
FROM items i, vendors v 
WHERE 
(
    SELECT COUNT(DISTINCT m.ingredientid) 
	-- number of ingredients in item 
	FROM madewith m WHERE i.itemid = m.itemid
) = 
-- number of ingredients in item supplied by vendor 
(
	SELECT COUNT(DISTINCT m.ingredientid) 
	FROM madewith m, ingredients n 
	-- vendor v ?
	WHERE i.itemid = m.itemid 
	AND m.ingredientid = n.ingredientid 
	AND n.vendorid = v.vendorid
);

SELECT name, companyname FROM items i, vendors v 
WHERE 
-- number of ingredients in item supplied by vendor 
(SELECT COUNT(DISTINCT m.ingredientid) 
FROM madewith m, ingredients ing 
WHERE i.itemid = m.itemid 
AND m.ingredientid = ing.ingredientid 
AND ing.vendorid = v.vendorid) = 
(SELECT COUNT(DISTINCT ing.ingredientid) 
-- number of ingredients supplied by vendor 
FROM ingredients ing WHERE ing.vendorid = v.vendorid);

use university1;

select student.name from university1.student
where (select count(*) from takes
where student.ID = takes.ID)<10;

use sakila;

select * from sakila.customer
where not exists
(select * from sakila.payment
where payment.customer_id = customer.customer_id);

use university1;

select instructor.ID, instructor.name, instructor.salary, 
(select avg(instructor.salary) from university1.instructor) 
 'AvgSalary', (select avg(instructor.salary)
 from university1.instructor)-instructor.salary 
 as 'Diff Salary' 
 from university1.instructor;
 
 select instructor.ID, instructor.name, 
 instructor.dept_name, instructor.salary, DeptAvgSal.AvgSal 
 from university1.instructor, 
 (select instructor.dept_name, 
 avg(instructor.salary) as 'AvgSal' 
 from university1.instructor 
 group by instructor.dept_name) DeptAvgSal 
 where DeptAvgSal.dept_name = instructor.dept_name;

select instructor.id, instructor.name, instructor.dept_name, 
instructor.salary, teaches.course_id 
from university1.instructor, university1.teaches 
where instructor.id = teaches.id 
having instructor.salary > 
(select avg(instructor.salary) from university1.instructor);

# QUESTIONS
use employee;
-- 1

select employees.firstname, employees.lastname
from employees
where employees.deptcode = 
(select code from departments 
where departments.name = 'Consulting');

-- 2

select e.firstname, e.lastname
from employees as e
where e.deptcode = 
(select code from departments 
where departments.name = 'Consulting')
and e.employeeid IN 
(select workson.employeeid 
from workson
where workson.assignedtime > 
(select 0.2*SUM(assignedtime) from workson)
and projectid = 'ADT4MFIA' and e.employeeid = workson.employeeid
group by workson.employeeid);

SELECT e.firstname, e.lastname
FROM employees AS e
WHERE e.deptcode = (
    SELECT code 
    FROM departments 
    WHERE name = 'Consulting'
)
AND e.employeeid IN (
    SELECT w.employeeid 
    FROM workson AS w
    WHERE w.assignedtime > (
        SELECT 0.2 * SUM(w2.assignedtime) 
        FROM workson AS w2 
        WHERE w2.projectid = 'ADT4MFIA' and e.employeeid = w2.employeeid
        GROUP BY w2.employeeid
    )
    AND w.projectid = 'ADT4MFIA'
    GROUP BY w.employeeid
);

-- 3
select emp.firstname, emp.lastname, 
(
	select sum(w.assignedtime)
	from workson as w
	where w.employeeid = emp.employeeid
)/
(	
	select sum(workson.assignedtime)
	from workson
) as percentage_of_time
from employees as emp
where employeeid = 
(
	select e.employeeid 
	from employees as e
	where firstname = 'Abe'
	and lastname = 'advice'
);

-- 4
select d.name from departments as d
where not exists 
(
	select * from projects as p
    where p.deptcode = d.code
);

-- 5
select e.firstname, e.lastname, e.salary 
from employees as e
where e.salary >
(
	select avg(emp.salary) from employees as emp
	group by emp.deptcode
    having emp.deptcode = "ACCNT"
);

-- 6
select p.projectid, p.description, 
(
	select w1.assignedtime from workson as w1
    where w1.employeeid = w3.employeeid and w1.projectid = p.projectid
)
/
(
	select sum(w2.assignedtime) from workson as w2
	where w3.employeeid = w2.employeeid
	group by w2.employeeid
) as time_spent
from projects as p
join workson as w3 on w3.projectid = p.projectid
having time_spent > 0.7;

SELECT p.projectid, p.description, w.employeeid, 
    w.assignedtime, 
    (w.assignedtime / 
        (SELECT SUM(w2.assignedtime) 
         FROM workson w2 
         WHERE w2.employeeid = w.employeeid)
    ) AS time_percent
FROM projects p
JOIN workson w ON p.projectid = w.projectid
HAVING time_percent > 0.7;

-- 7
select e.firstname, e.lastname, e.salary from employees as e
where e.salary >
ANY
(
	select e1.salary from employees as e1
    where e1.deptcode = "ACCNT"
);

-- 8
select MIN(e.salary) from employees as e
where e.salary >
ALL
(
	select e1.salary from employees as e1
    where e1.deptcode = "ACCNT"
);

-- 9
select e1.firstname, e1.lastname from employees as e1
where e1.deptcode = "ACCNT"
and e1.salary = (select MAX(salary) from employees as e2 where e2.deptcode = "ACCNT");

-- 10
use employee;
select e1.employeeid, w.assignedtime 
from employees as e1
join workson as w on e1.employeeid = w.employeeid
join projects as p on p.projectid = w.projectid
where e1.deptcode = "ACCNT"
and w.assignedtime > 0.5*
(
	select SUM(w1.assignedtime) 
    from workson as w1 
    where w1.employeeid = e1.employeeid
    and p.deptcode <> "ACCNT"
    group by w1.employeeid
)
order by w.assignedtime;

-- 11
SELECT d.code, d.name
FROM departments d
JOIN employees e ON d.code = e.deptcode
JOIN workson w ON e.employeeid = w.employeeid
JOIN projects p ON w.projectid = p.projectid AND p.deptcode = d.code
GROUP BY d.code, d.name
HAVING COUNT(DISTINCT e.employeeid) = (
    SELECT COUNT(*)
    FROM employees
    WHERE deptcode = d.code
) 
AND COUNT(DISTINCT w.projectid) = (
    SELECT COUNT(*)
    FROM projects
    WHERE deptcode = d.code
);

SELECT d.code, d.name
FROM departments d
JOIN employees e ON d.code = e.deptcode
WHERE NOT EXISTS (
    SELECT p.projectid
    FROM projects p
    WHERE p.deptcode = d.code
    AND NOT EXISTS (
        SELECT 1
        FROM workson w
        WHERE w.employeeid = e.employeeid
        AND w.projectid = p.projectid
    )
)
GROUP BY d.code, d.name;

-- avoiding departments with no projects
SELECT d.name
FROM departments d
JOIN employees e ON d.code = e.deptcode
WHERE EXISTS (
    SELECT 1
    FROM projects p
    WHERE p.deptcode = d.code
)
AND NOT EXISTS (
    SELECT p.projectid
    FROM projects p
    WHERE p.deptcode = d.code
    AND NOT EXISTS (
        SELECT *
        FROM workson w
        WHERE w.employeeid = e.employeeid
        AND w.projectid = p.projectid
    )
);
use employee;
-- 12a
select e.firstname, e.lastname from employees as e
where e.deptcode = "CNSLT";

-- 12b
select e.firstname, e.lastname from employees as e
where e.deptcode = "HDWRE"
and e.employeeid in 
(
	select w1.employeeid from workson as w1
    where w1.projectid = "ROBOSPSE"
    and w1.assignedtime > 0.2 *
    (
		select SUM(w2.assignedtime) from workson as w2 
		where w2.employeeid = w1.employeeid
    )
);

select * from projects
inner join workson on projects.projectid = workson.projectid
inner join employees on employees.employeeid = workson.employeeid;

-- 12c
select e.firstname, e.lastname, e.salary 
from employees as e
where e.salary >
(
	select avg(emp.salary) from employees as emp
	group by emp.deptcode
    having emp.deptcode = "ACCNT"
);

-- 12d
select p.projectid, p.description, 
(
	select w1.assignedtime from workson as w1
    where w1.employeeid = w3.employeeid and w1.projectid = p.projectid
)
/
(
	select sum(w2.assignedtime) from workson as w2
	where w3.employeeid = w2.employeeid
	group by w2.employeeid
) as time_spent
from projects as p
join workson as w3 on w3.projectid = p.projectid
having time_spent > 0.5;

-- 12e
select * from departments as d
where not exists
(
	select 1 from projects as p
    where d.code = p.deptcode
);

-- 12f
select e.firstname, e.lastname, e.salary from employees as e
where e.salary >
ANY
(
	select e1.salary from employees as e1
    where e1.deptcode = "ACCNT"
);

-- 12g
select e.firstname, e.lastname, e.salary from employees as e
where e.salary >
ALL
(
	select e1.salary from employees as e1
    where e1.deptcode = "ACCNT"
);

-- 12h
select e1.firstname, e1.lastname from employees as e1
where e1.deptcode = "CNSLT"
and e1.salary = (select MAX(salary) from employees as e2 where e2.deptcode = "CNSLT");

select * from employees;