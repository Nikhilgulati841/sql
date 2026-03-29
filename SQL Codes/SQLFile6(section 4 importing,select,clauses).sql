--importing excel to sql and then select queries
--like stored procedures, as multiple select as the select under a select 
--view, BY creating View, we do not have to have the stored procedures
--using the substring function, replacing or correcting the text or any information or trimming the data


use SuperstoreDB
select count([order ID]) as count_of_orders from returns where returned='Yes'

select * from returns

select distinct cast(substring([order id],4,4) as int) as Year from orders order by year 

--for the two digit country code from the [order id], get the counts of orders, total number of orders 
--and the % of each code orders share among total orders
select substring([order id],1,2) as [Country Code], count(*) as [count of orders],
(select count([order ID]) from orders) as [total orders],
concat (cast(count(*)*100.0/(select count([order ID]) from orders) as decimal(10,2)),'%') as Percentage
from orders where [order id] like 'CA%' or [order id] like 'US%' group by substring([order id],1,2)



update returns
set [order id] ='NIKHIL' + substring([order id],3,len([order id]))
where [order id] like 'CA%'

update returns
set [order id]='CA'+SUBSTRING([order id],4,len([order id]))
where [order id] like 'CA%'

select max(len([order id])) from returns

select substring('CA-2014-44',9,len('CA-2014-44'))

select count(distinct state) from orders

select count(distinct city),count(distinct country),count(distinct state) from orders 


select count(*) from (
select * from orders where quantity>=5
) as g

select *,count(city) over(partition by city order by city) from orders
where state='california' and city='fresno' or city='Los Angeles' order by city


--like stored procedures, as multiple select as the select under a select 
select distinct state from (select * from orders
where state<>'Iowa' and state like '__w%') as g

--view, BY creating View, we do not have to have the stored procedures
create view v_selected_state as
select * from orders where state<>'Iowa' and state like '__w%'

create or alter view new_logic_view as 
select distinct state,count(state) as [Count of orders],(select count(*) from v_selected_state) as TotalCount,
sum(sales) as [Total Sales],
cast(sum(sales)*1.0/count(state) as decimal(10,2)) as [Avg=total sales/Count],
cast((select sum(sales) from orders)*1.0/(select count(*) from orders) as decimal(10,2)) as [Avg=AllSales/AllCount]
from v_selected_state group by state

create or alter view new_logic2_view as 
select *, [Avg=total sales/Count]-[Avg=AllSales/AllCount] as Diff,
case
when [Avg=total sales/Count]-[Avg=AllSales/AllCount]>1 then 'Avove AVG'
when [Avg=total sales/Count]-[Avg=AllSales/AllCount]<1 then 'Below AVG'
else 'Avg'
end as [Status of sales]
from new_logic_view

select state,[count of orders],totalcount,[Total sales],[status of sales] from new_logic2_view

select * from orders
where state like '[^Ne]%'

select * from orders

begin tran
update orders 
set [order id]=cast([row id] as varchar(50))+substring([Order ID],len([Order ID])-5,6) 
rollback

select cast([Row id] as varchar(10))+substring([Order ID],len([Order ID])-5,6) from orders

select state, round(AVG(sales),0) as [average sales] from orders group by state

begin tran
update orders
--nested replace to condition the or options (means the result of 1st replace and then to if there are some data not having 'Nikhil'
--and other than 'CA' also if there are somethigns and you want them also to be replaced with Nikhil then in that case)
set [order id]=replace(replace([order id],'CA','Nikhil'),'US','Hola') 
rollback

select distinct(substring([order id],1,2)) as [Country Name] from orders
select replace([order id],'CA','Nikhil') from orders --temp, not saved


select concat([Row ID],'||',[Order id]) from orders

create view distinct_customers as
select [customer name], count(*) as Counts from orders group by [Customer Name] having count(*)>1

select * from distinct_customers order by [customer name] asc

select [customer name],left([customer name],CHARINDEX(' ',[customer name])) from orders
group by [customer name]
having count(*)=1

-- to find the last name by using the charindex to find the number for space and then getting the after part of the string using substring.
select [customer name], substring([customer name],CHARINDEX(' ',[customer name])+1,len([customer name])) from orders
group by [customer name]
having count(*)=1



