--Selecting the entire data and sorting by year

SELECT *
FROM portfolioproject..ElectricVehicleData
ORDER BY [Model Year] ASC

--Selecting cars where model is a ranger

SELECT Make, Model, [Model Year]
FROM portfolioproject..ElectricVehicleData
WHERE Model = 'Ranger'

--Classifying CAFV Elibgibilty

SELECT DISTINCT([Clean Alternative Fuel Vehicle (CAFV) Eligibility]), COUNT([Clean Alternative Fuel Vehicle (CAFV) Eligibility])
FROM portfolioproject..ElectricVehicleData
GROUP BY [Clean Alternative Fuel Vehicle (CAFV) Eligibility]
Order by 1

SELECT [Clean Alternative Fuel Vehicle (CAFV) Eligibility], Make
, CASE WHEN [Clean Alternative Fuel Vehicle (CAFV) Eligibility] = 'Clean Alternative Fuel Vehicle Eligible' THEN 'Eligible'
		WHEN [Clean Alternative Fuel Vehicle (CAFV) Eligibility] = 'Not eligible due to low battery range' THEN 'Not Eligible'
		WHEN  [Clean Alternative Fuel Vehicle (CAFV) Eligibility] = 'Eligibility unknown as battery range has not been researched' THEN 'Eligiblity Unknown'
		ELSE [Clean Alternative Fuel Vehicle (CAFV) Eligibility]
		END
FROM portfolioproject..ElectricVehicleData

UPDATE portfolioproject..ElectricVehicleData
SET [Clean Alternative Fuel Vehicle (CAFV) Eligibility] = CASE WHEN [Clean Alternative Fuel Vehicle (CAFV) Eligibility] = 'Clean Alternative Fuel Vehicle Eligible' THEN 'Eligible'
		WHEN [Clean Alternative Fuel Vehicle (CAFV) Eligibility] = 'Not eligible due to low battery range' THEN 'Not Eligible'
		WHEN  [Clean Alternative Fuel Vehicle (CAFV) Eligibility] = 'Eligibility unknown as battery range has not been researched' THEN 'Eligiblity Unknown'
		ELSE  [Clean Alternative Fuel Vehicle (CAFV) Eligibility] 
		END 

--Counting number of Teslas

SELECT COUNT(Make)
FROM portfolioproject..ElectricVehicleData
WHERE Make = 'Tesla' 


--County = King

SELECT County, City, Make, Model
FROM portfolioproject..ElectricVehicleData
WHERE County LIKE '%King%'

