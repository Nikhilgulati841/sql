-- Data exploration (Advanced)
--to find the new customers that were acquired in 2014
with cte as(
select CustomerName, min(orderdate) as FirstOrderDate from OrderList
group by CustomerName
having year(min(orderdate))=2014
)
select count(*) as [Total number of new customers in 2014] from cte

--calculate the percentage of total profit contributed by each sub-category to the overall profit.

select * from EachOrderBreakdown

select subcategory,sum(profit) as SubCategoryProfit,(select sum(profit) from EachOrderBreakdown) as TotalProfit,
sum(profit)/(select sum(profit) from EachOrderBreakdown)*100 as [Percentage/subcategory]
from EachOrderBreakdown 
group by SubCategory

--find the average sales per customer, considering only customers who have made more than one order

select * from OrderList
select * from EachOrderBreakdown

select t1.CustomerName,count(distinct t1.OrderID) as NoOfOrders,avg(t2.Sales) as AvgSales
from OrderList t1
left join EachOrderBreakdown t2
on t1.OrderID=t2.OrderID
group by t1.CustomerName
having count(distinct t1.orderID)>1

--identity the top-performing subcategory in each category based on total sales
--include sub-category name, total sales, and a ranking of sub-category within each category

with topperformer as (
select category,sum(sales) as CategoryTotalSales,subcategory,DENSE_RANK() over(partition by category order by sum(sales) desc) as subcategoryrank
from EachOrderBreakdown
group by category, subcategory
)
select * from topperformer
where subcategoryrank=1