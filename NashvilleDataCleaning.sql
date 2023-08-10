/* CREATED BY: VALERIA KYRIAKIDES
CREATE DATE: 08/09/2023
PURPOSE: Use SQL to clean raw housing data in order to make it more efficient and usable for data analysis
*/

SELECT
	*
FROM 
	NashvilleHousing
    
-- Standardizing the date format: has time stamp after date. Time stamp is unecessary so I will remove it. 
-- Convert from date-time format and turn it into a Date format

SELECT
	SaleDate
FROM 
	NashvilleHousing
    
SELECT
	SaleDateNew,
	CONVERT(Date, SaleDate)
FROM
	NashvilleHousing
    
UPDATE
	NashvilleHousing
SET
	SaleDate = CONVERT(Date,SaleDate)
    
ALTER TABLE
	NashvilleHousing
	ADD
	SaleDateNew Date;
    
UPDATE
	NashvilleHousing
SET
	SaleDateNew = CONVERT(Date, SaleDate)
    
    
-- populate adress: 'property adress' has NULL values

SELECT
	PropertyAdress
FROM
	NashvilleHousing

SELECT
	PropertyAdress
FROM
	NashvilleHousing
WHERE
	PropertyAdress IS NULL
ORDER BY
		ParcelId
-- Parcel ID repeated in some rows where adress is also repeated. If parcel ID has an adress, and if the same Parcel ID in a different row
-- does not have an address, I will populate it using the property address.
-- This will be done using a self join 
-- used 'AND a.[UniqueID] <> b.[UniqueID]  to ensure that parcel ID is the same but not on the same row

SELECT
	a.ParcelID,
    a.PropertyAdress,
    ISNULL(a.PropertyAdress, b.PropertyAdress)
    b.ParcelID,
    b.PropertyAdress
FORM
	NashvilleHousing a
JOIN
	NashvilleHousing b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
WHERE 	
	a.PropertyAdress IS NULL

 UPDATE NashvilleHousing a
	SET PropertyAdress = ISNULL(a.PropertyAdress, b.PropertyAdress)
FROM
	NashvilleHousing a
JOIN
	NashvilleHousing b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
WHERE 	
	a.PropertyAdress IS NULL


-- Break into columns 'property adress': currently has adress and city separated by comma
-- Break into columns 'owner address': curently holds adress, city and state separated by comma
-- will be done using a substring and character index

-- separating address form city and removing comma:
SELECT
	PropertyAdress
FROM
	NashvilleHousing

SELECT
	SUBSTRING
		(PropertyAddress, 1, CHARINDEX(',', PropertyAdress) - 1) AS Address,
	SUBSTRING
		(PropertyAddress, CHARINDEX(',', PropertyAdress) + 1, LEN(PropertyAdress)) AS Address
FROM
	NashvilleHousing
  
 -- separating into two columns:
 ALTER TABLE
	NashvilleHousing
	ADD
	PropertyAdressSplit NVARCHAR(200);

ALTER TABLE
	NashvilleHousing
	ADD
	PropertyCitySplit NVARCHAR(200);
    

UPDATE
	NashvilleHousing
SET
	PropertyAdressSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAdress) - 1)
    
UPDATE
	NashvilleHousing
SET
	PropertyCitySplit = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAdress) + 1, LEN(PropertyAdress))
    

-- Break into columns 'owner address': curently holds adress, city and state separated by comma
-- will be done using a parse name

-- separating address form city and removing comma:
SELECT
	OwnerAdress
FROM
	NashvilleHousing
    
SELECT
	PARSENAME(REPLACE(OwnerAdress, ',', '.'), 3),
    PARSENAME(REPLACE(OwnerAdress, ',', '.'), 2),
    PARSENAME(REPLACE(OwnerAdress, ',', '.'), 1)
FROM
	NashvilleHousing

-- separating into three columns:
ALTER TABLE
	NashvilleHousing
	ADD
	OwnerAdressSplit NVARCHAR(200);
    
ALTER TABLE
	NashvilleHousing
	ADD
	OwnerCitySplit NVARCHAR(200);
    
ALTER TABLE
	NashvilleHousing
	ADD
	OwnerStateSplit NVARCHAR(200);



UPDATE
	NashvilleHousing
SET
	OwnerAdressSplit = PARSENAME(REPLACE(OwnerAdress, ',', '.'), 3)

UPDATE
	NashvilleHousing
SET
	OwnerCitySplit =  PARSENAME(REPLACE(OwnerAdress, ',', '.'), 2)
        
UPDATE
	NashvilleHousing
SET
	OwnerStateSplit = PARSENAME(REPLACE(OwnerAdress, ',', '.'), 1)
    

-- In 'Sold as Vacant' field: change 'Y' and 'N' into 'Yes' and 'No'
-- Some columns have 'Yes' and 'No' while other have 'Y' and 'N'
SELECT
	SoldAsVacant,
    CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
	END
FROM
	NashvilleHousing
    
UPDATE
	NashvilleHousing
SET
	SoldAsVacant = 
		CASE
			WHEN SoldAsVacant = 'Y' THEN 'Yes'
			WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SoldAsVacant
		END




-- Deleting unused/edited columns
-- WILL ONLY BE DONE WITH PRIOR APPROVAL

SELECT
	*
FROM
	NashvilleHousing
    
ALTER TABLE
	NashvilleHousing
DROP COLUMN
	OwnerAdress,
    TaxDistrict,
    PropertyAdress,
    SaleDate





