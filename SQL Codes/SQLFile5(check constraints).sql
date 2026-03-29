--check constraint using multiple conditions mentioned below
--collate general language rule
--on delete cascade on update cascade & on delete set null & setting triggers


create table managementDetails(
empID int not null,
firstname varchar(50) not null check(firstname like '[A-Z]%' collate Latin1_General_BIN),
lastname varchar(50),
email varchar(50) not null check (email like '%@%' and email like '%.%' and email not like '% %'),
phone_No varchar(12) check (phone_No like '[6-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'), 
designation varchar(50) not null check (designation in ('Manager','Agent','BA','WFM')),
salary decimal(10,2) not null,
formatted_salary as format(salary,'C','en-IN'),
constraint ck_base_salary check (salary>=10000),
constraint ck_BA_condition check( (designation <> 'BA') or (salary>=50000)) 
--this means if designation = 'BA' then salary >=50000
)

drop table managementdetails


insert into managementDetails(empid,firstname,email,phone_No,designation,salary)
values(102,'Ngikhil','nikhilgulati8687@gmail.com','8418996010','BA',50000)

select * from managementdetails



select db_name() as creentDB,
OBJECT_SCHEMA_NAME(object_id) as Current_schema,
name as tablename
from sys.tables
where name='managementdetails'


