--Viewing the Dataset

SELECT *
FROM portfolioproject..nifty_500$

--Viewing Company and which indutries they operate in
SELECT [Company Name], Industry
FROM portfolioproject..nifty_500$

SELECT [Company Name], Industry
FROM portfolioproject..nifty_500$
WHERE Industry IN ('Power','Healthcare')
ORDER BY 2 ASC

--Counting Number of Companies in Financial Services 
SELECT COUNT(Industry) AS FinancialServicesCount
FROM portfolioproject..nifty_500$
WHERE Industry = 'Financial Services'

--Removing Duplicates
SELECT [Company Name], Industry, COUNT(*) AS CNT
FROM portfolioproject..nifty_500$
GROUP BY [Company Name], Industry
HAVING COUNT(*) > 1

--No duplicates found in the dataset :)

--Null values

SELECT *
FROM portfolioproject..nifty_500$
WHERE [Change] IS NOT NULL
AND [Percentage Change] IS NOT NULL
AND [365 Day Percentage Change] IS NOT NULL

--Or we can use this to replace NULL with 0 

SELECT COALESCE([Change], 0), COALESCE([Percentage Change], 0), COALESCE([365 Day Percentage Change], 0)
FROM portfolioproject..nifty_500$

--Updating the table with 0 where NULL VALUES are present

UPDATE portfolioproject..nifty_500$
SET [Change] = 0 
WHERE [Change] IS NULL

UPDATE portfolioproject..nifty_500$
SET [Percentage Change] = 0 --[Percentage Change] = 0, [365 Day Percentage Change] = 0
WHERE [Percentage Change] IS NULL

UPDATE portfolioproject..nifty_500$
SET  [365 Day Percentage Change] = 0
WHERE [365 Day Percentage Change] IS NULL

--Updated the values and the data looks better now!

--Demonstrating CTE, Temp Tables, Procedures, Joins(If possible)

--CTE Implementation (Counting Share Volume)

WITH Nifty AS 
(SELECT [Company Name], 
		[Industry], 
		[Last Traded Price], 
		[Share Volume],
		COUNT([Share Volume]) OVER (PARTITION BY [Share Volume] ORDER BY [Company Name]) AS ShareVolumePartition
FROM portfolioproject..nifty_500$
)
SELECT *
FROM Nifty

--Subquery 
SELECT [Company Name], Industry, [Last Traded Price], (SELECT AVG([Last Traded Price]) FROM portfolioproject..nifty_500$)  AS AvgTradedPrice
FROM portfolioproject..nifty_500$

--Temp Table Implementation

CREATE TABLE #temp_nifty2 (
CompanyName varchar(100),
Industry varchar(100),
LastTradedPrice int
)

INSERT INTO #temp_nifty2 VALUES(
'Tata Technologies', 'Technology', '1300'
)

SELECT * FROM #temp_nifty2

--Directly inserting from the main table
--Creating a new temp table


DROP TABLE IF EXISTS #temp_nifty2

CREATE TABLE #Temp_nifty (
Industry VARCHAR(100),
[Last Traded Price] int,
[Share Volume] int
)

INSERT INTO #Temp_nifty
SELECT Industry, AVG([Last Traded Price]), AVG([Share Volume])
FROM portfolioproject..nifty_500$
GROUP BY Industry

SELECT * 
FROM #Temp_nifty

--Stored Procedure Implementation

CREATE PROCEDURE NIFTY
AS 
SELECT [Company Name], Industry, [Last Traded Price], [Share Volume]
FROM portfolioproject..nifty_500$
WHERE [Last Traded Price] > 2000
AND [Share Volume] < 50000

EXEC NIFTY

CREATE PROCEDURE TEMP_NIFTY
AS
CREATE TABLE #Temp_nifty (
Industry VARCHAR(100),
[Last Traded Price] int,
[Share Volume] int
)

INSERT INTO #Temp_nifty
SELECT Industry, AVG([Last Traded Price]), AVG([Share Volume])
FROM portfolioproject..nifty_500$
GROUP BY Industry

SELECT * 
FROM #Temp_nifty

EXEC TEMP_NIFTY

--Views Implementation (Healthcare Nifty Data)

CREATE VIEW [Nifty 500] AS
SELECT [Company Name], Industry, [Previous Close], [Last Traded Price], [Share Volume], [52 Week High]
FROM portfolioproject..nifty_500$
WHERE Industry LIKE 'H%'

SELECT *
FROM [Nifty 500]