
create schema business;
create table business.employees_table(
employee_id SERIAL primary key,
first_name VARCHAR(20),
last_name VARCHAR(20),
gender VARCHAR(15),
department VARCHAR(30),
hiredate Date ,
salary DECIMAL(12,2)
);
insert INTO business.employees_table(first_name,last_name,gender,department,hiredate,salary)
VALUES('John','Doe','Male','IT','2028-05-01',60000.00),
      ('Jane','Smith','Female','HR','2019-06-15',50000.00),
      ('Michael','Johnson','Male','Finance','2017-03-10',75000.00),
      ('Emily','Davis','Female','IT','2020-11-20',70000.00),
      ('Sarah','Brown','Female','Marketing','2016-07-30',45000.00),
      ('David','Wilson','Male','Sales','2019-01-05',55000.00),
      ('Chris','Taylor','Male','IT','2022-02-25',65000.00);


create table business.products(
product_id SERIAL primary key,
product_name varchar(20),
category varchar(25),
price decimal(5,2),
stock int
);
insert into business.products (product_name,category,price,stock)
values('Desk','Furniture',300.00,50),
('Chair','Furniture',150.00,200),
('Smartphone','Electronics',800.00,75),
('Monitor','Electronics',250.00,40),
('Bookshelf','Furniture',100.00,60),
('Printer','Electronics',200.00,25);

create table business.sales (
    sale_id SERIAL primary key,
    product_id SERIAL references business.products(product_id),
    employee_id SERIAL references business.employees_table(employee_id),
    sale_date date,
    quantity int,
    total decimal(10,2)
);
insert into business.sales (product_id, employee_id, sale_date, quantity, total)
values
( 1, 1, '2021-01-15', 2, 2400.00),
( 2, 2, '2021-03-22', 1, 300.00),
( 3, 3, '2021-05-10', 4, 600.00),
( 4, 4, '2021-07-18', 3, 2400.00),
( 5, 5, '2021-09-25', 2, 500.00),
( 6, 6, '2021-11-30', 1, 100.00),
( 7, 1, '2022-02-15', 1, 200.00),
( 1, 2, '2022-04-10', 1, 1200.00),
( 2, 3, '2022-06-20', 2, 600.00),
( 3, 4, '2022-08-05', 3, 450.00),
( 4, 5, '2022-10-11', 1, 800.00),
( 5, 6, '2022-12-29', 4, 1000.00);

--1. Select all columns from the Employees table. 
select * 
from business.employees_table et;

--2. Select the first names of all employees. 
select et.first_name 
from business.employees_table et ;

--3. Select distinct departments from the Employees table. 
select distinct et.department
from business.employees_table et ;

--4. Select the total number of employees. 
select count(*) 
from business.employees_table;

--5.Select the total salary paid to all employees. 
select sum(salary) 
from business.employees_table;

--6. Select the average salary of all employees.
select avg(salary) 
from  business.employees_table;

--7. Select the highest salary in the Employees table. 
select max(salary) as maximumsalary 
from business.employees_table;

--8. Select the lowest salary in the Employees table. 
select min(salary) as  minimumsalary
from business.employees_table;

--9. Select the total number of male employees. 
select count(*)
from business.employees_table
where gender = 'Male';

--10. Select the total number of female employees. 
select count(*) 
from business.employees_table 
where gender = 'Female';

--11. Select the total number of employees hired in the year 2020. 
select count(*) as total_employees_2020
from business.employees_table
where extract (year from hiredate) = 2020;

--12. Select the average salary of employees in the 'IT' department. 
select avg(salary) as avgsalary
from business.employees_table
where department = 'IT';

--13. Select the number of employees in each department. 
select department, count(*) as num_employees
from business.employees_table 
group by department;

--14. Select the total salary paid to employees in each department. 
select department, sum(salary) as total_salary
from business.employees_table 
group by department;

--15. Select the maximum salary in each department. 
select department, max(salary) as max_salary
from business.employees_table
group by department;

--16. Select the minimum salary in each department. 
select department, min(salary) as min_salary
from business.employees_table
group by department;

--17. Select the total number of employees, grouped by gender. 
select gender, count(*) as num_employees
from business.employees_table
group by gender;

--18. Select the average salary of employees, grouped by gender. 
select gender, avg(salary) as avg_salary
from business.employees_table
group by gender;

--19. Select the top 5 highest-paid employees. 
select *
from business.employees_table
order by salary desc
limit 5;

--20. Select the total number of unique first names in the Employees table. 
select count(distinct firstname) as unique_first_names
from business.employees_table ;


--21. Select all employees and their corresponding sales 
select et.*, s.*
from business.employees_table et
left join business.sales s
on et.employee_id = s.employee_id;


--22. Select the first 10 employees hired, ordered by their HireDate.
select *
from business.employees_table et 
order by hiredate asc
limit 10;


--23. Select the employees who have not made any sales. 
select et.*
from business.employees_table et
left join business.sales s
on et.employee_id = s.employee_id
where s.sale_id is null;

--24. Select the total number of sales made by each employee. 
select et.employee_id, et.firstname, et.lastname, count(s.sale_id) as total_sales
from business.employees_table et
left join business.sales s
on et.employee_id = s.employee_id
group by et.employee_id, et.firstname, et.lastname;


--25. Select the employee who made the highest total sales. 
select et.*
from business.employees_table et
join (
    select employee_id, sum(total) as total_sales
    from business.sales
    group by employee_id
    order by total_sales desc
    limit 1
) s on et.employee_id = s.employee_id;

--26. Select the average quantity of products sold by employees in each department. 
select et.department, avg(s.quantity) as avg_quantity
from business.employees_table et 
join business.sales s on et.employee_id = s.employee_id
group by et.department;


--27. Select the total sales made by each employee in the year 2021. 
select et.employee_id, et.firstname, et.lastname, sum(s.total) as total_sales_2021
from business.employees_table et  
join business.sales s on et.employee_id = s.employee_id
where extract (YEAR from s.sale_date) = 2021
group by et.employee_id, et.firstname, et.lastname;


--28. Select the top 3 employees with the most sales in terms of quantity. 
select et.employee_id, et.firstname, et.lastname, sum(s.quantity) as total_quantity
from business.employees_table et 
join business.sales s on et.employee_id = s.employee_id
group by et.employee_id, et.firstname, et.lastname
order by total_quantity desc
limit 3;

--29. Select the total quantity of products sold by each department.
select et.department, sum(s.quantity) as total_quantity
from business.employees_table et 
join business.sales s on et.employee_id = s.employee_id
group by et.department;


--30. Select the total revenue generated by sales of products in each category.
select p.category, sum(s.total) as total_revenue
from business.sales s
join business.products p on s.product_id = p.product_id
group by p.category;






