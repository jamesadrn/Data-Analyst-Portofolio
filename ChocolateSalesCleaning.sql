SELECT * FROM chocolate_sales
LIMIT 100;

--- Check Column, data type , and null value
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'chocolate_sales';

--- Change data type on Amount column to numeric
-- New column
ALTER TABLE chocolate_sales
ADD COLUMN amount_num numeric;

-- Update New Column
UPDATE chocolate_sales
SET amount_num = REPLACE(REPLACE("Amount", '$', ''), ',', '')::numeric;

-- Check between old column vs new 
SELECT "Amount", amount_num FROM chocolate_sales limit 10;

-- Count row  = 1094
SELECT COUNT(*) AS total_rows FROM chocolate_sales;

--- Change data type on Date column to date
-- New Column
ALTER TABLE chocolate_sales
ALTER COLUMN "Date" TYPE date
USING to_date("Date", 'DD-Mon-YY');

Select "Date" FROM chocolate_sales LIMIT 5;
	
--- Profiling Function
CREATE OR REPLACE FUNCTION profile_table(_schema_name text, _table_name text)
RETURNS TABLE (
    column_name text,
    total_rows bigint,
    null_count bigint,
    null_percent numeric,
    unique_values bigint
)
LANGUAGE plpgsql AS $$
DECLARE
    sql text;
BEGIN
    SELECT string_agg(
        format(
            'SELECT %L AS column_name,
                    COUNT(*) AS total_rows,
                    SUM(CASE WHEN %I IS NULL THEN 1 ELSE 0 END) AS null_count,
                    ROUND(SUM(CASE WHEN %I IS NULL THEN 1 ELSE 0 END)*100.0/COUNT(*), 2) AS null_percent,
                    COUNT(DISTINCT %I) AS unique_values
             FROM %I.%I',
            col.column_name, col.column_name, col.column_name, col.column_name, _schema_name, _table_name
        ),
        ' UNION ALL '
    )
    INTO sql
    FROM information_schema.columns AS col
    WHERE col.table_schema = _schema_name
      AND col.table_name = _table_name;

    RETURN QUERY EXECUTE sql;
END $$;

-- Call the function
SELECT * FROM profile_table('public', 'chocolate_sales');

--- Check Duplicate data
SELECT 
    "Sales Person",
    "Country",
    "Product",
    "Date",
    "Amount",
    "Boxes Shipped",
    COUNT(*) AS duplicate_count
FROM chocolate_sales
GROUP BY 
    "Sales Person",
    "Country",
    "Product",
    "Date",
    "Amount",
    "Boxes Shipped"
HAVING COUNT(*) > 1;

--- Basic Calculation
SELECT * FROM chocolate_sales
limit 10
	
SELECT 
    MIN(amount_num) AS min_value,
    MAX(amount_num) AS max_value,
    AVG(amount_num) AS avg_value,
    SUM(amount_num) AS total_sales
FROM chocolate_sales;

--- Check Outlier on data
WITH stats AS (
  SELECT 
    percentile_cont(0.25) WITHIN GROUP (ORDER BY amount_num) AS q1,
    percentile_cont(0.75) WITHIN GROUP (ORDER BY amount_num) AS q3
  FROM chocolate_sales
)
SELECT 
  c.*,
  s.q1, s.q3,
  (s.q3 - s.q1) AS iqr
FROM chocolate_sales c
CROSS JOIN stats s
WHERE c.amount_num > (s.q3 + 1.5 * (s.q3 - s.q1))
   OR c.amount_num < (s.q1 - 1.5 * (s.q3 - s.q1));

--- Check negative data
SELECT *
FROM chocolate_sales
WHERE "Date" > CURRENT_DATE
   OR "Date" < DATE '2000-01-01';

SELECT *
FROM chocolate_sales
WHERE amount_num < 0 OR "Boxes Shipped" < 0;


--- View
CREATE OR REPLACE VIEW chocolate_sales_clean AS
SELECT 
    "Sales Person" as sales_person,
    "Country" as country,
    "Product" as product,
    "Date" as date,
    amount_num AS amount,
    "Boxes Shipped" AS boxes_shipped
FROM chocolate_sales


