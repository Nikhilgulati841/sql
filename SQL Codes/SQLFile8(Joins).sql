--inner Joins

create table Employee(
[employee id] int not null,
[employee name] varchar(20) not null,
[Division] varchar(10) not null,
salary int not null
)

create table empDetails (
EMPID int not null,
city varchar(20) not null,
state varchar(20) not null
)



use sampledata
update empdetails
set empid=
case 
when city='San diego' then 1
when city='oceanside' then 1
when city='new york city' then 2
when city='Miami' then 3
when city='orlando' then 3
when city='tampa' then 6
else empid
end


use sampledata
select * from employee
select * from empDetails

--e1 & e2 are table (alias|naming the table) helpful for readability purpose
select e1.[employee id], e1.[employee name],e2.city,e2.state,e1.salary
from employee e1
left join empdetails e2 on e1.[employee id]=e2.empid


--way to pull all the columns from one table and then specify some columns from another table without writing all the columns name from 1st table 
select e1.*,e2.city,e2.state from employee e1
full join empdetails e2
on e1.[employee id]=e2.empid


select * from orders
select * from returns


create schema excel
--to transfer all the data from one table to a new table which is not created 
select * 
into excel.orderinfo
from orders

select * from orders
select * from returns

--only these order it's were returned with all of it's details
select * from returns t1 inner join orders t2
on t1.[Order ID]=t2.[Order ID]

select substring(t1.[order id],1,2),count(t1.[order id]) from returns t1 inner join orders t2
on t1.[Order ID]=t2.[Order ID]
group by substring(t1.[order id],1,2)

--second way without (alias)
select * from returns inner join orders
on
returns.[order id]=orders.[Order ID]


--left joins

use sampledata
select * from employee
select * from empDetails

select e.[employee id],e.[employee name],e.Division,e.salary,ed.city,ed.state from employee e left join empDetails ed
on e.[employee id]=ed.EMPID

--same as inner join, but without using inner join and with using subqueries
select * from(
select * from employee e left join empDetails ed
on e.[employee id]=ed.EMPID) as t
where EMPID is not null

select * from orders

--from the orderes table, wanted to know what all orders are returned and what are not.
use SelectClause
select r.Returned, o.[Order ID],o.[Product ID],o.[Product Name],o.Category,o.[Sub-Category],o.Sales from orders o left join returns r
on o.[Order ID]=r.[Order ID]

--among the above view, wanted to know an information from the order id that
--as seen starting two char of [order id] shows the country information
--so, [order id] are different for every row unless not repeated
--so, curated|substring the 1st 2 char from orders, get it's count, how many times it comes and which one is the most
-- that shows which country has, the returned order id the most, by adding the conditions for returned cases only
with cte as(
select r.Returned, o.[Order ID],o.[Product ID],o.[Product Name],o.Category,o.[Sub-Category],o.Sales from orders o left join returns r
on o.[Order ID]=r.[Order ID]
)
select substring([order id],1,2), count(*) from cte
where Returned is not null
group by substring([order id],1,2)


--same type of result, but with using like and specifically for CA
with cte as(
select r.Returned, o.[Order ID],o.[Product ID],o.[Product Name],o.Category,o.[Sub-Category],o.Sales from orders o left join returns r
on o.[Order ID]=r.[Order ID]
)
select count(*) as country from cte
where returned is not null and [order id] like 'CA%'


--right join, either write right join or change the order of table before and after writing (left join)
use sampledata
select * from employee
select * from empDetails

select ed.EMPID,e.[employee id],e.[employee name],e.Division,e.salary,ed.city,ed.state
from empdetails ed left join employee e
on e.[employee id]=ed.EMPID

select * into employee_manager
from employee

update employee_manager
set [manager id]=
case 
when [employee id]=1 then 2
when [employee id]=2 then 4
when [employee id]=3 then 1
when [employee id]=4 then 3
end

alter table employee_manager
alter column [manager id] int not null

select e1.[employee name] as Employee,e2.[employee name] as Manager from employee_manager e1
join employee_manager e2
on e1.[manager id]=e2.[employee id]
where e1.salary>e2.salary

select * from employee_manager
--way to find the name of each employees manager from within the table | SELF JOIN
select e1.[employee name] as "Employee name", e2.[employee name] as "Manager name"
from employee_manager e1
inner join employee_manager e2
on e1.[manager id]=e2.[employee id]
order by e1.[employee id]
--way to find the sub-ordinates of each manager on the left from within the table 
--[just the logic is reversed and due to which the aliases are misleading] | SELF JOIN
select e1.[employee name] as "Manager name", e2.[employee name] as "Employee name"
from employee_manager e1
inner join employee_manager e2
on e1.[employee id]=e2.[manager id]

select * from employee_manager


--CROSS JOIN

create table colors(
color varchar(20) not null
)

create table size(
size varchar(20) not null
)

select * from colors
select * from size

select * from 
size cross join colors