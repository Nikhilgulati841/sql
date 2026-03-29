--primary key constraint single or multi
--Unique constraint
--foriegn key constraint


--primary key constraint single or multi

create table hr.employeeDetails2(
empID int not null,
firstname varchar(20) not null,
lastname varchar(20),
age int,
constraint pkEMPID_Firstname primary key(empID,firstname)
)

alter schema hr
transfer dbo.employeedetails

insert into hr.employeedetails2(empid,firstname)
values(464618,'Meityi')

alter table hr.employeedetails2
add constraint pkEMPID_Firstname
primary key(empID,firstname)

begin tran
delete from hr.employeedetails2
where empid=464619 or empid=464618
rollback
select * from hr.employeedetails2

--Unique constraint

declare @a char(10)='Nikhil'
declare @b varchar(10)='Nikhil'
select len(@a),DATALENGTH(@a),len(@b),DATALENGTH(@b)

create table hr.employeeDetails3(
empID int not null,
firstname varchar(20) not null,
lastname varchar(20),
age int,
constraint un_empID unique(empID)
)

update hr.employeedetails3
set Phone_no=8418996010, firstname='Nikhil'
where empID is null

alter table hr.employeedetails3
add constraint un_PhoneNo
unique (phone_no)

insert into hr.employeedetails3(firstname,lastname,phone_no)
values ('Yolo','H',21)

select * from hr.employeeDetails3

sp_help 'hr.employeedetails3'

create table hr.hola(
empID int not null identity(20,1),
firstname varchar(20) not null,
lastname varchar(20)
)
use department
sp_help 'hr.hola'


--FOREIGN key constraint
create table wnsEmployee(
empID int not null,
firstname varchar(20) not null,
lastname varchar(20),
salary decimal(10,2),
credited_salary as format(salary,'N2','en-IN'),
empDeptCode char(2) references deptname(emdeptcode)
)
--while creating a table, it is not mandatory to name the constarint explicitly,
--as the default constaring for foreign key or any constarint will already be created by the system 
--as default but naming the constraint is a good practice as it is easy to drop the constraint or find it later
--ALSO, while creating the table, it is not mandatory to name the foreign key as foreign key (column_name)
--BUT, while adding a constraint for foreign key by altering the table later, is mandatory to add it like below
/*
alter table table_name
add constraint give_constrain_name
foreign key(column_name)
references table_name(column_name)
*/

insert into wnsEmployee(empID,firstname,salary,empDeptCode) 
values(464620,'Sahil',810000,'BA'),(464620,'Aditya',910000,'OP')
/*
create view v_wnsemployee as
select empid,firstname,lastname,credited_salary,empDeptCode from wnsEmployee*/

select * from v_wnsemployee

create table deptName(
emDeptCode char(2) constraint pkDEPT_NAME primary key,
deptName varchar(20) not null,
emp_Count int
)

insert into deptName(emDeptCode,deptName,emp_Count) 
values('BA','Business Analyst',4),('SA','Sales',12),('OP','Operations',200)

from * deptName select order by emp_count asc


-- to find the department that is not present in another table by using not in and two select cmds
select * from deptName
where emDeptCode not in (select empdeptcode from wnsEmployee)

