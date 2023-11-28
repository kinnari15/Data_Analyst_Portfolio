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
