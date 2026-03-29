--schema creating, default schema will be dbo
--transfer tables from one schema to another, also inserting|deleting|adding values to any of the schema
--formatting the salary with using decimal while creating, money, format to format that in ##,###,en-In,en-GB, 00-000-000-00

/*create database forSchema

create schema HR
create schema IT

select * from sys.schemas

create table test3(
id int not null
)

create table hr.employee(
empid int identity(1,1) primary key not null
)

alter table hr.employee
add firstname varchar(20) not null,
lastname varchar(20) null;

alter schema it
transfer test1

alter schema it
transfer dbo.test3

drop schema it

select name from sys.schemas

create schema it

create table it.employee(
FileNo int not null
)

/* create table it.employee(
IdCard int not null
)    -- this is wrong, because in the same database and inside the same schema, 
     -- no two tables can have the same name
     -- in diff schema, inside the same DB, two tables can have the same name.*/

create table hr.leads(
leadNo int not null
)

sp_help 'it.leads'

insert into it.leads values
(2),
(3),(4)

select * from it.leads

alter schema it
transfer hr.leads

sp_help [it.leads]

alter table it.leads
add phone int*/

use department
create schema HR
create Schema IT

create table employee(
EmpId int not null identity(464619,1),
Firstname varchar(50) not null default 'Unknown'
)

create table HR.employee(
EmpId int not null identity(464619,1),
Firstname varchar(50) not null default 'Unknown'
)

alter schema it
transfer dbo.employee

insert into it.employee
values('Nikhil Gulati'),('Sahil Rana')

select * from it.employee

sp_help 'it.employee'

update it.employee
set Firstname='Aditya'
where Empid=464620

alter table it.employee
add age int not null default 20

alter table it.employee
add salary money not null default 20000

insert into it.employee(Firstname,salary)
values('HOla',120000)

select *, format(salary,'C','en-GB') as formatted_salary from it.employee

alter table it.employee
add formatted_salaryy as format(salary,'N2','en-IN')

alter table it.employee
drop column salary

select * from it.employee


select * from orders
