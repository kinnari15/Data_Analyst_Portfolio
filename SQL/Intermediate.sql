

----------JOINS----------------------------------------------
select  * from EmployeeDemographics
INNER JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID;

select  * from EmployeeDemographics
FULL OUTER JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID;


select  * from EmployeeDemographics
LEFT OUTER JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID;



select  * from EmployeeDemographics
Right OUTER JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID;



select EmployeeSalary.EmployeeID, FirstName, LastName, JobTitle, Salary
from EmployeeDemographics
Right Outer Join EmployeeSalary
ON
EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID
Where FirstName <> 'Michael'
ORDER BY salary DESC;

---UNION
Insert into EmployeeDemographics VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly', 'Flax', NULL, NULL),
(1013, 'Darryl', 'Philbin', NULL, 'Male');


Create Table WareHouseEmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
)

Insert into WareHouseEmployeeDemographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female');

select * from EmployeeDemographics
UNION all
select * from WareHouseEmployeeDemographics
ORDER BY EmployeeID;


select * from EmployeeDemographics
Full outer join WareHouseEmployeeDemographics
on EmployeeDemographics.EmployeeID=WareHouseEmployeeDemographics.EmployeeID


--------Case statement


select FirstName, LastName, Age,
CASE
	WHEN Age > 30 THEN 'old'
	Else 'Young'
END
from EmployeeDemographics
WHERE Age is not null
order by Age;




select FirstName, LastName, JobTitle, Salary,
CASE
	WHEN JobTitle='Salesman' THEN Salary + (Salary * 0.10)
	WHEN JobTitle='Accountant' THEN Salary + (Salary * 0.05)
	WHEN JobTitle='HR' THEN Salary + (Salary * 0.2)
	ELSE Salary + (Salary * 0.03)
END AS SalaryAfterRaise
from EmployeeDemographics
INNER JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID;


----Having Clause

select  JobTitle, Count(Jobtitle) from EmployeeDemographics
JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID=EmployeeSalary.EmployeeID
Group by JobTitle
HAVING COUNT(JobTitle) > 1;

-----Updating/Deleting Data

Update EmployeeDemographics 
set Age='31', Gender='Female', EmployeeID='1012' 
WHERE FirstName='Holly' AND LastName='Flax';

select * from EmployeeDemographics;

DELETE FROM EmployeeDemographics
WHERE EmployeeID='1005';


--------ALiasing

select FirstName + ' ' + LastName AS FullName
from EmployeeDemographics;


----Partition by----> Gives or divides by paritioning with a single column with the table also.

select FirstName,LastName,Gender, Salary,
COUNT(Gender) OVER (PARTITION BY Gender) as TotalGenders
from EmployeeDemographics dem
JOIN EmployeeSalary sal
ON dem.EmployeeID=sal.EmployeeID;


select Gender, COUNT(Gender)
from EmployeeDemographics dem
JOIN EmployeeSalary sal
ON dem.EmployeeID=sal.EmployeeID
GROUP BY Gender;
