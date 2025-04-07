use university1;

-- 1a
select DISTINCT name, ID from student
join takes as t using (ID)
join course as c on t.course_id = c.course_id
where c.dept_name = "Comp. Sci.";

select distinct stud.name, stud.ID from student as stud
join takes as course on stud.id = course.id 
where course_id in(select course_id from course where dept_name = 'Comp. Sci.');

-- 1b
-- first query is collapsing repeat entries
select name, ID from student
join takes as t using (ID)
group by ID, year
having year < 2017;

select distinct s.name, s.ID from student as s
join takes as t on s.ID = t.ID
where t.year < 2017
order by s.ID;

SELECT s.ID, s.name
FROM student s
WHERE NOT EXISTS (
    SELECT 1
    FROM takes t
    JOIN course c ON t.course_id = c.course_id
    WHERE t.ID = s.ID AND t.year > 2017
);

-- 1c
select dept_name, MAX(salary) as sal from department
join instructor as i using (dept_name)
group by dept_name
order by sal DESC;

-- 1d
SELECT dept_name, MIN(sal) AS min_sal
FROM (
    SELECT d.dept_name, MAX(i.salary) AS sal
    FROM department d
    JOIN instructor i ON d.dept_name = i.dept_name
    GROUP BY d.dept_name
) s
GROUP BY s.dept_name
HAVING min_sal =
(
    SELECT MIN(max_sal) AS min_max_sal
    FROM (
        SELECT MAX(salary) AS max_sal
        FROM instructor
        GROUP BY dept_name
    ) max_salaries
)
ORDER BY min_sal;

-- wrong
select dept_name, MIN(sal) OVER (order by dept_name) as min_sal
FROM (
    SELECT d.dept_name, MAX(i.salary) AS sal
    FROM department d
    JOIN instructor i ON d.dept_name = i.dept_name
    GROUP BY d.dept_name
) s
HAVING min_sal =
(
    SELECT MIN(max_sal) AS min_max_sal
    FROM (
        SELECT MAX(salary) AS max_sal
        FROM instructor
        GROUP BY dept_name
    ) max_salaries
)
ORDER BY min_sal;

SELECT MIN(sal) AS min_sal
FROM (
    SELECT d.dept_name, MAX(i.salary) AS sal
    FROM department d
    JOIN instructor i ON d.dept_name = i.dept_name
    GROUP BY d.dept_name
) s;

-- 2a
insert into course values ('CS-001', "Weekly Seminar", "Comp. Sci.", 2);

-- 2b
insert into section (course_id, sec_id, semester, year) values ('CS-001', 1, "Fall", 2017);

-- 2c
INSERT INTO takes (ID, course_id, sec_ID, semester, year)
SELECT s.ID, 'CS-001', 1, 'Fall', 2017
FROM student s
JOIN department d ON s.dept_name = d.dept_name
WHERE d.dept_name = 'Comp. Sci.';

-- 2d
DELETE FROM takes
WHERE course_id = 'CS-001' AND sec_id = 1 AND semester = 'Fall' AND year = 2017 AND ID = 12345;

-- 2e
-- leaves unlinked values in section
delete from course where course_id = 'CS-001';
select * from section where course_id = 'CS-001';
delete from section where course_id = 'CS-001';

-- 2f
delete from takes where course_id in 
(
	select course_id 
    from course
    where UPPER(title) LIKE "%GEOLOGY%"
);

-- ADDITIONAL

create table grade_points (
	grade VARCHAR(2),
    point FLOAT(2,1) CHECK (point>=0 AND point <= 4),
    PRIMARY KEY(grade)
);

insert into grade_points values
("A+", 4), ("A", 3.7), ("A-", 3.3), ("B+", 3), ("B", 2.7), ("B-", 2.3), ("C+", 2), ("C", 1.7), ("C-", 1.3);

-- 1a
select s.ID, SUM(gp.point * c.credits)
from student as s
join takes as t on s.ID = t.ID
join course as c on c.course_id = t.course_id
join grade_points as gp on gp.grade = t.grade
group by s.ID;

SELECT SUM(gp.points * c.credits) AS total_grade_points
FROM takes t
JOIN course c ON t.course_id = c.course_id
JOIN grade_points gp ON t.grade = gp.grade
WHERE t.ID = '12345';

-- 1b use the where clause, 1c use the group by clause
select s.ID, SUM(gp.point * c.credits)/s.tot_cred as GPA
from student as s
join takes as t on s.ID = t.ID
join course as c on c.course_id = t.course_id
join grade_points as gp on gp.grade = t.grade
-- where s.ID = 1000;
group by s.ID;

SELECT t.id, SUM(gp.point * c.credits) / SUM(c.credits) AS gpa
FROM takes t
JOIN course c ON t.course_id = c.course_id
JOIN grade_points gp ON t.grade = gp.grade
group by t.ID;
-- WHERE t.ID = '12345';

-- difference in sum of credit course by course and tot_cred
select s.ID, s.tot_cred, SUM(c.credits)
from student as s
join takes as t on s.ID = t.ID
join course as c on c.course_id = t.course_id
group by s.ID;

-- if grades can be null, don't count it in GPA
SELECT t.ID, 
       SUM(CASE WHEN t.grade IS NOT NULL THEN gp.point * c.credits ELSE 0 END) / 
       SUM(CASE WHEN t.grade IS NOT NULL THEN c.credits ELSE 0 END) AS gpa
FROM takes t
JOIN course c ON t.course_id = c.course_id
LEFT JOIN grade_points gp ON t.grade = gp.grade
GROUP BY t.ID;


