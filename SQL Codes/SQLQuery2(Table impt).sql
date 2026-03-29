--creating table, renaming table/Column name, adding values, specific data entry, specific searches/deletion
--alter column dataType length, adding default, constraints multiple columns at once
--use of EXEC to execute multiple renaming of the column at once
--update Null values and then adding the column type as Not Null forever
--check and check constraints as well 
--changing the data type by adding new column, updating the data according to the data already there in the previous column
--then after using case|when|then dropping the previous column and then renaming the current column

create table cardetails(
SerialNo int identity(10,1) not null,
brand varchar(30) null,
price int not null,
country varchar(30) null
)

--renaming table name
sp_rename car2details, car1details

sp_help car1details

--adding multiple values at once
insert into car1details 
values('Suzuki',500000,'Japan'),
('Kia',1600000,'Spain')

--inserting a specific column data only
insert into car1details(price)
values(500000)

select * from car1details
--specific search according to conditions
select * from car1details where brand is null and country is null

--altering the data type
alter table car1details 
alter column brand varchar(15)

--renaming a column name
exec sp_rename 'car1details.origin_country','Supply_country'
exec sp_rename 'car1details.price','car1_Price'

--adding default constraint for previous entries, if adding a new column
alter table car1details 
add mileage int NOT NULL default 15
--testing
insert into car1details(mileage,car1_price)
values(20,1200000)

--testing and adding multiple columns and renaming some column names at once
alter table car1details
add ownership varchar(20) not null default 'New',
fuel_type varchar(50) not null default 'Petrol'
exec sp_rename 'car1details.car1_Price','Price'
exec sp_rename 'car1details.car1_brand','Brand'

select * from car1details
--testing and adding values
insert into car1details(price,supply_country,mileage,ownership)
values(2000000,'Tokyo',25,'Second Hand')

--adding rating (check type) of values(restricts the value should only be under 1-5)
alter table car1details
add add_still_active BIT default 1,
	rating int check (rating between 1 and 5)

insert into car1details(price,supply_country,mileage,ownership,fuel_type,add_still_active,rating)
values(2000000,'Tokyo',25,'Second Hand','Diesel',0,4)

--updating Null TO not Null || for that we need to firstly update the previous null entries for that column
update car1details
set brand='Unknown'
where brand is null

--if default for any Not NULL column is not added then constraint needs to be added
alter table car1details
add constraint DF_car1details_country
default 'I don''t know' for Origin_Country

--checking the table data again 
select * from car1details

insert into car1details(price,supply_country,mileage,ownership,fuel_type,add_still_active,rating)
values(2000000,'Yolo3',25,'Second Hand','Diesel',0,4)

update car1details
set brand='Not Known'
where brand='Unknown'

--dropping the previous constraint first to add a new default value and add new constraint
alter table car1details 
drop constraint DF_car1details_brand

sp_rename 'car1details.supply_country','Origin_Country'

update car1details
set Origin_Country='Unknown'
where Origin_Country is null


--to change the default value of the column for which already a constraint is there,
--we need to drop the previous one to add the new one
--but for the new column, we can simply add the new constraint, without dropping the previous column

alter table car1details
add constraint ck_car1details_fuel_type
check (fuel_type in ('Petrol','Diesel','CNG','EV'))

insert into car1details(price,Origin_country,mileage,ownership,fuel_type,add_still_active,rating)
values(2000000,'Fuel-Type-Testing',25,'Second Hand','ev',0,4)

delete from car1details 
where brand='I don"t know'

select * from car1details

alter table car1details
add review int not null default 1

--changing the data type by adding new column, updating the data according to the data already there in the previous column
--then after using case|when|then dropping the previous column and then renaming the current column


alter table car1details
add add_still_active_txt varchar(3) not null default 'yes'

update car1details
set add_still_active_txt=
	case 
		when add_still_active=1 then 'Yes'
		when add_still_active=0 then 'No'
	end

alter table car1details
add Good_Bad varchar(10)

update car1details
set Good_Bad=
case
	when rating<3 then 'Bad'
	when rating>=4 then 'Good'
end;


alter table car1details
drop constraint DF__car1detai__add_s__4CA06362,
column add_still_active

exec sp_rename 'car1details.add_still_active_txt','add_still_active'

--testing some of the output result from teh data already have in the table
select * from car1details
select sum(price) as sum_of_unknown, count(Origin_Country) as Count_of_unknown_count from car1details where Origin_country='Unknown' group by Origin_Country 

begin tran
delete from car1details where brand='I don''t know'


rollback
commit

begin tran
update car1details
set add_still_active=
case
	when add_still_active='yes' then 'Approved'
	when add_still_active='NO' then 'Discarded'
end;


rollback
select * from sys.default_constraints

use car1
select * from car1details

