-- 1

select p.productVendor, SUM(o.quantityOrdered * o.priceEach - p.buyprice) as sales_margin
from products as p
join orderdetails as o
group by p.productvendor
order by sales_margin DESC
limit 5;

-- 2a

select 
	e.employeeID, e.firstName, e.lastName, e.jobTitle, e.reportsTo,  
	e1.employeeID, e1.firstName, e1.lastName, e1.jobTitle
from employees as e
join employees as e1 on e.reportsTo = e1.employeeID;

-- 2b

select * 
from employees as e
where e.employeeID NOT IN 
(select e1.reportsTo from employees as e1);

-- 2c

select * 
from employees as e
where e.jobTitle  LIKE ("","","");

-- 3a

SELECT c.customerName, COUNT(DISTINCT p.type) AS num_product_types
FROM orders o
JOIN orderdetails od ON o.orderID = od.orderID
JOIN products p ON od.productCode = p.productCode
JOIN customers c ON o.customerID = c.customerID
GROUP BY c.customerName, o.orderNumber
ORDER BY num_product_types DESC
LIMIT 1;

-- 3b

SELECT c.customerName, COUNT(p.type) AS num_product_types
FROM orders o
JOIN orderdetails od ON o.orderID = od.orderID
JOIN products p ON od.productCode = p.productCode
JOIN customers c ON o.customerID = c.customerID
GROUP BY c.customerName
ORDER BY num_product_types DESC
LIMIT 1;

-- 3c

select c.customerID, c.customerName, SUM(p.amount) as amount
from customer c
join payment p on p.customerID = c.customerID
where c.amount > 
(
	select p1.amount/count(o1.orderID) as av
	from 
