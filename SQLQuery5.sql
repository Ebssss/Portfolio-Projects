
select * from PortfolioProject..NashvileHousing

--Standardizing date format

select SaleDate, convert(Date, SaleDate)
from PortfolioProject..NashvileHousing

Update NashvileHousing
set SaleDate = Convert(date, SaleDate)

--or

alter table NashvileHousing 
add SaleDateConverted Date;

update NashvileHousing
set SaleDateConverted = convert(Date, SaleDate)

select SaleDateConverted, convert(Date, SaleDate)
from PortfolioProject..NashvileHousing

--Populating Property Address Data

select PropertyAddress
from PortfolioProject..NashvileHousing
--where PropertyAddress is null

select PropertyAddress
from PortfolioProject..NashvileHousing
where PropertyAddress is null

select *
from PortfolioProject..NashvileHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,isnull(a.PropertyAddress,
b.PropertyAddress)
from PortfolioProject..NashvileHousing a
join PortfolioProject..NashvileHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvileHousing a
join PortfolioProject..NashvileHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL



--Breaking out address into individual columns (address, city, state)


select PropertyAddress
from PortfolioProject..NashvileHousing
--where PropertyAddress is null

select
substring(PropertyAddress,1, charindex(',', PropertyAddress) -1) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress))
as Address


from PortfolioProject..NashvileHousing


alter table NashvileHousing 
add PropertySplitAddress Nvarchar(255);

update NashvileHousing
set PropertySplitAddress = substring(PropertyAddress,1, charindex(',', PropertyAddress) -1)

alter table NashvileHousing 
add PropertySplitCity Nvarchar(255);

update NashvileHousing
set PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress))


select * 
from PortfolioProject..NashvileHousing



select OwnerAddress 
from PortfolioProject..NashvileHousing


select 
parsename(replace(OwnerAddress,',', '.' ),3),
parsename(replace(OwnerAddress,',', '.' ),2),
parsename(replace(OwnerAddress,',', '.' ),1)
from PortfolioProject..NashvileHousing




alter table NashvileHousing 
add OwnerSplitAddress Nvarchar(255);

update NashvileHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress,',', '.' ),3)

alter table NashvileHousing 
add OwnerSplitCity Nvarchar(255);

update NashvileHousing
set OwnerSplitCity = parsename(replace(OwnerAddress,',', '.' ),2)

alter table NashvileHousing 
add OwnerSplitState Nvarchar(255);

update NashvileHousing
set OwnerSplitState = parsename(replace(OwnerAddress,',', '.' ),1)


select * 
from PortfolioProject..NashvileHousing


--Changing Y and N to Yes and NO in 'Sold as Vacant' field

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvileHousing
group by SoldAsVacant
order by 2




select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject..NashvileHousing

update NashvileHousing
set SoldAsVacant =  case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvileHousing
group by SoldAsVacant
order by 2 



-- remove duplicates 
with RowNumCTE as (
select *, 
ROW_NUMBER() over (
partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
order by UniqueID) row_num

from PortfolioProject..NashvileHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

-- to remove duplicates replacing select* by delete
with RowNumCTE as (
select *, 
ROW_NUMBER() over (
partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
order by UniqueID) row_num

from PortfolioProject..NashvileHousing
--order by ParcelID
)
delete
from RowNumCTE
where row_num > 1
--order by PropertyAddress


--checking 

with RowNumCTE as (
select *, 
ROW_NUMBER() over (
partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
order by UniqueID) row_num

from PortfolioProject..NashvileHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

select *
from PortfolioProject..NashvileHousing

--delete unused columns 

alter table PortfolioProject..NashvileHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table PortfolioProject..NashvileHousing
drop column SaleDate