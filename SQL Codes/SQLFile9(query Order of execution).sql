--Query order of execution

create table state_employees(
empid int identity(100,1) not null,
salary int not null,
state varchar(20) not null
)

select * from state_employees

select top 1 state, count(*) as EmpCount
from state_employees
where salary>20000
group by state
order by EmpCount desc

/* Order Of Execution 1
from
join
where
group by
having
select
distinct
order by
top

*/

select top 2 o.Region, p.Person as "Regional Manager",count(*) as "Number of orders"
from orders o
left join people p
on o.Region=p.Region
where Segment='Consumer'
group by o.Region,p.Person
having count(*)>1000
order by [Number of orders] desc

select * from people























