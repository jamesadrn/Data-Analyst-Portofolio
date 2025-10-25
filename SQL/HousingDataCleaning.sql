-- =====================================================
-- 🧹 Nashville Housing Data Cleaning (PostgreSQL Project)
-- Author : James
-- University : Tarumanagara University
-- Description : Data Cleaning and Standardization of the Nashville Housing Dataset
-- =====================================================

-- Step 1️⃣ : View all data
SELECT * FROM "NashvilleHousing";

-- =====================================================
-- Step 2️⃣ : Standardize Date Format
-- Convert "SaleDate" from text/timestamp into Date format
-- =====================================================

-- Preview conversion result
SELECT "SaleDate", "SaleDate"::DATE AS SaleDateConverted
FROM "NashvilleHousing";

-- Add a new column for converted date
ALTER TABLE "NashvilleHousing"
ADD "SaleDateConverted" DATE;

-- Update the new column with converted date values
UPDATE "NashvilleHousing"
SET "SaleDateConverted" = "SaleDate"::DATE;

-- =====================================================
-- Step 3️⃣ : Populate Missing Property Address
-- Some rows have NULL property addresses but same ParcelID
-- Use self-join to copy missing addresses
-- =====================================================

SELECT *
FROM "NashvilleHousing"
ORDER BY "ParcelID";

-- Identify null property addresses by joining on ParcelID
SELECT 
  a."ParcelID", a."PropertyAddress", 
  b."ParcelID", b."PropertyAddress",
  COALESCE(a."PropertyAddress", b."PropertyAddress") AS FilledAddress
FROM "NashvilleHousing" a
JOIN "NashvilleHousing" b
  ON a."ParcelID" = b."ParcelID"
 AND a."UniqueID" <> b."UniqueID"
WHERE a."PropertyAddress" IS NULL;

-- Update null addresses using self-join logic
UPDATE "NashvilleHousing" AS a
SET "PropertyAddress" = COALESCE(a."PropertyAddress", b."PropertyAddress")
FROM "NashvilleHousing" AS b
WHERE a."ParcelID" = b."ParcelID"
  AND a."UniqueID" <> b."UniqueID"
  AND a."PropertyAddress" IS NULL;

-- =====================================================
-- Step 4️⃣ : Split Property Address into Address & City
-- =====================================================

SELECT 
  SUBSTRING("PropertyAddress", 1, POSITION(',' IN "PropertyAddress") - 1) AS Address,
  SUBSTRING("PropertyAddress", POSITION(',' IN "PropertyAddress") + 1) AS City
FROM "NashvilleHousing";

-- Add new columns for split address
ALTER TABLE "NashvilleHousing" ADD "PropertyAddressSplit" VARCHAR(255);
ALTER TABLE "NashvilleHousing" ADD "PropertyCity" VARCHAR(255);

-- Populate them with split parts
UPDATE "NashvilleHousing"
SET "PropertyAddressSplit" = SUBSTRING("PropertyAddress", 1, POSITION(',' IN "PropertyAddress") - 1);

UPDATE "NashvilleHousing"
SET "PropertyCity" = SUBSTRING("PropertyAddress", POSITION(',' IN "PropertyAddress") + 1);

-- =====================================================
-- Step 5️⃣ : Split Owner Address into Address, City, and State
-- =====================================================

SELECT 
  SPLIT_PART("OwnerAddress", ',', 1) AS OwnerSplitAddress,
  SPLIT_PART("OwnerAddress", ',', 2) AS OwnerCity,
  SPLIT_PART("OwnerAddress", ',', 3) AS OwnerState
FROM "NashvilleHousing";

ALTER TABLE "NashvilleHousing" ADD "OwnerSplitAddress" VARCHAR(255);
ALTER TABLE "NashvilleHousing" ADD "OwnerCity" VARCHAR(255);
ALTER TABLE "NashvilleHousing" ADD "OwnerState" VARCHAR(255);

UPDATE "NashvilleHousing" SET "OwnerSplitAddress" = SPLIT_PART("OwnerAddress", ',', 1);
UPDATE "NashvilleHousing" SET "OwnerCity" = SPLIT_PART("OwnerAddress", ',', 2);
UPDATE "NashvilleHousing" SET "OwnerState" = SPLIT_PART("OwnerAddress", ',', 3);

-- =====================================================
-- Step 6️⃣ : Standardize SoldAsVacant values (Y/N → Yes/No)
-- =====================================================

SELECT DISTINCT("SoldAsVacant"), COUNT("SoldAsVacant")
FROM "NashvilleHousing"
GROUP BY "SoldAsVacant"
ORDER BY 2 DESC;

UPDATE "NashvilleHousing"
SET "SoldAsVacant" = CASE 
  WHEN "SoldAsVacant" = 'Y' THEN 'Yes'
  WHEN "SoldAsVacant" = 'N' THEN 'No'
  ELSE "SoldAsVacant"
END;

-- =====================================================
-- Step 7️⃣ : Remove Duplicates using ROW_NUMBER
-- =====================================================

-- Check duplicates first
WITH rownumcte AS (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY "ParcelID", "PropertyAddress", "SaleDate", "LegalReference"
      ORDER BY "UniqueID"
    ) AS row_num
  FROM "NashvilleHousing"
)
SELECT * FROM rownumcte WHERE row_num > 1;

-- Safe delete duplicate rows using Transaction
BEGIN;

WITH rownumcte AS (
  SELECT 
    "UniqueID",
    ROW_NUMBER() OVER (
      PARTITION BY "ParcelID", "PropertyAddress", "SaleDate", "LegalReference"
      ORDER BY "UniqueID"
    ) AS row_num
  FROM "NashvilleHousing"
)
DELETE FROM "NashvilleHousing"
USING rownumcte
WHERE "NashvilleHousing"."UniqueID" = rownumcte."UniqueID"
  AND rownumcte.row_num > 1;

COMMIT;
-- ROLLBACK; -- Uncomment if you need to undo changes

-- =====================================================
-- Step 8️⃣ : Delete Unused Columns
-- =====================================================

ALTER TABLE "NashvilleHousing"
DROP COLUMN "OwnerAddress",
DROP COLUMN "TaxDistrict",
DROP COLUMN "PropertyAddress",
DROP COLUMN "SaleDate";

-- =====================================================
-- ✅ Data cleaning complete!
-- =====================================================