select * from sys.objects where type='UQ'
select * from sys.default_constraints
select * from sys.check_constraints
select * from sys.key_constraints

--get the database name from the table name
select 
db_name() as CurrentDB,
OBJECT_SCHEMA_NAME(object_id) as CurrentSchema,
name as TableName
from sys.tables
where name='sales_company'



create table dept.deptdetails(
deptID int,
deptname varchar(20),
constraint pk_deptID primary key(deptID)
)

create table employee.employeedetails(
empID int,
empName varchar(20) check(empName like '[A-Z]%' collate latin1_general_bin),
salary int,
deptID int,
constraint fk_deptID foreign key (deptID)
references dept.deptdetails(deptID)
on delete cascade
on update cascade
)

sp_help 'employee.employeedetails'



use sales
select * from dept.deptdetails
select * from employee.employeedetails
select * from dept.newdeptdetails

create or alter trigger trg_delete_employee
on dept.deptdetails
after delete
as
begin
delete from employee.employeedetails where deptid in (select deptid from deleted)
end


select * from dept.newdeptdetails
drop trigger dept.trg_delete_employee

select * from india_data
select *, isnull(coalesce(firstname,lastname),'N\A') as [Name of the person] from india_data


select * from sales_info


--precisely correct
select format(EOMONTH(credit_date),'MM-yyyy') as dated,sum(salary) as [total month salary of all emp] from sales_info
group by format(EOMONTH(credit_date),'MM-yyyy')
order by dated
--only grouping the month irrespective of the year
select datename(month,EOMONTH(credit_date)) as dated ,sum(salary) as [total month salary of all emp] from sales_info
group by datename(month,EOMONTH(credit_date))

select [product name],count([product name]) as product_count
from days_info2
where number_of_days=(
select max(number_of_days) from days_info2)
group by [product name]
having count(*)>1
order by product_count desc


select * from employee order by salary desc

select * from employee
order by salary desc
offset 1 row
fetch next 1 rows only

select top 1 * from employee
where salary not in (
select top 1 salary from employee
order by salary desc
)
order by salary desc

select top 1 * from employee
where salary != (
select max(salary) from employee
)
order by salary desc

select top 1 * from (
select top 2 * from employee
order by salary desc
) as t
order by salary

select * from employee order by salary desc;

with cte as (
select *, DENSE_RANK() over(order by salary desc) as rnk from employee
)
select top 1 [employee id],[employee name],division,salary from cte
where rnk=2

--name of employees having more than 1 count in their divisions
select [employee id],[employee name],division from employee
where division in (select division from employee group by division having count(*)>1)
order by division

select * from employee order by salary desc;
--max salary from each department when salary are not unique
--correlated subquery
select [employee id],[employee name],division,salary,(select max(salary) from employee e2 where e2.division=e1.division) as max_salary_by_division from employee e1 

select *,
case 
when salary>(select avg(salary) from employee) then 'Above AVG. salary'
when salary<(select avg(salary) from employee) then 'Below AVG. salary'
else 'Equal to avg salary'
end as [status of salary]
from employee

--
select [customer name],string_agg(state,',') as All_States,count(*) as Total_States_count from
(
select [customer name],state from orders
group by [customer name],state  --having count(state)>1 here will give me all the states that were repeated and not the distinct count of states
) as t
group by [customer name]
having count(state)>1
order by Total_States_count desc

select [customer name],state,[product name],dense_rank() over(order by state) from orders where [customer name]='Eric Murdock' order by state
--
select * from employee e1 where salary>(select avg(salary) from employee e2 where e1.division=e2.division)

select division,avg(salary) from employee group by division




--stored procedures

select * from employee

create or alter procedure salary_app
@name varchar(20),
@increment decimal(10,2),
@choice varchar(20)
as
begin
	if lower(@choice) not like 'add%' and lower(@choice) not like 'sub%'
	begin
		print('The choosen option is not among - Add||Sub')
	end
	if @increment<5
	begin
		print'The increment should be at least 5%'
	end
	if @increment>=5
	begin
	
		declare @changes table
		(
		empname varchar(20),
		old_salary decimal(10,2),
		new_salary decimal(10,2),
		change_salary decimal(10,2)
		)

		update employee
		set salary=
		case 
		when LOWER(@choice) like 'add%' then salary+(salary*(@increment/100))
		when LOWER(@choice) like 'sub%' then salary-(salary*(@increment/100))
		end
		output
		inserted.[employee name],
		deleted.salary,
		inserted.salary,
		inserted.salary-deleted.salary
		into @changes
		where [employee name] like @name+'%'

		select empname,format(old_salary,'C','en-IN') as old_salary,format(new_salary,'C','en-IN') as new_salary,format(new_salary-old_salary,'C','en-IN') as cchange_salary from @changes

		declare @nam varchar(20)

		select @nam=string_agg([employee name],',') within group(order by [employee name])
		from employee
		where [employee name] like @name+'%'

		if lower(@choice) like 'add%'
		begin
			print('The salary has been increased for ['+@nam+'] by '+cast(@increment as varchar(10))+'%, the exact amount you can check in the CHNAGE TABLE')
		end
		if lower(@choice) like 'sub%'
		begin
			print('The salary has been decreased for ['+@nam+'] by '+cast(@increment as varchar(10))+'%, the exact amount you can check in the CHNAGE TABLE')
		end
		select [employee id],[employee name],division, format(salary,'C','en-In') as Salary_updated from employee order by salary desc
	end
end

exec salary_app 's',10,'add'

--using Output
create or alter procedure orders_info
@category varchar(20),
@region varchar(20),
@orderCount int output
as
begin

select @orderCount=count(*) from orders where category=@category and region=@region
select [order id],[order date],[customer id],[customer name],region,category
from orders where category=@category and region=@region
end

declare @count int
exec orders_info 'furniture','south', @count output
print('Total number of orders are '+cast(@count as varchar(10))+'Orders')

--using return
create or alter procedure orders_info2
@category varchar(20),
@region varchar(20)
as
begin

select [order id],[order date],[customer id],[customer name],region,category
from orders where category=@category and region=@region
declare @orderCount int
select @orderCount=count(*) from orders where category=@category and region=@region
return @orderCount
end

declare @count int
exec @Count=orders_info2 'furniture','south'
print('Total number of orders are '+cast(@count as varchar(10))+' Orders')

--now to find and print some parameters, we need to get the output
--above is the small version and below is the bigger version
--above only getting the @count out of it and the below is getting many things out of it.

create or alter procedure orders_parameter
@orderID varchar(20),
@customerID varchar(20) output,
@customerName varchar(20) output,
@sales float output,
@profit float output
as
begin
	if exists(select 1 from orders where [order id]=@orderID)
	begin
		select @orderID=[order ID],@customerID=[Customer ID],@customerName=[Customer Name],@sales=sum(sales),@profit=sum(profit)
		from orders where [order id]=@orderID group by [order ID],[Customer ID],[Customer Name]
		return 1
	end
	else
	begin
	return 0
	end
end

create or alter procedure orders_display
@orderID varchar(20)
as
begin
declare @customerID varchar(20)
declare @customerName varchar(20)
declare @sales float
declare @profit float
declare @returnValue int

exec @returnValue=orders_parameter @orderID,@customerID output,@customerName output,@sales output,@profit output
if @returnValue=1
begin
	print 'The order ID is '+@orderID
	print 'For the Customer ID: '+@customerID
	print 'For Customer Name: '+@customerName
	print 'Total sales revenue: '+cast(@sales as varchar(20))
	print 'Total profit out of it as: '+cast(@profit as varchar(20))
    select * from orders where [order id]=@orderID  --this part executes the main query unlike the above one
end
else
begin
print 'No orders Exists'
end
end


orders_display 'CA-2011-115812'

































