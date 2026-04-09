select * from DataCleaningProject.dbo.NashvilleHousing;

-----Standardize Date format 

select SaleDateConverted, CONVERT(Date, SaleDate)
from DataCleaningProject.dbo.NashvilleHousing;

Update NashvilleHousing
SET SaleDate=CONVERT(Date, SaleDate);

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted=CONVERT(Date, SaleDate);


---Populate property address data

select *
from DataCleaningProject.dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID;


-----Checking if both columns are same or not
select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress
from DataCleaningProject.dbo.NashvilleHousing a
JOIN DataCleaningProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ];


select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from DataCleaningProject.dbo.NashvilleHousing a
JOIN DataCleaningProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ];


update a 
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from DataCleaningProject.dbo.NashvilleHousing a
JOIN DataCleaningProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null;


----Breaking Address into individual columns

select PropertyAddress 
from DataCleaningProject.dbo.Nashvillehousing;

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from DataCleaningProject.dbo.Nashvillehousing;

Alter table NashvilleHousing
Add ProperSplitAddress nvarchar(255);

Update NashvilleHousing
SET ProperSplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


Alter table NashvilleHousing
Add ProperSplitCity nvarchar(255);

Update NashvilleHousing
SET ProperSplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select * 
from DataCleaningProject.dbo.Nashvillehousing;

select OWNERAddress from DataCleaningProject.dbo.Nashvillehousing;

---Using parsename

select PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from DataCleaningProject.dbo.Nashvillehousing;

Alter table NashvilleHousing
Add OwnerSplitAddress1 nvarchar(255);


Update NashvilleHousing
SET OwnerSplitAddress1=PARSENAME(REPLACE(OwnerAddress,',','.'),3)


Alter table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter table NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)


----------Changing Y to N 

select DISTINCT(SoldAsVacant), count(SoldAsVacant)
from DataCleaningProject.dbo.Nashvillehousing
group by SoldAsVacant
order by SoldAsVacant;

select SoldAsVacant,
CASE 
WHEN SoldAsVacant='Y' then 'Yes'
WHEN SoldAsVacant='N' then 'No'
ELSE SoldAsVacant 
END
from DataCleaningProject.dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
WHEN SoldAsVacant='Y' then 'Yes'
WHEN SoldAsVacant='N' then 'No'
ELSE SoldAsVacant 
END
from DataCleaningProject.dbo.NashvilleHousing;


----Removing Duplicates 

WITH RowNumCTE AS (
select *, 
ROW_NUMBER() OVER(
PARTITION BY ParcelID, 
			 PropertyAddress, 
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY UniqueID) row_num
from DataCleaningProject..NashvilleHousing
--order by ParcelID;
)

--select * from RowNumCTE
--where row_num > 1;

DELETE from RowNumCTE
where row_num > 1;


----Delete unused columns 

select * from 
DataCleaningProject..NashvilleHousing


ALTER TABLE DataCleaningProject..NashvilleHousing
DROP COLUMN PropertyAddress, TaxDistrict,  OwnerAddress;

ALTER TABLE DataCleaningProject..NashvilleHousing
DROP COLUMN OwnerSplitAddress;

