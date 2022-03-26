
--- Data that we will be looking at ---
Select * 
from NashvilleHousing

--- Standardizing the Date --
Select SaleDate
from NashvilleHousing

Alter table NashvilleHousing 
ADD Converted_SalesDate date;

Update NashvilleHousing
SET Converted_SalesDate = CONVERT(Date,SaleDate)

-- Property Address

Select *
from NashvilleHousing
--where PropertyAddress is Null
order by 2;

--Self Join to utilize ParcelID as a reference point in order to populate Property Address --
-- Parcel ID can be repetitive and be used to add a value to NA values within Property address --

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
,ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b 
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is Null;


UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)

from NashvilleHousing a
JOIN NashvilleHousing b 
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is Null;


-- Breaking Address into differnt columns ( Address, City, State)--

Select PropertyAddress
from NashvilleHousing

Select 
Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as City
from NashvilleHousing

-- Adress Split
Alter table NashvilleHousing 
ADD PropertyAddressSplit nvarchar(255);

Update NashvilleHousing
SET PropertyAddressSplit = Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

-- City Split 

Alter table NashvilleHousing 
ADD PropertyCitySplit nvarchar(255);

Update NashvilleHousing
SET PropertyCitySplit = Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))



-- ParseName --

Select OwnerAddress
from NashvilleHousing

Select
Parsename(REPLACE(OwnerAddress,',','.'),3),
Parsename(REPLACE(OwnerAddress,',','.'),2),
Parsename(REPLACE(OwnerAddress,',','.'),1)
FROM NashvilleHousing

-- OwnserAddress
Alter table NashvilleHousing 
ADD OwnerAddressSplit nvarchar(255);

Update NashvilleHousing
SET OwnerAddressSplit= Parsename(REPLACE(OwnerAddress,',','.'),3)

--Owner City
Alter table NashvilleHousing 
ADD OwnerCitySplit nvarchar(255);

Update NashvilleHousing
SET OwnerCitySplit = Parsename(REPLACE(OwnerAddress,',','.'),2)


--Owner State
Alter table NashvilleHousing 
ADD OwnerStateSplit nvarchar(255);

Update NashvilleHousing
SET OwnerStateSplit = Parsename(REPLACE(OwnerAddress,',','.'),1)


-- Changing Y and N in column into Yes or No 

Select Distinct(SoldAsVacant)
from NashvilleHousing

Select count(SoldAsVacant),SoldAsVacant
from NashvilleHousing
group by SoldAsVacant
order by 1


Select SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No' 
	ELSE SoldAsVacant
	END
from NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No' 
	ELSE SoldAsVacant
	END




-- Deleting unused columns 

select * 
from NashvilleHousing

Alter Table NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress,SaleDate
