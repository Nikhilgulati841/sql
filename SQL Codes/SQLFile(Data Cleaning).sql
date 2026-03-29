--Data Cleaning

--establish relationship between the orderlist and order breakdownlist tables as per the ER diagram
alter table orderlist
add constraint pk_orderid
primary key(orderID)

alter table eachorderbreakdown
add constraint fk_orderID
foreign key(orderID)
references orderlist(orderID)

--split the city state country into 3 individual columns namely, 'City','State' like that
select * from OrderList

alter table orderlist
add City nvarchar(50),
	State nvarchar(50),
	Country nvarchar(50)

update orderlist
set state=parsename(replace(city_state_country,',','.'),2),
	City=parsename(replace(city_state_country,',','.'),3)

--breakdown of the productName column with the first 3 char with eg OFS-Office Supplies, TEC-Technology,FUR-Furniture

select * from EachOrderBreakdown

alter table EachOrderBreakdown
add Category varchar(20)

update EachOrderBreakdown
set category=
case
when substring(productname,1,3)='OFS' then 'Office Supplies'
when substring(productname,1,3)='FUR' then 'Furniture'
when substring(productname,1,3)='TEC' then 'Technology'
end
-- or left(productname,3)='OFS' then 'Office Supplies'


update EachOrderBreakdown
set productname=substring(productname,CHARINDEX('-',productname)+1,len(productname))
--or
-- =right(productname, len(productname)-charindex('-',productname))

--now to remove the dublicate rows, means each of the column information is same not just one thing like orderID
with cte_duplicates as (
select *, row_number() over(partition by orderID,productname,discount,sales,profit,quantity,subcategory,category order by orderID) as rn from EachOrderBreakdown
)
delete from cte_duplicates where rn>1


create table testing(
empid int,
empname varchar(20),
age int
)

insert into testing values
(1,'Nikhil',26),
(2,'Hola',26),
(2,'Hola',27),
(2,'Hola',27),
(3,'Gola',27)

select *, row_number() over(partition by empid,empname,age order by empid) as rn from testing


select * from OrderList

update orderlist
set orderpriority=isnull(OrderPriority,'NA')







