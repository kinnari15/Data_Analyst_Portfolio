--CREATE TABLE EmployeeDemographics
--(
--EmployeeID INT,
--FirstName varchar(50),
--LastName varchar(50),
--Age INT,
--Gender varchar(50)
--)

--CREATE TABLE EmployeeSalary
--(EmployeeID INT,
--JobTitle varchar(50),
--Salary INT
--)

--INSERT INTO EmployeeDemographics VALUES
--(1001, 'Jim', 'Halpert', 30, 'Male'),
--(1002, 'Pam', 'Beasley', 30, 'Female'),
--(1003, 'Dwight', 'Schrute', 29, 'Male'),
--(1004, 'Angela', 'Martin', 31, 'Female'),
--(1005, 'Toby', 'Flenderson', 32, 'Male'),
--(1006, 'Michael', 'Scott', 35, 'Male'),
--(1007, 'Meredith', 'Palmer', 32, 'Female'),
--(1008, 'Stanley', 'Hudson', 38, 'Male'),
--(1009, 'Kevin', 'Malone', 31, 'Male')


--Insert Into EmployeeSalary VALUES
--(1001, 'Salesman', 45000),
--(1002, 'Receptionist', 36000),
--(1003, 'Salesman', 63000),
--(1004, 'Accountant', 47000),
--(1005, 'HR', 50000),
--(1006, 'Regional Manager', 65000),
--(1007, 'Supplier Relations', 41000),
--(1008, 'Salesman', 48000),
--(1009, 'Accountant', 42000)


select * 
from EmployeeDemographics;

select DISTINCT(Gender)
from EmployeeDemographics;

select COUNT(LastName) as LastNameCount
from EmployeeDemographics;

select * 
from EmployeeSalary;

select MIN(salary)
from EmployeeSalary;


--WHERE STATEMENT

SELECT * FROM EmployeeDemographics
WHERE FirstName = 'Pam';

select * from EmployeeDemographics
WHERE Age <=32 AND gender='Male';


--WILDCARDS
select * from EmployeeDemographics
WHERE LastName LIKE '%S%';


select * from EmployeeDemographics
WHERE FirstName is not NULL;

select * from EmployeeDemographics
WHERE FirstName IN ('Jim','Michael');


---GROUP BY and ORDER BY

select DISTINCT(Gender) from EmployeeDemographics;

select GENDER, COUNT(Gender) from EmployeeDemographics
GROUP BY Gender;

select GENDER, Age, COUNT(Gender) from EmployeeDemographics
GROUP BY Gender, Age;
 

 select GENDER, Age, COUNT(Gender) AS CountGender from EmployeeDemographics
 WHERE Age > 31
GROUP BY Gender, Age
ORDER BY CountGender ASC;

select * from EmployeeSalary
ORDER BY SALARY DESC;


select * from EmployeeDemographics 
ORDER BY 4 DESC;