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


--breaking out address into individual columns (adddress, city, state)

SELECT PropertyAddress 
FROM [portfolio project].dbo.NashVilleHousing
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)  as Address
--CHARINDEX(',',PropertyAddress)
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))  as Address

FROM [portfolio project].dbo.NashVilleHousing

ALTER TABLE NashVilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashVilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashVilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashVilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM [portfolio project].dbo.NashVilleHousing

SELECT OwnerAddress 
FROM [portfolio project].dbo.NashVilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',','.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)
FROM [portfolio project].dbo.NashVilleHousing

ALTER TABLE NashVilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashVilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)

ALTER TABLE NashVilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashVilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)

ALTER TABLE NashVilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashVilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)

SELECT *
FROM [portfolio project].dbo.NashVilleHousing

--Change Y and N to Yes and No in 'Sold as Vacant' field
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [portfolio project].dbo.NashVilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM [portfolio project].dbo.NashVilleHousing

Update NashVilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

--Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID, 
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					) row_num
FROM [portfolio project].dbo.NashVilleHousing
--order by ParcelID

)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
Order by PropertyAddress

--Delete unused columns
SELECT *
FROM [portfolio project].dbo.NashVilleHousing

ALTER TABLE [portfolio project].dbo.NashVilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [portfolio project].dbo.NashVilleHousing
DROP COLUMN SaleDate


