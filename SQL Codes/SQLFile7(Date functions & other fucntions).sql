



select * from orders
--creating view for the difference in order and ship date
create view days_info as
select [order id], [order date], [ship date], DATEDIFF(day,[order date],[ship date]) as number_of_days from orders
--selecting all those orders and their information whose date diff is the max
select * from days_info where number_of_days = (select max(number_of_days) from days_info)
--now with all the columns and diff of the date also
select *, DATEDIFF(day,[order date],[ship date]) as number_of_days from orders

create view days_info2 as
select *, DATEDIFF(day,[order date],[ship date]) as number_of_days from orders order by number_of_days desc
--see the difference in the city having the late delivery
select distinct country, city, category, [sub-category], [product name] from days_info2 where number_of_days= (select max(number_of_days) from days_info2)
select distinct city from orders

--selecting those products name, which are mostly repeated more than 2 case,
--under the category of maximum delay between order date & ship date
select [product name], count([product name]) as product_count
from days_info2
where number_of_days=
(select max(number_of_days) from days_info2) 
group by [Product Name] having count(*)>=2 
order by product_count desc

-- count of number of different products from orderes
select count(*) from
(select distinct [product name] from days_info2) as t
--different way for the same counting of different products
select count(distinct [product name]) from days_info2



select * from orders
--difference between dates and weekday name.
create view view1 as
select *, DATEDIFF(day,[order date],[ship date]) as shipment_delay_days, DATENAME(weekday,[ship date]) as shipment_week from orders

-- two ways to print date time but with the timestamp or any other string inside the column cell itself
select replace(format(getdate(),'timestamp: yyyy-MM-dd hh:mm:ss'),substring(format(getdate(),'timestamp: yyyy-MM-dd hh:mm:ss'),1,charindex(':',format(getdate(),'timestamp: yyyy-MM-dd hh:mm:ss'))),'Timestamp: ') as timestamp
select 'Timestamp: ' + format(getdate(),'yyyy-MM-dd hh:mm:ss') as [date-time]

-- to get the data type of any temp information not even stored and just in select clause
select SQL_VARIANT_PROPERTY(
replace(format(getdate(),'timestamp: yyyy-MM-dd hh:mm:ss'),substring(format(getdate(),'timestamp: yyyy-MM-dd hh:mm:ss'),1,charindex(':',format(getdate(),'timestamp: yyyy-MM-dd hh:mm:ss'))),'Timestamp: ')
,'baseType') as data_type_name



select * from view1
--with CTE(comman table expression) to subquery, to compare aggregate function with aggregate function use cte, subquery, window function.
with cte as (
select [product name], count(*) as [product count] from view1 where shipment_delay_days=
(select max(shipment_delay_days) from view1)
group by [product name]
)

select '    '+[product name] as [Product: Max Repeated under max delayed],[product count] from cte 
where [product count]=(select max([product count]) from cte)

--Mathematical Function
select cast(round(4.567,2) as decimal(10,1)) --this because, round fnc round off the int but does not changes it's default decimal data type
--i.e. numeric(4,3) 4 digits with 3 decimal points
select ceiling(4.4)
select floor(4.4)
select cast(round(4.566678,1,0) as numeric(6,3))

--data conversion (cast|convert)
select * from EmployeeDetails

insert into EmployeeDetails values(100,'Nikhil','Gulati',20000,'2026-01-31')
select cast(empid as varchar(10))+'_'+firstname+'_'+lastname from EmployeeDetails
select convert(varchar(10),empid)+'_'+firstname+'_'+lastname from EmployeeDetails

select convert('mm-dd-yyyy hh:mm:ss',getdate()) --this is wrong
select convert(varchar(20),getdate(),108) --110 & 108 will give the above result 
select cast(getdate() AS varchar(20))

create view diff_ist_utc as
select cast(getdate() as varchar(20)) as [Indian Time], cast(GETUTCDATE() as varchar(20)) as [US Time]

select *, DATEDIFF(HOUR,[us time],[indian time]) as [hour gap],
cast(DATEDIFF(second,[indian time],[us time]) as decimal(10,3))/3600 as [Time gap] ,
DATEDIFF(SECOND,[indian time],[us time]) as [second gap]
from diff_ist_utc

select cast(cast(330 as decimal(5,2))/60 as numeric(3,2))

select SUBSTRING(
cast(cast(DATEDIFF(second,'Jan 31 2026  4:14PM','Jan 31 2026  10:45AM') as decimal(10,3))/3600 as varchar(20)),1,2)+':'+
select cast(SUBSTRING(
cast(cast(DATEDIFF(second,'Jan 31 2026  4:14PM','Jan 31 2026  10:45AM') as decimal(10,3))/3600 as varchar(20)),4,8) as int)*60/100

--simplest version to get teh diff and get in this format, dateadd is only used for representation
select format(dateadd(second,datediff(second,'Jan 31 2026 11:23AM','Jan 31 2026 04:52PM'),0),'hh:mm')+' Hrs'
--ignores the null value and concat
select CONCAT_WS(' ',firstname,lastname) from orders
select CONCAT([order date],'||',[ship date]) from orders --this is a simple concat

create table info(
empid int identity(100,1) not null,
firstname varchar(20),
lastname varchar(20),
salary int not null,
[joined date] date,
country varchar(20) default 'India'
)

insert into info(salary,country) values(20000,'Veitnam')
select * from info

--coalesce for the data which is null, so the second argument is being printed in that place 
--but if both the columns have null, then it will return null only
select empid, coalesce(firstname,lastname) AS [Name or identifier] from info
select * from info
--but if both the columns have null, so not to return null, use isnull and give what should be there instead
--isnull(attribute\expression,'Missing value(alias)')
select empid, isnull(coalesce(firstname,lastname),'N\A') AS [Name or identifier]
from info
--if using coalesce and one of the column's data type does not match with other, will give an error
--better to only use same type of data type columns or to convert the column data type at the same time.
select empid, coalesce(firstname,lastname,cast(salary as varchar(10))) AS [Name or identifier]
from info
--concat_ws ignores the null value and concat
select concat_ws(' ',firstname,lastname,salary) as data from info
--parsename starts from right and delimeter(.)
select PARSENAME('nikhil.gulati.90000',3) as firstname

--string_agg this function uses (expression,delimeter) 
--ignores null values and can be used with joins, where clauses etc
select string_agg(firstname,'.') from info
select parsename((select string_agg(firstname,'.') from info),1) as [lastname instance]

select string_agg(isnull(coalesce(firstname,lastname),'N\A'),'.') from info

select parsename((replace(
(concat_ws(' ',firstname,lastname,salary),' ','.')),1) as data from info

select replace(
	string_agg(
		concat_ws(' ',firstname,lastname,salary),' | '),' ','.') as data from info

select * from info
--method to use the concat_ws with parsename
select parsename(
concat_ws('.',firstname,lastname,salary),3
) as firstname from info 

--using format, cast, parsename to get the salary in the correct indian format
select format(cast(parsename('Nikhil.Gulati.20000',1) as int),'c','en-IN') as Salary 

select value from string_split((select string_agg(firstname,'\') from info),'\')

create view sample1 as
select 'model:asus zenbook' as data

select substring(data,CHARINDEX(':',data)+1,len(data)) from sample1