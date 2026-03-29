/* create table EmployeeDetails
(
EmpID int Not Null,
FirstName varchar(6) Not Null,
LastName varchar Null,
Salary Int Null,
JoiningDate date Not Null
)
drop table employeedetails
sp_help employeedetails  */

--creating files, modify DB name, ssms name, physical name by making it offline 
--then telling the ssms about the new name and then making it online 

create database car on (
name=car_data,
filename='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\car.mdf',
size=16,
maxsize=32,
filegrowth=2
)

log on (
name=car_logs,
filename='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\car.ldf',
size=4,
maxsize=10,
filegrowth=2
)

alter database car
modify name=car1

alter database car1
modify file (name=car_data,size=20,maxsize=40,filegrowth=3,newname=car1_data)

select name, physical_name 
from car1.sys.database_files

alter database car1
set offline with rollback immediate

alter database car1
modify file (name=N'car1_data', filename='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\car_update.mdf')

alter database car1
modify file (name=N'car_logs',filename='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\car_logs_update.ldf')

alter database car1
set online;

select name, physical_name
from car1.sys.database_files


exec sp_helpdb car1

alter database car1 set online

BACKUP DATABASE SuperstoreDB
TO DISK = 'E:\SQlbackups\SuperstoreDB.bak'
WITH FORMAT,
NAME = 'Full Backup of SuperstoreDB';