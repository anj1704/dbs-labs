use sakila;
-- ALWAYS put a space between delimiter and ; in the end
select customer.customer_id, customer.first_name, customer.last_name 
from sakila.customer;

DELIMITER $$ 
CREATE PROCEDURE GetCustomers() 
BEGIN  
select customer.customer_id, customer.first_name, customer.last_name  
from sakila.customer;     
END$$ 
DELIMITER ;

CALL GetCustomers();

DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` PROCEDURE GetCustomers1()     
	READS SQL DATA     
	DETERMINISTIC     
	SQL SECURITY INVOKER     
	COMMENT 'Stored procedure example' 
BEGIN 
	select customer.customer_id, customer.first_name,
    customer.last_name   
    from sakila.customer;     
END$$ 
DELIMITER ; 

CALL GetCustomers1();

DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` 
PROCEDURE `list_semester`(IN sem_name VARCHAR(10))     
	READS SQL DATA     
	DETERMINISTIC     
	SQL SECURITY INVOKER     
    COMMENT 'Semester wise list of student, Input - Semester name and Output – Student count' 
BEGIN 
	select student.name 
    from university1.student 
    where student.ID IN  
		(select takes.id 
         from university1.takes 
		 where takes.semester = sem_name);     
END$$
DELIMITER ;

call list_semester('spring');

select student.name 
    from university1.student 
    where student.ID IN  
		(select takes.id 
         from university1.takes 
		 where takes.semester = 'spring'); 

DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` 
PROCEDURE `list_semester_and_count`(IN sem_name VARCHAR(10), out student_count int)     
	READS SQL DATA     
    DETERMINISTIC     
    SQL SECURITY INVOKER     
    COMMENT 'Semester wise list of student, Input - Semester name.' 
BEGIN 
	select student.name 
    from university1.student 
    where student.ID IN  
		(select takes.id 
         from university1.takes 
         where takes.semester = sem_name);      
	select count(student.name) 
    into student_count 
    from university1.student 
    where student.ID IN  
		(select takes.id 
         from university1.takes 
          where takes.semester = sem_name); 
	END$$
DELIMITER ;

call list_semester_and_count('Spring', @st_count);
select @st_count;

DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` 
PROCEDURE `SetCounter`( INOUT counter INT,     IN inc INT )     
	DETERMINISTIC
	SQL SECURITY INVOKER
    COMMENT 'INOUT EXAMPLE.'
BEGIN
	SET counter = counter + inc;
END $$
DELIMITER ;

set @counter = 1;
CALL SetCounter(@counter, 1);
CALL SetCounter(@counter, 1);
CALL SetCounter(@counter, 5);
select @counter;

DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` 
FUNCTION `overdue`(return_date DATE) 
RETURNS varchar(3) 
	CHARSET utf8mb4     
	DETERMINISTIC 
BEGIN      
	DECLARE sf_value VARCHAR(3);
		IF curdate() > return_date             
			THEN SET sf_value = 'Yes';         
		ELSEIF  curdate() <= return_date             
			THEN SET sf_value = 'No';         
		END IF;      
	RETURN sf_value;     
END$$ 
DELIMITER ;  

DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` 
FUNCTION `count_days`(return_date DATE) 
RETURNS int     
	DETERMINISTIC 
begin  
	declare days INT;         
		IF curdate() > return_date             
			THEN SET days = DATEDIFF(curdate(), return_date);         
		ELSEIF  curdate() <= return_date             
			THEN SET days = 0;         
		END IF;         
	return days; 
end$$ 
DELIMITER ;

select rental.customer_id, rental.rental_date, rental.return_date, 
	curdate(), overdue (rental.return_date) as 'IS OVERDUE?',
	count_days(rental.return_date) as 'NO. DAYS'
from sakila.rental;

DELIMITER $$
CREATE PROCEDURE low_price()
BEGIN
	DECLARE done INT DEFAULT FALSE;
    DECLARE a CHAR(16);
    DECLARE b, c INT;
	DECLARE cur1 CURSOR FOR SELECT item, price FROM t1;   
	DECLARE cur2 CURSOR FOR SELECT price FROM t2;   
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 
    -- if condition after handler is true
    -- execute the statement
    -- perform the handler action after the statement is done
	OPEN cur1;   
	OPEN cur2;
	read_loop: LOOP     
		FETCH cur1 INTO a, b;     
		FETCH cur2 INTO c;     
		IF done THEN       
			LEAVE read_loop;     
		END IF;     
		IF b < c THEN       
			INSERT INTO t3 VALUES (a,b);     
		ELSE       
			INSERT INTO t3 VALUES (a,c);     
		END IF;   
	END LOOP;
    CLOSE cur1;   
    CLOSE cur2; 
END$$
DELIMITER ;

 
DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` 
FUNCTION `inventory_in_stock`(p_inventory_id INT) 
RETURNS tinyint(1)     
	READS SQL DATA 
BEGIN     
	DECLARE v_rentals INT;     
    DECLARE v_out     INT;  
    #AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE     #FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED  
    SELECT COUNT(*) INTO v_rentals     
    FROM rental     
    WHERE inventory_id = p_inventory_id;  
    IF v_rentals = 0 THEN       
		RETURN TRUE;     
	END IF; 
	  SELECT COUNT(rental_id) INTO v_out     FROM inventory LEFT JOIN rental USING(inventory_id)     WHERE inventory.inventory_id = p_inventory_id     AND rental.return_date IS NULL;  
    IF v_out > 0 THEN       
		RETURN FALSE;     
	ELSE       
		RETURN TRUE;     
	END IF; 
END$$ 
DELIMITER ; 

DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` 
PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)     
	READS SQL DATA 
BEGIN      
	SELECT inventory_id      
    FROM inventory      
    WHERE film_id = p_film_id      
    AND store_id = p_store_id      
    AND inventory_in_stock(inventory_id);  
	SELECT FOUND_ROWS() INTO p_film_count; 
END$$ 
DELIMITER ; 
use sakila;
select * from inventory;

set @a = 0;
CALL film_in_stock(1, 1, @a);

select @a;
-- EXERCISES

-- q1

use university1;

DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` 
PROCEDURE `list_students_in_course`(IN sem_name VARCHAR(10), IN course_name VARCHAR(20))     
	READS SQL DATA     
	NOT DETERMINISTIC     
	SQL SECURITY INVOKER     
    COMMENT 'Semester wise list of student who have taken a certain course, Input - Semester name , Course name and Output – Student name' 
BEGIN 
	select student.name 
    from university1.student 
    where student.ID IN  
		(select takes.id 
         from university1.takes 
		 where takes.semester = sem_name)
	AND
    student.ID in
		(select takes.id
         from university1.takes, university1.course
         where course.title = course_name
         and course.course_ID = takes.course_ID)
	;     
END$$
DELIMITER ;

call list_students_in_course('spring', 'Manufacturing');

-- q2

use sakila;
show tables;
desc payment;
desc customer;
DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` 
PROCEDURE `customer_payed_by_staff_id`(IN staff_id int)     
	READS SQL DATA     
	NOT DETERMINISTIC     
	SQL SECURITY INVOKER     
    COMMENT 'All customer who did a payment with a staff ID, Input - staff ID, and Output – Customer ID, Customer name' 
BEGIN 
	select customer.first_name, customer.last_name, customer_id
    from sakila.customer
    where customer.customer_id IN  
		(select payment.customer_id 
         from sakila.payment
		 where payment.staff_id = staff_id)
	;     
END$$
DELIMITER ;
drop procedure customer_payed_by_staff_id;
call customer_payed_by_staff_id(1);

-- q3

use university1;

DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` 
PROCEDURE `avergae_plus_minus_amount`(IN amount int)     
	READS SQL DATA     
	NOT DETERMINISTIC     
	SQL SECURITY INVOKER     
    COMMENT 'Shows instructors names and salaries whose salary = av ± amount' 
BEGIN 
	select i.ID, i.name
    from instructor as i
    where i.salary 
    <= (select avg(i1.salary)+amount from instructor as i1)
    and i.salary >= (select avg(i1.salary)-amount from instructor as i1);
END$$
DELIMITER ;
select * from instructor;
drop procedure avergae_plus_minus_amount;
call avergae_plus_minus_amount(1000);

-- q4

use restaurant;

DELIMITER $$ 
CREATE DEFINER=`root`@`localhost` 
PROCEDURE `name_of_ingredients`(IN vendor varchar(20))     
	READS SQL DATA     
	NOT DETERMINISTIC     
	SQL SECURITY INVOKER     
    COMMENT 'Shows instructors names and salaries whose salary = av ± amount' 
BEGIN 
	select i.name from ingredients as i
    join vendors as v on v.vendorid = i.vendorid
    where v.vendorid like vendor;
END$$
DELIMITER ;
drop procedure name_of_ingredients;
select * from ingredients;
call name_of_ingredients('EDDRS');