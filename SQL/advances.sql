-----------CTEs(Common table expression)------Temporary 
-----------Acts like a temporary memory and a subquery

WITH CTE_Employee as (
SELECT FirstName, LastName, Gender, Salary, 
COUNT(gender) OVER (PARTITION BY gender) as TotalGender,
AVG(Salary) Over (Partition by Gender) as AvgSalary
FROM SQLTutorial.dbo.EmployeeDemographics emp
JOIN SQLTutorial..EmployeeSalary sal
ON emp.EmployeeID=sal.EmployeeID
WHERE salary > '45000'
)

select * from CTE_Employee;


----Temp tables(Can be used multiple times)

CREATE TABLE #temp_Employee (
EmployeeID int,
JobTitle varchar(100),
Salary int
)

select * from #temp_Employee;

INSERT INTO #temp_Employee VALUES ('1001', 'HR', '45000');

---INserts data from an existing table to a temp table. We can work and run our qeries so it doesnt affect the actual table much and we can do our testing
INSERT INTO #temp_Employee
SELECT * FROM SQLTutorial..EmployeeSalary


DROP TABLE IF EXISTS #temp_Employee2
CREATE TABLE #temp_employee2(
JobTitle varchar(50),
Employeesperjob int,
AvgAge int,
Avgsalary int
)

INSERT INTO #temp_employee2
select Jobtitle, Count(JobTitle), AVG(Age), AVG(salary)
from SQLTutorial..EmployeeDemographics emp
JOIN SQLTutorial..EmployeeSalary sal
ON emp.EmployeeID=sal.EmployeeID
GROUP BY JobTitle;


select * from #temp_employee2;

------STRING FUNCTIONS

CREATE TABLE EmployeeErrors(
EmployeeID varchar(50),
FirstName varchar(50),
LastName varchar(50))

INSERT INTO EmployeeErrors values(
'1001', 'Jimbo', 'Halpert'),
('1002', 'Pamela', 'Beasley'),
('1003','Toby', 'Flenderson - Fired')

select * from EmployeeErrors;

------Using trim, LTRIM, RTRIM
select EmployeeID, TRIM(EmployeeID) AS IDTRIM
from EmployeeErrors;

select EmployeeID, LTRIM(EmployeeID) AS IDTRIM
from EmployeeErrors;

select EmployeeID, RTRIM(EmployeeID) AS IDTRIM
from EmployeeErrors;

------Using Replace

select LastName, REPLACE(LastName, '- Fired', '') as Lastname_edited
from EmployeeErrors;

------Substring

select SUBSTRING(FirstName, 1,3) AS substringed
from EmployeeErrors;


---Fuzzy matching

select err.FirstName, SUBSTRING(err.FirstName,1,3), dem.FirstName, SUBSTRING(dem.FirstName, 1,3)
from EmployeeErrors err
JOIN SQLTutorial..EmployeeDemographics dem
ON SUBSTRING(err.FirstName,1,3)=SUBSTRING(dem.FirstName, 1,3);

----UPPER and LOWER

select FirstName, LOWER(FirstName), UPPER(FirstName)
from EmployeeErrors;


-------Stored procedure(Group of SQL statements, created and stored within that database)

CREATE PROCEDURE TEST
AS
select * from SQLTutorial..EmployeeDemographics

EXEC TEST

CREATE PROCEDURE Temp_employee1
AS
CREATE TABLE #temp_employee3(
JobTitle varchar(50),
Employeesperjob int,
AvgAge int,
Avgsalary int
)

EXEC Temp_employee1


ALTER PROCEDURE Temp_Employee1
@JobTitle nvarchar(50)
AS
CREATE TABLE #temp_employee3(
JobTitle varchar(50),
Employeesperjob int,
AvgAge int,
Avgsalary int
)

INSERT INTO #temp_employee3
select Jobtitle, Count(JobTitle), AVG(Age), AVG(salary)
from SQLTutorial..EmployeeDemographics emp
JOIN SQLTutorial..EmployeeSalary sal
ON emp.EmployeeID=sal.EmployeeID
where JobTitle=@JobTitle
GROUP BY JobTitle;


select * from #temp_employee3;

---------Subqueries

select * from SQLTutorial..EmployeeSalary;

--SELECT

SELECT EmployeeID, Salary, (select AVG(Salary) from SQLTutorial..EmployeeSalary)
FROM SQLTutorial..EmployeeSalary;

----How to fo it with partition by

SELECT EmployeeID, Salary, AVG(Salary) over () as AllAvgsalary
FROM SQLTutorial..EmployeeSalary;

----Why groupby does not work

SELECT EmployeeID, Salary, AVG(Salary) as AllAvgsalary
FROM SQLTutorial..EmployeeSalary
GROUP BY EmployeeID, Salary
Order by 1,2;

select a.EmployeeID, AllAvgsalary from
(SELECT EmployeeID, Salary, AVG(Salary) over () as AllAvgsalary
FROM SQLTutorial..EmployeeSalary) a


---In where

SELECT EmployeeID, JobTitle, Salary 
FROM SQLTutorial..EmployeeSalary
WHERE EmployeeID in (
select EmployeeID 
from SQLTutorial..EmployeeDemographics
WHERE AGE > 30)

