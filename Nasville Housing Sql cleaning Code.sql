SELECT *
FROM NasvilleHousing

--Change Date format
SELECT SalesDateConverted
from NasvilleHousing;

ALTER Table NasvilleHousing
Add SalesDateConverted Date;

UPDATE NasvilleHousing 
SET SalesDateConverted = CONVERT(Date,SaleDate);

--Fill in null values in Propert Adress Data
SELECT A.ParcelID, B.ParcelID,A.[UniqueID ],B.[UniqueID ],A.PropertyAddress,B.PropertyAddress,ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM NasvilleHousing A JOIN 
NasvilleHousing B ON A.ParcelID = B.ParcelID
AND A.[UniqueID ]<>B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM NasvilleHousing A JOIN 
NasvilleHousing B ON A.ParcelID = B.ParcelID
AND A.[UniqueID ]<>B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

--Breaking Up adress into seperate columns for better visuals 
SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
FROM NasvilleHousing

ALTER TABLE NasvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE NasvilleHousing
SET PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NasvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE NasvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

--Breaking Up Owner adress into seperate columns for better visuals
SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM NasvilleHousing

ALTER TABLE NasvilleHousing
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE NasvilleHousing SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NasvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE NasvilleHousing SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NasvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE NasvilleHousing SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


--Update SoldAsVacnt Status from y to Yes and n to No
SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM NasvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END AS NewSoldASVacnt
FROM NasvilleHousing

ALTER TABLE NasvilleHousing
ADD NewSoldAsVacnt NVARCHAR(50)

UPDATE NasvilleHousing
SET NewSoldAsVacnt = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

SELECT DISTINCT(NewSoldAsVacnt)
FROM NasvilleHousing


--Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY
ParcelID,
PropertyAddress,
SaleDate,
SalePrice
ORDER BY UniqueID
) row_num
FROM NasvilleHousing 
)

SELECT *
FROM RowNumCTE	
WHERE row_num > 1

--Deleting unused columns
ALTER TABLE NasvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict,SoldAsVacant