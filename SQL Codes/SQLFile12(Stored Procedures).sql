--Stored Procedures
use employee
select * from employee

create or alter procedure update_my_salary
@name varchar(20),
@increment decimal(10,2),
@choice varchar(20)

as
begin
    if lower(@choice) not like 'add%' and lower(@choice) not like 'sub%'
    begin
    print('Choose between Add || Subtract')
    end
    if @increment<5
    begin
    print('Increment should atleast be 5% or more, and you have choosen: '+cast(@increment as varchar(10)))
    end
    if @increment>=5
    begin
        
        declare @changes table
        (
        empname varchar(20),
        old_salary decimal(10,2),
        new_salary decimal(10,2),
        change_amount decimal(10,2)
        
        )

        update employee
        set salary=
        case
        when lower(@choice) like 'add%' then salary+(salary*(@increment/100))
        when lower(@choice) like 'sub%' then salary-(salary*(@increment/100))
        end
        output
            inserted.[employee name],
            deleted.salary,
            inserted.salary,
            inserted.salary-deleted.salary
        into @changes
        where [employee name] like @name+'%'

        select empname,format(old_salary,'C','en-IN') as old_salary,format(new_salary,'C','en-IN') as new_salary,format(new_salary-old_salary,'C','en-IN') as Change_In_Salary
        from @changes

        declare @nam varchar(max)

        select @nam=string_agg([employee name],',')
        within group(order by salary desc)
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

update_my_salary @name='s', @increment=12,@choice='addition'

sp_helptext update_my_salary

-- two ways to change the database name from code, and with GUI it is simple right click option
use master 
go
sp_renamedb 'SuperStoreData','SuperstoreDB'
-- way 2
alter database Superstoredb modify name=SuperStoreData


create or alter procedure uniq_region_category
as
begin
    select region,string_agg(category,' || ') within group (order by category) as [Falling Categories], count(*) as Count_of_category
    from (
    select region, category
    from orders
    group by region, category
    ) as t
    group by region
end

exec uniq_region_category

--group by region, category means  
--east->furniture || east->furniture || east->Office Supplies || west->Office supplies  BECOMES
--east->furniture || east->Office Supplies || west->Office supplies  MEANS unique category for every region, but region may be same 
--then group by region at the last will group all the same region's category falling under one

exec uniq_region_category

--alter procedure, a procedure inside another procedure
/*
create or alter procedure region_category
@choice varchar(10),
@region varchar(10),
@category varchar(20),
@order int output

as 
begin
    if lower(@choice) like 'show%'
    begin
        select @order=count(*) from orders where category=@category and region=@region
        exec uniq_region_category
        select [order id],[order date],[customer id],[customer name],category,region from orders 
        where category=@category and region=@region
    end
    if lower(@choice) like 'get%'
    begin
        select @order=count(*) from orders where category=@category and region=@region
        select [order id],[order date],[customer id],[customer name],category,region from orders 
        where category=@category and region=@region
    end
end
*/


/*
another way to use return also
make the changes in procedure, by removing @order as a parameter and then declare it somewhere inside
the same way select @order=count(*) from orders where then condition n all
 then at the very last end and before the last end, return @order
then while execute procedure
declare @count int
exec @count=region_category 'get','south','furniture'
as it should accept that integer value */

region_category @region='South', @category='furniture',@choice='get'
--if in the same order of paramenters, then no need to define the paramenters name again 
region_category 'get','south','furniture'
--otherwise you have to name them

declare @count int
exec region_category @region='South', @category='furniture',@choice='get',@order=@count output
print 'The total no of orders are '+cast(@count as varchar(10))


create or alter procedure get_orders
@region varchar(10),
@category varchar(10),
@orders int output
as
begin
select @orders=count(*) from orders where category=@category and region=@region
--print('There are ,'+cast(@orders as varchar(10))+' Orders')
select [order id],[order date],[customer id],[customer name],region, category
from orders where category=@category and region=@region
end


declare @count int
exec get_orders 'south','furniture',@count output
print 'There are total, '+cast(@count as varchar(10))+' Orders'

--using return

create or alter procedure get_orders2
@region varchar(10),
@category varchar(10)
as
begin
select [order id],[order date],[customer id],[customer name],region, category
from orders where category=@category and region=@region

declare @orderCount int
select @ordercount=count(*) from orders
where category=@category and region=@region
return @ordercount
end

declare @count int
exec @count=get_orders2 'south','furniture'
print 'There are total, '+cast(@count as varchar(10))+' Orders'


--find the order details of any given order ID
	--check without assigning the variable also to @orderID
	--Will Give error: A SELECT statement that assigns a value to a variable must not be combined with data-retrieval operations.

create or alter procedure order_details
@orderID varchar(20),  --parameter
@customerID varchar(20) output,
@customerName varchar(30) output,
@sales float output,
@profit float output
as
begin
    if exists(select 1 from orders where [order id]=@orderID)
    begin
        select @orderID=[order id],@customerID=[customer id],@customerName=[customer name],@sales=sum(sales),@profit=sum(profit)
        from orders where [order id]=@orderID group by [customer ID],[order id],[customer name]
        --this part only assigns the values of columns to the parameters unlike below one
        --then in the below procedure, by 
        return 1
    end
    else
    begin
        return 0
    end
end


create or alter procedure display_orderDetails
@orderID varchar(20)
as 
begin
--Variable names do NOT necessarirly have to match parameters names.
Declare @customerID varchar(20)  --variables
Declare @customerName varchar(30)
Declare @sales float
Declare @profit float
Declare @returnValue int
exec @returnValue=order_details @orderID,@customerID output,@customerName output,@sales output,@profit output
if @returnValue=1
    begin
    print 'The Order ID is: '+@orderID
    print 'The Customer ID is: '+@customerID
    print 'The Customer Name is: '+@customerName
    print 'The Sales are: '+cast(@sales as varchar(10))
    print 'The Profit is: '+cast(@profit as varchar(10))
    select * from orders where [order id]=@orderID  --this part executes the main query unlike the above one
    end
else
    begin
    print 'No Order Exists'
    end
end

exec display_orderDetails 'CA-2011-115812'

