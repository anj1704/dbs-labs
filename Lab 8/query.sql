use restaurant;
show tables;

DELIMITER //
CREATE TRIGGER add_gst BEFORE INSERT ON orders
FOR EACH ROW
	BEGIN
		SET NEW.price = NEW.price*1.18;
        END //
DELIMITER ;

create database test;
use test;

create table test1(a1 INT);
create table test2(a2 INT);
create table test3(a3 INT not null auto_increment primary key);
create table test4(
	a4 INT not null auto_increment primary key,
    b4 int default 0
);

delimiter |
create trigger testref before insert on test1
	for each row
    begin
    insert into test2 set a2 = new.a1;
    delete from test3 where a3 = new.a1;
    update test4 set b4 = b4 + 1 where a4 = new.a1;
	end;
|
delimiter ;

insert into test3 (a3) values
	(NULL), (NULL), (NULL), (NULL), (NULL), (NULL),
    (NULL), (NULL), (NULL), (NULL);
    
insert into test4 (a4) values
	(0), (0), (0), (0), (0), (0), (0), (0), (0), (0);
    
insert into test1 values 
	(1), (3), (1), (7), (1), (8), (4), (4);
    
select * from test1;
select * from test2;
select * from test3;
select * from test4;

drop trigger if exists test.testref;

use test;

create table t1(
	col1 varchar(20),
    col2 varchar(20),
    INDEX (col1, col2(10))
);

drop table t1;

create table t1 (col1 INT, col2 INT, index func_index ((ABS(col1))));
create index idx1 on t1 ((col1 + col2), (col1 = col2), col1);

alter table t1 add index ((col1 * 40) DESC);

create table customers (
	id BIGINT not null auto_increment primary key, modified 
    datetime default current_timestamp on update
    current_timestamp,
		custinfo JSON,
        INDEX zips( (CAST(custinfo->'$.zip' AS UNSIGNED ARRAY)) )
);

select * from customers;

alter table customers add index comp(id, modified,
(CAST(custinfo->'$.zipcode' AS UNSIGNED ARRAY)) );

insert into customers values
	(NULL, NOW(), '{"user":"Jack","user_id":37,"zipcode":[94582,94536]}'),
	(NULL, NOW(), '{"user":"Jill","user_id":22,"zipcode":[94568,94507,94582]}'),
    (NULL, NOW(), '{"user":"Bob","user_id":31,"zipcode":[94477,94507]}'),
    (NULL, NOW(), '{"user":"Mary","user_id":72,"zipcode":[94536]}'),
    (NULL, NOW(), '{"user":"Ted","user_id":56,"zipcode":[94507,94582]}');
    

select * from customers where 94507 MEMBER OF (custinfo->'$.zipcode');
select * from customers where JSON_CONTAINS(custinfo->'$.zipcode',
	CAST('[94507,94582]' as JSON));

-- q1
use sakila;
delimiter $$ 
create trigger toupper2 before insert on staff
for each row begin
declare f, l varchar(20);
declare cur1 cursor for select first_name from staff;
declare cur2 cursor for select last_name from staff;
open cur1;
open cur2;
fetch cur1 into f;
fetch cur2 into l;
set new.first_name = upper(f), new.last_name = upper(l);
close cur1;
close cur2;
end $$
delimiter ;

drop trigger toupper2;

insert into staff (staff_id, first_name, last_name, address_id, store_id, username) values (3, 'Jon', 'Hillyer', 5, 2, 'Jon');
select * from staff;

use employee;
show tables;
select * from employees;

delimiter $$
create trigger toupper3 before update on employees
for each row begin
declare f varchar(20);
declare l varchar(20);
declare cur1 cursor for select firstname from employees;
declare cur2 cursor for select lastname from employees;
open cur1;
open cur2;
fetch cur1 into f;
fetch cur2 into l;
set new.firstname = upper(new.firstname), new.lastname = upper(new.lastname);
close cur1;
close cur2;
end $$
delimiter ;

drop trigger toupper3;

update employees set salary = 50001 where employeeid = 3;

-- q2

show tables;
select * from instructor;
use university1;
describe instructor;

delimiter $$ 
create trigger limit_salary before update on instructor
for each row begin
if new.salary > 50000 then
set new.salary = old.salary + 1;
end if;
end $$
delimiter ;
drop trigger limit_salary;
update instructor set salary = 60000 where instructor.id = '10076';
