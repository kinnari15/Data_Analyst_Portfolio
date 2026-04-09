select * from Project..['titanic passenger list$'];


----Split the name for better data
select SUBSTRING(name,1,CHARINDEX(',',name)-1) as edited_name
, SUBSTRING(name,CHARINDEX(',',name)+1,LEN(name)) as edited_name
from Project..['titanic passenger list$'];


Alter table ['titanic passenger list$']
Add Firstname nvarchar(255);

Update ['titanic passenger list$']
SET Firstname =SUBSTRING(name,CHARINDEX(',',name)+1,LEN(name));

Alter table ['titanic passenger list$']
Add LastName nvarchar(255);

Update ['titanic passenger list$']
SET LastName =SUBSTRING(name,1,CHARINDEX(',',name)-1);

ALTER TABLE ['titanic passenger list$']
DROP COLUMN name;

----Split the name for better address of the people 

select PARSENAME(REPLACE(home#dest,',','.'),3),
PARSENAME(REPLACE(home#dest,',','.'),2),
PARSENAME(REPLACE(home#dest,',','.'),1)
from Project..['titanic passenger list$'];

Alter table ['titanic passenger list$']
Add HomedestSpiltAddress nvarchar(255);


Update ['titanic passenger list$']
SET HomedestSpiltAddress=PARSENAME(REPLACE(home#dest,',','.'),3);

Alter table ['titanic passenger list$']
Add HomedestSpiltCity nvarchar(255);


Update ['titanic passenger list$']
SET HomedestSpiltCity=PARSENAME(REPLACE(home#dest,',','.'),2);

Alter table ['titanic passenger list$']
Add HomedestSpiltState nvarchar(255);


Update ['titanic passenger list$']
SET HomedestSpiltState=PARSENAME(REPLACE(home#dest,',','.'),1);


ALTER TABLE ['titanic passenger list$']
DROP COLUMN home#dest;

ALTER TABLE ['titanic passenger list$']
DROP COLUMN body;

------People who had survived the titanic
select FirstName, LastName, age from
Project..['titanic passenger list$']
where survived=1;

----Count of male and female survivors
select COUNT(survived) from
Project..['titanic passenger list$']
where survived=1
GROUP BY sex;


----This statement gives us the analysis that people who had more boats to their name had a huge chance of survival
select FirstName, LastName, survived, boat from
Project..['titanic passenger list$']
where survived=1 and boat>1;