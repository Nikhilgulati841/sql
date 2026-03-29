--subqueries
select * from employee
--to find the second highest salary person data, using 1 subqueries, easiest logic, with order by
-- We name the subqueries with a variable when used under from
select top 1 * from (
select top 2 * from employee
order by salary desc
) as t
order by salary asc

--another way of doing it, using 1 subqueries with order by
--skipping the max salary and then sort DESC, will give second highest
select top 1 * from employee
where salary !=(
select max(salary) from employee
) order by salary desc

--2nd another way of doing it, using 2 subqueries WithouT order by
--skipping the max value and then WITHOUT Sorting, get the max among them which will indirectly be the second highest salary
select * from employee
where salary = (select max(salary) from employee where salary <> (
select max(salary) from employee
)
)

--as Top and offset cannot be used together, so.
--select top1 * from employee
select * from employee
order by salary desc
offset 1 rows
fetch next 1 rows only


--to find the employees name for divisons having more than 1 employee
select [employee name], Division from employee
where Division in (
    select division from employee
    group by Division
    having count(*)>1
    )




update_my_salary @name='s', @increment=10, @choice='addd'

--max salary from each department when salary are unique
select * from employee where salary in (
select max(salary) from employee
group by division
)
select * from employee
--when salary are not unique then , we will have to use the join to bget the unique of two

select * from employeedetails

select [employee id], [employee name], t1.Division, Salary
from employee t1
join (
select max(salary) as max_salary,division from employee
group by division
) t2
on t1.Salary=t2.max_salary and t1.division=t2.division

--display the employee name along with an additional column that shows 
--whether they earn more than the average sakary of all employees.
--case cannot be used after from, instead it is always used with select
--any additional column with all the other columns is showing either by naming all the columns and new columns simply with commas seperated ','
--or use *, Means, (everything and this also) like we normally use comma, for diff column names

select *, 
case
when salary> (select avg(salary) from employeedetails) then 'Above Avg. Salary'
else 'Below Avg. Salary'
end as [More or Less salary than Average]
from employeedetails


/*
Output $action, inserted.*,deleted.*;
use of merge 
merge table1_name as alias1
using table2_name as alias2
on alias1.column_name=alias2.column_name

when matched then update,delete,etc
when not matched by table1 then ....
when not matched by table2 then delete, ....
*/

--with CTE, get me the employee's name and salary>3000

select * from employeedetails;

with cte_emp_3000more ([First Name],[Last Name],salary)as (
select firstname,lastname,salary from employeedetails
where salary>3000
)

select * from cte_emp_3000more

--with CTE, where the sales are higher than the average sales across all regions

with cte_divisionTS as (
select region, cast(sum(sales) as int) as division_Tsales from orders
group by region
)
,cte_divisionAS as (
select avg(division_Tsales) as Avg_Dsales 
from cte_divisionTS
)

select t1.region,t1.division_Tsales,t2.Avg_Dsales,t1.division_Tsales-t2.Avg_Dsales as [How much more sale than AVG]
from cte_divisionTS t1
join cte_divisionAS t2
on t1.division_Tsales>t2.Avg_Dsales;


--Merge
select * from employee_salaryData
select * from new_salaryData

merge employee_salaryData as target
using new_salaryData as source
on target.empid=source.[emp ID]

when matched then 
update set target.salary=source.salary

when not matched by target then
insert values(source.[emp id],source.[first name],source.[last name],source.salary)

when not matched by source then
delete

output $action, inserted.*,deleted.*;


--SQL PROBLEM 1
--way 1 (mine)
select [customer name],string_agg(state,',') as [All States],count(*) as counts from (
select distinct [customer name], state from orders
) as t
group by [customer name]
having count(state)>1
order by counts desc


--way 2 (course)
select [customer name],string_agg(state,',') as [All States],count(*) as State_counts from (
select [customer name], state
from orders
group by [customer name], state  -- this group by does access all the states-[customer name] unique entries
) as t                           -- means this does not removes repeated customer names but gives only unique states name which were repeated earlier
group by [customer name]         -- then this group by access all the states under one unique customer name for each customer
having count(state)>1            --as string_agg function were already grouping states inside comma ','
order by State_counts desc


--SQL PROBLEM 2
--way 1 (mine) have done in 3 different categories or all the different available category possible in the orders table
select [customer ID],[customer name],count(*) from(
select [customer id],[customer name] from orders
group by [customer ID],[customer name],category
) as t
group by [customer id],[customer name]
having count(*)=3 -- or (select count(distinct category) from orders)

--way 2 (Course) have done orders in all the different available category possible in the orders table
select [customer name] from orders
group by [customer name]
having count(distinct category)=(select count(distinct category) from orders)


select sales,cast(avg(sales) over() as int) as avg_sales, avg(sales) over()-sales as difference from orders
--way to find the names who earn more salary than their departments AVG salary
select * from employee

--My way
select t1.[employee name], t1.Division, t1.salary from employee t1
join (
select avg(salary) as salary, Division from employee
group by Division
) as t2
on t1.salary>t2.salary and t1.Division=t2.Division

--course way
select * from employee e1
where salary>(
select avg(salary) from employee e2
where e2.division=e1.division  --comparison for individual division wise
)
--below are just the views
select avg(salary),division from employee
group by division

select *, (select avg(salary) from employee) as AvgSalary from employee
where salary>(
select avg(salary) from employee
)

--A new way to use a subquery inside a select with select as a new column
select *, (select avg(salary) from employee) as Avg_Salary from employee



select *, (select avg(salary) from employee e2 where e2.division=e1.division) as [Avg_Salary/Department]
from employee e1

select *, avg(salary) over(partition by division) as avg_salary_by_division from employee order by [employee id]

select *, avg(salary) over(partition by division) as [Avg_Salary/Department]
from employee

--newer testing way
use sampledata
select * from sales_data;

with cte as(
select [product name],
sum([sales amount]) as [Total product Sales],
count(*) as Count,
(select count(*) from sales_data) as TotalCount,
format((select sum([sales amount]) from sales_data),'C','en-IN') as [Total Amount],
(select avg([sales amount]) from sales_data) as AvgTotalSales,
(select avg([sales amount]) from sales_data t2 where t2.[product name]=t1.[product name]) as [Avg Category Sales],
cast(cast((sum([sales amount])*100.0/(select sum([sales amount]) from sales_data)) as decimal(10,2)) as varchar(20))+'%' as [Percentage%]
from sales_data t1 group by [product name]
)

select *, 
case 
when [total product sales]>AvgTotalSales then 'Above AVG'
when [total product sales]<AvgTotalSales then 'Below AVG'
else 'Equal To avg'
end as [Status of Sales]
from cte



--for different problem
with cte as (
select *,
cast([sales amount]*100.0/(select sum([sales amount]) from sales_data) as decimal(10,2)) as [Percentage% of Total]
from sales_Data
)
select *, sum([percentage% of Total]) over(order by [percentage% of Total] rows between unbounded preceding and current row) as [Running Percentage]
from cte


select sum([sales amount]) from sales_data
--check if this is updated to github or not

