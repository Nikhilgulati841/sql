--window function

--aggregate window function
select [order id],category,[product name],quantity, 
sum(quantity) over(partition by [order id]) as [Total quantity for each orders],
cast(avg(quantity) over(partition by [order id]) as decimal(10,2)) as [AVG quantity for each orders],
max(quantity) over(partition by [order id]) as [Max quantity for each orders],
min(quantity) over(partition by [order id]) as [Min quantity for each orders],
count(quantity) over(partition by [order id]) as [Total Order ID's count]
from orders where [order id] in ('CA-2011-115812','CA-2012-135545','US-2012-108966')

--ranking window function
select [order id],category,[product name],quantity,
row_number() over(partition by [order ID] order by quantity) as RowNum,
rank() over(partition by [order id] order by quantity) as Ranking,
dense_rank() over(partition by [order id] order by quantity) as DenseRanking,
PERCENT_RANK() over(partition by [order id] order by quantity) as [percentRanking proceeding bar], 
/*this is acting like a progress bar if sorted dats according to the quantity, 
for the same quantity, it does not increases and shows the next one synced with rank like
NTILE(2) if written without partition, then whole result set will be divided by 2 parts marking half of it with 1 and the half with 2.
if odd numbers then one part will be assigned automatically with 1 more.
if NTILE(2) with partition, then individual partition will have 2 partition with the same logic. 
Means, each set of partition will have two labels of partitions.*/
NTILE(2) over(partition by [order id] order by quantity) as sectionNO
from orders where [order id] in ('CA-2011-115812','CA-2012-135545','US-2012-108966')
/*rank function skips the next rank if there is two quantity same but with the dense rank it is more precise
rank- if sees two same ranking that means compedition between*/

 
--Rows Between window function
with cte as(
select [order id],category,[product name],quantity,
sum(quantity) over(partition by [order id] order by quantity rows between unbounded preceding and current row) as [running Total],
dense_rank() over(order by [order id]) as sections,
rank() over(order by [order id]) as [section Type2],
sum(quantity) over() as Total,
sum(quantity) over(order by quantity rows between unbounded preceding and unbounded following) as [Total Type1], --same result as the upper one
sum(quantity) over(partition by [order id] order by quantity rows between unbounded preceding and unbounded following) as [Total Type2],
sum(quantity) over(partition by [order id] order by quantity rows between 1 preceding and 1 following) as [3 Consecutive sum]
from orders
where [order id] in ('CA-2011-115812','CA-2012-135545','US-2012-108966')
)
select * from cte
where [sections]=1 --check it with or withiut CTE(Common Table Expression)


--Lag and Lead
select [order id],category,[product name],quantity,
lag(cast(quantity as varchar(10)),1,'-') over(partition by [order id] order by quantity) as previous_quantity,
lead(cast(quantity as varchar(10)),1,'-') over(partition by [order id] order by quantity) as next_quantity,
isnull(case
when quantity>lag(quantity) over(partition by [order id] order by quantity,[order id]) then 'Increases'
when quantity<lag(quantity) over(partition by [order id] order by quantity,[order id]) then 'Decreased'
when quantity=lag(quantity) over(partition by [order id] order by quantity,[order id]) then 'EQUAL'

end ,'N\A') as [quantity increased or decreased]
from orders
where [order id] in ('CA-2011-115812','CA-2012-135545','US-2012-108966')
order by [order id]

--First_Value & Last_Value

select [order id],category,[product name],quantity,
FIRST_VALUE(quantity) over(partition by [order id] order by quantity rows between unbounded preceding and unbounded following) as First_Value,
Last_VALUE(quantity) over(partition by [order id] order by quantity rows between unbounded preceding and unbounded following) as Last_Value,
dense_rank() over(order by [order id]) as [SameID's]
--we have to mention ->rows between unbounded preceding and unbounded following
--because by DEFAULT it is rows between unbounded preceding and current row for First and Last value
from orders
where [order id] in ('CA-2011-115812','CA-2012-135545','US-2012-108966')


--cross apply

create table sales(
productID int primary key,
product_name varchar(10),
year int,
Q1_sales int,
Q2_sales int,
Q3_sales int,
Q4_sales int
)

select * from sales

select productID,year,quarter,sales from sales
cross apply (values
('Quarter 1',Q1_sales),
('Quarter 2',Q2_sales),
('Quarter 3',Q3_sales),
('Quarter 4',Q4_sales)
) as v(quarter,sales)



select db_name(),OBJECT_SCHEMA_NAME(object_id),name from sys.tables

select * into sampledata.dbo.sales from superstoredb.dbo.sales

select * from sales_Data