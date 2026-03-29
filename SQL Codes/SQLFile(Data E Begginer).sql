--Data exploration (Beginner)

--list top 10 orders with the highest sales from teh EachOrderBreakdown table 
select top 10 * from EachOrderBreakdown
order by sales desc

--show te number of orders for each product category in the EachOrderBreakdown table.
select category,count(*) as TotalOrders from EachOrderBreakdown
group by category

--toltal profit for each subcategory in the same table.
select * from EachOrderBreakdown

select subcategory,sum(profit) as [Total Profit] from EachOrderBreakdown
group by SubCategory