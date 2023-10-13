USE [portfolio project]
GO

SELECT [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [dbo].[NashVilleHousing]

GO


SELECT *
FROM [portfolio project].dbo.NashVilleHousing
 --Standardized Date format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM [portfolio project].dbo.NashVilleHousing

Update NashVilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashVilleHousing
Add SaleDateConverted Date;

Update NashVilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


--Populate Property Address Data

SELECT *
FROM [portfolio project].dbo.NashVilleHousing
--WHERE PropertyAddress is null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [portfolio project].dbo.NashVilleHousing a
JOIN  [portfolio project].dbo.NashVilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [portfolio project].dbo.NashVilleHousing a
JOIN  [portfolio project].dbo.NashVilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

