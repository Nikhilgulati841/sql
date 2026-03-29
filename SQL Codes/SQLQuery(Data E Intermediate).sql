--Data Exploration (Intermediate)

--identify the customer with the highest total sales across all orders
select * from OrderList
select * from EachOrderBreakdown

select top 1 e1.CustomerName,sum(e2.sales) as TotalSales from orderlist e1
left join EachOrderBreakdown e2
on e1.orderID=e2.orderID
group by e1.CustomerName
order by TotalSales desc

--find the month with the highest average sales in the orderlist table.
select format(orderdate,'MM'),avg(e2.sales) as AvgSales from orderlist e1
left join EachOrderBreakdown e2
on e1.orderID=e2.orderID
group by format(orderdate,'MM')
order by AvgSales desc
--use MMMM if you do not want numbers and full name instead
-- also you can use this also-> select datename(month,orderdate),avg(e2.sales) as AvgSales from orderlist e1
-- or Month(orderdate) and group by also with month(orderdate)

select * from OrderList
select * from EachOrderBreakdown


--get the average quantity ordered by customers whose first name starts with 's'
select avg(Quantity) as Avg_Qty from OrderList t1
left join EachOrderBreakdown t2
on t1.OrderID=t2.OrderID
where lower(CustomerName) like 's%'


