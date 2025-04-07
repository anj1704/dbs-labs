use university1;
# 1a
select course_id, title 
from course
where dept_name = "Comp. Sci." AND credits = 3;
# 1b
-- select distinct s_ID
-- from advisor
-- where i_ID = (select ID  from instructor where name = "dale");

select ID 
from student 
where ID in 
(
	select ID 
    from takes 
    where course_id in 
    (
		select course_id 
        from teaches
        where ID = (select ID from instructor where name = "dale")
	)
);

-- OR

SELECT DISTINCT s.ID
FROM student s
JOIN takes t ON s.ID = t.ID
JOIN teaches te ON t.course_id = te.course_id
JOIN instructor i ON te.ID = i.ID
WHERE i.name = 'Dale';


# 1c
select salary
from instructor
where salary = (select MAX(salary) from instructor);

select MAX(salary) from instructor;

# 1d
select ID, name
from instructor
where salary = (select MAX(salary) from instructor);

# 2a
update instructor
set salary = (1.1*salary)
where dept_name = "Comp. Sci.";
# 2b
insert into instructor (ID, name, dept_name, salary) 
select ID, name, dept_name, 30000
from student
where tot_cred > 100;

select s.ID, t.ID, s.tot_cred, t.salary from student as s, instructor as t where s.ID = t.ID;
