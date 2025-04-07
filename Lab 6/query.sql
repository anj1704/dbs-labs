use restaurant;

START transaction;
select * from restaurant.items;
update items
set price = price * 2
where items.itemid = 'CHKSD';
select * from restaurant.items;
rollback;
select * from restaurant.items;

START TRANSACTION;
SELECT * FROM `restaurant`.`items`;
update items
set price = price *2
where items.itemid = 'CHKSD';
SELECT * FROM `restaurant`.`items`;
commit;
rollback;
SELECT * FROM restaurant.items;

START TRANSACTION;
SELECT * FROM `restaurant`.`items`;
update items
set price = price *0.5
where items.itemid = 'CHKSD';
SELECT * FROM `restaurant`.`items`;
ROLLBACK;
SELECT * FROM `restaurant`.`items`;
update items
set price = price *2
where items.itemid = 'CHKSD';
SELECT * FROM `restaurant`.`items`;
ROLLBACK;
SELECT * FROM `restaurant`.`items`;

START TRANSACTION;
SELECT * FROM `restaurant`.`items`;
update items
set price = price *0.5
where items.itemid = 'CHKSD';
savepoint point1;
SELECT * FROM `restaurant`.`items`;
update items
set price = price *2
where items.itemid = 'CHKSD';
SELECT * FROM `restaurant`.`items`;
savepoint point2;
SELECT * FROM `restaurant`.`items`;
rollback to savepoint point1;
SELECT * FROM `restaurant`.`items`;
commit;
SELECT * FROM `restaurant`.`items`;
rollback to savepoint point1;
SELECT * FROM `restaurant`.`items`;